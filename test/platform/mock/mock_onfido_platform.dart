import 'package:onfido_sdk/onfido_sdk.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOnfidoPlatform with MockPlatformInterfaceMixin implements OnfidoPlatform {
  MockOnfidoPlatform({this.startResult});

  final List<OnfidoResult>? startResult;
  var startCount = 0;
  late String startSdkToken;
  late FlowSteps startFlowSteps;
  late String? startIosLocalizationFileName;
  late EnterpriseFeatures? startEnterpriseFeatures;

  @override
  Future<List<OnfidoResult>> start(
      {required String sdkToken,
      required FlowSteps flowSteps,
      IOSAppearance? iosAppearance,
      String? iosLocalizationFileName,
      EnterpriseFeatures? enterpriseFeatures}) {
    startCount++;
    startSdkToken = sdkToken;
    startFlowSteps = flowSteps;
    startIosLocalizationFileName = iosLocalizationFileName;
    startEnterpriseFeatures = enterpriseFeatures;
    return Future.value(startResult!);
  }

  var startStudioCount = 0;
  late String startStudioSdkToken;
  late String startStudioWorkflowRunId;
  late EnterpriseFeatures? startStudioEnterpriseFeatures;

  @override
  Future<void> startWorkflow(
      {required String sdkToken,
      required String workflowRunId,
      String? iosLocalizationFileName,
      IOSAppearance? iosAppearance,
      EnterpriseFeatures? enterpriseFeatures}) {
    startStudioCount++;
    startStudioSdkToken = sdkToken;
    startStudioWorkflowRunId = workflowRunId;
    startStudioEnterpriseFeatures = enterpriseFeatures;
    return Future.value();
  }
}
