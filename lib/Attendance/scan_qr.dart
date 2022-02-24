import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({Key? key}) : super(key: key);

  @override
  _ScanQRState createState() => _ScanQRState();
}

var scanres = "";
late List l = [];

class _ScanQRState extends State<ScanQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          IconButton(onPressed: _scan, icon: const Icon(Icons.camera)),
          Center(child: Text(scanres)),
          IconButton(onPressed: _add(scanres), icon: const Icon(Icons.add)),
          //IconButton(onPressed: _view, icon: const Icon(Icons.view_agenda))
        ],
      ),
    );
  }

  Future<void> _scan() async {
    final result = await BarcodeScanner.scan();
    setState(() {
      scanres = result.rawContent.toString();
    });
  }

  _add(String scanres) async {
    l.add(scanres);
  }
}
