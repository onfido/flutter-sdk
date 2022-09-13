import 'package:onfido_sdk/onfido_sdk.dart';

/// This is the main class for Onfido SDK
class Onfido {
  /// Initialize Onfido with the given arguments.
  /// - The [sdkToken] is the JWT sdk token obtained by making a call to the SDK token API.
  /// - The [iOSLocalizationFileName] is the file name for configuring the localisation for iOS only. See [Language Customisation](https://github.com/onfido/flutter-sdk/#language-customisation) for the details.
  /// - The [iOSAppearance] is the configuration for iOS appearance, for Android you can see [UI Customisation](https://github.com/onfido/flutter-sdk/#ui-customisation) for the details.
  /// - The [enterpriseFeatures] is a set of features for advanced customisation, get in touch to enable this for your account.
  Onfido(
      {required String sdkToken,
      String? iosLocalizationFileName,
      IOSAppearance? iosAppearance,
      EnterpriseFeatures? enterpriseFeatures})
      : _sdkToken = sdkToken,
        _iOSLocalizationFileName = iosLocalizationFileName,
        _enterpriseFeatures = enterpriseFeatures,
        _iosAppearance = iosAppearance;

  final String _sdkToken;
  final String? _iOSLocalizationFileName;
  final EnterpriseFeatures? _enterpriseFeatures;
  final IOSAppearance? _iosAppearance;

  /// Start Onfido SDK using [FlowSteps].
  /// - The [flowSteps] allows you to configure which screens are going to be displayed in the flow. For more information see the [Start the Flow](https://github.com/onfido/flutter-sdk/#start-the-flow) section.
  Future<List<OnfidoResult>> start({required FlowSteps flowSteps}) {
    return OnfidoPlatform.instance.start(
        sdkToken: _sdkToken,
        flowSteps: flowSteps,
        iosAppearance: _iosAppearance,
        iosLocalizationFileName: _iOSLocalizationFileName,
        enterpriseFeatures: _enterpriseFeatures);
  }

  /// Start Onfido SDK using [Workflow].
  Future<void> startWorkflow(String workflowRunId) {
    return OnfidoPlatform.instance.startWorkflow(
        sdkToken: _sdkToken,
        workflowRunId: workflowRunId,
        iosAppearance: _iosAppearance,
        iosLocalizationFileName: _iOSLocalizationFileName);
  }
}
