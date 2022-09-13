import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:onfido_sdk/onfido_sdk.dart';
import 'package:onfido_sdk_example/components/alert_dialog.dart';

import 'components/labeled_checkbox.dart';
import 'http/onfido_api.dart';
import 'model/document_type_with_any.dart';

class OnfidoChecksSample extends StatefulWidget {
  const OnfidoChecksSample({super.key});

  @override
  State<OnfidoChecksSample> createState() => _OnfidoChecksSampleState();
}

class _OnfidoChecksSampleState extends State<OnfidoChecksSample> {
  TextEditingController firstNameController = TextEditingController(text: "first");
  TextEditingController lastNameController = TextEditingController(text: "last");
  TextEditingController emailController = TextEditingController(text: "email@email.com");

  bool _welcomeStep = true;
  bool _proofOfAddressStep = true;
  bool _hideOnfidoLogo = false;
  FaceCaptureType _faceCaptureType = FaceCaptureType.photo;
  DocumentTypes _documentType = DocumentTypes.nationalIdentityCard;
  CountryCode _countryCode = CountryCode.USA;

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
        enterpriseFeatures: EnterpriseFeatures(
          hideOnfidoLogo: _hideOnfidoLogo,
        ),
      );

      final response = await onfido.start(
        flowSteps: FlowSteps(
          proofOfAddress: _proofOfAddressStep,
          welcome: _welcomeStep,
          documentCapture: DocumentCapture(documentType: _documentType.toOnfido(), countryCode: _countryCode),
          faceCapture: _faceCaptureType,
        ),
      );
      _showDialog("Success", "Result it ${response.toString()}");
    } on PlatformException catch (error) {
      // Handle error
      _showDialog("Error", "Error ${error.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onfido Checks'),
      ),
      body: Center(
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
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                value: _hideOnfidoLogo,
                onChanged: (bool newValue) {
                  setState(() {
                    _hideOnfidoLogo = newValue;
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
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                value: _welcomeStep,
                onChanged: (bool newValue) {
                  setState(() {
                    _welcomeStep = newValue;
                  });
                },
              ),
              LabeledCheckbox(
                label: 'Proof of Address',
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                value: _proofOfAddressStep,
                onChanged: (bool newValue) {
                  setState(() {
                    _proofOfAddressStep = newValue;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Document Capture",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    child: Row(
                      children: const [
                        Text("Document Type"),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_drop_down, color: Colors.white),
                      ],
                    ),
                    onPressed: () async => {showDocumentPicker(context)},
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    child: Row(
                      children: const [
                        Text("Country"),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_drop_down, color: Colors.white),
                      ],
                    ),
                    onPressed: () async => {showCountryPicker(context)},
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Face Capture",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    child: Row(
                      children: const [
                        Text("Face Capture"),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_drop_down, color: Colors.white),
                      ],
                    ),
                    onPressed: () async => {showFaceCapturePicker(context)},
                  ),
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
    );
  }

  showFaceCapturePicker(BuildContext context) {
    Picker picker = Picker(
        adapter: PickerDataAdapter<FaceCaptureType>(
          pickerdata: FaceCaptureType.values,
        ),
        selecteds: [FaceCaptureType.values.indexOf(_faceCaptureType)],
        changeToFirst: false,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          _faceCaptureType = picker.getSelectedValues().first!;
        });

    picker.showModal(context);
  }

  showDocumentPicker(BuildContext context) {
    Picker picker = Picker(
        adapter: PickerDataAdapter<DocumentTypes>(
          pickerdata: DocumentTypes.values,
        ),
        selecteds: [DocumentTypes.values.indexOf(_documentType)],
        changeToFirst: false,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          _documentType = picker.getSelectedValues().first!;
        });

    picker.showModal(context);
  }

  showCountryPicker(BuildContext context) {
    Picker picker = Picker(
        adapter: PickerDataAdapter<CountryCode>(
          pickerdata: CountryCode.values,
        ),
        selecteds: [CountryCode.values.indexOf(_countryCode)],
        changeToFirst: false,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          _countryCode = picker.getSelectedValues().first!;
        });

    picker.showModal(context);
  }

  _showDialog(String title, String message) {
    showAlertDialog(context, title, message);
  }
}
