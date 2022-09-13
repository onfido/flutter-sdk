package com.onfido.sdk.flutter.api

import android.app.Activity

internal interface FlutterActivityProvider {
    fun provide(): Activity?
}