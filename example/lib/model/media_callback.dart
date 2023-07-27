import 'package:fluttertoast/fluttertoast.dart';
import 'package:onfido_sdk/onfido_sdk.dart';

class ExampleMediaCallback implements OnfidoMediaCallback {
  @override
  Future<void> onMediaCaptured({required OnfidoMediaResult result}) async {
    // ignore: avoid_print
    print('Media callback result: ${[
      result.resultType,
      result.fileData?.fileName,
      result.documentMetadata?.type,
      result.documentMetadata?.side
    ]}');

    Fluttertoast.showToast(
        msg:
            "Received callback result: ${result.resultType} ${result.fileData?.fileName} ${result.documentMetadata?.type} ${result.documentMetadata?.side}. Has data? -> ${result.fileData?.fileData != null}",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 3);
  }
}
