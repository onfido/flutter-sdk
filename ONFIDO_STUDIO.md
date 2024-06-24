## Overview
[Onfido Studio](https://documentation.onfido.com/getting-started/onfido-studio-product) is a drag and drop interface enabling you to build an optimised route to verify each end user, by defining and configuring different paths, as well as incorporating a combination of signals, in a single identity verification flow.

## Integrating with Flutter SDK
The Onfido Flutter SDK provides a drop-in set of screens and tools for Flutter applications to capture identity documents and selfie photos and videos for the purpose of identity verification.

The SDK communicates directly and dynamically with active workflows to show the relevant screens to ensure the correct capture and upload of user information. As a result, the SDK flow will vary depending on the workflow configuration. You won't need to specify any steps directly in the SDK integration as these will be overridden when the workflow run ID is passed into the SDK initialisation.


> ℹ️ 
> 
> The following guide will help you to integrate with Onfido Studio.
> If you are looking for the standard integration using Onfido checks, please head to our [README](https://github.com/onfido/flutter-sdk).

## Getting started 

The SDK supports:

* Dart 3.1.0 or higher
* Flutter 1.20 or higher
* Supports iOS 11+
* Supports Android API level 21+
* Supports iPads and tablets


### 1. Add the SDK dependency

#### Using pub.dev
The SDK is available on [pub.dev](https://pub.dev/packages/onfido_sdk/install) and you can include it in your project by running the following script from your project folder:

```shell
flutter pub add onfido_sdk
```

### 2. Update your iOS configuration files
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


### 3. Build a configuration object

To initiaise the SDK, you must provide a `workflowRunId`, obtained by [creating a workflow run](https://documentation.onfido.com/api/latest#create-workflow-run), and an `sdkToken`, obtained by [generating an SDK token](https://documentation.onfido.com/api/latest#generate-sdk-token). 

```dart
final Onfido onfido = Onfido(
  sdkToken: '<YOUR_SDK_TOKEN>'
);
```    

### 4. Start the flow
```dart
await onfido.startWorkflow('<YOUR_WORKFLOW_RUN_ID>');
// listen for the result
```    

## Handling callbacks

To receive the result from a completed workflow, you should use async await with try catch, the following code is provided as an example:


```dart
try { 
    final Onfido onfido = Onfido(
        sdkToken: '<YOUR_SDK_TOKEN>'
    );

    await onfido.startWorkflow('<YOUR_WORKFLOW_RUN_ID>');
    // User completed the flow
} catch(error) { 
    // Error occurred
}
```


| ATTRIBUTE        | NOTES           |
| ------------- |-------------|
| .success    | The end user completed all interactive tasks in the workflow. If you have configured [webhooks](https://documentation.onfido.com/api/latest#webhooks), a notification will be sent to your backend confirming the workflow run has finished. You do not need to create a check using your backend as this is handled directly by the Workflow.  |
| .error(Error)      | An unexpected error occurred.      |


### Customizing the SDK

Onfido Studio uses the same appearance and localization objects as a standard integration. You can see how to create them here: [Appearance](https://documentation.onfido.com/sdk/flutter/#appearance-and-colors) and [Localization](https://documentation.onfido.com/sdk/flutter/#language-localization).