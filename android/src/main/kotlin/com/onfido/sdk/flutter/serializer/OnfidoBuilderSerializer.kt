package com.onfido.sdk.flutter.serializer

import android.app.Activity
import android.content.Context
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import android.util.Log
import com.onfido.android.sdk.capture.DocumentType
import com.onfido.android.sdk.capture.EnterpriseFeatures
import com.onfido.android.sdk.capture.OnfidoConfig
import com.onfido.android.sdk.capture.R
import com.onfido.android.sdk.capture.config.EnterpriseConfig
import com.onfido.android.sdk.capture.ui.camera.face.stepbuilder.FaceCaptureStepBuilder
import com.onfido.android.sdk.capture.ui.options.CaptureScreenStep
import com.onfido.android.sdk.capture.ui.options.FlowStep
import com.onfido.android.sdk.capture.ui.options.stepbuilder.DocumentCaptureStepBuilder
import com.onfido.android.sdk.capture.utils.CountryCode
import com.onfido.sdk.flutter.api.FlutterActivityProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin

internal fun Any?.deserializeOnfidoBuilder(
    context: Context,
    assets: FlutterPlugin.FlutterAssets
): OnfidoConfig.Builder {
    if (this !is Map<*, *>) throw Exception("Invalid arguments for start method")

    val builder = OnfidoConfig.builder(context)

    (this["sdkToken"] as? String)?.let {
        builder.withSDKToken(it)
    }

    val flowSteps =
        this["flowSteps"] as? Map<*, *> ?: throw Exception("Invalid arguments for start method")

    val steps = mutableListOf<FlowStep>()
    if (flowSteps["welcome"] == true) {
        steps.add(FlowStep.WELCOME)
    }

    if (flowSteps["proofOfAddress"] == true) {
        steps.add(FlowStep.PROOF_OF_ADDRESS)
    }

    val captureDocument = flowSteps["documentCapture"] as? Map<*, *>
    val docType = (captureDocument?.get("documentType") as? String)
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

    (flowSteps["faceCapture"] as? String)?.let {
        val faceStepBuilder = FaceCaptureStepBuilder
        val faceStep = when (it) {
            "photo" -> faceStepBuilder.forPhoto()
            "video" -> faceStepBuilder.forVideo()
            else -> throw Exception("Unsupported face capture type")
        }
        steps.add(faceStep.build())
    }

    builder.withCustomFlow(steps.toTypedArray())

    val enterpriseFeatures =
        this["enterpriseFeatures"] as? Map<*, *> ?: return builder

    val features = EnterpriseFeatures.buildFromMap(enterpriseFeatures, context, assets)
    builder.withEnterpriseFeatures(features)

    return builder
}

fun EnterpriseFeatures.Companion.buildFromMap(
    map: Map<*, *>,
    context: Context,
    assets: FlutterPlugin.FlutterAssets
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
