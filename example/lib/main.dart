import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onfido_sdk_example/checks.dart';
import 'package:onfido_sdk_example/workflow.dart';

void main() async {
  await dotenv.load();

  runApp(const MaterialApp(
    title: 'Onfido',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onfido Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              child: const Text("Onfido Checks Sample"),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OnfidoChecksSample()),
                )
              },
            ),
            MaterialButton(
              child: const Text("Onfido Workflow Sample"),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OnfidoWorkflowSample()),
                )
              },
            ),
          ],
        ),
      ),
    );
  }
}
