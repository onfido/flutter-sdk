package com.onfido.sdk.flutter.serializer

import com.onfido.android.sdk.capture.OnfidoTheme


@Throws(Exception::class)
fun getTheme(theme: String): OnfidoTheme {
    return when (theme) {
        "LIGHT" -> OnfidoTheme.LIGHT
        "DARK" -> OnfidoTheme.DARK
        "AUTOMATIC" -> OnfidoTheme.AUTOMATIC
        else -> {
            System.err.println("Unexpected theme value: [$theme]");
            throw IllegalArgumentException("Unexpected theme value");
        }
    }
}