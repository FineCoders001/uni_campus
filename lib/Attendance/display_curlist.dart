import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/Attendance/scan_qr.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';

class Select extends StatefulHookConsumerWidget {
  const Select({Key? key}) : super(key: key);

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends ConsumerState<Select> {
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
  String subj = "";
  String facName = "";
  String y = DateTime.now().year.toString();
  String d = DateTime.now().toString();
  String sem = "Semester 1";

  @override
  void initState() {
    facName = ref.read(userCrudProvider).user["userName"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String m = months[DateTime.now().month - 1];

    TextEditingController _formcontroller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 138, 63),
        elevation: 0,
        centerTitle: true,
        title: const Text("Subject Information"),
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
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 3),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Center(
                                child: Text(
                                  "Department",
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 26,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(),
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Center(
                                child: Text(
                                  "Semester",
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 26,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(),
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Center(
                                child: Text(
                                  "Subject",
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 26,
                                  ),
                                ),
                              ),
                            ),
                            Form(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1),
                                    ),
                                    hintText:
                                        "Enter Subject Name (eg: CN, ADA) "),
                                controller: _formcontroller,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              //Button
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formcontroller.value.text.toString() != "") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ScanQR(
                              facultyName: facName,
                              department: dept,
                              semester: sem,
                              subject: _formcontroller.value.text
                                  .toString()
                                  .toUpperCase(),
                              year: y,
                              month: m,
                              date: d);
                        },
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.redAccent,
                        duration: Duration(milliseconds: 1500),
                        content: Text('Subject cannot be empty',
                            textAlign: TextAlign.center),
                      ),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
