package com.onfido.sdk.flutter.serializer

import com.onfido.workflow.WorkflowConfig
import com.onfido.android.sdk.capture.EnterpriseFeatures
import com.onfido.android.sdk.capture.EnterpriseFeatures.Builder
import android.content.Context

fun Any.deserializeWorkflowConfig(): WorkflowConfig {
    if (this !is Map<*, *>) throw Exception("Invalid arguments for start method")

    val sdkToken =
        this["sdkToken"] as? String ?: throw Exception("Invalid arguments for start method")
    val workflowRunId =
        this["workflowRunId"] as? String ?: throw Exception("Invalid arguments for start method")

    var builder = WorkflowConfig.Builder(sdkToken, workflowRunId)

    val enterpriseFeatures = this["enterpriseFeatures"] as? Map<*, *>
    enterpriseFeatures?.let {
        val features = EnterpriseFeatures.buildFromMap(it)
        builder.withEnterpriseFeatures(features)
    }
    return builder.build()

}
