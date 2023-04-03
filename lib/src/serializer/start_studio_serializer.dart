import 'package:onfido_sdk/onfido_sdk.dart';

/// convert dart code to dictionary to be passed to the paltform
class StartStudioSerializer {
  static serialize(
      {required String sdkToken,
      required String workflowRunId,
      IOSAppearance? iosAppearance,
      String? iosLocalizationFileName,
      EnterpriseFeatures? enterpriseFeatures}) {
    return {
      'sdkToken': sdkToken,
      'workflowRunId': workflowRunId,
      'iosAppearance': iosAppearance?.toJson(),
      'iosLocalizationFileName': iosLocalizationFileName,
      'enterpriseFeatures': enterpriseFeatures?.toJson()
    };
  }
}
