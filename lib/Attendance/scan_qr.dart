import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:uni_campus/Attendance/Models/attend.dart';
import 'package:uni_campus/Attendance/view_list.dart';

class ScanQR extends StatefulWidget {
  final dynamic department;
  final dynamic semester;
  final dynamic year;
  final dynamic month;
  final dynamic subject;
  final dynamic date;
  final dynamic facultyName;
  const ScanQR(
      {Key? key,
      required this.department,
      required this.year,
      required this.month,
      required this.subject,
      required this.semester,
      required this.date,
      required this.facultyName})
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
        facultyName: widget.facultyName,
        dept: widget.department,
        year: widget.year,
        month: widget.month,
        subject: widget.subject,
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
        title: const Text("Scan QR"),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTile(
                title: Text("Faculty : " + at.facultyName.toString()),
              ),
              ListTile(
                title: Text("Department : " + at.dept.toString()),
                subtitle: Text(
                    "Semester : " + at.semester + " Subject : " + at.subject),
              ),
              ListTile(
                title: Text("Date : " + at.date.toString().substring(0, 10)),
                subtitle:
                    Text("Time : " + at.date.toString().substring(11, 16)),
              ),
              // Text(
              //     "${at.dept} ${at.year} ${at.month} ${at.semester} ${at.date} ${at.subject} ${at.facultyName}"),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: ListView(
                  children: [
                    IconButton(
                      onPressed: _scan,
                      tooltip: "Capture QR",
                      icon: const Icon(Icons.camera),
                    ),
                    Center(
                      child: Text(scanRes),
                    ),
                    IconButton(
                        tooltip: "Add",
                        onPressed: () {
                          if (at.map.contains(scanRes)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    duration: Duration(milliseconds: 1500),
                                    content: Text('Already Added',
                                        textAlign: TextAlign.center)));
                          } else {
                            at.map.add(scanRes);
                          }
                        },
                        icon: const Icon(Icons.add)),
                    IconButton(
                      tooltip: "See the list",
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
      ),
    );
  }

  Future<void> _scan() async {
    final result = await BarcodeScanner.scan();
    setState(
      () {
        scanRes = result.rawContent.toString().substring(0, 12);
      },
    );
  }
}
