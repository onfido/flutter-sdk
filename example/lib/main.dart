import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onfido_sdk_example/classic.dart';
import 'package:onfido_sdk_example/studio.dart';

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
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: "Classic"),
                Tab(text: "Studio"),
              ],
            ),
            title: const Text('Flutter SDK'),
          ),
          body: const TabBarView(
            children: [OnfidoClassic(), OnfidoStudio()],
          ),
        ),
      ),
    );
  }
}
