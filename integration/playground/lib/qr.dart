import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:validators/validators.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'kraken.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({ Key? key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool flashState = false;
  bool isScanning = true;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Scan Kraken QR'),
        trailing: CupertinoButton(
          child: Text('History'),
          padding: EdgeInsets.zero,
          onPressed: _enterHistory,
        ),
      ),
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
      ),
    );
  }

  void _enterHistory() async {
    await Navigator.push(context, CupertinoPageRoute(
      builder: (context) => HistoryPage(),
    ));
  }

  void _onQRScanned(Barcode scanData) async {
    // Avoid duplicated scanning.
    if (!isScanning) return;
    isScanning = false;

    final String code = scanData.code;
    if (isURL(code)) {
      await ScanHistoryStorage().addRecord(code);
      await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => KrakenPage(code),
        ),
      );
    } else {
      await Fluttertoast.showToast(
        msg: 'Scanned: $scanData',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 14.0,
      );
    }
    isScanning = true;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(_onQRScanned);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

@immutable
class QRCodeResult {
  final String value;

  QRCodeResult(this.value);

  @override
  String toString() => 'QRCodeResult($value)';
}

class HistoryPage extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<HistoryPage> {
  List<String>? _records;

  @override
  void initState() {
    super.initState();
    ScanHistoryStorage().readHistory()
        .then((List<String>? records) {
      setState(() {
        _records = records;
      });
    });
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Widget divider = Divider(color: Colors.grey);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Scan History'),
      ),
      child: Scaffold(
        body: _records == null ? null : ListView.separated(
          itemCount: _records?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            String url = _records![_records!.length - index - 1];
            return ListTile(
              title: Text(url),
              hoverColor: Colors.white24,
              contentPadding: EdgeInsets.fromLTRB(18, 8, 18, 8),
              onTap: () async {
                await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => KrakenPage(url),
                  ),
                );
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) => divider,
        ),
      ),
    );
  }
}

class ScanHistoryStorage {
  static String FILE_NAME = 'scan_history.data';
  static ScanHistoryStorage? instance;

  factory ScanHistoryStorage() {
    if (ScanHistoryStorage.instance != null) {
      return instance!;
    } else {
      ScanHistoryStorage.instance = ScanHistoryStorage._();
      return ScanHistoryStorage.instance!;
    }
  }

  ScanHistoryStorage._();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$FILE_NAME');
  }

  Future<List<String>?> readHistory() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      List _rawDecoded = jsonDecode(contents);
      return _rawDecoded.cast<String>();
    } catch (e, trace) {
      print('Error while read scan history record, $e');
      print(trace);
      return null;
    }
  }

  Future<void> addRecord(String url) async {
    try {
      List<String>? original = await readHistory();
      if (original == null) {
        original = <String>[];
      }
      if (original.contains(url)) {
        original.remove(url);
      }

      original.add(url);
      await _writeHistory(original);
    } catch (e, trace) {
      print('Error while add scan history record, $e');
      print(trace);
      return null;
    }
  }

  Future<File> _writeHistory(List<String> content) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(jsonEncode(content));
  }
}