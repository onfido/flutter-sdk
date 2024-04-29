# Onfido Flutter SDK Migration Guide

The guides below are provided to ease the transition of existing applications using the Onfido SDK from one version to another that introduces breaking API changes.

If your migration involves upgrading across multiple SDK versions, be sure to read each individual guide in order to account for all relevant breaking changes.

## `5.1.0` -> `6.0.0`

### Breaking Changes

- Motion is now supported on all devices. Motion capture fallback configuration has therefore been removed.
- `supportDarkMode` and `bubbleErrorBackgroundColor` properties have been removed from `IOSAppearance`


### Migration Steps

- If you currently set `withCaptureFallback` on `FaceCapture.motion`, then you should be aware that this configuration is no longer available, so you can safely remove it from your integration code.
- Please use `onfidoTheme` instead of `supportDarkMode`.

## `3.3.0` -> `4.0.0`

### Breaking Changes

The previous implementation used the `FaceCaptureType` enum to define the face capture method. The new implementation replaces the `FaceCaptureType` enum with the abstract `FaceCapture` class and its subclasses for different capture methods.

Near Field Communication (NFC) is now enabled by default and offered to customers when both the document and the device support NFC. To disable NFC, please refer to our [NFC reference guide](https://developers.onfido.com/guide/document-report-nfc#flutter-1).

### Migration Steps

1. Replace the `FaceCaptureType` enum with the corresponding `FaceCapture` factory constructors:
* Replace `FaceCaptureType.photo` with `FaceCapture.photo()`.
* Replace `FaceCaptureType.video` with `FaceCapture.video()`.
* If integrating the Motion capture, use `FaceCapture.motion()`.

2. Update the face capture configurations based on the new implementation. See the updated documentation for `FlowSteps.faceCapture` in the readme file for details on the new configuration options and their usage.

By following these steps, you can successfully migrate to the new `FlowSteps.faceCapture` implementation and take advantage of the additional configurations offered.