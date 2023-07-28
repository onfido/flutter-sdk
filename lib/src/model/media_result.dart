import 'dart:typed_data';

enum OnfidoMediaResultType { documentResult, livenessResult, selfieResult }

class OnfidoDocumentMetadata {
  String side;
  String type;
  String? issuingCountry;

  OnfidoDocumentMetadata({required this.side, required this.type, this.issuingCountry});
}

class OnfidoMediaFile {
  Uint8List fileData; //ByteArray
  String fileType;
  String fileName;

  OnfidoMediaFile({required this.fileData, required this.fileType, required this.fileName});
}

class OnfidoMediaResult {
  const OnfidoMediaResult({
    this.resultType,
    this.fileData,
    this.documentMetadata,
  });

  final OnfidoMediaResultType? resultType;
  final OnfidoMediaFile? fileData;
  final OnfidoDocumentMetadata? documentMetadata;
}
