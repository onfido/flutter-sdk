import Foundation
import Onfido

enum OnfidoLocalizationHelper {
    private static var onfidoBundle: Bundle {
        Bundle(for: WorkflowConfiguration.self)
    }

    static func localizedBundle(for locale: String) -> Bundle? {
        for candidate in localizationCandidates(for: locale) {
            guard let path = onfidoBundle.path(forResource: candidate, ofType: "lproj"),
                  let bundle = Bundle(path: path) else {
                continue
            }
            return bundle
        }
        return nil
    }

    static func applyLocalization(
        to builder: OnfidoConfigBuilder,
        locale: String?,
        customLocalizationFileName: String?
    ) {
        if let customLocalizationFileName {
            builder.withCustomLocalization(andTableName: customLocalizationFileName)
            return
        }

        guard let locale, !locale.isEmpty, let localizedBundle = localizedBundle(for: locale) else {
            return
        }

        builder.withCustomLocalization(andTableName: "Localizable", in: localizedBundle)
    }

    static func applyLocalization(
        to configuration: WorkflowConfiguration,
        locale: String?,
        customLocalizationFileName: String?
    ) {
        if let customLocalizationFileName {
            configuration.withCustomLocalization(withTableName: customLocalizationFileName, in: .main)
            return
        }

        guard let locale, !locale.isEmpty, let localizedBundle = localizedBundle(for: locale) else {
            return
        }

        configuration.withCustomLocalization(withTableName: "Localizable", in: localizedBundle)
    }

    private static func localizationCandidates(for locale: String) -> [String] {
        let normalized = locale.replacingOccurrences(of: "_", with: "-")
        let components = normalized.split(separator: "-", omittingEmptySubsequences: true)

        guard let language = components.first else {
            return [normalized]
        }

        var candidates = [String]()

        if components.count >= 2 {
            let region = String(components[1])
            candidates.append("\(language)-\(region)")
            candidates.append("\(language)-\(region.uppercased())")
            candidates.append("\(language)-\(region.lowercased())")
        }

        candidates.append(String(language))
        candidates.append(normalized)

        var uniqueCandidates: [String] = []
        for candidate in candidates where !uniqueCandidates.contains(candidate) {
            uniqueCandidates.append(candidate)
        }

        return uniqueCandidates
    }
}