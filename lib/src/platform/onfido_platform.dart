import 'package:onfido_sdk/onfido_sdk.dart';

import 'onfido_method_channel.dart';

abstract class OnfidoPlatform {
  static OnfidoPlatform instance = MethodChannelOnfido();

  Future<List<OnfidoResult>> start(
      {required String sdkToken,
      required FlowSteps flowSteps,
      String? iosLocalizationFileName,
      IOSAppearance? iosAppearance,
      EnterpriseFeatures? enterpriseFeatures});

  Future<void> startWorkflow(
      {required String sdkToken,
      required String workflowRunId,
      IOSAppearance? iosAppearance,
      String? iosLocalizationFileName,
      EnterpriseFeatures? enterpriseFeatures});
}
