//
//  AppearanceSerializer.swift
//  onfido_sdk
//
//  Created by Pedro Henrique on 12/08/2022.
//

import Foundation
import Onfido

extension Appearance {
    func withAttributes(from dictionary: NSDictionary) -> Appearance {
        fontBold = dictionary["fontBold"] as? String
        fontRegular = dictionary["fontRegular"] as? String

        if
            let backgroundColor = dictionary["backgroundColor"] as? NSDictionary,
            let lightColor = extractColor("light", from: backgroundColor),
            let darkColor = extractColor("dark", from: backgroundColor)
        {
            self.backgroundColor = .init(lightColor: lightColor, darkColor: darkColor)
        }

        if let buttonCornerRadius = dictionary["buttonCornerRadius"] as? CGFloat {
            self.buttonCornerRadius = buttonCornerRadius
        }

        if let primaryColor = extractColor("primaryColor", from: dictionary) {
            self.primaryColor = primaryColor
        }

        if let secondaryBackgroundPressedColor = extractColor("secondaryBackgroundPressedColor", from: dictionary) {
            self.secondaryBackgroundPressedColor = secondaryBackgroundPressedColor
        }

        if let primaryBackgroundPressedColor = extractColor("primaryBackgroundPressedColor", from: dictionary) {
            self.primaryBackgroundPressedColor = primaryBackgroundPressedColor
        }

        if let secondaryTitleColor = extractColor("secondaryTitleColor", from: dictionary) {
            self.secondaryTitleColor = secondaryTitleColor
        }

        if let primaryTitleColor = extractColor("primaryTitleColor", from: dictionary) {
            self.primaryTitleColor = primaryTitleColor
        }

        return self
    }
}

private func extractColor(_ colorName: String, from dictionary: NSDictionary) -> UIColor? {
    let color = dictionary[colorName] as? String
    return UIColor(unsafeHex: color)
}

@available(iOS 12.0, *)
extension UIUserInterfaceStyle {
    init(_ stringRepresentation: String) {
        switch stringRepresentation {
        case "LIGHT": self = .light
        case "DARK": self = .dark
        default: self = .unspecified
        }
    }
}
