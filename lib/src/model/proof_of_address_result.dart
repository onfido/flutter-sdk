class ProofOfAddressResult {
  String? id;
  String? type;
  String? issuingCountry;

  ProofOfAddressResult({this.id, this.type, this.issuingCountry});

  @override
  bool operator ==(Object other) {
    if (other is! ProofOfAddressResult) return false;
    if (other.id != id) return false;
    if (other.type != type) return false;
    if (other.issuingCountry != issuingCountry) return false;
    return true;
  }

  @override
  int get hashCode => id.hashCode + type.hashCode + issuingCountry.hashCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['issuingCountry'] = issuingCountry;
    return data;
  }
}
