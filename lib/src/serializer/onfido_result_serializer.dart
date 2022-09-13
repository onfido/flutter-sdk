import 'package:onfido_sdk/src/model/document_result.dart';
import 'package:onfido_sdk/src/model/document_side_result.dart';
import 'package:onfido_sdk/src/model/face_capture_type.dart';
import 'package:onfido_sdk/src/model/face_result.dart';
import 'package:onfido_sdk/src/model/onfido_result.dart';
import 'package:onfido_sdk/src/model/proof_of_address_result.dart';

class OnfidoResultSerializer {
  static List<OnfidoResult> deserialize(dynamic value) {
    final list = value as List<dynamic>;
    final map = list.map((e) => _deserializeResult(e)).toList();
    return map;
  }

  static OnfidoResult _deserializeResult(dynamic value) {
    return OnfidoResult(
        document: value['document'] != null ? _deserializeDocumentResult(value['document']) : null,
        face: value['face'] != null ? _deserializeFaceResult(value['face']) : null,
        proofOfAddress:
            value['proofOfAddress'] != null ? _deserializeProofOfAddressResult(value['proofOfAddress']) : null);
  }

  static DocumentResult _deserializeDocumentResult(dynamic value) {
    return DocumentResult(
        back: value["back"] != null ? _deserializeDocumentSideResult(value["back"]) : null,
        front: value["front"] != null ? _deserializeDocumentSideResult(value["front"]) : null,
        countrySelected: value["countrySelected"],
        typeSelected: value["typeSelected"]);
  }

  static DocumentSideResult _deserializeDocumentSideResult(dynamic value) {
    return DocumentSideResult(id: value["id"]);
  }

  static FaceResult _deserializeFaceResult(dynamic value) {
    return FaceResult(id: value["id"], variant: FaceCaptureType.values[value['variant']]);
  }

  static ProofOfAddressResult _deserializeProofOfAddressResult(dynamic value) {
    return ProofOfAddressResult(id: value["id"], issuingCountry: value["issuingCountry"], type: value["type"]);
  }
}
