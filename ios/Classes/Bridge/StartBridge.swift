//
//  StartBridge.swift
//  onfido_sdk
//
//  Created by Pedro Henrique on 18/07/2022.
//

import Foundation
import Onfido

struct StartBridge: BaseBridge {

    let name: String = "start"
    let assetProvider: FlutterPluginRegistrar
    
    func invoke(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        do {
            guard let args = call.arguments as? NSDictionary else {
                throw NSError(domain: "Invalid arguments for start method", code: 500)
            }

            let onfidoBuilder = try OnfidoConfig.builder(with: args, assetProvider: assetProvider)
            let onfidoFlow = OnfidoFlow(withConfiguration: try onfidoBuilder.build())

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

            getFlutterViewController()?.present(try onfidoFlow.run(), animated: true)
        } catch {
            result(FlutterError(code: "configuration", message: error.localizedDescription, details: "\(error)"))
        }
    }
}
