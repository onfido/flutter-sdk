import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';

import 'package:onfido_sdk/onfido_sdk.dart';

import 'components/alert_dialog.dart';

void main() => runApp(const QRCodeScanner());

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            String res = utf8.decode(base64.decode(barcode.rawValue!));
            Map<String, dynamic> jsonMap = json.decode(res);

            final clientId = jsonMap['clientId'];
            final sdkToken = jsonMap['token'];
            final applicantId = jsonMap['applicantId'];
            final workflowRunId = jsonMap['workflowRunId'];
            final configuration = jsonMap['configuration'];

            // TODO: Map config to object
            // TODO: Is it Classic or Studio config? — aka contains workflowRunId?
            // TODO: Launch Studio flow
            // TODO: Launch Classic flow
            // TODO: Better logging (within the config object)
            // FIXME: Support to token expired
            // FIXME: Support iOS camera permissions on real device
            debugPrint('token: $sdkToken');
            debugPrint('applicantId: $applicantId');
            debugPrint('workflowRunId: $workflowRunId');
            debugPrint('clientId: $clientId');
            debugPrint('configuration: $configuration');

            final Onfido onfido = Onfido(sdkToken: sdkToken);

            try {
              onfido.startWorkflow(workflowRunId);
              showAlertDialog(context, "Success", "Flow ended successfully");
            } catch (error) {
              showAlertDialog(context, "Error", "Error ${error.toString()}");
            }
          }
        },
      ),
    );
  }
}
