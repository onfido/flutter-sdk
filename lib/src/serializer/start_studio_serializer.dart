import 'package:onfido_sdk/onfido_sdk.dart';

class StartStudioSerializer {
  static serialize(
      {required String sdkToken,
      required String workflowRunId,
      IOSAppearance? iosAppearance,
      String? iosLocalizationFileName}) {
    return {
      'sdkToken': sdkToken,
      'workflowRunId': workflowRunId,
      'iosAppearance': iosAppearance?.toJson(),
      'iosLocalizationFileName': iosLocalizationFileName
    };
  }
}
