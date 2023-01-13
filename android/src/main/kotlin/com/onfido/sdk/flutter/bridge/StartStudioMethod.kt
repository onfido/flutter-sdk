package com.onfido.sdk.flutter.bridge

import com.onfido.workflow.OnfidoWorkflow
import com.onfido.sdk.flutter.api.FlutterActivityProvider
import com.onfido.sdk.flutter.serializer.deserializeWorkflowConfig
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

internal class StartStudioMethod(
    private val activityProvider: FlutterActivityProvider,
    private val client: OnfidoWorkflow
) : BaseMethod {
    override val name: String = "startStudio"

    companion object {
        const val startRequestCode: Int = 205040
    }

    override fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val activity = activityProvider.provide() ?: throw Exception("Invalid activity")

        client.startActivityForResult(
            activity,
            startRequestCode,
            call.arguments.deserializeWorkflowConfig()
        )
    }
}