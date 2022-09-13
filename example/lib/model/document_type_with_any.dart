import 'package:onfido_sdk/onfido_sdk.dart';

enum DocumentTypes { any, passport, drivingLicence, nationalIdentityCard, residencePermit, visa, workPermit, generic }

extension DocumentTypeExtension on DocumentTypes {
  DocumentType? toOnfido() {
    switch (this) {
      case DocumentTypes.any:
        return null;
      case DocumentTypes.residencePermit:
        return DocumentType.residencePermit;
      case DocumentTypes.nationalIdentityCard:
        return DocumentType.nationalIdentityCard;
      case DocumentTypes.passport:
        return DocumentType.passport;
      case DocumentTypes.drivingLicence:
        return DocumentType.drivingLicence;
      case DocumentTypes.visa:
        return DocumentType.visa;
      case DocumentTypes.workPermit:
        return DocumentType.workPermit;
      case DocumentTypes.generic:
        return DocumentType.generic;
    }
  }
}
