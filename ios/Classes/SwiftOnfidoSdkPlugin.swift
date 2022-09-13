import Flutter
import UIKit
import Onfido

public class SwiftOnfidoSdkPlugin: NSObject, FlutterPlugin {

    lazy var methods: [String: BaseBridge] = {
        let bridges: [BaseBridge] = [
            StartBridge(assetProvider: assetProvider),
            StartStudioBridge()
        ]

        return bridges.reduce([String : BaseBridge]()) { dict, value in
            var dict = dict
            dict[value.name] = value
            return dict
        }
    }()

    let assetProvider: FlutterPluginRegistrar

    init(assetProvider: FlutterPluginRegistrar) {
        self.assetProvider = assetProvider
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "onfido_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftOnfidoSdkPlugin(assetProvider: registrar)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      guard let method = methods[call.method] else {
          result(FlutterMethodNotImplemented)
          return
      }
      method.invoke(call, result)
    }
}
