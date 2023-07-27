import 'package:onfido_sdk/src/model/media_result.dart';

abstract class OnfidoMediaCallback {
  void onMediaCaptured({required OnfidoMediaResult result});
}
