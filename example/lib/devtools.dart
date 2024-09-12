import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onfido_sdk/onfido_sdk.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

import 'model/media_callback.dart';

class Devtools extends StatefulWidget {
  const Devtools({super.key});

  @override
  State<Devtools> createState() => _DevtoolsState();
}

class _DevtoolsState extends State<Devtools> {
  late final WebViewController controller;

  startFromDevtoolsConfig(Map<String, dynamic> devtoolsConfig) {
    String token = devtoolsConfig['token'];
    OnfidoTheme theme = parseTheme(devtoolsConfig['theme']['name']);
    var parsedTestingConfig = parseTestingConfiguration(devtoolsConfig['testingConfiguration']);

    if (devtoolsConfig['workflowRunId'] != null) {
      String workflowRunId = devtoolsConfig['workflowRunId'];

      startStudio(Config(
        sdkToken: token,
        workflowRunId: workflowRunId,
        hideLogo: parsedTestingConfig['hideLogo'],
        logoCobrand: parsedTestingConfig['logoCobrand'],
        localisation: {
          'ios_strings_file_name': null,
        },
        disableNFC: parsedTestingConfig['disableNFC'],
        shouldUseMediaCallbacks: parsedTestingConfig['shouldUseMediaCallbacks'],
        disableMobileSdkAnalytics: parsedTestingConfig['disableMobileSdkAnalytics'],
        theme: theme,
      ));
    }

    if (devtoolsConfig['steps'] != null) {
      var parsedClassicConfig = parseClassicConfig(devtoolsConfig['steps']);

      startClassic(Config(sdkToken: token, theme: theme, flowSteps: parsedClassicConfig.flowSteps));
    }
  }

  startStudio(Config studioConfig) async {
    final Onfido onfido = Onfido(
        sdkToken: studioConfig.sdkToken!,
        iosLocalizationFileName: "onfido_ios_localisation",
        mediaCallback: studioConfig.shouldUseMediaCallbacks != false ? ExampleMediaCallback() : null,
        enterpriseFeatures: EnterpriseFeatures(
            hideOnfidoLogo: studioConfig.hideLogo, disableMobileSDKAnalytics: studioConfig.disableMobileSdkAnalytics),
        onfidoTheme: studioConfig.theme);

    await onfido.startWorkflow(studioConfig.workflowRunId!);
  }

  startClassic(Config classicConfig) async {
    final Onfido onfido = Onfido(
        sdkToken: classicConfig.sdkToken!,
        mediaCallback: classicConfig.shouldUseMediaCallbacks != null ? ExampleMediaCallback() : null,
        enterpriseFeatures: EnterpriseFeatures(
            hideOnfidoLogo: classicConfig.hideLogo, disableMobileSDKAnalytics: classicConfig.disableMobileSdkAnalytics),
        nfcOption: classicConfig.disableNFC ?? true ? NFCOptions.DISABLED : NFCOptions.REQUIRED,
        onfidoTheme: classicConfig.theme);

    await onfido.start(
      flowSteps: FlowSteps(
        proofOfAddress: classicConfig.flowSteps?.proofOfAddress ?? false,
        welcome: classicConfig.flowSteps?.welcome ?? false,
        documentCapture: classicConfig.flowSteps?.captureDocument,
        faceCapture: classicConfig.flowSteps?.captureFace,
      ),
    );
  }

  OnfidoTheme parseTheme(dynamic themeName) {
    if (themeName == null) {
      return OnfidoTheme.AUTOMATIC;
    }

    return themeName == 'dark' ? OnfidoTheme.DARK : OnfidoTheme.LIGHT;
  }

  Map<String, dynamic> parseTestingConfiguration(dynamic testingConfiguration) {
    if (testingConfiguration == null) {
      return {
        'disableNFC': false,
        'disableMobileSdkAnalytics': false,
        'shouldUseMediaCallbacks': false,
        'hideLogo': false,
        'logoCobrand': false,
      };
    }

    return {
      'disableNFC': testingConfiguration['DISABLE_NFC'] != null ? true : false,
      'disableMobileSdkAnalytics': testingConfiguration['DISABLE_MOBILE_SDK_ANALYTICS'] != null ? true : false,
      'shouldUseMediaCallbacks': testingConfiguration['ENABLE_MEDIA_CALLBACKS'] != null ? true : false,
      'hideLogo': testingConfiguration['ENABLE_HIDE_ONFIDO_LOGO'] != null ? true : false,
      'logoCobrand': testingConfiguration['ENABLE_LOGO_COBRAND'] != null ? true : false,
    };
  }

