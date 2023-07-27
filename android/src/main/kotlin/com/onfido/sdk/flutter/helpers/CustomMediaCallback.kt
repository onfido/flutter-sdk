package com.onfido.sdk.flutter.helpers

import com.onfido.android.sdk.capture.config.MediaCallback
import com.onfido.android.sdk.capture.config.MediaResult
import com.onfido.sdk.flutter.OnfidoPlugin
import com.onfido.sdk.flutter.serializer.toFlutterResult

class CustomMediaCallback : MediaCallback {

    override fun onMediaCaptured(result: MediaResult) {
        val methodChannel = OnfidoPlugin.channel
        methodChannel.invokeMethod("onMediaCaptured", result.toFlutterResult())
    }
}