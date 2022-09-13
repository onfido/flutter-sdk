package com.onfido.sdk.flutter.bridge

import com.onfido.android.sdk.capture.Onfido
import com.onfido.sdk.flutter.api.FlutterActivityProvider
import com.onfido.sdk.flutter.serializer.deserializeOnfidoBuilder
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

internal class StartMethod(
    private val activityProvider: FlutterActivityProvider,
    private val client: Onfido,
    private val assets: FlutterPlugin.FlutterAssets
) : BaseMethod {
    override val name: String = "start"

    companion object {
        const val startRequestCode: Int = 203040
    }

    override fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val activity = activityProvider.provide() ?: throw Exception("Invalid activity")
        val onfidoBuilder = call.arguments.deserializeOnfidoBuilder(activity, assets).build()
        this.client.startActivityForResult(activity, startRequestCode, onfidoBuilder)
    }
}