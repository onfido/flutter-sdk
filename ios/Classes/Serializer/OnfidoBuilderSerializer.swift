//
//  OnfidoBuilderSerializer.swift
//  onfido_sdk
//
//  Created by Pedro Henrique on 21/07/2022.
//

import Foundation
import Onfido

extension OnfidoConfig {
/// convert the dictionary to actual iOS SDK APIs
    static func builder(with dictionary: NSDictionary, assetProvider: FlutterPluginRegistrar) throws -> OnfidoConfigBuilder {
        let onfidoBuilder = Self.builder()

        if let token = dictionary.value(forKey: "sdkToken") as? String {
            onfidoBuilder.withSDKToken(token)
        }

        if let fileName = dictionary["iosLocalizationFileName"] as? String {
            onfidoBuilder.withCustomLocalization(andTableName: fileName)
        }

        var appearance = Appearance()
        if let iosAppearance = dictionary["iosAppearance"] as? NSDictionary {
            appearance = appearance.withAttributes(from: iosAppearance)
        }

        if
            #available(iOS 12.0, *),
            let theme = dictionary["onfidoTheme"] as? String
        {
            appearance.setUserInterfaceStyle(.init(theme))
        }

        onfidoBuilder.withAppearance(appearance)

        guard let flowSteps = dictionary["flowSteps"] as? NSDictionary else { return onfidoBuilder }

        if let welcomeStep = flowSteps["welcome"] as? Bool, welcomeStep {
            onfidoBuilder.withWelcomeStep()
        }

        if let proofOfAddress = flowSteps["proofOfAddress"] as? Bool, proofOfAddress {
            onfidoBuilder.withProofOfAddressStep()
        }

        if let documentCapture = flowSteps["documentCapture"] as? NSDictionary {
            try configDocumentCapture(documentCapture: documentCapture, onfidoBuilder: onfidoBuilder)
        }

        if let faceCapture = flowSteps["faceCapture"] as? NSDictionary {
            try configFaceCapture(faceCapture: faceCapture, onfidoBuilder: onfidoBuilder)
        }

        if let disableNFC = dictionary["disableNFC"] as? Bool, disableNFC {
            onfidoBuilder.disableNFC()
        }

        if let shouldUseMediaCallback = dictionary["shouldUseMediaCallback"] as? Bool, shouldUseMediaCallback {
            onfidoBuilder.withMediaCallback(mediaCallback: CustomMediaCallback())
        }

        guard let enterpriseFeatures = dictionary["enterpriseFeatures"] as? NSDictionary else { return onfidoBuilder }
        onfidoBuilder.withEnterpriseFeatures(EnterpriseFeatures.builder(with: enterpriseFeatures))

        return onfidoBuilder
    }
}

fileprivate func configDocumentCapture(documentCapture: NSDictionary, onfidoBuilder: OnfidoConfigBuilder) throws {
    if let docType = documentCapture["documentType"] as? String, let countryCode = documentCapture["countryCode"] as? String {
        switch docType {
        case "passport":
            onfidoBuilder.withDocumentStep(type: .passport(config: PassportConfiguration()))
        case "drivingLicence":
            onfidoBuilder.withDocumentStep(type: .drivingLicence(config: DrivingLicenceConfiguration(country: countryCode)))
        case "nationalIdentityCard":
            onfidoBuilder.withDocumentStep(type: .nationalIdentityCard(config: NationalIdentityConfiguration(country: countryCode)))
        case "residencePermit":
            onfidoBuilder.withDocumentStep(type: .residencePermit(config: ResidencePermitConfiguration(country: countryCode)))
        case "visa":
            onfidoBuilder.withDocumentStep(type: .visa(config: VisaConfiguration(country: countryCode)))
        case "workPermit":
            onfidoBuilder.withDocumentStep(type: .workPermit(config: WorkPermitConfiguration(country: countryCode)))
        case "generic":
            onfidoBuilder.withDocumentStep(type: .generic(config: GenericDocumentConfiguration(country: countryCode)))
        default:
            throw NSError(domain: "Unsupported document type", code: 0)
        }
    } else {
        onfidoBuilder.withDocumentStep()
    }
}

fileprivate func configFaceCapture(faceCapture: NSDictionary, onfidoBuilder: OnfidoConfigBuilder) throws {
    if let type = faceCapture["type"] as? String {
        switch type {
        case "photo":
            onfidoBuilder.withFaceStep(ofVariant: .photo(withConfiguration: getPhotoStepConfiguration(faceCapture: faceCapture)))
        case "video":
            onfidoBuilder.withFaceStep(ofVariant: .video(withConfiguration: getVideoStepConfiguration(faceCapture: faceCapture)))
        case "motion":
            onfidoBuilder.withFaceStep(ofVariant: .motion(withConfiguration: getMotionStepConfiguration(faceCapture: faceCapture)))
        default:
            throw NSError(domain: "Unsupported faceStep type", code: 0)
        }
    }
}

fileprivate func getPhotoStepConfiguration(faceCapture: NSDictionary) -> PhotoStepConfiguration? {
    if let showIntroScreen = faceCapture["withIntroScreen"] as? Bool {
        return PhotoStepConfiguration(showSelfieIntroScreen: showIntroScreen)
    }
    return nil
}

fileprivate func getVideoStepConfiguration(faceCapture: NSDictionary) -> VideoStepConfiguration? {
    let showIntroVideo: Bool? = faceCapture["withIntroVideo"] as? Bool
    let manualLivenessCapture: Bool? = faceCapture["withManualLivenessCapture"] as? Bool

    if let showIntroVideo = showIntroVideo, let manualLivenessCapture = manualLivenessCapture {
        return VideoStepConfiguration(showIntroVideo: showIntroVideo, manualLivenessCapture: manualLivenessCapture)
    } else if let showIntroVideo = showIntroVideo {
        return VideoStepConfiguration(showIntroVideo: showIntroVideo, manualLivenessCapture: false)
    } else if let manualLivenessCapture = manualLivenessCapture {
        return VideoStepConfiguration(showIntroVideo: true, manualLivenessCapture: manualLivenessCapture)
    }

    return nil
}

fileprivate func getMotionStepConfiguration(faceCapture: NSDictionary) -> MotionStepConfiguration? {
    let recordAudio: Bool? = faceCapture["withAudio"] as? Bool
    var captureFallback: MotionStepCaptureFallback? = nil

    if let fallbackDictionary = faceCapture["withCaptureFallback"] as? NSDictionary,
       let fallbackType = fallbackDictionary["type"] as? String {
        switch fallbackType {
        case "photo":
            captureFallback = MotionStepCaptureFallback(photoFallbackWithConfiguration: getPhotoStepConfiguration(faceCapture: fallbackDictionary))
        case "video":
            captureFallback = MotionStepCaptureFallback(videoFallbackWithConfiguration: getVideoStepConfiguration(faceCapture: fallbackDictionary))
        default:
            break // No fallback
        }
    }

    if let recordAudio = recordAudio, let captureFallback = captureFallback {
        return MotionStepConfiguration(captureFallback: captureFallback, recordAudio: recordAudio)
    } else if let recordAudio = recordAudio {
        return MotionStepConfiguration(recordAudio: recordAudio)
    } else if let captureFallback = captureFallback {
        return MotionStepConfiguration(captureFallback: captureFallback)
    }

    return nil
}
