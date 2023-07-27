# Onfido Flutter SDK Migration Guide

## `3.3.0` -> `4.0.0`

### Breaking Change

The previous implementation used the `FaceCaptureType` enum to define the face capture method. The new implementation replaces the `FaceCaptureType` enum with the abstract `FaceCapture` class and its subclasses for different capture methods.

### Migration Steps

1. Replace the `FaceCaptureType` enum with the corresponding `FaceCapture` factory constructors:
* Replace `FaceCaptureType.photo` with `FaceCapture.photo()`.
* Replace `FaceCaptureType.video` with `FaceCapture.video()`.
* If integrating the Motion capture, use `FaceCapture.motion()`.

2. Update the face capture configurations based on the new implementation. See the updated documentation for `FlowSteps.faceCapture` in the readme file for details on the new configuration options and their usage.

By following these steps, you can successfully migrate to the new `FlowSteps.faceCapture` implementation and take advantage of the additional configurations offered.