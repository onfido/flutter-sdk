//
//  StartStudioBridge.swift
//  onfido_sdk
//
//  Created by Pedro Henrique on 03/08/2022.
//

import Foundation
import Onfido

struct StartStudioBridge: BaseBridge {

    let name: String = "startStudio"
    func invoke(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        do {
            guard let args = call.arguments as? NSDictionary else {
                throw NSError(domain: "Invalid arguments for start studio method", code: 500)
            }

            let workflow = try WorkflowConfiguration(from: args)
            let onfidoFlow = OnfidoFlow(workflowConfiguration: workflow)

            onfidoFlow.with(responseHandler: {
                switch $0 {
                case .success(let data):
                    let serialized = data.map { $0.serialize() }
                    result(serialized)

                case .error(let error):
                    result(FlutterError(code: "error", message: error.localizedDescription, details: nil))

                case .cancel:
                    result(FlutterError(code: "exit", message: "User canceled the flow", details: nil))

                @unknown default:
                    result(FlutterError())
                }
            })

            guard let viewController = getFlutterViewController() else {
                assertionFailure("There is no viewController to present Onfido flow")
                return
            }

            try onfidoFlow.run(from: viewController, presentationStyle: .fullScreen)
        } catch {
            result(FlutterError(code: "configuration", message: error.localizedDescription, details: "\(error)"))
        }
    }
}
