import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:uni_campus/Attendance/Models/attend.dart';
import 'package:uni_campus/Attendance/view_list.dart';

class ScanQR extends StatefulWidget {
  final dynamic department;
  final dynamic semester;
  final dynamic year;
  final dynamic month;
  final dynamic date;
  const ScanQR(
      {Key? key,
      required this.department,
      required this.year,
      required this.month,
      required this.semester,
      required this.date})
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
        dept: widget.department,
        year: widget.year,
        month: widget.month,
        semester: widget.semester,
        map: <String>[],
        date: widget.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 138, 63),
        elevation: 0,
        centerTitle: true,
        title: Text("Scan QR ${at.dept} ${at.year} ${at.semester}"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("${at.dept} ${at.year} ${at.month} ${at.semester} ${at.date}"),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: ListView(
                children: [
                  IconButton(
                    onPressed: _scan,
                    icon: const Icon(Icons.camera),
                  ),
                  Center(
                    child: Text(scanRes),
                  ),
                  IconButton(
                      onPressed: () {
                        at.map.add(scanRes);
                      },
                      icon: const Icon(Icons.add)),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ViewList(d: at);
                        }),
                      );
                    },
                    icon: const Icon(Icons.view_agenda),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scan() async {
    final result = await BarcodeScanner.scan();
    setState(
      () {
        scanRes = result.rawContent.toString();
      },
    );
  }
}
