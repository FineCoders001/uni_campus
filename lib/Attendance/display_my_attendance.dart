import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uni_campus/Attendance/Models/attend.dart';
import 'Models/meeting.dart';

class DisplayUserAttendace extends StatefulWidget {
  const DisplayUserAttendace({Key? key}) : super(key: key);

  @override
  State<DisplayUserAttendace> createState() => _DisplayUserAttendaceState();
}

class _DisplayUserAttendaceState extends State<DisplayUserAttendace> {
  late List<Attend> li = [];
  late Query<Map<String, dynamic>> list = FirebaseFirestore.instance
      .collection("Attendance")
      .doc(DateTime.now().year.toString())
      .collection(months[calendarMonth])
      .doc("Semester 7")
      .collection("Information Technology")
      .where("Map", arrayContainsAny: [
    FirebaseAuth.instance.currentUser!.email!.toString()
  ]);
  final CalendarController _calendarController = CalendarController();
  late int calendarMonth = DateTime.now().month - 1;
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
  @override
  void didChangeDependencies() {
    list = FirebaseFirestore.instance
        .collection("Attendance")
        .doc(DateTime.now().year.toString())
        .collection(months[calendarMonth])
        .doc("Semester 7")
        .collection("Information Technology")
        .where("Map", arrayContainsAny: [
      FirebaseAuth.instance.currentUser!.email!.toString()
    ]);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 138, 63),
        elevation: 0,
        centerTitle: true,
        title: const Text("My Attendance"),
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
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("Attendance")
              .doc(DateTime.now().year.toString())
              .collection(months[calendarMonth])
              .doc("Semester 7")
              .collection("Information Technology")
              .where("Map", arrayContainsAny: [
            FirebaseAuth.instance.currentUser!.email!.toString()
          ]).get(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.data?.size != null) {
              var snap = snapshot.data!.docs;
              return Column(
                children: [
                  SizedBox(
                    height: 3 * MediaQuery.of(context).size.height / 4,
                    child: SfCalendar(
                      controller: _calendarController,
                      showDatePickerButton: true,
                      onViewChanged: (value) {
                        int calLength = value.visibleDates.length;
                        int sum = 0;
                        for (int i = 0; i < calLength; i++) {
                          sum += value.visibleDates[i].month;
                        }

                        calendarMonth =
                            int.parse((sum / calLength).floor().toString());

                        super.didChangeDependencies();
                      },
                      appointmentTextStyle: GoogleFonts.ubuntu(),
                      allowedViews: const [
                        CalendarView.month,
                        CalendarView.week
                      ],
                      allowViewNavigation: true,
                      view: CalendarView.week,
                      initialSelectedDate: DateTime.now(),
                      dataSource: DS(_getds(snap)),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snap.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                            "${snap[index].get("Subject")} ${snap[index].get("Date").toString().substring(0, 10)}"),
                        subtitle: Text(snap[index]
                            .get("Date")
                            .toString()
                            .substring(11, 16)),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  List<Meeting> _getds(List<QueryDocumentSnapshot<Map<String, dynamic>>> snap) {
    final List<Meeting> meetings = <Meeting>[];
    for (int i = 0; i < snap.length; i++) {
      meetings.add(Meeting(
          snap[i].get("Subject").toString(),
          DateTime.parse(snap[i].get("Date")),
          DateTime.parse(snap[i].get("Date")).add(const Duration(hours: 1)),
          Colors.primaries[Random().nextInt(Colors.primaries.length)]));
    }
    return meetings;
  }
}
