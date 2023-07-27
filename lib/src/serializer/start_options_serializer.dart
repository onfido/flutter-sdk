import 'package:onfido_sdk/onfido_sdk.dart';

class StartOptionsSerializer {
  static serialize(
      {required String sdkToken,
      required FlowSteps flowSteps,
      IOSAppearance? iosAppearance,
      bool? shouldUseMediaCallback,
      EnterpriseFeatures? enterpriseFeatures,
      String? iosLocalizationFileName,
      bool? disableNFC}) {
    return {
      'sdkToken': sdkToken,
      'flowSteps': flowSteps.toJson(),
      'iosAppearance': iosAppearance?.toJson(),
      'iosLocalizationFileName': iosLocalizationFileName,
      'disableNFC': disableNFC,
      'shouldUseMediaCallback': shouldUseMediaCallback,
      'enterpriseFeatures': enterpriseFeatures?.toJson()
    };
  }
}
