class DocumentSideResult {
  String? id;
  String? fileName;
  String? fileType;
  int? fileSize;

  DocumentSideResult({this.id, this.fileName, this.fileType, this.fileSize});

  @override
  bool operator ==(Object other) {
    if (other is! DocumentSideResult) return false;
    if (other.id != id) return false;
    if (other.fileName != fileName) return false;
    if (other.fileSize != fileSize) return false;
    if (other.fileType != fileType) return false;
    return true;
  }

  @override
  int get hashCode => id.hashCode + fileName.hashCode + fileType.hashCode + fileSize.hashCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fileName'] = fileName;
    data['fileSize'] = fileSize;
    data['fileType'] = fileType;
    return data;
  }
}
