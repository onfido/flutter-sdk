class DocumentSideResult {
  String? id;

  DocumentSideResult({this.id});

  @override
  bool operator ==(Object other) {
    if (other is! DocumentSideResult) return false;
    if (other.id != id) return false;
    return true;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
