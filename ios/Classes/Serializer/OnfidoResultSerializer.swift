//
//  OnfidoResultSerializer.swift
//  onfido_sdk
//
//  Created by Pedro Henrique on 18/07/2022.
//

import Foundation
import Onfido

extension OnfidoResult {
    func serialize() -> Any {
        switch self {
        case .document(let document):
            return ["document": document.serialize()]
        case .face(let face):
            return ["face": face.serialize()]
        case .proofOfAddress(let address):
            return ["proofOfAddress": address.serialize()]

        default:
            return [:]
        }
    }
}

extension DocumentResult {
    func serialize() -> Any {
        var data: [String: Any] = [
            "front": ["id": front.id],
            "typeSelected": typeSelected,
        ]

        if let back = back {
            data["back"] = ["id": back.id]
        }

        if let countrySelected = countrySelected {
            data["countrySelected"] = countrySelected
        }
        
        return data
    }
}

extension FaceResult {
    func serialize() -> Any {
        return [
            "id": id,
            "variant": variant.rawValue
        ]
    }
}

extension ProofOfAddressResult {
    func serialize() -> Any {
        return [
            "id": id,
            "type": type,
            "issuingCountry": issuingCountry
        ]
    }
}
