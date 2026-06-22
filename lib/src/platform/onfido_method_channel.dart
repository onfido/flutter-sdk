import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:onfido_sdk/onfido_sdk.dart';
import 'package:onfido_sdk/src/serializer/biometric_token_result_serializer.dart';
import 'package:onfido_sdk/src/serializer/serializer.dart';

class MethodChannelOnfido extends OnfidoPlatform {
  static MethodChannel? _methodChannel;

  @visibleForTesting
  static MethodChannel get methodChannel {
    if (_methodChannel == null) {
      _methodChannel = const MethodChannel('onfido_sdk');
      _methodChannel!.setMethodCallHandler(platformCallHandler);
    }
    return _methodChannel!;
  }

  static OnfidoMediaCallback? _mediaCallback;
  static BiometricTokenCallback? _biometricTokenCallback;

  @override
  Future<List<OnfidoResult>> start(
      {required String sdkToken,
      required FlowSteps flowSteps,
      String? iosLocalizationFileName,
      String? locale,
      IOSAppearance? iosAppearance,
      OnfidoMediaCallback? mediaCallback,
      EnterpriseFeatures? enterpriseFeatures,
      NFCOptions? nfcOption,
      OnfidoTheme? onfidoTheme}) async {
    final arguments = StartOptionsSerializer.serialize(
        sdkToken: sdkToken,
        flowSteps: flowSteps,
        iosAppearance: iosAppearance,
        shouldUseMediaCallback: mediaCallback != null,
        iosLocalizationFileName: iosLocalizationFileName,
        locale: locale,
        enterpriseFeatures: enterpriseFeatures,
        nfcOption: nfcOption,
        onfidoTheme: onfidoTheme);

    _mediaCallback = mediaCallback;

    final result = await methodChannel.invokeMethod('start', arguments);
    return OnfidoResultSerializer.deserialize(result);
  }

  @override
  Future<void> startWorkflow(
      {required String sdkToken,
      required String workflowRunId,
      IOSAppearance? iosAppearance,
      OnfidoMediaCallback? mediaCallback,
      BiometricTokenCallback? biometricTokenCallback,
      String? iosLocalizationFileName,
      String? locale,
      EnterpriseFeatures? enterpriseFeatures,
      OnfidoTheme? onfidoTheme}) async {
    final arguments = StartStudioSerializer.serialize(
        sdkToken: sdkToken,
        workflowRunId: workflowRunId,
        iosAppearance: iosAppearance,
        shouldUseMediaCallback: mediaCallback != null,
        shouldUseBiometricTokenCallback: biometricTokenCallback != null,
        iosLocalizationFileName: iosLocalizationFileName,
        locale: locale,
        enterpriseFeatures: enterpriseFeatures,
        onfidoTheme: onfidoTheme);

    _mediaCallback = mediaCallback;
    _biometricTokenCallback = biometricTokenCallback;

    await methodChannel.invokeMethod('startStudio', arguments);
  }

  static Future<dynamic> platformCallHandler(MethodCall call) async {
    try {
      switch (call.method) {
        case 'onMediaCaptured':
          {
            if (kDebugMode) {
              print('onMediaCaptured call handler');
            }
            final OnfidoMediaResult result = OnfidoMediaResultSerializer.deserialize(call.arguments);
            _mediaCallback?.onMediaCaptured(result: result);
            break;
          }
        case 'onTokenGenerated':
          {
            final BiometricTokenGenerationResult args = BiometricTokenResultSerializer.deserialize(call.arguments);
            _biometricTokenCallback?.onTokenGenerated(args.customerUserHash, args.biometricToken);
            break;
          }
        case 'onTokenRequested':
          {
            final BiometricTokenRequestResult args = BiometricTokenResultSerializer.deserializeRequest(call.arguments);
            final Completer<String> completer = Completer<String>();
            _biometricTokenCallback?.onTokenRequested(args.customerUserHash, (String biometricToken) {
              completer.complete(biometricToken);
            });
            return completer.future;
          }
        default:
          if (kDebugMode) {
            print('Unknown method ${call.method} ');
          }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return Future.value();
  }
}
