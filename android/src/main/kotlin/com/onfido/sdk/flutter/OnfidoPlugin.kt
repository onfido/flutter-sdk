package com.onfido.sdk.flutter

import android.app.Activity
import android.content.Intent
import com.onfido.android.sdk.capture.ExitCode
import com.onfido.android.sdk.capture.Onfido
import com.onfido.android.sdk.capture.OnfidoFactory
import com.onfido.android.sdk.capture.errors.OnfidoException
import com.onfido.android.sdk.capture.upload.Captures
import com.onfido.workflow.OnfidoWorkflow
import com.onfido.sdk.flutter.api.FlutterActivityProvider
import com.onfido.sdk.flutter.bridge.BaseMethod
import com.onfido.sdk.flutter.bridge.StartMethod
import com.onfido.sdk.flutter.bridge.StartStudioMethod
import com.onfido.sdk.flutter.serializer.toFlutterResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class OnfidoPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware,
    FlutterActivityProvider, PluginRegistry.ActivityResultListener {

    companion object {
        lateinit var channel: MethodChannel

        private fun initMethodChannel(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
            channel = MethodChannel(flutterPluginBinding.binaryMessenger, "onfido_sdk")
        }
    }

    private lateinit var onfido: Onfido
    private lateinit var onfidoWorkflow: OnfidoWorkflow

    private var flutterAssets: FlutterPlugin.FlutterAssets? = null
    private var result: MethodChannel.Result? = null

    private var activityBinding: ActivityPluginBinding? = null

    private val methods: Map<String, BaseMethod> by lazy {
        listOf(
            StartMethod(this, onfido, flutterAssets!!),
            StartStudioMethod(this, onfidoWorkflow)
        ).associateBy { it.name }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        runCatching {
            this.methods[call.method]?.invoke(call, result) ?: result.notImplemented()
            this.result = result
        }.onFailure {
            result.error("configuration", it.message, it)
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterAssets = flutterPluginBinding.flutterAssets

        onfidoWorkflow = OnfidoWorkflow.create(flutterPluginBinding.applicationContext)
        onfido = OnfidoFactory.create(flutterPluginBinding.applicationContext).client

        initMethodChannel(flutterPluginBinding)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        flutterAssets = null
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(activityBinding: ActivityPluginBinding) {
        this.activityBinding = activityBinding
        this.activityBinding?.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        this.activityBinding?.removeActivityResultListener(this)
        this.activityBinding = null
    }

    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) =
        onAttachedToActivity(binding)

    override fun provide(): Activity? = activityBinding?.activity

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == StartMethod.startRequestCode) {
            this.handleOnfidoChecksResult(resultCode, data)
            return true
        }

        if (requestCode == StartStudioMethod.startRequestCode) {
            this.handleOnfidoStudioResult(resultCode, data)
            return true
        }

        return false
    }

    //region Onfido Results

    private fun handleOnfidoChecksResult(resultCode: Int, data: Intent?) {
        onfido.handleActivityResult(resultCode, data, object : Onfido.OnfidoResultListener {
            override fun onError(exception: OnfidoException) {
                result?.error("error", exception.message, null)
                result = null
            }

            override fun userCompleted(captures: Captures) {
                result?.success(captures.toFlutterResult())
                result = null
            }

            override fun userExited(exitCode: ExitCode) {
                result?.error("exit", "User canceled the flow", null)
                result = null
            }
        })
    }

    private fun handleOnfidoStudioResult(resultCode: Int, data: Intent?) {
        onfidoWorkflow.handleActivityResult(
            resultCode,
            data,
            object : OnfidoWorkflow.ResultListener {
                override fun onException(exception: OnfidoWorkflow.WorkflowException) {
                    result?.error("error", exception.message, null)
                    result = null
                }

                override fun onUserCompleted() {
                    result?.success("")
                    result = null
                }

                override fun onUserExited(exitCode: ExitCode) {
                    result?.error("exit", "User canceled the flow", null)
                    result = null
                }
            })
    }

    //endregion
}

