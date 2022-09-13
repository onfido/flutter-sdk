class CobrandingLogo {
  String lightLogo;
  String darkLogo;

  CobrandingLogo({required this.lightLogo, required this.darkLogo});

  @override
  bool operator ==(Object other) {
    if (other is! CobrandingLogo) return false;
    if (other.lightLogo != lightLogo) return false;
    if (other.darkLogo != darkLogo) return false;
    return true;
  }

  @override
  int get hashCode => lightLogo.hashCode + darkLogo.hashCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['darkLogo'] = darkLogo;
    data['lightLogo'] = lightLogo;
    return data;
  }
}
