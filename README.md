# Onfido
[![Version](https://img.shields.io/pub/v/onfido_sdk)](https://pub.dev/packages/onfido_sdk)
[![Build Status](https://app.bitrise.io/app/f903440a37a6c929/status.svg?token=arqCbpqUc8jvgj71_qQZoQ)](https://app.bitrise.io/app/f903440a37a6c929)

## Table of contents
  - [Overview](#overview)
  - [Getting started](#getting-started)
      - [Obtain an API token](#1-obtain-an-api-token)
          - [Regions](#1.1-regions)
      - [Create an applicant](#2-create-an-applicant)
      - [Configure the SDK with token](#3-configure-the-sdk-with-token)
      - [Add the SDK dependency](#4-add-the-sdk-dependency)
      - [Update your iOS Configuration files](#5-update-your-ios-configuration-files)
  - [Usage](#usage)
      - [Creating the SDK configuration](#1-creating-the-sdk-configuration)
      - [Start the flow](#2-start-the-flow)
      - [Handling responses](#3-handling-responses)
          - [Success handling](#success-handling)
          - [Error handling](#error-handling)
      - [Custom callbacks](#4-custom-callbacks)
          - [Media callbacks](#media-callbacks)
  - [Language Customisation](#language-customisation)
  - [UI Customisation](#ui-customisation)
  - [Going live](#going-live)
  - [More Information](#more-information)
      - [Sample App](#sample-app)
      - [Support](#support)
      - [How is the Onfido Flutter SDK licensed?](#how-is-the-onfido-flutter-sdk-licensed)
## Overview

The Onfido Flutter SDK provides a drop-in set of screens and tools for Flutter applications to capture identity documents and selfie photos, videos and motion captures for the purpose of identity verification.

It offers a number of benefits to help you create the best identity verification experience for your customers:

-   Carefully designed UI to guide your customers through the photo, video or motion capture process
-   Modular design to help you seamlessly integrate the photo, video or motion capture process into your application flow
-   Advanced image quality detection technology to ensure the quality of the captured images meets the requirement of the Onfido identity verification process, guaranteeing the best success rate
-   Direct image upload to the Onfido service, to simplify integration


> ℹ️ 
> 
> If you are integrating using Onfido Studio please see our [Studio integration guide](ONFIDO_STUDIO.md)

⚠️ Note: The SDK is only responsible for capturing and uploading  photos, videos and motion capture. You still need to access the [Onfido API](https://documentation.onfido.com/) to manage applicants and perform checks.

## Getting started

* Dart 2.12 or higher
* Flutter 1.20 or higher
* Supports iOS 11+
* Supports Android API level 21+
* Supports iPads and tablets

### 1. Obtain an API token

In order to start integrating, you'll need an [API token](https://documentation.onfido.com/#api-tokens).

You can use our [sandbox](https://documentation.onfido.com/#sandbox-testing) environment to test your integration. To use the sandbox, you'll need to generate a sandbox API token in your [Onfido Dashboard](https://onfido.com/dashboard/api/tokens).

⚠️ Note: You must never use API tokens in the frontend of your application or malicious users could discover them in your source code. You should only use them on your server.

#### 1.1 Regions

Onfido offers region-specific environments. Refer to the [Regions](https://documentation.onfido.com/#regions) section in our API documentation for token format and API base URL information.

### 2. Create an applicant

To create an applicant from your backend server, make a request to the ['create applicant' endpoint](https://documentation.onfido.com/#create-applicant), using a valid API token.

**Note**: Different report types have different minimum requirements for applicant data. For a Document or Facial Similarity report the minimum applicant details required are `first_name` and `last_name`.

```shell
$ curl https://api.onfido.com/v3/applicants \
    -H 'Authorization: Token token=<YOUR_API_TOKEN>' \
    -d 'first_name=John' \
    -d 'last_name=Smith'
```

The JSON response will return an `id` field containing a UUID that identifies the applicant. Once you pass the applicant ID to the SDK, documents, photos, videos and motion captures uploaded by that instance of the SDK will be associated with that applicant.

### 3. Configure the SDK with token

You'll need to generate and include an SDK token every time you initialize the SDK.

To generate an SDK token, make a request to the ['generate SDK token' endpoint](https://documentation.onfido.com/#generate-web-sdk-token).

```shell
$ curl https://api.onfido.com/v3/sdk_token \
  -H 'Authorization: Token token=<YOUR_API_TOKEN>' \
  -F 'applicant_id=<APPLICANT_ID>' \
  -F 'application_id=<YOUR_APPLICATION_BUNDLE_IDENTIFIER>'
```

| Parameter           |  Notes   |
| ------------ | --- |
| `applicant_id` | **required** <br /> Specifies the applicant for the SDK instance. |
| `application_id` | **required** <br /> The application ID (for iOS "application bundle ID") that was set up during development. For iOS, this is usually in the form `com.your-company.app-name`. Make sure to use a valid `application_id` or you'll receive a 401 error. |

⚠️ SDK tokens expire after 90 minutes.

### 4. Add the SDK dependency
```shell
flutter pub add onfido_sdk
```

### 5. Update your iOS Configuration files

Change `ios/Podfile` to use version 11:
```
platform :ios, '11.0'
```

The SDK uses the device camera. You're required to have the following keys in your application's `ios/Runner/Info.plist` file:
*  `NSCameraUsageDescription`
*  `NSMicrophoneUsageDescription`

```xml
<key>NSCameraUsageDescription</key>
<string>Required for document and facial capture</string>
<key>NSMicrophoneUsageDescription</key>
<string>Required for video capture</string>
```
**Note**: All keys will be required for app submission.

## Usage

### 1. Creating the SDK configuration
Once you have an added the SDK as a dependency, and you have a SDK token, you can configure the SDK:

```dart
final Onfido onfido = Onfido(
  sdkToken: apiToken,
  iosLocalizationFileName: "onfido_ios_localisation", //Optional
  onfidoTheme: OnfidoTheme.AUTOMATIC //Optional
);
```

#### 1.1 Parameter details

* **`sdkToken`**: Required.  This is the JWT sdk token obtained by making a call to the SDK token API.  See section [Configuring SDK with Tokens](#3-configure-the-sdk-with-token).
* **`iosLocalizationFileName`**: Optional. This is the file name for configuring the localisation for iOS only. See section [Language Customisation](#language-customisation) for the details.
* **`onfidoTheme`**: Optional. The theme in which Onfido SDK is displayed. By default, the user's active device theme will be
  automatically applied to the Onfido SDK. However, you can opt out from dynamic theme switching at run time
  and instead set a theme statically at the build time as shown below. In this case, the flow will always be in displayed
  in the selected theme regardless of the user's device theme.
    * Valid values in `OnfidoTheme`: `AUTOMATIC`, `LIGHT`, `DARK`.

### 2. Start the flow
```dart
startOnfido() async {
  try {
    final response = await onfido.start(
      flowSteps: FlowSteps(
        proofOfAddress: true,
        welcome: true,
        documentCapture: DocumentCapture(),
        faceCapture: FaceCapture.photo(
          withIntroScreen: _introScreen,
        ),
      ),
    );
    ... handle response
  } catch (error) {
    ... handle error
  }
}
```

#### 2.1 Parameter details

* **`flowSteps`**: Required. This object is used to toggle individual screens on and off and set configurations inside the screens. 
  * **`FlowSteps.welcome`**: Optional. This toggles the welcome screen on or off. If omitted, this screen does not appear in the flow.

  * **`FlowSteps.proofOfAddress`**: Optional. In the Proof of Address step, a user picks the issuing country and type of document that proves their address before capturing the document with their phone camera or uploading it.

  * **`FlowSteps.documentCapture`**: Optional. In the Document step, a user can pick the type of document to capture and its issuing country before capturing it with their phone camera. Document selection and country selection are both optional screens. These screens will only show to the end user if specific options are not configured to the SDK.
    * **`DocumentCapture.documentType`**: Required if countryCode is specified. Valid values in `document_type.dart`.
    * **`DocumentCapture.countryCode`**: Required if documentType is specified. Valid values in `country_code.dart`.
      
  * **`FlowSteps.faceCapture`**: Optional. In this step, a user can use the front camera to capture their face in the form of photo, video, or motion capture. You can create a `FaceCapture` object using the corresponding factory constructors: `FaceCapture.photo()`, `FaceCapture.video()`, or `FaceCapture.motion()`. Each capture method can have additional configurations. If any of these optional parameters are not provided, the default values will be used in each platform. Please refer to the respective platform documentation for details on the default behaviors of these parameters. 
      * `photo`:
          * `withIntroScreen` (Optional, bool): Whether to show an introduction screen before the photo capture.
      * `video`:
          * `withIntroVideo` (Optional, bool): Whether to show video guidance on the introduction screen before the video capture.
          * `withConfirmationVideoPreview` (Optional, bool) (Android only): Whether to show a preview of the captured video for user confirmation.
          * `withManualLivenessCapture` (Optional, bool) (iOS only): Whether to enable manual capture during the video recording.
      * `motion`:
          * `withAudio` (Optional, bool): Whether to capture audio during the motion sequence.
          * `withCaptureFallback` (Optional, FaceCapture): An alternative FaceCapture method (Photo or Video) to use as a fallback if the Motion variant is not supported on the user's device due to platform-specific factors:
              * Android: Device capabilities, Google Play Services availability, and the MLKit Face Detection module can affect support for the Motion variant.
              * iOS: Minimum device and OS requirements can limit support, such as Motion not being supported on devices older than iPhone 7, on iOS older than 12, or on iPads.


#### 2.1.1 Android Project Prerequisites

NFC dependencies are not included in the SDK to avoid increasing the SDK size when the NFC feature is disabled. To use the NFC feature, you need to include the following dependencies (with the specified versions) in your build script:

```
implementation "net.sf.scuba:scuba-sc-android:0.0.23"
implementation "org.jmrtd:jmrtd:0.7.34"
implementation "com.madgag.spongycastle:prov:1.58.0.0"
```

You also need to add the following Proguard rules to your `proguard-rules.pro` file:

```
-keep class org.jmrtd.** { *; }
-keep class net.sf.scuba.** {*;}
-keep class org.bouncycastle.** {*;}
-keep class org.spongycastle.** {*;}
-keep class org.ejbca.** {*;}

-dontwarn kotlin.time.jdk8.DurationConversionsJDK8Kt
-dontwarn org.ejbca.**
-dontwarn org.bouncycastle.**
-dontwarn org.spongycastle.**

-dontwarn module-info
-dontwarn org.jmrtd.**
-dontwarn net.sf.scuba.**
```

### 3. Handling responses

#### Success handling
When the user has reached the end of the flow, you will receive the response with `[OnfidoResult]` and you can now [create a check]() on your backend server.

`[OnfidoResult]` is a list with multiple results. The results are different objects, each with its own associated value (also known as payload). This object, `OnfidoResult`, can have the following values:

```dart
OnfidoResult(
  document: DocumentResult(
    front: DocumentSideResult(id: "id"),
    typeSelected: "passport",
    countrySelected: null,
  ),
  face: FaceResult(
    id: "id",
    variant: FaceCaptureType.video,
  ),
  proofOfAddress: ProofOfAddressResult(
    id: "id",
    type: "bank_building_society_statement",
    issuingCountry: "BRA",
  ),
);
```

#### Error handling
You will receive a `PlatformException` if something goes wrong and the SDK will reject the promise falling into the catch block. The failure can be triggered during the initialisation, user leaving the SDK flow without completing it and run time exceptions.

| Error Code | Notes |
| ----- | ------ |
| `exit` | When the user has left the SDK flow without completing. |
| `error` | When something happens in run time, e.g. camera permission denied by the user. |
| `configuration` | When something happens before initializing the SDK, may be caused by invalid configuration. |


### 4. Custom Callbacks

#### Media Callbacks (beta)

### Introduction
Onfido provides the possibility to integrate with our Smart Capture SDK, without the requirement of using this data only through the Onfido API. Media callbacks enable you to control the end user data collected by the SDK after the end user has submitted their captured media. As a result, you can leverage Onfido’s advanced on-device technology, including image quality validations, while still being able to handle end users’ data directly. This unlocks additional use cases, including compliance requirements and multi-vendor configurations, that require this additional flexibility.

**This feature must be enabled for your account.** Please contact your Onfido Solution Engineer or Customer Success Manager.

### Implementation
To use this feature, implement the `OnfidoMediaCallback` interface and provide the callback for `OnfidoMediaResult` for documents, live photos and live videos.

```dart
class MediaCallback implements OnfidoMediaCallback {
  @override
  Future<void> onMediaCaptured({required OnfidoMediaResult result}) async {
    // Your callback code here
  }
}
```

Then you should pass this class to Onfido SDK builder as a parameter:

```dart
MediaCallback callback = MediaCallback();

final Onfido onfido = Onfido(
    sdkToken: sdkToken,
    mediaCallback: callback,
    enterpriseFeatures: EnterpriseFeatures(
        hideOnfidoLogo: _hideOnfidoLogo,
    )
);    
```


## NFC Capture

Recent passports, national identity cards and residence permits contain a chip that can be accessed using Near Field Communication (NFC).

The Onfido SDKs provide a set of screens and functionalities to extract this information, verify its authenticity and provide the results as part of a Document report.

With version 4.0.0 of the Onfido Flutter SDK, NFC is enabled by default and offered to customer when both the document and the device support NFC.

For more information on how to configure NFC and the list of supported documents, please refer to the [NFC for Document Report](https://developers.onfido.com/guide/document-report-nfc) guide.


## Language Customisation

The SDK supports and maintains the following 44 languages:

- Arabic: ar
- Armenian: hy
- Bulgarian: bg
- Chinese (Simplified): zh_rCN (Android), zh-Hans (iOS)
- Chinese (Traditional): zh_rTW (Android), zh-Hant (iOS)
- Croatian: hr
- Czech: cs
- Danish: da🇰
- Dutch: nl🇱
- English (United Kingdom): en_rGB
- English (United States): en_rUS
- Estonian: et
- Finnish: fi
- French (Canadian): fr_rCA
- French: fr
- German: de
- Greek: el
- Hebrew: iw
- Hindi: hi
- Hungarian: hu
- Indonesian: in
- Italian: it
- Japanese: ja
- Korean: ko
- Latvian: lv
- Lithuanian: lt
- Malay: ms
- Norwegian bokmål: nb
- Norwegian nynorsk: nn
- Persian: fa
- Polish: pl
- Portuguese (Brazil): pt_rBR
- Portuguese: pt
- Romanian: ro
- Russian: ru
- Serbian: sr
- Slovak: sk
- Slovenian: sl
- Spanish (Latin America): es_rUS
- Spanish: es
- Swedish: sv
- Thai: th
- Turkish: tr
- Ukrainian: uk
- Vietnamese: vi

However, you can add your own translations.

### Android
By default, custom localisation is enabled on Android. There is no configuration needed on Flutter SDK to enable it.
You could also provide custom translation for a locale that we don’t currently support, by having an additional XML strings file inside your resources folder for the desired locale. See [Localisation section of Android SDK repo](https://github.com/onfido/onfido-android-sdk#4-localisation) for the details.

### iOS
You can also provide a custom translation for a locale that Onfido doesn't currently support.
There is a simple configuration needed on the Flutter SDK to enable custom localisation.

1. Add this statement to your configuration object.
```dart
final Onfido onfido = Onfido(
  ...
  iosLocalizationFileName: '<Your .strings file name in iOS app bundle>'
);
```
2. Navigate to the iOS folder ```cd ios```, and open your XCode workspace.
3. Follow the instructions for [iOS Localisation](https://medium.com/lean-localization/ios-localization-tutorial-938231f9f881) to add a new custom language or override existing translations.
4. You can find the keys that need to be translated in the [iOS SDK repo](https://github.com/onfido/onfido-ios-sdk/blob/master/localization/Localizable_EN.strings).


## UI Customisation
The SDK supports the customisation of colors and fonts used in the SDK flow.

### Android

Starting from Flutter version 4.1.0, dark mode and UI theme customsizations are supported. You can customize the colors across fonts, icons, buttons, etc. and other appearance attributes by overriding Onfido themes (OnfidoActivityTheme and OnfidoDarkTheme) in your themes.xml or styles.xml files. There is no additional configuration needed on the Flutter SDK to enable these Android customisations. 

Please see the [UI Customization section](https://github.com/onfido/onfido-android-sdk#ui-customization) of the Android SDK for full customisation options and implementation details. 

### iOS
You can use the `IOSAppearance` object to customise the iOS application.

For example: 
```dart
final Onfido onfido = Onfido(
  iosAppearance: IOSAppearance(
      fontBold: "<Font-Name>",
      fontRegular: "<Font-Name>",
      secondaryTitleColor: Colors.yourColor,
      primaryColor: Colors.yourColor,
      buttonCornerRadius: 10,
      primaryTitleColor: Colors.yourColor,
      bubbleErrorBackgroundColor: Colors.yourColor,
      primaryBackgroundPressedColor: Colors.yourColor,
      secondaryBackgroundPressedColor: Colors.yourColor,
      backgroundColor: BackgroundColor(Colors.yourLightColor, Colors.yourDarkColor)
  )
);
```

#### Dark Mode

The `onfidoTheme` parameter allows you to force light or dark mode via `DARK` and `LIGHT` respectively, or follow the system's interface style with `AUTOMATIC` (the default value).

Note: The usage of `supportDarkMode` in `IOSAppearance` is now deprecated. Please use `onfidoTheme` instead.

## Error handling

The `Error` object returned as part of `PlatformException` which translate the errors from native side to Dart. You can identify the type of the error from the error message

```dart
    // This happens if the user denies permission to the SDK during the flow
    PlatformException(error, The operation couldn’t be completed. (Onfido.OnfidoFlowError error 2.), cameraPermission, null)
    
    // This happens when the SDK tries to save capture to disk, maybe due to a lack of space
    PlatformException(error, The operation couldn’t be completed. (Onfido.OnfidoFlowError error 2.), failedToWriteToDisk, null)

    // This happens when the user denies permission for microphone usage by the app during the flow
    PlatformException(error, The operation couldn’t be completed. (Onfido.OnfidoFlowError error 2.), microphonePermission, null)

    // This happens when the SDK receives an error from an API call see [https://documentation.onfido.com/#errors](https://documentation.onfido.com/#errors) for more information
    PlatformException(error, The operation couldn’t be completed. (Onfido.OnfidoFlowError error 2.), upload, null)

    // This happens when an unexpected error occurs. Please contact [ios-sdk@onfido.com](mailto:ios-sdk@onfido.com?Subject=ISSUE%3A) when this happens
    PlatformException(error, The operation couldn’t be completed. (Onfido.OnfidoFlowError error 2.), exception, null)

    // This happens when you are using an older version of the iOS SDK and trying to access a new functionality from workflow. You can fix this by updating the SDK
    PlatformException(error, The operation couldn’t be completed. (Onfido.OnfidoFlowError error 2.), versionInsufficient, null)

    // The flow was exited prematurely by the user. The reason can be `.userExit` or `.consentDenied`
    PlatformException(exit, "User canceled the flow", null, null)
```


## Going live

Once you are happy with your integration and are ready to go live, please contact [client-support@onfido.com](mailto:client-support@onfido.com) to obtain live versions of the API token and the mobile SDK token. You will have to replace the sandbox tokens in your code with the live tokens.

A few things to check before you go live:

* Make sure you have entered correct billing details inside your [Onfido Dashboard](https://onfido.com/dashboard/)

## More Information

### Sample App

We have included sample app to show how to integrate with the Onfido Flutter SDK. See the `SampleApp` directory for more information.

### Support

Please open an issue through [GitHub](https://github.com/onfido/onfido-flutter-sdk/issues). Please be as detailed as you can. Remember **not** to submit your token in the issue. Also check the closed issues to check whether it has been previously raised and answered.

If you have any issues that contain sensitive information please send us an email with the `ISSUE:` at the start of the subject to [flutter-sdk@onfido.com](mailto:flutter-sdk@onfido.com?Subject=ISSUE%3A)

Previous version of the SDK will be supported for a month after a new major version release. Note that when the support period has expired for an SDK version, no bug fixes will be provided, but the SDK will keep functioning (until further notice).

Copyright 2022 Onfido, Ltd. All rights reserved.

### How is the Onfido Flutter SDK licensed?
The Onfido Flutter SDK is available under the MIT license.
