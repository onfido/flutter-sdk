//
//  FlutterViewController.swift
//  onfido_sdk
//
//  Created by Pedro Henrique on 21/07/2022.
//

import Foundation

func getFlutterViewController() -> FlutterViewController? {
    var window: UIWindow?
    if #available(iOS 13.0, *) {
        window = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    } else {
        window = UIApplication.shared.windows.first { $0.isKeyWindow }
    }
    return window?.rootViewController as? FlutterViewController
}

@objcMembers
final class PluginMetadata: NSObject {
    let pluginPlatform = "flutter"
    let pluginVersion = "4.0.0"     // add the current version
}
