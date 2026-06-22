//
//  WorkflowConfigurationSerializer.swift
//  onfido_sdk
//
//  Created by Pedro Henrique on 12/08/2022.
//

import Foundation
import Onfido

extension WorkflowConfiguration {
    convenience init(from dictionary: NSDictionary) throws {
        guard
            let token = dictionary.value(forKey: "sdkToken") as? String,
            let workflowRunId = dictionary.value(forKey: "workflowRunId") as? String
        else { throw NSError(domain: "Invalid serialization", code: 0) }

        self.init(workflowRunId: workflowRunId, sdkToken: token)

        if let enterpriseFeatures = dictionary["enterpriseFeatures"] as? NSDictionary {
            withEnterpriseFeatures(EnterpriseFeatures.builder(with: enterpriseFeatures))
         }
        OnfidoLocalizationHelper.applyLocalization(
            to: self,
            locale: dictionary["locale"] as? String,
            customLocalizationFileName: dictionary["iosLocalizationFileName"] as? String
        )

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

        withAppearance(appearance)

        if let shouldUseMediaCallback = dictionary["shouldUseMediaCallback"] as? Bool, shouldUseMediaCallback {
            withMediaCallback(mediaCallback: CustomMediaCallback())
        }

        if let shouldUseBiometricTokenCallback = dictionary["shouldUseBiometricTokenCallback"] as? Bool,
           shouldUseBiometricTokenCallback
        {
            withEncryptedBiometricTokenHandler(handler: CustomEncryptedBiometricTokenCallback())
        }
    }
}
