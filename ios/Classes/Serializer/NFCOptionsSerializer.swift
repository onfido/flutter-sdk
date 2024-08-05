import Onfido

func getNFCConfiguration(_ nfcOption: String) -> NFCConfiguration {
    let nfcConfigurationMap: [String: NFCConfiguration] = [
        "DISABLED": .off,
        "OPTIONAL": .optional,
        "REQUIRED": .required
    ]
    return nfcConfigurationMap[nfcOption, default: .optional]
}
