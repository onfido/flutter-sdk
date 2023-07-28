package com.onfido.sdk.flutter.serializer

import android.content.Context
import com.onfido.android.sdk.capture.EnterpriseFeatures
import com.onfido.android.sdk.capture.OnfidoConfig
import com.onfido.android.sdk.capture.ui.camera.face.stepbuilder.FaceCaptureStepBuilder
import com.onfido.android.sdk.capture.ui.camera.face.stepbuilder.MotionCaptureStepBuilder
import com.onfido.android.sdk.capture.ui.options.FlowStep
import com.onfido.android.sdk.capture.ui.options.stepbuilder.DocumentCaptureStepBuilder
import com.onfido.sdk.flutter.helpers.CustomMediaCallback
import io.flutter.embedding.engine.plugins.FlutterPlugin

internal fun Any?.deserializeOnfidoBuilder(
    context: Context,
    assets: FlutterPlugin.FlutterAssets,
): OnfidoConfig.Builder {
    if (this !is Map<*, *>) throw Exception("Invalid arguments for start method")

    val builder = OnfidoConfig.builder(context)

    (this["sdkToken"] as? String)?.let {
        builder.withSDKToken(it)
    }

    val flowSteps = this["flowSteps"] as? Map<*, *>
        ?: throw Exception("Invalid arguments for start method (flow steps)")

    val steps = mutableListOf<FlowStep>()
    if (flowSteps["welcome"] == true) {
        steps.add(FlowStep.WELCOME)
    }

    if (flowSteps["proofOfAddress"] == true) {
        steps.add(FlowStep.PROOF_OF_ADDRESS)
    }

    val captureDocument = flowSteps["documentCapture"] as? Map<*, *>
    val docType = captureDocument?.get("documentType") as? String
    val country = captureDocument?.get("countryCode") as? String

    if (docType != null && country != null) {
        val countryCode = getCountryCodeFrom(country)

        val documentStepBuilder = DocumentCaptureStepBuilder
        val documentStep: FlowStep =
            when (docType) {
                "passport" -> {
                    documentStepBuilder.forPassport().build()
                }
                "drivingLicence" -> {
                    documentStepBuilder.forDrivingLicence().withCountry(countryCode).build()
                }
                "nationalIdentityCard" -> {
                    documentStepBuilder.forNationalIdentity().withCountry(countryCode).build()
                }
                "residencePermit" -> {
                    documentStepBuilder.forResidencePermit().withCountry(countryCode).build()
                }
                "visa" -> {
                    documentStepBuilder.forVisa().withCountry(countryCode).build()
                }
                "workPermit" -> {
                    documentStepBuilder.forWorkPermit().withCountry(countryCode).build()
                }
                "generic" -> {
                    documentStepBuilder.forGenericDocument().withCountry(countryCode).build()
                }
                else -> throw Exception("Unsupported document type")
            }

        steps.add(documentStep)

    } else if (captureDocument != null) {
        steps.add(FlowStep.CAPTURE_DOCUMENT)
    }

    (flowSteps["faceCapture"] as? Map<*, *>)?.let { faceCapture ->
        (faceCapture["type"] as? String)?.let { type ->
            val faceStepBuilder = FaceCaptureStepBuilder
            val faceStep = when (type) {
                "photo" -> getPhotoCaptureStepBuilder(faceStepBuilder, faceCapture)
                "video" -> getVideoCaptureStepBuilder(faceStepBuilder, faceCapture)
                "motion" -> getMotionCaptureStepBuilder(faceStepBuilder, faceCapture)
                else -> throw Exception("Unsupported face capture type")
            }
            steps.add(faceStep.build())
        }
    }

    builder.withCustomFlow(steps.toTypedArray())

    val enterpriseFeatures = this["enterpriseFeatures"] as? Map<*, *> ?: return builder
    val features = EnterpriseFeatures.buildFromMap(enterpriseFeatures)
    builder.withEnterpriseFeatures(features)

    if (this["disableNFC"] as? Boolean == true) {
        builder.disableNFC()
    }

    val withMediaCallback = this["shouldUseMediaCallback"] as? Boolean ?: false
    if (withMediaCallback) {
        builder.withMediaCallback(mediaCallback = CustomMediaCallback())
    }

    return builder
}

private fun getPhotoCaptureStepBuilder(
    faceStepBuilder: FaceCaptureStepBuilder,
    faceCapture: Map<*, *>
) = faceStepBuilder.forPhoto().apply {
    (faceCapture["withIntroScreen"] as? Boolean)?.let {
        this.withIntro(it)
    }
}

private fun getVideoCaptureStepBuilder(
    faceStepBuilder: FaceCaptureStepBuilder,
    faceCapture: Map<*, *>
) = faceStepBuilder.forVideo().apply {
    (faceCapture["withIntroVideo"] as? Boolean)?.let {
        this.withIntro(it)
    }
    (faceCapture["withConfirmationVideoPreview"] as? Boolean)?.let {
        this.withConfirmationVideoPreview(it)
    }
}

private fun getMotionCaptureStepBuilder(
    faceStepBuilder: FaceCaptureStepBuilder,
    faceCapture: Map<*, *>
): MotionCaptureStepBuilder {
    val motionCaptureStepBuilder = faceStepBuilder.forMotion()

    (faceCapture["withAudio"] as? Boolean)?.let {
        motionCaptureStepBuilder.withAudio(it)
    }

    (faceCapture["withCaptureFallback"] as? Map<*, *>)?.let { captureFallback ->
        (captureFallback["type"] as? String)?.let { type ->
            when (type) {
                "photo" -> motionCaptureStepBuilder.withCaptureFallback(
                    getPhotoCaptureStepBuilder(faceStepBuilder, captureFallback)
                )
                "video" -> motionCaptureStepBuilder.withCaptureFallback(
                    getVideoCaptureStepBuilder(faceStepBuilder, captureFallback)
                )
                else -> Unit// No fallback
            }
        }
    }

    return motionCaptureStepBuilder
}

fun EnterpriseFeatures.Companion.buildFromMap(
    map: Map<*, *>
): EnterpriseFeatures {
    val builder = EnterpriseFeatures.Builder()

    if (map["hideOnfidoLogo"] as? Boolean == true) {
        builder.withHideOnfidoLogo(true)
    }

    if (map["disableMobileSDKAnalytics"] as? Boolean == true) {
        builder.disableMobileSdkAnalytics()
    }

    (map["cobrandingText"] as? String)?.let {
        builder.withCobrandingText(it)
    }

    return builder.build()
}
