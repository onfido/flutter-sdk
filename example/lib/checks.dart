import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:onfido_sdk/onfido_sdk.dart';
import 'package:onfido_sdk_example/components/alert_dialog.dart';

import 'components/labeled_checkbox.dart';
import 'http/onfido_api.dart';
import 'model/document_type_with_any.dart';
import 'model/media_callback.dart';

class OnfidoChecksSample extends StatefulWidget {
  const OnfidoChecksSample({super.key});

  @override
  State<OnfidoChecksSample> createState() => _OnfidoChecksSampleState();
}

class _OnfidoChecksSampleState extends State<OnfidoChecksSample> {
  TextEditingController firstNameController = TextEditingController(text: "first");
  TextEditingController lastNameController = TextEditingController(text: "last");
  TextEditingController emailController = TextEditingController(text: "email@email.com");

  bool _hideOnfidoLogo = false;
  bool _withMediaCallback = false;
  bool _welcomeStep = true;
  bool _proofOfAddressStep = false;

  bool _disableNFC = false;

  bool _enableDocCapture = false;
  DocumentTypes _documentType = DocumentTypes.nationalIdentityCard;
  CountryCode _countryCode = CountryCode.USA;

  bool _enableFaceCapture = false;
  FaceCaptureType _faceCaptureType = FaceCaptureType.photo;
  bool _introScreen = false;
  bool _introVideo = false;
  bool _confirmationVideoPreview = false;
  bool _manualLivenessCapture = false;
  bool _audio = false;
  FaceCaptureType? _motionCaptureFallback;

  startOnfido() async {
    try {
      final applicant = await OnfidoApi.instance.createApplicant(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
      );

      final applicantId = applicant.id!;
      final sdkToken = await OnfidoApi.instance.createSdkToken(applicantId);

      final Onfido onfido = Onfido(
        sdkToken: sdkToken,
        mediaCallback: _withMediaCallback ? ExampleMediaCallback() : null,
        enterpriseFeatures: EnterpriseFeatures(
          hideOnfidoLogo: _hideOnfidoLogo,
        ),
        disableNFC: _disableNFC,
      );

      final response = await onfido.start(
        flowSteps: FlowSteps(
          proofOfAddress: _proofOfAddressStep,
          welcome: _welcomeStep,
          documentCapture: configureDocumentCapture(),
          faceCapture: configureFaceCapture(),
        ),
      );

      _showDialog("Success", "Result is ${response.toString()}");
    } on PlatformException catch (error) {
      // Handle error
      _showDialog("Error", "Error ${error.toString()}");
    }
  }

  DocumentCapture? configureDocumentCapture() {
    if (!_enableDocCapture) {
      return null;
    }

    return DocumentCapture(documentType: _documentType.toOnfido(), countryCode: _countryCode);
  }

  FaceCapture? configureFaceCapture() {
    if (!_enableFaceCapture) {
      return null;
    }

    switch (_faceCaptureType) {
      case FaceCaptureType.photo:
        return configurePhotoCapture();
      case FaceCaptureType.video:
        return configureVideoCapture();
      case FaceCaptureType.motion:
        return FaceCapture.motion(
          withAudio: _audio,
          withCaptureFallback: configureMotionCaptureFallback(),
        );
    }
  }

  FaceCapture configurePhotoCapture() {
    return FaceCapture.photo(
      withIntroScreen: _introScreen,
    );
  }

  FaceCapture configureVideoCapture() {
    return FaceCapture.video(
      withIntroVideo: _introVideo,
      withConfirmationVideoPreview: _confirmationVideoPreview,
      withManualLivenessCapture: _manualLivenessCapture,
    );
  }

