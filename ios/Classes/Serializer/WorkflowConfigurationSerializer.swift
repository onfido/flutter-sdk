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
        if let fileName = dictionary["iosLocalizationFileName"] as? String {
            withCustomLocalization(withTableName: fileName, in: Bundle.self.main)
        }

        if let iosAppearance = dictionary["iosAppearance"] as? NSDictionary {
            withAppearance(Appearance.from(dictionary: iosAppearance))
        }

        if let shouldUseMediaCallback = dictionary["shouldUseMediaCallback"] as? Bool, shouldUseMediaCallback {
            withMediaCallback(mediaCallback: CustomMediaCallback())
        }
    }
}
