import 'package:flutter/material.dart';
import 'package:uni_campus/Attendance/scan_qr.dart';

class Select extends StatefulWidget {
  const Select({Key? key}) : super(key: key);

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  String? s;
  String? y;
  String? sem;
  @override
  Widget build(BuildContext context) {
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
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: y,
                items: <String>["2022", "2023", "2024", "2025"].map((String v) {
                  return DropdownMenuItem(value: v, child: Text(v));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    y = value;
                  });
                },
              ),
            ),
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ScanQR(
                    de: s,
                    se: sem,
                    ye: y,
                  );
                }));
              },
              child: const Text("Sumbit"),
            ),
          ],
        ),
      ),
    );
  }
}