  FaceCapture? configureMotionCaptureFallback() {
    switch (_motionCaptureFallback) {
      case FaceCaptureType.photo:
        return configurePhotoCapture();
      case FaceCaptureType.video:
        return configureVideoCapture();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onfido Checks'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Applicant Configuration",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                  ),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                  ),
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 30.0),
                const Text(
                  "General Configuration",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                LabeledCheckbox(
                  label: 'Hide Onfido Logo',
                  value: _hideOnfidoLogo,
                  onChanged: (bool newValue) {
                    setState(() {
                      _hideOnfidoLogo = newValue;
                    });
                  },
                ),
                LabeledCheckbox(
                  label: 'Disable NFC',
                  value: _disableNFC,
                  onChanged: (bool newValue) {
                    setState(() {
                      _disableNFC = newValue;
                    });
                  },
                ),
                LabeledCheckbox(
                  label: 'Use custom media callbacks',
                  value: _withMediaCallback,
                  onChanged: (bool newValue) {
                    setState(() {
                      _withMediaCallback = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "SDK Flow Customisation",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                LabeledCheckbox(
                  label: 'Welcome Screen',
                  value: _welcomeStep,
                  onChanged: (bool newValue) {
                    setState(() {
                      _welcomeStep = newValue;
                    });
                  },
                ),
                LabeledCheckbox(
                  label: 'Proof of Address',
                  value: _proofOfAddressStep,
                  onChanged: (bool newValue) {
                    setState(() {
                      _proofOfAddressStep = newValue;
                    });
                  },
                ),
                Column(
                  children: [
                    LabeledCheckbox(
                      label: "Document Capture",
                      value: _enableDocCapture,
                      onChanged: (bool value) {
                        setState(() {
                          _enableDocCapture = value;
                        });
                      },
                    ),
                    if (_enableDocCapture) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Document Type"),
                                ElevatedButton(
                                  child: Row(
                                    children: [
                                      Text(describeEnum(_documentType)),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                                    ],
                                  ),
                                  onPressed: () async => {showDocumentPicker(context)},
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Country Code"),
                                ElevatedButton(
                                  child: Row(
                                    children: [
                                      Text(describeEnum(_countryCode)),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                                    ],
                                  ),
                                  onPressed: () async => {showCountryPicker(context)},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                Column(
                  children: [
                    LabeledCheckbox(
                      label: "Face Capture",
                      value: _enableFaceCapture,
                      onChanged: (bool value) {
                        setState(() {
                          _enableFaceCapture = value;
                        });
                      },
                    ),
                    if (_enableFaceCapture) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Type"),
                                ElevatedButton(
                                  child: Row(
                                    children: [
                                      Text(describeEnum(_faceCaptureType)),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                                    ],
                                  ),
                                  onPressed: () async => {showFaceCapturePicker(context)},
                                ),
                              ],
                            ),
                            Visibility(
                              visible: _faceCaptureType == FaceCaptureType.photo,
                              child: SwitchListTile(
                                title: const Text(
                                  "Intro Screen",
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                value: _introScreen,
                                onChanged: (bool value) {
                                  setState(() {
                                    _introScreen = value;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: _faceCaptureType == FaceCaptureType.video,
                              child: Column(
                                children: [
                                  SwitchListTile(
                                    title: const Text(
                                      "Intro Video",
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    value: _introVideo,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _introVideo = value;
                                      });
                                    },
                                  ),
                                  SwitchListTile(
                                    title: const Text(
                                      "Confirmation Video Preview (Android Only)",
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    value: _confirmationVideoPreview,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _confirmationVideoPreview = value;
                                      });
                                    },
                                  ),
                                  SwitchListTile(
                                    title: const Text(
                                      "Manual Liveness Capture (iOS only)",
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    value: _manualLivenessCapture,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _manualLivenessCapture = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: _faceCaptureType == FaceCaptureType.motion,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Capture Fallback"),
                                      ElevatedButton(
                                        child: Row(
                                          children: [
                                            Text(_motionCaptureFallback != null
                                                ? describeEnum(_motionCaptureFallback!)
                                                : "None"),
                                            const SizedBox(width: 6),
                                            const Icon(Icons.arrow_drop_down, color: Colors.white),
                                          ],
                                        ),
                                        onPressed: () async => {showMotionCaptureFallbackPicker(context)},
                                      ),
                                    ],
                                  ),
                                  SwitchListTile(
                                    title: const Text(
                                      "Audio",
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    value: _audio,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _audio = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  child: const Text("Launch Onfido"),
                  onPressed: () async => {startOnfido()},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showFaceCapturePicker(BuildContext context) {
    Picker picker = Picker(
        adapter: PickerDataAdapter<FaceCaptureType>(
          pickerData: FaceCaptureType.values,
        ),
        selecteds: [FaceCaptureType.values.indexOf(_faceCaptureType)],
        changeToFirst: false,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          setState(() {
            _faceCaptureType = picker.getSelectedValues().first!;
          });
        });

    picker.showModal(context);
  }

  showMotionCaptureFallbackPicker(BuildContext context) {
    Picker picker = Picker(
        adapter: PickerDataAdapter<FaceCaptureType>(
          pickerData: FaceCaptureType.values.where((type) => type != FaceCaptureType.motion).toList(),
        ),
        selecteds: [_motionCaptureFallback != null ? FaceCaptureType.values.indexOf(_motionCaptureFallback!) : 0],
        changeToFirst: false,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          setState(() {
            _motionCaptureFallback = picker.getSelectedValues().first!;
          });
        });

    picker.showModal(context);
  }

  showDocumentPicker(BuildContext context) {
    Picker picker = Picker(
        adapter: PickerDataAdapter<DocumentTypes>(
          pickerData: DocumentTypes.values,
        ),
        selecteds: [DocumentTypes.values.indexOf(_documentType)],
        changeToFirst: false,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          setState(() {
            _documentType = picker.getSelectedValues().first!;
          });
        });

    picker.showModal(context);
  }

  showCountryPicker(BuildContext context) {
    Picker picker = Picker(
        adapter: PickerDataAdapter<CountryCode>(
          pickerData: CountryCode.values,
        ),
        selecteds: [CountryCode.values.indexOf(_countryCode)],
        changeToFirst: false,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          setState(() {
            _countryCode = picker.getSelectedValues().first!;
          });
        });

    picker.showModal(context);
  }

  _showDialog(String title, String message) {
    showAlertDialog(context, title, message);
  }
}
