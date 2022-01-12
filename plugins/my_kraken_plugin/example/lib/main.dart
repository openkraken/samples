import 'package:flutter/material.dart';
import 'package:kraken/kraken.dart';
import 'package:my_kraken_plugin/my_kraken_plugin.dart';

void main() {
  MyKrakenPlugin.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Kraken(
          bundle: KrakenBundle.fromUrl('assets://assets/bundle.js'),
        )),
      ),
    );
  }
}
