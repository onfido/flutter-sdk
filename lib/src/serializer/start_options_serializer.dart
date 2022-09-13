import 'package:onfido_sdk/onfido_sdk.dart';

class StartOptionsSerializer {
  static serialize(
      {required String sdkToken,
      required FlowSteps flowSteps,
      IOSAppearance? iosAppearance,
      EnterpriseFeatures? enterpriseFeatures,
      String? iosLocalizationFileName}) {
    return {
      'sdkToken': sdkToken,
      'flowSteps': flowSteps.toJson(),
      'iosAppearance': iosAppearance?.toJson(),
      'iosLocalizationFileName': iosLocalizationFileName,
      'enterpriseFeatures': enterpriseFeatures?.toJson()
    };
  }
}
