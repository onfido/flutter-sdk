import 'face_capture_type.dart';

abstract class FaceCapture {
  final FaceCaptureType _type;

  const FaceCapture._(this._type);

  factory FaceCapture.photo({
    bool? withIntroScreen,
  }) = _Photo;

  factory FaceCapture.video({
    bool? withIntroVideo,
    bool? withConfirmationVideoPreview,
    bool? withManualLivenessCapture,
  }) = _Video;

  factory FaceCapture.motion({
    bool? withAudio,
  }) = _Motion;

  FaceCaptureType get type => _type;

  Map<String, dynamic> toJson();
}

class _Photo extends FaceCapture {
  final bool? withIntroScreen;

  _Photo({
    this.withIntroScreen,
  }) : super._(FaceCaptureType.photo);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': _type.name,
      'withIntroScreen': withIntroScreen,
    };
  }
}

class _Video extends FaceCapture {
  final bool? withIntroVideo;
  final bool? withConfirmationVideoPreview;
  final bool? withManualLivenessCapture;

  _Video({
    this.withIntroVideo,
    this.withConfirmationVideoPreview,
    this.withManualLivenessCapture,
  }) : super._(FaceCaptureType.video);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': _type.name,
      'withIntroVideo': withIntroVideo,
      'withConfirmationVideoPreview': withConfirmationVideoPreview,
      'withManualLivenessCapture': withManualLivenessCapture
    };
  }
}

class _Motion extends FaceCapture {
  final bool? withAudio;

  _Motion({
    this.withAudio,
  }) : super._(FaceCaptureType.motion);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': _type.name,
      'withAudio': withAudio,
    };
  }
}
