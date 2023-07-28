package com.onfido.sdk.flutter.serializer

import com.onfido.android.sdk.capture.config.DocumentMetadata
import com.onfido.android.sdk.capture.config.MediaResult
import com.onfido.android.sdk.capture.config.MediaResult.DocumentResult
import com.onfido.android.sdk.capture.config.MediaResult.LivenessResult
import com.onfido.android.sdk.capture.config.MediaResult.SelfieResult
import com.onfido.android.sdk.capture.config.MediaFile

internal fun MediaResult.toFlutterResult(): Map<String, *> {
    val elements = mutableMapOf<String, Any>()

    when (this) {
        is DocumentResult -> {
            val documentResult: DocumentResult = this
            elements["resultType"] = "documentResult"
            elements[KEY_DATA] = documentResult.fileData.deserialize()

            documentResult.documentMetadata.let {
                elements["fileMetadata"] = it.deserialize()
            }
        }

        is LivenessResult -> {
            val livenessResult: LivenessResult = this
            elements["resultType"] = "livenessResult"
            elements[KEY_DATA] = livenessResult.fileData.deserialize()
        }

        is SelfieResult -> {
            val selfieResult: SelfieResult = this
            elements["resultType"] = "selfieResult"
            elements[KEY_DATA] = selfieResult.fileData.deserialize()
        }
    }

    return elements
}

private fun DocumentMetadata.deserialize(): Map<String, *> {
    return mapOf(
        KEY_DOCUMENT_SIDE to this.side,
        KEY_DOCUMENT_TYPE to this.type,
        KEY_DOCUMENT_ISSUING_COUNTRY to this.issuingCountry
    )
}

private fun MediaFile.deserialize(): Map<String, *> {
    return mapOf(
        KEY_FILE_NAME to this.fileName,
        KEY_FILE_TYPE to this.fileType,
        KEY_FILE_DATA to this.fileData
    )
}

const val KEY_FILE_DATA = "fileData"
const val KEY_FILE_NAME = "fileName"
const val KEY_FILE_TYPE = "fileType"

const val KEY_DOCUMENT_SIDE = "side"
const val KEY_DOCUMENT_TYPE = "type"
const val KEY_DOCUMENT_ISSUING_COUNTRY = "issuingCountry"

const val KEY_DATA = "data"
const val KEY_CAPTURE_TYPE = "captureType"