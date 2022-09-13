import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:onfido_sdk/onfido_sdk.dart';
import 'package:onfido_sdk/src/serializer/serializer.dart';

class MethodChannelOnfido extends OnfidoPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('onfido_sdk');

  @override
  Future<List<OnfidoResult>> start(
      {required String sdkToken,
      required FlowSteps flowSteps,
      String? iosLocalizationFileName,
      IOSAppearance? iosAppearance,
      EnterpriseFeatures? enterpriseFeatures}) async {
    final arguments = StartOptionsSerializer.serialize(
        sdkToken: sdkToken,
        flowSteps: flowSteps,
        iosAppearance: iosAppearance,
        iosLocalizationFileName: iosLocalizationFileName,
        enterpriseFeatures: enterpriseFeatures);

    final result = await methodChannel.invokeMethod('start', arguments);
    return OnfidoResultSerializer.deserialize(result);
  }

  @override
  Future<void> startWorkflow(
      {required String sdkToken,
      required String workflowRunId,
      IOSAppearance? iosAppearance,
      String? iosLocalizationFileName}) async {
    final arguments = StartStudioSerializer.serialize(
        sdkToken: sdkToken,
        workflowRunId: workflowRunId,
        iosAppearance: iosAppearance,
        iosLocalizationFileName: iosLocalizationFileName);

    await methodChannel.invokeMethod('startStudio', arguments);
  }
}
