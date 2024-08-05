//
//  BaseBridge.swift
//  onfido_sdk
//
//  Created by Pedro Henrique on 18/07/2022.
//

import Foundation
import Flutter
import Onfido

protocol BaseBridge {
    var name: String { get }

    func invoke(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

extension BaseBridge {
    static func extractDetails(from error: Error) -> String? {
        // In case we receive a `OnfidoFlowError`, we want to include more details about the underlying
        // error in the `FlutterError`. In any other case, we only care about the error's localized description.
        guard let flowError = error as? OnfidoFlowError else { return nil }
        return String(describing: error)
    }
}
