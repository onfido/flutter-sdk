//
//  AppearanceSerializer.swift
//  onfido_sdk
//
//  Created by Pedro Henrique on 12/08/2022.
//

import Foundation
import Onfido

extension Appearance {
    static func from(dictionary: NSDictionary) -> Appearance {
        let appearance = Appearance()
        appearance.fontBold = dictionary["fontBold"] as? String
        appearance.fontRegular = dictionary["fontRegular"] as? String

        if let supportDarkMode = dictionary["supportDarkMode"] as? Bool {
            appearance.supportDarkMode = supportDarkMode
        }

        if let buttonCornerRadius = dictionary["buttonCornerRadius"] as? CGFloat {
            appearance.buttonCornerRadius = buttonCornerRadius
        }

        if let primaryColor = self.getColor(for: "primaryColor", at: dictionary) {
            appearance.primaryColor = primaryColor
        }

        if let secondaryBackgroundPressedColor = self.getColor(for: "secondaryBackgroundPressedColor", at: dictionary) {
            appearance.secondaryBackgroundPressedColor = secondaryBackgroundPressedColor
        }

        if let primaryBackgroundPressedColor = self.getColor(for: "primaryBackgroundPressedColor", at: dictionary) {
            appearance.primaryBackgroundPressedColor = primaryBackgroundPressedColor
        }

        if let secondaryTitleColor = self.getColor(for: "secondaryTitleColor", at: dictionary) {
            appearance.secondaryTitleColor = secondaryTitleColor
        }

        if let primaryTitleColor = self.getColor(for: "primaryTitleColor", at: dictionary) {
            appearance.primaryTitleColor = primaryTitleColor
        }

        if let bubbleErrorBackgroundColor = self.getColor(for: "bubbleErrorBackgroundColor", at: dictionary) {
            appearance.bubbleErrorBackgroundColor = bubbleErrorBackgroundColor
        }

        return appearance
    }

    static private func getColor(for name: String, at dictionary: NSDictionary) -> UIColor? {
        let color = dictionary[name] as? String
        return UIColor(unsafeHex: color)
    }
}
