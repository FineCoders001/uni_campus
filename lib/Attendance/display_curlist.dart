import 'package:flutter/material.dart';
import 'package:uni_campus/Attendance/scan_qr.dart';

class Select extends StatefulWidget {
  const Select({Key? key}) : super(key: key);

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  String? s;
  String y = DateTime.now().year.toString();
  String d = DateTime.now().toString();
  String? sem;
  @override
  Widget build(BuildContext context) {
    String m = months[DateTime.now().month - 1];
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: s,
                items: <String>[
                  "Information Technology",
                  "Mechanical",
                  "Civil",
                  "Chemical",
                  "Power Electronics",
                  "Industrial",
                  "Electrical",
                  "Computer Engineering"
                ].map((String v) {
                  return DropdownMenuItem(value: v, child: Text(v));
                }).toList(),
                onChanged: (nevalue) {
                  setState(() {
                    s = nevalue;
                  });
                },
              ),
            ),
            // DropdownButtonHideUnderline(
            //   child: DropdownButton<String>(
            //     value: y,
            //     items: <String>["2022", "2023", "2024", "2025"].map((String v) {
            //       return DropdownMenuItem(value: v, child: Text(v));
            //     }).toList(),
            //     onChanged: (value) {
            //       setState(() {
            //         y = value;
            //       });
            //     },
            //   ),
            // ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: sem,
                items: <String>[
                  "Semester 1",
                  "Semester 2",
                  "Semester 3",
                  "Semester 4",
                  "Semester 5",
                  "Semester 6",
                  "Semester 7",
                  "Semester 8"
                ].map((String v) {
                  return DropdownMenuItem(value: v, child: Text(v));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    sem = value;
                  });
                },
              ),
            ),
            // DropdownButtonHideUnderline(
            //   child: DropdownButton<String>(
            //     value: m,
            //     items: <String>[
            //       'January',
            //       'February',
            //       'March',
            //       'April',
            //       'May',
            //       'June',
            //       'July',
            //       'August',
            //       'September',
            //       'October',
            //       'November',
            //       'December'
            //     ].map((String v) {
            //       return DropdownMenuItem(value: v, child: Text(v));
            //     }).toList(),
            //     onChanged: (value) {
            //       setState(() {
            //         m = value;
            //       });
            //     },
            //   ),
            // ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ScanQR(
                      department: s, semester: sem, year: y, month: m, date: d);
                }));
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
