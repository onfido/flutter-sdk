import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onfido_sdk/onfido_sdk.dart';
import 'package:onfido_sdk/src/platform/onfido_method_channel.dart';

part 'mock/onfido_method_channel_test.mock.dart';

void main() {
  const MethodChannel channel = MethodChannel('onfido_sdk');
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  group('start', () {
    test('success', () async {
      int callCounter = 0;
      MethodCall? receivedCall;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
        callCounter++;
        receivedCall = call;
        return startMockResponse;
      });

      final instance = MethodChannelOnfido();
      final result = await instance.start(
          sdkToken: "sdkToken",
          iosLocalizationFileName: "file",
          iosAppearance: mockIosAppearance(),
          enterpriseFeatures: EnterpriseFeatures(
            cobrandingText: "text",
            disableMobileSDKAnalytics: false,
            hideOnfidoLogo: true,
          ),
          flowSteps: FlowSteps(
            welcome: false,
            proofOfAddress: true,
            documentCapture:
                DocumentCapture(countryCode: CountryCode.UGA, documentType: DocumentType.nationalIdentityCard),
            faceCapture: FaceCapture.video(),
          ),
          disableNFC: false,
          onfidoTheme: OnfidoTheme.LIGHT);

      expect(callCounter, 1);
      expect(receivedCall?.method, 'start');
      expect(receivedCall?.arguments, startMockRequestBody);
      expect(result.first.toString(), mockedResultObject.toString());
    });
  });

  group('startStudio', () {
    test('success', () async {
      int callCounter = 0;
      MethodCall? receivedCall;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
        callCounter++;
        receivedCall = call;
        return startMockResponse;
      });

      final instance = MethodChannelOnfido();
      await instance.startWorkflow(
          sdkToken: "sdkToken",
          workflowRunId: "workflowRunId",
          iosAppearance: mockIosAppearance(),
          iosLocalizationFileName: "iosFileName",
          onfidoTheme: null);

      expect(callCounter, 1);
      expect(receivedCall?.method, 'startStudio');
      expect(receivedCall?.arguments, startStudioMockRequestBody);
    });
  });
}

IOSAppearance mockIosAppearance() {
  return IOSAppearance(
      primaryColor: const Color(0x0012c4b4),
      secondaryTitleColor: const Color.fromARGB(10, 20, 30, 10),
      fontRegular: 'avenir',
      fontBold: 'avenir-heavy',
      backgroundColor: BackgroundColor(const Color.fromARGB(10, 20, 30, 10), const Color.fromARGB(30, 20, 10, 10)));
}
