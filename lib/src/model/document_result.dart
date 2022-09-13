import 'document_side_result.dart';

class DocumentResult {
  DocumentSideResult? front;
  DocumentSideResult? back;
  String? typeSelected;
  String? countrySelected;

  DocumentResult({this.front, this.back, this.typeSelected, this.countrySelected});

  @override
  bool operator ==(Object other) {
    if (other is! DocumentResult) return false;
    if (other.front != front) return false;
    if (other.back != back) return false;
    if (other.typeSelected != typeSelected) return false;
    if (other.countrySelected != countrySelected) return false;
    return true;
  }

  @override
  int get hashCode => front.hashCode + back.hashCode + typeSelected.hashCode + countrySelected.hashCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (front != null) {
      data['front'] = front!.toJson();
    }
    if (back != null) {
      data['back'] = back!.toJson();
    }
    data['typeSelected'] = typeSelected;
    data['countrySelected'] = countrySelected;
    return data;
  }
}
