import 'dart:io' show Platform;

import 'package:onfido_sdk/src/model/media_result.dart';
import 'dart:typed_data';

class OnfidoMediaResultSerializer {
  static OnfidoMediaResult deserialize(dynamic value) {
    return OnfidoMediaResult(
        resultType: value['resultType'] != null ? _deserializeResultType(value['resultType']) : null,
        fileData: value["data"] != null ? _deserializeMediaFile(value["data"]) : null,
        documentMetadata: value["fileMetadata"] != null ? _deserializeMetadata(value["fileMetadata"]) : null);
  }

  static OnfidoMediaResultType _deserializeResultType(dynamic value) {
    return OnfidoMediaResultType.values.firstWhere((e) => e.name == value);
  }

  static OnfidoMediaFile _deserializeMediaFile(dynamic value) {
    Uint8List bytes;
    if (Platform.isIOS) {
      List<int> dataList = value["fileData"].codeUnits;
      bytes = Uint8List.fromList(dataList);
    } else {
      bytes = value["fileData"];
    }
    return OnfidoMediaFile(fileData: bytes, fileType: value["fileType"], fileName: value["fileName"]);
  }

  static OnfidoDocumentMetadata _deserializeMetadata(dynamic value) {
    return OnfidoDocumentMetadata(side: value["side"], type: value["type"], issuingCountry: value["issuingCountry"]);
  }
}
