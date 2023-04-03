import 'package:flutter/material.dart';
import 'package:onfido_sdk/onfido_sdk.dart';

import 'components/alert_dialog.dart';
import 'http/onfido_api.dart';

class OnfidoWorkflowSample extends StatefulWidget {
  const OnfidoWorkflowSample({super.key});

  @override
  State<OnfidoWorkflowSample> createState() => _OnfidoWorkflowState();
}

class _OnfidoWorkflowState extends State<OnfidoWorkflowSample> {
  TextEditingController firstNameController = TextEditingController(text: "first");
  TextEditingController lastNameController = TextEditingController(text: "last");
  TextEditingController emailController = TextEditingController(text: "email@email.com");
  TextEditingController coBrandTextController = TextEditingController();
  bool hideLogo = false;
  bool disableMobileSDKAnalytics = false;

  startWorkflow() async {
    try {
      final applicant = await OnfidoApi.instance.createApplicant(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
      );
      final applicantId = applicant.id!;
      final sdkToken = await OnfidoApi.instance.createSdkToken(applicantId);
      final workflowRunId = await OnfidoApi.instance.getWorkflowRunId(applicantId);

      final Onfido onfido = Onfido(
          sdkToken: sdkToken,
          iosLocalizationFileName: "onfido_ios_localisation",
          enterpriseFeatures: EnterpriseFeatures(
              hideOnfidoLogo: hideLogo,
              cobrandingText: coBrandTextController.text,
              disableMobileSDKAnalytics: disableMobileSDKAnalytics));

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
      appBar: AppBar(
        title: const Text('Onfido Workflow Sample'),
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
    );
  }

  _showDialog(String title, String message) {
    showAlertDialog(context, title, message);
  }
}
