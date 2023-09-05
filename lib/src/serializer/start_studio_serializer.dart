import 'package:flutter/foundation.dart';
import 'package:onfido_sdk/onfido_sdk.dart';

/// convert dart code to dictionary to be passed to the paltform
class StartStudioSerializer {
  static serialize(
      {required String sdkToken,
      required String workflowRunId,
      IOSAppearance? iosAppearance,
      String? iosLocalizationFileName,
      bool? shouldUseMediaCallback,
      EnterpriseFeatures? enterpriseFeatures,
      OnfidoTheme? onfidoTheme}) {
    return {
      'sdkToken': sdkToken,
      'workflowRunId': workflowRunId,
      'iosAppearance': iosAppearance?.toJson(),
      'iosLocalizationFileName': iosLocalizationFileName,
      'shouldUseMediaCallback': shouldUseMediaCallback,
      'enterpriseFeatures': enterpriseFeatures?.toJson(),
      'onfidoTheme': onfidoTheme == null ? null : describeEnum(onfidoTheme)
    };
  }
}
