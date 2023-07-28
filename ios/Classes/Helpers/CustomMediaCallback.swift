//
//  CustomMediaCallback.swift
//  onfido_sdk
//
//  Created by Kirill Ivonin on 09/06/2023.
//

import Foundation
import Onfido

class CustomMediaCallback: Onfido.MediaCallback {

    func onMediaCaptured(result: MediaResult) {
        guard
            let result = result as? Encodable,
            let serializedResult = try? result.toDictionary(),
            let channel = SwiftOnfidoSdkPlugin.channel else { return }

        channel.invokeMethod("onMediaCaptured", arguments: serializedResult)
    }
}
