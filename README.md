# Onfido
[![Version](https://img.shields.io/pub/v/onfido_sdk)](https://pub.dev/packages/onfido_sdk)
[![Build Status](https://app.bitrise.io/app/f903440a37a6c929/status.svg?token=arqCbpqUc8jvgj71_qQZoQ)](https://app.bitrise.io/app/f903440a37a6c929)

## Table of contents

- [1. Overview](#overview)
- [2. Adding the SDK dependency](#adding-the-sdk-dependency)
- [3. Initializing the SDK](#initializing-the-sdk)
- [4. Completing a session](#completing-a-session)
- [Advanced flow customization](#advanced-flow-customization)
- [Advanced callbacks](#advanced-callbacks)
- [More information](#more-information)
- [Raising support issues](#support)

## Overview

The Onfido Smart Capture SDKs provide a set of screens and functionalities that enable applications to implement user identity verification flows. Each SDK contains:

- Carefully designed UX to guide your customers through the different photo or video capture processes
- Modular design to help you seamlessly integrate the different photo or video capture processes into your application's flow
- Advanced image quality detection technology to ensure the quality of the captured images meets the requirement of the
  Onfido identity verification process, guaranteeing the best success rate
- Direct image upload to the Onfido service, to simplify integration
- A suite of advanced fraud detection signals to protect against malicious users

All Onfido Smart Capture SDKs are orchestrated using [Onfido Studio](https://documentation.onfido.com/getting-started/onfido-studio-product) workflows, with only minor customization differences between the available platforms.

### Environments and testing with the SDK

Two environments exist to support the Onfido SDK integrations:

- 'sandbox' - to be used for testing with sample documents
- 'live' - to be used only with real documents and in production apps

The environment being used is determined by the API token that is used to generate the necessary [SDK token](#sdk-authentication).

### Going Live

Once you are satisfied with your integration and are ready to go live, please contact [client-support@onfido.com](mailto:client-support@onfido.com) to obtain a live API token. You will have to replace the sandbox token in your code with the live token.

Check that you have entered correct billing details inside your [Onfido Dashboard](https://onfido.com/dashboard/), before going live.

## Adding the SDK dependency

The Flutter SDK supports:

- Dart 3.1.0 or higher
- Flutter 1.20 or higher
- iOS 13+
- Supports Android API level 21+
- Supports iPads and tablets

### Using pub.dev

The Flutter SDK is available on [pub.dev](https://pub.dev/packages/onfido_sdk/install) and you can include it in your project by running the following script from your project folder:

```shell
flutter pub add onfido_sdk
```

### Update your iOS Configuration files

Change `ios/Podfile` to use version 13:
```
platform :ios, '13.0'
```

The Flutter SDK uses the device camera. You're required to have the following keys in your application's `ios/Runner/Info.plist` file:

*  `NSCameraUsageDescription`
*  `NSMicrophoneUsageDescription`

```xml
<key>NSCameraUsageDescription</key>
<string>Required for document and facial capture</string>
<key>NSMicrophoneUsageDescription</key>
<string>Required for video capture</string>
```
**Note**: All keys will be required for app submission.

### NFC capture using Onfido Studio

Recent passports, national identity cards and residence permits contain a chip that can be accessed using Near Field Communication (NFC). The Onfido SDKs provide a set of screens and functionalities to extract this information, verify its authenticity and provide the resulting verification as part of a Document report.

From version 4.0.0 onwards, NFC is enabled by default for the Flutter SDK and offered to customers when both the document and the device support NFC.

For more information on how to configure NFC and the list of supported documents, please refer to the [NFC for Document Report](https://documentation.onfido.com/guide/document-report-nfc) guide.

#### Disabling NFC

NFC is enabled by default. To disable NFC, include the `disableNFC` parameter while configuring the `onfido` [initialization object](#build-a-configuration-object).

For Android, a range of NFC library dependencies are included in the build automatically. In addition to configuring the `disableNFC` parameter, you must remove any libraries from the build process.

Exclude dependencies required for NFC from your build:

```gradle
dependencies {
  implementation 'com.onfido.sdk.capture:onfido-capture-sdk:x.y.z' {
    exclude group: 'net.sf.scuba', module: 'scuba-sc-android'
    exclude group: 'org.jmrtd', module: 'jmrtd'
    exclude group: 'com.madgag.spongycastle', module: 'prov'
  }
}
```

If your application already uses the same libraries that the Onfido SDK needs for the NFC feature, you may encounter some dependency conflicts that will impact and could interfere with the NFC capture in our SDK. In such cases, we propose using the dependency resolution strategy below, by adding the following lines to your `build.gradle` file:

```gradle
implementation ("com.onfido.sdk:onfido-<variant>:19.1.0"){
     exclude group: "org.bouncycastle"
 }
 implementation ("the other library that conflicts with Onfido on BouncyCastle") {
     exclude group: "org.bouncycastle"
 }
 
 implementation "org.bouncycastle:bcprov-jdk15to18:1.69"
 implementation "org.bouncycastle:bcutil-jdk15to18:1.69"
```

## Initializing the SDK

The Flutter SDK has multiple initialization and customization options that provide flexibility to your integration, while remaining easy to integrate.

### Defining a workflow

Onfido Studio is the platform used to create highly reusable identity verification workflows for use with the Onfido SDKs. For an introduction to working with workflows, please refer to our [Getting Started guide](https://documentation.onfido.com/getting-started/general-introduction), or the Onfido Studio [product guide](https://documentation.onfido.com/getting-started/onfido-studio-product).

SDK sessions are orchestrated by a session-specific `workflow_run_id`, itself derived from a `workflow_id`, the unique identifier of a given workflow.

For details on how to generate a `workflow_run_id`, please refer to the `POST /workflow_runs/` endpoint definition in the Onfido [API reference](https://documentation.onfido.com/api/latest#workflow-runs).

<Callout type="warning">

> **Note** that in the context of the SDK, the `workflow_run_id` property is referred to as `workflowRunId`.

</Callout>

#### Applicant ID reuse

When defining workflows and creating identity verifications, we highly recommend saving the `applicant_id` against a specific user for potential reuse. This helps to keep track of users should you wish to run multiple identity verifications on the same individual, or in scenarios where a user returns to and resumes a verification flow.

### SDK authentication

The SDK is authenticated using SDK tokens. As each SDK token must be specific to a given applicant and session, a new token must be generated each time you initialize the Flutter SDK.

| Parameter | Notes |
|------|------|
| `applicant_id` | **required** <br /> Specifies the applicant for the SDK instance. |
| `application_id` | **required** <br /> The application ID (for iOS "application bundle ID") that was set up during development. For iOS, this is usually in the form `com.your-company.app-name`. Make sure to use a valid `application_id` or you'll receive a 401 error. |

It's important to note that SDK tokens expire after **90 minutes**.

For details on how to generate SDK tokens, please refer to the `POST /sdk_token/` endpoint definition in the Onfido [API reference](https://documentation.onfido.com/api/latest#generate-sdk-token).

**Note**: You must never use API tokens in the frontend of your application as malicious users could discover them in your source code. You should only use them on your server.

### Build a configuration object

To use the SDK, you need to obtain an instance of the client object, using your generated SDK token. You can also pass in a range of optional configuration parameters to customize the SDK flow.

```dart
final Onfido onfido = Onfido(
  sdkToken: "<YOUR_SDK_TOKEN>",
  iosLocalizationFileName: "onfido_ios_localisation", // Optional
  onfidoTheme: OnfidoTheme.AUTOMATIC, // Optional
  disableNFC: "true" // Optional
);
```

#### Parameter details

* **`sdkToken`**: **Required**.  This is the SDK token obtained by making a call to the SDK token API, as [documented above](#sdk-authentication).

* **`iosLocalizationFileName`**: **Optional**. This is the file name for configuring custom language localization for iOS only. See the section on [language localization](#language-localization) for more details.

* **`onfidoTheme`**: **Optional**. The theme in which the Onfido SDK is displayed. By default, the user's active device theme will be
  automatically applied to the Onfido SDK. However, you can opt out from dynamic theme switching at run time
  and instead set a theme statically at the build time. In this case, the flow will always be in displayed
  in the selected theme regardless of the user's device theme.
    * Valid values in `OnfidoTheme`: `AUTOMATIC`, `LIGHT`, `DARK`.

* **`disableNFC`**: **Optional**. Set this parameter to `true` to disable NFC. 

### Start the flow

You can then start the flow by calling `startWorkflow`, passing in a `workflowRunId`.

```dart
await onfido.startWorkflow('workflowRunId');
// listen for the response
```

### Styling customization

For both iOS and Android, the Flutter SDK supports the customization of colors, fonts and strings used in the SDK flow.

### Appearance and Colors

#### Android

The customization of UI attributes for Android in the Flutter SDK is implemented in the same way as our native Android SDK.

Starting from version 4.1.0, the Flutter SDK also supports [dark mode](https://documentation.onfido.com/sdk/android/#dark-theme) for Android.

Please refer to the [Android SDK reference](https://documentation.onfido.com/sdk/android/#ui-customization) documentation for implementation details, as well as the [SDK customization guide](https://documentation.onfido.com/sdk/sdk-customization#flutter) for a complete list and visualizations of available attributes.

#### iOS

For iOS, you can use the `IOSAppearance` object to customize your application.

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
      primaryBackgroundPressedColor: Colors.yourColor,
      secondaryBackgroundPressedColor: Colors.yourColor,
      backgroundColor: BackgroundColor(Colors.yourLightColor, Colors.yourDarkColor),
      onfidoTheme: "DARK"
  )
);
```

##### Dark Mode

Starting from version 4.1.0, the Flutter SDK supports dark mode customization for iOS.

The `onfidoTheme` property in the `IOSAppearance` object allows you to force light or dark mode via `DARK` and `LIGHT` respectively, or follow the system's interface style with `AUTOMATIC` (the default value).

### Language localization

The Flutter SDK supports and maintains translations for over 40 languages, available for use with both Android and iOS.

The SDK will detect and use the end user's device language setting. If the device's language is not supported by Onfido, the SDK will default to English (`en_US`).

For a complete list of the languages Onfido supports, refer to our [SDK customization guide](https://documentation.onfido.com/sdk/sdk-customization#language-localization).

#### Custom languages for Android

You can also provide a custom translation for a specific language or locale that Onfido does not currently support, by having an additional XML strings file inside your resources folder for the desired locale. See our [Android localization documentation](https://documentation.onfido.com/sdk/android/#language-localization) for more details.

#### Custom languages for iOS

For iOS, you can also provide a custom translation for a specific language or locale that Onfido does not currently support. To configure this on the Flutter SDK:

1. Add this statement to your [configuration object](#build-a-configuration-object).

```dart
final Onfido onfido = Onfido(
  ...
  iosLocalizationFileName: '<Your .strings file name in iOS app bundle>'
);
```

2. Navigate to the iOS folder ```cd ios```, and open your XCode workspace.
3. Follow the instructions for [iOS Localisation](https://medium.com/lean-localization/ios-localization-tutorial-938231f9f881) to add a new custom language or override existing translations.
4. You can find the keys that need to be translated in the [iOS SDK repo](https://github.com/onfido/onfido-ios-sdk/blob/master/localization/Localizable_EN.strings).

## Completing a session

### Media Callbacks

#### Introduction

Onfido provides the possibility to integrate with our Smart Capture SDK, without the requirement of using this data only through the Onfido API. Media callbacks enable you to control the end user data collected by the SDK after the end user has submitted their captured media. As a result, you can leverage Onfido’s advanced on-device technology, including image quality validations, while still being able to handle end users’ data directly. This unlocks additional use cases, including compliance requirements and multi-vendor configurations, that require this additional flexibility.

**This feature must be enabled for your account.** Please contact your Onfido Solution Engineer or Customer Success Manager.

#### Implementation
To use this feature, implement the `OnfidoMediaCallback` interface and provide the callback for `OnfidoMediaResult` for documents, live photos and live videos:

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

### Generating verification reports

While the SDK is responsible for capturing and uploading the user's media and data, identity verification reports themselves are generated based on workflows created using [Onfido Studio](https://documentation.onfido.com/getting-started/onfido-studio-product).

For a step-by-step walkthrough of creating an identity verification using Onfido Studio and our SDKs, please refer to our [Quick Start Guide](https://documentation.onfido.com/getting-started/quick-start-guide).

If your application initializes the Onfido Flutter SDK using the options defined in the [Advanced customization](#advanced-flow-customization) section of this document, you may [create checks](https://documentation.onfido.com/api/latest#create-check) and [retrieve report results](https://documentation.onfido.com/#retrieve-report) manually using the Onfido API.
You may also configure [webhooks](https://documentation.onfido.com/api/latest#webhooks) to be notified asynchronously when the report results have been generated.

## Advanced flow customization

This section on 'Advanced customization' refers to the process of initializing the Onfido Flutter SDK without the use of Onfido Studio. This process requires a manual definition of the verification steps and their configuration.

While building the configuration object is done in exactly the same way as [documented above](#build-a-configuration-object), the `flowSteps` parameter used to manually define the steps of the identity verification journey in the `start` function is mutually exclusive of the `startWorkflow` function and the `workflowRunId` parameter.

**Note** that this initialization process is **not recommended** as the majority of new features are exclusively released for Studio workflows.

### Manually starting the flow

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

#### Parameter details

* **`flowSteps`**: **Required**. This object is used to toggle on or off the individual screens a user will see during the verification flow, and to set configurations for each screen. 
  * **`FlowSteps.welcome`**: **Optional**. This toggles the welcome screen on or off. If omitted, this screen does not appear in the flow. Valid values are `true` or `false`.

  * **`FlowSteps.proofOfAddress`**: **Optional**. This toggles the proof of address screen on or off, where a user selects the issuing country and type of document that verifies their address before capturing the document with their phone camera, or uploading it. Valid values are `true` or `false`.

  * **`FlowSteps.documentCapture`**: **Optional**. In the Document step, a user can select the type of document to capture and its issuing country before capturing it with their phone camera. Document type selection and country selection are dynamic screens, and will be automatically hidden where the end user is not required to choose which document should be captured.
    * **`DocumentCapture.documentType`**: Required if `countryCode` is specified. Valid values can be found in the `document_type.dart` modal.
    * **`DocumentCapture.countryCode`**: Required if `documentType` is specified. Valid values can be found in the `country_code.dart` modal.
      
  * **`FlowSteps.faceCapture`**: **Optional**. In this step, a user can use the front camera to capture their face in the form of a photo, video, or motion capture. You can create a `FaceCapture` object using the corresponding factory constructors: `FaceCapture.photo()`, `FaceCapture.video()`, or `FaceCapture.motion()`. Each capture method can have additional configurations. If any of these optional parameters are not provided, the default values will be used in each platform. Please refer to the respective platform documentation for details on the default behaviors of these parameters. 
      * `photo`:
          * `withIntroScreen` (**Optional**): Whether to show an introduction screen before the photo capture.
      * `video`:
          * `withIntroVideo` (**Optional**): Whether to show video guidance on the introduction screen before the video capture.
          * `withConfirmationVideoPreview` (**Optional**, Android only): Whether to show a preview of the captured video for user confirmation.
          * `withManualLivenessCapture` (**Optional**, iOS only): Whether to enable manual capture during the video recording.
      * `motion`:
          * `withAudio` (**Optional**): Whether to capture audio during the motion sequence.

## Advanced callbacks

### Success Response

When the user has reached the end of the flow, you will receive the response with `[OnfidoResult]`, a list with multiple results. 

The results are different objects, each with its own associated value (also known as payload). The `OnfidoResult` object can have the following values:

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

### Error Response

You will receive a `PlatformException` if an error occurs, and the SDK will reject the promise falling into the catch block. The failure can be triggered during the initialization, by run time exceptions, or by the user leaving the SDK without completing the flow.

| Error Code | Notes |
| ----- | ------ |
| `configuration` | When something happens before initializing the SDK, may be caused by invalid configuration. |
| `error` | When something happens in run time, e.g. camera permission denied by the user. |
| `exit` | When the user has left the SDK flow without completing. |

The `Error` object returned as part of `PlatformException` translates the errors from the native side to Dart. You can identify the type of the error from the error message:

```dart
    PlatformException(error, The operation couldn’t be completed. (Onfido.OnfidoFlowError error 2.), cameraPermission, null)
      // Occurs if the user denies permission to the SDK during the flow

    PlatformException(error, The operation couldn’t be completed. (Onfido.OnfidoFlowError error 2.), failedToWriteToDisk, null)
      // Occurs when the SDK tries to save capture to disk, maybe due to a lack of space

    PlatformException(error, The operation couldn’t be completed. (Onfido.OnfidoFlowError error 2.), microphonePermission, null)
      // Occurs when the user denies permission for microphone usage by the app during the flow

    PlatformException(error, The operation couldn’t be completed. (Onfido.OnfidoFlowError error 2.), upload, null)
      // Occurs when the SDK receives an error from an [API call](https://documentation.onfido.com/#errors)

    PlatformException(error, The operation couldn’t be completed. (<platform_specific_error>), exception, null)
      // Occurs when an unexpected error occurs. Please contact [ios-sdk@onfido.com](mailto:ios-sdk@onfido.com?Subject=ISSUE%3A) or [android-sdk@onfido.com](mailto:android-sdk@onfido.com?Subject=ISSUE%3A) when this happens

    PlatformException(error, The operation couldn’t be completed. (Onfido.OnfidoFlowError error 2.), versionInsufficient, null)
      // Occurs when you are using an older version of the iOS SDK and trying to access a new functionality from the workflow. You can fix this by updating the SDK

    PlatformException(exit, "User canceled the flow", null, null)
      // The flow was exited prematurely by the user. The reason can be `.userExit` or `.consentDenied`
```

### Handling callbacks

When the Onfido SDK session concludes, a range of callback functions may be triggered.

For documentation regarding handling callbacks, please refer to our native [iOS](https://documentation.onfido.com/sdk/ios/#handling-callbacks-1) and [Android](https://documentation.onfido.com/sdk/android/#handling-callbacks-1) documentation.

## More Information

### Sample App

We have included a sample app to show how to integrate with the Onfido Flutter SDK. See the `SampleApp` directory for more information.

## Support

Should you encounter any technical issues during integration, please contact Onfido's Customer Support team via [email](mailto:support@onfido.com), including the word ISSUE: at the start of the subject line. 

Alternatively, you can search the support documentation available via the customer experience portal, [public.support.onfido.com](http://public.support.onfido.com).

We recommend you update your SDK to the latest version release as frequently as possible. Customers on newer versions of the Onfido SDK consistently see better performance across user onboarding and fraud mitigation, so we strongly advise keeping your SDK integration up-to-date.

You can review our full SDK versioning policy [here](https://documentation.onfido.com/sdk/sdk-version-releases).

Copyright 2024 Onfido, Ltd. All rights reserved.

## How is the Onfido Flutter SDK licensed?
The Onfido Flutter SDK is available under the MIT license.
