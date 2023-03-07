//
//  OnfidoBuilderSerializer.swift
//  onfido_sdk
//
//  Created by Pedro Henrique on 21/07/2022.
//

import Foundation
import Onfido

extension OnfidoConfig {

    static func builder(with dictionary: NSDictionary, assetProvider: FlutterPluginRegistrar) throws -> OnfidoConfigBuilder {
        let onfidoBuilder = Self.builder()

        if let token = dictionary.value(forKey: "sdkToken") as? String {
            onfidoBuilder.withSDKToken(token)
        }

        if let fileName = dictionary["iosLocalizationFileName"] as? String {
            onfidoBuilder.withCustomLocalization(andTableName: fileName)
        }

        if let iosAppearance = dictionary["iosAppearance"] as? NSDictionary {
            onfidoBuilder.withAppearance(Appearance.from(dictionary: iosAppearance))
        }

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

        if let faceCapture = flowSteps["faceCapture"] as? String {
            try configFaceCapture(value: faceCapture, onfidoBuilder: onfidoBuilder)
        }

        if let enableNFC = flowSteps["enableNFC"] as? Bool, enableNFC {
            onfidoBuilder.withNFCReadFeatureEnabled()
        }

        guard let enterpriseFeatures = dictionary["enterpriseFeatures"] as? NSDictionary else { return onfidoBuilder }
        onfidoBuilder.withEnterpriseFeatures(EnterpriseFeatures.builder(with: enterpriseFeatures, assetProvider: assetProvider))

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

fileprivate func configFaceCapture(value: String, onfidoBuilder: OnfidoConfigBuilder) throws {
    switch value {
    case "photo":
        onfidoBuilder.withFaceStep(ofVariant: .photo(withConfiguration: nil))
    case "video":
        onfidoBuilder.withFaceStep(ofVariant: .video(withConfiguration: nil))
    default:
        throw NSError(domain: "Unsupported faceStep type", code: 0)
    }
}
