package com.onfido.sdk.flutter.serializer

import com.onfido.workflow.WorkflowConfig

fun Any.deserializeWorkflowConfig(): WorkflowConfig {
    if (this !is Map<*, *>) throw Exception("Invalid arguments for start method")

    val sdkToken =
        this["sdkToken"] as? String ?: throw Exception("Invalid arguments for start method")
    val workflowRunId =
        this["workflowRunId"] as? String ?: throw Exception("Invalid arguments for start method")

    return WorkflowConfig.Builder(sdkToken = sdkToken, workflowRunId = workflowRunId).build()
}
