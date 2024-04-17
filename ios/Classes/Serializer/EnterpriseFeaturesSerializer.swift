//
//  EnterpriseFeaturesSerializer.swift
//  onfido_sdk
//
//  Created by Pedro Henrique on 09/08/2022.
//

import Foundation
import Onfido

extension EnterpriseFeatures {
    static func builder(with dictionary: NSDictionary) -> EnterpriseFeatures {
        let enterpriseBuilder = EnterpriseFeatures.Builder()

        if let hideOnfidoLogo = dictionary["hideOnfidoLogo"] as? Bool, hideOnfidoLogo {
            enterpriseBuilder.withHideOnfidoLogo(true)
        }

        if let cobrandingText = dictionary["cobrandingText"] as? String, !cobrandingText.isEmpty {
            enterpriseBuilder.withCobrandingText(cobrandingText)
        }

        if let disableMobileSDKAnalytics = dictionary["disableMobileSDKAnalytics"] as? Bool, disableMobileSDKAnalytics {
            enterpriseBuilder.withDisableMobileSdkAnalytics(true)
        }

        return enterpriseBuilder.build()
    }
}
