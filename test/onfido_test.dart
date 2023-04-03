import 'package:flutter_test/flutter_test.dart';
import 'package:onfido_sdk/onfido_sdk.dart';

import 'platform/mock/mock_onfido_platform.dart';

void main() {
  test('start', () async {
    final platform = MockOnfidoPlatform(startResult: []);
    const token = "abc";

    final flowSteps = FlowSteps();
    Onfido onfido = Onfido(sdkToken: token);
    OnfidoPlatform.instance = platform;

    final response = await onfido.start(flowSteps: flowSteps);

    expect(platform.startCount, 1);
    expect(platform.startSdkToken, token);
    expect(platform.startFlowSteps, flowSteps);
    expect([], response);
  });

  test('startStudio', () async {
    final platform = MockOnfidoPlatform();
    const token = "abc";
    const workflowRunId = "runId";

    Onfido onfido = Onfido(sdkToken: token);
    OnfidoPlatform.instance = platform;

    await onfido.startWorkflow(workflowRunId);

    expect(platform.startStudioCount, 1);
    expect(platform.startStudioSdkToken, token);
    expect(platform.startStudioWorkflowRunId, workflowRunId);
  });
}
