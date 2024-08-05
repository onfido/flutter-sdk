package com.onfido.sdk.flutter.serializer

import com.onfido.android.sdk.capture.model.NFCOptions
import com.onfido.android.sdk.capture.model.NFCOptions.Disabled
import com.onfido.android.sdk.capture.model.NFCOptions.Enabled.Optional
import com.onfido.android.sdk.capture.model.NFCOptions.Enabled.Required

internal fun getNFCOption(nfcOption: String): NFCOptions {
    val nfcOptionsMap = mapOf(
        "DISABLED" to Disabled,
        "OPTIONAL" to Optional,
        "REQUIRED" to Required
    )
    return nfcOptionsMap.getOrDefault(nfcOption, Optional)
}
