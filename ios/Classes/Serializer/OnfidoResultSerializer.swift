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

        if let nfcMediaId = nfcMediaId {
            data["nfcMediaId"] = nfcMediaId
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
        ] as [String : Any]
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

extension Encodable {
  func toDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}


extension MediaDocumentResult: Encodable {
    enum Keys: String, CodingKey {
        case resultType
        case fileData = "data"
        case fileMetadata
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode("documentResult", forKey: .resultType)
        try container.encode(file, forKey: .fileData)
        try container.encode(metadata, forKey: .fileMetadata)
    }
}

extension LivenessResult: Encodable {
    enum Keys: String, CodingKey {
        case resultType
        case fileData = "data"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode("livenessResult", forKey: .resultType)
        try container.encode(file, forKey: .fileData)
    }
}

extension SelfieResult: Encodable {
    enum Keys: String, CodingKey {
        case resultType
        case fileData = "data"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode("selfieResult", forKey: .resultType)
        try container.encode(file, forKey: .fileData)
    }
}

extension MediaFile: Encodable {
    enum Keys: String, CodingKey {
        case fileName
        case fileData
        case fileType
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(fileName, forKey: .fileName)
        try container.encode(fileData, forKey: .fileData)
        try container.encode(fileType, forKey: .fileType)
    }
}

extension DocumentMetadata: Encodable {
    enum Keys: String, CodingKey {
        case side
        case type
        case issuingCountry
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(side, forKey: .side)
        try container.encode(type, forKey: .type)
        try container.encode(issuingCountry, forKey: .issuingCountry)
    }
}
