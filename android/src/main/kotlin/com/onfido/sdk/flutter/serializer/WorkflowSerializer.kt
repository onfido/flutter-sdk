package com.onfido.sdk.flutter.serializer

import com.onfido.workflow.WorkflowConfig
import com.onfido.android.sdk.capture.EnterpriseFeatures
import com.onfido.sdk.flutter.helpers.BiometricTokenCallbackBridge
import com.onfido.sdk.flutter.helpers.CustomMediaCallback
import java.util.Locale

fun Any.deserializeWorkflowConfig(): WorkflowConfig {
    if (this !is Map<*, *>) throw Exception("Invalid arguments for start method")

    val sdkToken = this["sdkToken"] as? String
        ?: throw Exception("Invalid arguments for start method (SDK token)")

    val workflowRunId = this["workflowRunId"] as? String
        ?: throw Exception("Invalid arguments for start method (workflow run ID")

    val builder = WorkflowConfig.Builder(sdkToken, workflowRunId)

    (this["locale"] as? String)?.takeIf { it.isNotBlank() }?.let { localeTag ->
        builder.withLocale(Locale.forLanguageTag(localeTag))
    }

    val withMediaCallback = this["shouldUseMediaCallback"] as? Boolean ?: false
    if (withMediaCallback) {
        builder.withMediaCallback(mediaCallback = CustomMediaCallback())
    }

    val withBiometricTokenCallback = this["shouldUseBiometricTokenCallback"] as? Boolean ?: false
    if (withBiometricTokenCallback) {
        builder.withBiometricTokenCallback(tokenCallback = BiometricTokenCallbackBridge())
    }

    val enterpriseFeatures = this["enterpriseFeatures"] as? Map<*, *>
    enterpriseFeatures?.let {
        val features = EnterpriseFeatures.buildFromMap(it)
        builder.withEnterpriseFeatures(features)
    }

    val theme = this["onfidoTheme"] as? String
    if (theme != null) {
        builder.withTheme(getTheme(theme))
    }
    return builder.build()
}
