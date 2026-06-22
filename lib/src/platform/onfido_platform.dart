import 'package:onfido_sdk/onfido_sdk.dart';

import 'onfido_method_channel.dart';

abstract class OnfidoPlatform {
  static OnfidoPlatform instance = MethodChannelOnfido();

  Future<List<OnfidoResult>> start(
      {required String sdkToken,
      required FlowSteps flowSteps,
      String? iosLocalizationFileName,
      String? locale,
      IOSAppearance? iosAppearance,
      EnterpriseFeatures? enterpriseFeatures,
      NFCOptions? nfcOption,
      OnfidoMediaCallback? mediaCallback,
      OnfidoTheme? onfidoTheme});

  Future<void> startWorkflow(
      {required String sdkToken,
      required String workflowRunId,
      IOSAppearance? iosAppearance,
      OnfidoMediaCallback? mediaCallback,
      BiometricTokenCallback? biometricTokenCallback,
      String? iosLocalizationFileName,
      String? locale,
      EnterpriseFeatures? enterpriseFeatures,
      OnfidoTheme? onfidoTheme});
}
