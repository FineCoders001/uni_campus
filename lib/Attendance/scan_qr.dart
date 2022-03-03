import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:uni_campus/Attendance/Models/attend.dart';
import 'package:uni_campus/Attendance/view_list.dart';

class ScanQR extends StatefulWidget {
  final dynamic de;
  final dynamic se;
  final dynamic ye;
  const ScanQR({Key? key, required this.de, required this.ye, required this.se})
      : super(key: key);

  @override
  _ScanQRState createState() => _ScanQRState();
}

String scanRes = "";
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
          Center(child: Text(scanRes)),
          IconButton(
              onPressed: () {
                at.map.add(scanRes);
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
      scanRes = result.rawContent.toString();
    });
  }
}
