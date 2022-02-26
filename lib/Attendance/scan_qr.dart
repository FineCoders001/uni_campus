// ignore_for_file: unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:uni_campus/Attendance/view_list.dart';
import 'package:uni_campus/attend.dart';

class ScanQR extends StatefulWidget {
  var de;

  var se;

  var ye;

  ScanQR({Key? key, required this.de, required this.ye, required this.se})
      : super(key: key);

  @override
  _ScanQRState createState() => _ScanQRState();
}

var scanres = "";
//late List<String> l;
late Attend at;
//var at = Attend(dept: de, year: ye, semester: se);

class _ScanQRState extends State<ScanQR> {
  @override
  void initState() {
    at = Attend(
        dept: widget.de, year: widget.ye, semester: widget.se, map: <String>[]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${at.dept} ${at.year}"),
      ),
      body: ListView(
        children: [
          IconButton(onPressed: _scan, icon: const Icon(Icons.camera)),
          Center(child: Text(scanres)),
          IconButton(
              onPressed: () {
                at.map.add(scanres);
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewList(d: at);
                }));
              },
              icon: const Icon(Icons.view_agenda))
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
}