  Config parseClassicConfig(List<dynamic> steps) {
    bool welcome = false;
    dynamic captureFace;
    dynamic captureDocument;
    bool proofOfAddress = false;

    for (var step in steps) {
      String stepType = step is Map ? step['type'] : step;
      switch (stepType) {
        case 'welcome':
          welcome = true;
          break;
        case 'face':
          captureFace = parseFaceStep(step);
          break;
        case 'document':
          captureDocument = parseDocumentStep(step);
          break;
        case 'poa':
          proofOfAddress = true;
          break;
        default:
          break;
      }
    }

    return Config(
        flowSteps: Steps(
            welcome: welcome,
            proofOfAddress: proofOfAddress,
            captureDocument: captureDocument,
            captureFace: captureFace));
  }

  FaceCapture parseFaceStep(dynamic step) {
    FaceCapture faceCapture = FaceCapture.photo(withIntroScreen: true);

    if (step == 'face') {
      return faceCapture;
    }

    if (step['options'] != null) {
      if (step['options']['requestedVariant'] == 'motion') {
        var withAudio = step['options']['recordAudio'];

        return FaceCapture.motion(withAudio: withAudio);
      }

      if (step['options']['requestedVariant'] == 'video') {
        var withIntroVideo = step['options']['showIntro'];
        var withConfirmationVideoPreview = step['options']['showVideoConfirmation'];

        return FaceCapture.video(
            withIntroVideo: withIntroVideo, withConfirmationVideoPreview: withConfirmationVideoPreview);
      }
    }

    return faceCapture;
  }

  /// Generic documents are not officially supported, yet
  DocumentCapture parseDocumentStep(dynamic step) {
    DocumentCapture captureDocument = DocumentCapture();

    if (step == 'document') {
      return captureDocument;
    }

    if (step['options'] != null) {
      // One restricted document only, and by country
      if (step['options']['documentTypes'] != null) {
        Map<String, dynamic> documentType = step['options']['documentTypes'];

        String country = documentType['driving_licence']['country'];
        CountryCode countryCode = CountryCode.values.firstWhere((c) => c.toString() == 'CountryCode.$country');

        if (documentType.containsKey('driving_licence')) {
          captureDocument = DocumentCapture(documentType: DocumentType.drivingLicence, countryCode: countryCode);
        }

        if (documentType.containsKey('passport')) {
          captureDocument = DocumentCapture(
              documentType: DocumentType.passport, countryCode: documentType['passport']['country'] as CountryCode);
        }
      }
    }

    return captureDocument;
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterWebView',
        onMessageReceived: (message) {
          var devtoolsConfig = json.decode(message.message);
          startFromDevtoolsConfig(devtoolsConfig);
        },
      )
      ..loadRequest(
        Uri.parse('https://sdk.onfido.com/run?mode=webview'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        gestureRecognizers: {}..add(Factory(() => VerticalDragGestureRecognizer())),
        controller: controller,
      ),
    );
  }
}

class Config {
  final String? sdkToken;
  final String? workflowRunId;
  final bool? hideLogo;
  final bool? logoCobrand;
  final Map<String, dynamic>? localisation;
  final Steps? flowSteps;
  final bool? disableNFC;
  final bool? shouldUseMediaCallbacks;
  final bool? disableMobileSdkAnalytics;
  final OnfidoTheme? theme;

  Config({
    this.sdkToken,
    this.workflowRunId,
    this.hideLogo,
    this.logoCobrand,
    this.localisation,
    this.flowSteps,
    this.disableNFC,
    this.shouldUseMediaCallbacks,
    this.disableMobileSdkAnalytics,
    this.theme,
  });
}

class Steps {
  final bool welcome;
  final FaceCapture? captureFace;
  final DocumentCapture? captureDocument;
  final bool proofOfAddress;

  Steps({required this.welcome, this.captureFace, this.captureDocument, required this.proofOfAddress});
}
