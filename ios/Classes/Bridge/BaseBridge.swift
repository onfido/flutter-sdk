//
//  BaseBridge.swift
//  onfido_sdk
//
//  Created by Pedro Henrique on 18/07/2022.
//

import Foundation
import Flutter

protocol BaseBridge {
    var name: String { get }

    func invoke(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}
