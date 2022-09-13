class EnterpriseFeatures {
  bool? hideOnfidoLogo;
  String? cobrandingText;
  bool? disableMobileSDKAnalytics;

  EnterpriseFeatures({this.hideOnfidoLogo, this.cobrandingText, this.disableMobileSDKAnalytics});

  @override
  bool operator ==(Object other) {
    if (other is! EnterpriseFeatures) return false;
    if (other.hideOnfidoLogo != hideOnfidoLogo) return false;
    if (other.cobrandingText != cobrandingText) return false;
    if (other.disableMobileSDKAnalytics != disableMobileSDKAnalytics) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode => hideOnfidoLogo.hashCode + cobrandingText.hashCode + disableMobileSDKAnalytics.hashCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hideOnfidoLogo'] = hideOnfidoLogo;
    data['cobrandingText'] = cobrandingText;
    data['disableMobileSDKAnalytics'] = disableMobileSDKAnalytics;
    return data;
  }
}
