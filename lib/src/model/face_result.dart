import 'package:onfido_sdk/src/model/face_capture_type.dart';

class FaceResult {
  String? id;
  FaceCaptureType? variant;

  FaceResult({this.id, this.variant});

  @override
  bool operator ==(Object other) {
    if (other is! FaceResult) return false;
    if (other.id != id) return false;
    if (other.variant != variant) return false;
    return true;
  }

  @override
  int get hashCode => id.hashCode + variant.hashCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['variant'] = variant;
    return data;
  }
}
