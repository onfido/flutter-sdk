import 'package:flutter/foundation.dart';

import 'document_capture.dart';
import 'face_capture_type.dart';

class FlowSteps {
  final bool? welcome;
  final bool? proofOfAddress;
  final DocumentCapture? documentCapture;
  final FaceCaptureType? faceCapture;
  final bool? enableNFC;

  FlowSteps({this.welcome, this.proofOfAddress, this.documentCapture, this.faceCapture, this.enableNFC});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['welcome'] = welcome;
    data['proofOfAddress'] = proofOfAddress;
    data['documentCapture'] = documentCapture?.toJson();
    data['faceCapture'] = faceCapture == null ? null : describeEnum(faceCapture!);
    data['enableNFC'] = enableNFC;

    return data;
  }
}
