import 'dart:ui';

import 'package:onfido_sdk/src/serializer/color_serializer.dart';

class IOSAppearance {
  final Color? primaryColor;
  final Color? primaryTitleColor;
  final Color? secondaryTitleColor;
  final Color? primaryBackgroundPressedColor;
  final Color? secondaryBackgroundPressedColor;
  final int? buttonCornerRadius;
  final String? fontRegular;
  final String? fontBold;
  final bool? supportDarkMode;
  final Color? bubbleErrorBackgroundColor;

  IOSAppearance(
      {this.primaryColor,
      this.primaryTitleColor,
      this.secondaryTitleColor,
      this.primaryBackgroundPressedColor,
      this.secondaryBackgroundPressedColor,
      this.buttonCornerRadius,
      this.fontRegular,
      this.fontBold,
      this.supportDarkMode,
      this.bubbleErrorBackgroundColor});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['primaryColor'] = ColorSerializer.serialize(primaryColor);
    data['primaryTitleColor'] = ColorSerializer.serialize(primaryTitleColor);
    data['secondaryTitleColor'] = ColorSerializer.serialize(secondaryTitleColor);
    data['primaryBackgroundPressedColor'] = ColorSerializer.serialize(primaryBackgroundPressedColor);
    data['secondaryBackgroundPressedColor'] = ColorSerializer.serialize(secondaryBackgroundPressedColor);
    data['bubbleErrorBackgroundColor'] = ColorSerializer.serialize(bubbleErrorBackgroundColor);

    data['buttonCornerRadius'] = buttonCornerRadius;
    data['fontRegular'] = fontRegular;
    data['fontBold'] = fontBold;
    data['supportDarkMode'] = supportDarkMode;

    return data;
  }
}
