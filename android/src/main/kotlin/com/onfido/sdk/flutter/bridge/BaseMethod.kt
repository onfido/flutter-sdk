package com.onfido.sdk.flutter.bridge

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

interface BaseMethod {
    val name: String
    fun invoke(call: MethodCall, result: MethodChannel.Result)
}