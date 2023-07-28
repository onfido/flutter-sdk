import 'document_capture.dart';
import 'face_capture.dart';

class FlowSteps {
  final bool? welcome;
  final bool? proofOfAddress;
  final DocumentCapture? documentCapture;
  final FaceCapture? faceCapture;

  FlowSteps({this.welcome, this.proofOfAddress, this.documentCapture, this.faceCapture});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['welcome'] = welcome;
    data['proofOfAddress'] = proofOfAddress;
    data['documentCapture'] = documentCapture?.toJson();
    data['faceCapture'] = faceCapture?.toJson();
    return data;
  }
}
