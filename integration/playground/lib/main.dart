import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playground/qr.dart';
import 'package:kraken_video_player/kraken_video_player.dart';
import 'kraken.dart';

void main() async {
  KrakenVideoPlayer.initialize();
  var app = KrakenPlayground();
  runApp(app);
  sendPV();
}

class KrakenPlayground extends StatefulWidget {
  @override
  _KrakenPlaygroundState createState() {
    return _KrakenPlaygroundState();
  }
}

class _KrakenPlaygroundState extends State<KrakenPlayground> {
  String? _singleKrakenAppURL;
  void setSingleKrakenURL(String url) {
    setState(() {
      _singleKrakenAppURL = url;
    });
  }

  Widget _buildHome() {
    if (_singleKrakenAppURL != null) {
      return KrakenPage(_singleKrakenAppURL!, showFPS: false);
    } else {
      return QRScannerPage();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Play Kraken',
      theme: CupertinoThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        scaffoldBackgroundColor: Colors.white,
      ),
      home: _buildHome(),
    );
  }
}

void sendPV() async {
  var httpClient = HttpClient();
  var uri = Uri.https('gm.mmstat.com', '/gokraken.app.pv', {
    'system': _getSystem(),
    // Other goldlog info.
  });
  var request = await httpClient.getUrl(uri);
  var response = await request.close();
  print('Goldlog PV status ${response.statusCode}');
}

String _getSystem() {
  if (Platform.isMacOS) return 'macos';
  if (Platform.isAndroid) return 'android';
  if (Platform.isIOS) return 'ios';
  return 'unknown';
}
