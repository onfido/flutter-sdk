import 'package:onfido_sdk/onfido_sdk.dart';

/// convert dart code to dictionary to be passed to the platform
class StartStudioSerializer {
  static serialize(
      {required String sdkToken,
      required String workflowRunId,
      IOSAppearance? iosAppearance,
      String? iosLocalizationFileName,
      String? locale,
      bool? shouldUseMediaCallback,
      bool? shouldUseBiometricTokenCallback,
      EnterpriseFeatures? enterpriseFeatures,
      OnfidoTheme? onfidoTheme}) {
    return {
      'sdkToken': sdkToken,
      'workflowRunId': workflowRunId,
      'iosAppearance': iosAppearance?.toJson(),
      'iosLocalizationFileName': iosLocalizationFileName,
      'locale': locale,
      'shouldUseMediaCallback': shouldUseMediaCallback,
      'shouldUseBiometricTokenCallback': shouldUseBiometricTokenCallback,
      'enterpriseFeatures': enterpriseFeatures?.toJson(),
      'onfidoTheme': onfidoTheme?.name
    };
  }
}
