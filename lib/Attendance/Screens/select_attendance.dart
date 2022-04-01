import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/Attendance/Screens/display_attendance.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';

class MyAttendance extends StatefulHookConsumerWidget {
  const MyAttendance({Key? key}) : super(key: key);

  @override
  _MyAttendanceState createState() => _MyAttendanceState();
}

class _MyAttendanceState extends ConsumerState<MyAttendance> {
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
  late String facName = "";
  String y = DateTime.now().year.toString();
  late String m = months[DateTime.now().month - 1];
  String sem = "Semester 1";

  @override
  void initState() {
    facName = ref.read(userCrudProvider).user["userName"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 138, 63),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Add Details",
          style: GoogleFonts.ubuntu(),
        ),
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
                      padding: const EdgeInsets.all(20.0),
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
                    Padding(
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Center(
                              child: Text(
                                "Month, Year",
                                style: GoogleFonts.ubuntu(
                                  fontSize: 26,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              var sely = await showDatePicker(
                                  context: context,
                                  initialEntryMode:
                                      DatePickerEntryMode.calendarOnly,
                                  initialDatePickerMode: DatePickerMode.year,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2015),
                                  lastDate: DateTime.now());
                              if (sely!.year != DateTime.now().year ||
                                  sely.month != DateTime.now().month) {
                                setState(() {
                                  y = sely.year.toString();
                                  m = months[sely.month - 1];
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(border: Border.all()),
                                child: Center(
                                  child: Text(
                                    m + ", " + y,
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 23,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ElevatedButton(
                    //     onPressed: () async {
                    //       var sely = await showDatePicker(
                    //           context: context,
                    //           initialEntryMode:
                    //               DatePickerEntryMode.calendarOnly,
                    //           initialDatePickerMode: DatePickerMode.year,
                    //           initialDate: DateTime.now(),
                    //           firstDate: DateTime(2015),
                    //           lastDate: DateTime.now());
                    //       if (sely!.year != DateTime.now().year ||
                    //           sely.month != DateTime.now().month) {
                    //         setState(() {
                    //           y = sely.year.toString();
                    //           m = months[sely.month - 1];
                    //         });
                    //       }
                    //     },
                    //     child: Text(m + ", " + y)),
                    // DatePickerDialog(
                    //     initialDate: DateTime.now(),
                    //     firstDate: DateTime.parse("2015-01-01"),
                    //     lastDate: DateTime.now()),
                  ],
                ),
              ),
            ),
            Padding(
              //Button
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DisplayFacultyAttendance(
                          dept: dept,
                          month: m,
                          year: y,
                          semester: sem,
                        );
                      },
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Proceed",
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
