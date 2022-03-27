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
  String dept = "Information Technology";
  late String subj = "";
  String y = DateTime.now().year.toString();
  String d = DateTime.now().toString();
  String sem = "Semester 1";
  @override
  Widget build(BuildContext context) {
    String m = months[DateTime.now().month - 1];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 138, 63),
        elevation: 0,
        centerTitle: true,
        title: const Text("Display Current List"),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    isDense: true,
                    underline: const SizedBox(),
                    value: dept,
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
                      return DropdownMenuItem(
                          value: v,
                          child: Text(
                            v,
                            style: const TextStyle(fontSize: 20),
                          ));
                    }).toList(),
                    onChanged: (nevalue) {
                      setState(() {
                        dept = nevalue!;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    isDense: true,
                    underline: const SizedBox(),
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
                      return DropdownMenuItem(
                          value: v,
                          child: Text(
                            v,
                            style: const TextStyle(fontSize: 20),
                          ));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        sem = value!;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Form(
                child: TextFormField(
                  initialValue: subj,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a valid subject";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    if (value != "" || value.isNotEmpty) {
                      setState(() {
                        subj = value;
                      });
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ScanQR(
                            department: dept,
                            semester: sem,
                            subject: subj,
                            year: y,
                            month: m,
                            date: d);
                      },
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Submit", style: TextStyle(fontSize: 22)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
