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

        if let fileName = dictionary["iosLocalizationFileName"] as? String {
            self.localisation = (Bundle.self.main, fileName)
        }

        if let iosAppearance = dictionary["iosAppearance"] as? NSDictionary {
            self.appearance = (Appearance.from(dictionary: iosAppearance))
        }
    }
}
