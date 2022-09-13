import 'document_result.dart';
import 'face_result.dart';
import 'proof_of_address_result.dart';

class OnfidoResult {
  const OnfidoResult({
    this.document,
    this.face,
    this.proofOfAddress,
  });

  final DocumentResult? document;
  final FaceResult? face;
  final ProofOfAddressResult? proofOfAddress;

  @override
  String toString() => "$OnfidoResult(document: ${document?.toJson().toString()}, "
      "face: ${face?.toJson().toString()}, "
      "proofOfAddress: ${proofOfAddress?.toJson().toString()})";
}
