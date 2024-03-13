import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:onfido_sdk/onfido_sdk.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'components/alert_dialog.dart';
import 'http/onfido_api.dart';
import 'model/media_callback.dart';

class OnfidoStudio extends StatefulWidget {
  const OnfidoStudio({super.key});

  @override
  State<OnfidoStudio> createState() => _OnfidoStudioState();
}

class _OnfidoStudioState extends State<OnfidoStudio> {
  TextEditingController customApiTokenController = TextEditingController(text: "");
  TextEditingController firstNameController = TextEditingController(text: "first");
  TextEditingController lastNameController = TextEditingController(text: "last");
  TextEditingController emailController = TextEditingController(text: "email@email.com");
  TextEditingController workflowIdController = TextEditingController(text: dotenv.get("WORKFLOW_ID"));
  TextEditingController coBrandTextController = TextEditingController();
  bool hideLogo = false;
  bool withMediaCallback = false;
  bool disableMobileSDKAnalytics = false;
  OnfidoTheme onfidoTheme = OnfidoTheme.AUTOMATIC;

  startWorkflow() async {
    try {
      if (customApiTokenController.text.isNotEmpty) {
        OnfidoApi.instance.setCustomApiToken(customApiTokenController.text);
      }

      final applicant = await OnfidoApi.instance.createApplicant(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
      );
      final applicantId = applicant.id!;
      final sdkToken = await OnfidoApi.instance.createSdkToken(applicantId);
      final workflowRunId = await OnfidoApi.instance.getWorkflowRunId(applicantId, workflowIdController.text);

      final Onfido onfido = Onfido(
          sdkToken: sdkToken,
          iosLocalizationFileName: "onfido_ios_localisation",
          mediaCallback: withMediaCallback ? ExampleMediaCallback() : null,
          enterpriseFeatures: EnterpriseFeatures(
              hideOnfidoLogo: hideLogo,
              cobrandingText: coBrandTextController.text,
              disableMobileSDKAnalytics: disableMobileSDKAnalytics),
          onfidoTheme: onfidoTheme);

      await onfido.startWorkflow(workflowRunId);
      _showDialog("Success", "Workflow run successfully");
    } catch (error) {
      // handle error
      _showDialog("Error", "Error ${error.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  controller: customApiTokenController,
                  decoration: const InputDecoration(
                    labelText: 'Custom API Token',
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
                TextField(
                  controller: workflowIdController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Workflow Id',
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
                const SizedBox(height: 30.0),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Theme"),
                          ElevatedButton(
                            child: Row(
                              children: [
                                Text(describeEnum(onfidoTheme)),
                                const SizedBox(width: 6),
                                const Icon(Icons.arrow_drop_down, color: Colors.white),
                              ],
                            ),
                            onPressed: () async => {showThemePicker(context)},
                          ),
                        ],
                      )
                    ])),
                const SizedBox(height: 30.0),
                const Text("Enterprise Settings",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    )),
                TextField(
                  controller: coBrandTextController,
                  decoration: const InputDecoration(
                    labelText: 'Cobranding',
                  ),
                ),
                CheckboxListTile(
                  title: const Text('Hide Logo Configuration'),
                  value: hideLogo,
                  onChanged: (bool? newValue) {
                    setState(() {
                      hideLogo = newValue!;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title: const Text('Use custom media callbacks'),
                  value: withMediaCallback,
                  onChanged: (bool? newValue) {
                    setState(() {
                      withMediaCallback = newValue!;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title: const Text('Disable mobile SDK analytics'),
                  value: disableMobileSDKAnalytics,
                  onChanged: (bool? newValue) {
                    setState(() {
                      disableMobileSDKAnalytics = newValue!;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  child: const Text("Launch Workflow"),
                  onPressed: () async => {startWorkflow()},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDialog(String title, String message) {
    showAlertDialog(context, title, message);
  }

  showThemePicker(BuildContext context) {
    Picker picker = Picker(
        adapter: PickerDataAdapter<OnfidoTheme>(pickerData: OnfidoTheme.values),
        selecteds: [OnfidoTheme.values.indexOf(onfidoTheme)],
        changeToFirst: false,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          setState(() {
            onfidoTheme = picker.getSelectedValues().first!;
          });
        });

    picker.showModal(context);
  }
}
