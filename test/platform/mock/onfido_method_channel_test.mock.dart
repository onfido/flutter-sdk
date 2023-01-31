part of '../onfido_method_channel_test.dart';

const startMockRequestBody = {
  'sdkToken': 'sdkToken',
  'flowSteps': {
    'welcome': false,
    'proofOfAddress': true,
    'documentCapture': {'documentType': 'nationalIdentityCard', 'countryCode': 'UGA'},
    'faceCapture': 'video',
    'enableNFC': true
  },
  'iosLocalizationFileName': 'file',
  'iosAppearance': {
    'primaryColor': '#0012c4b4',
    'primaryTitleColor': null,
    'secondaryTitleColor': '#0a141e0a',
    'primaryBackgroundPressedColor': null,
    'secondaryBackgroundPressedColor': null,
    'bubbleErrorBackgroundColor': null,
    'buttonCornerRadius': null,
    'fontRegular': 'avenir',
    'fontBold': 'avenir-heavy',
    'supportDarkMode': false
  },
  'enterpriseFeatures': {'hideOnfidoLogo': true, 'cobrandingText': 'text', 'disableMobileSDKAnalytics': false}
};

const startStudioMockRequestBody = {
  'sdkToken': 'sdkToken',
  'workflowRunId': 'workflowRunId',
  'iosLocalizationFileName': 'iosFileName',
  'iosAppearance': {
    'primaryColor': '#0012c4b4',
    'primaryTitleColor': null,
    'secondaryTitleColor': '#0a141e0a',
    'primaryBackgroundPressedColor': null,
    'secondaryBackgroundPressedColor': null,
    'bubbleErrorBackgroundColor': null,
    'buttonCornerRadius': null,
    'fontRegular': 'avenir',
    'fontBold': 'avenir-heavy',
    'supportDarkMode': false
  }
};

const startMockResponse = [
  {
    'document': {
      'front': {'id': '123'},
      'typeSelected': 'typeSelected',
      'countrySelected': 'countrySelected',
    },
    'face': {'id': '123', 'variant': 1},
    'proofOfAddress': {'id': '123', 'type': 'type', 'issuingCountry': 'country'}
  }
];

final mockedResultObject = OnfidoResult(
  document: DocumentResult(
    front: DocumentSideResult(id: "123"),
    typeSelected: "typeSelected",
    countrySelected: "countrySelected",
  ),
  face: FaceResult(
    id: "123",
    variant: FaceCaptureType.video,
  ),
  proofOfAddress: ProofOfAddressResult(
    id: "123",
    type: "type",
    issuingCountry: "country",
  ),
);
