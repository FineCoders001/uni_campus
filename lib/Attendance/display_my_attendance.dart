import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uni_campus/Attendance/Models/attend.dart';
import 'Models/meeting.dart';

class DisplayUserAttendance extends StatefulWidget {
  const DisplayUserAttendance({Key? key}) : super(key: key);

  @override
  State<DisplayUserAttendance> createState() => _DisplayUserAttendanceState();
}

class _DisplayUserAttendanceState extends State<DisplayUserAttendance> {
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
  late final ValueNotifier<Query<Map<String, dynamic>>> _valuecontroller =
      ValueNotifier<Query<Map<String, dynamic>>>(list);
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
          future: list.get(),
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
                            int.parse((sum / calLength).floor().toString()) - 1;
                        Future.delayed(Duration.zero, () {
                          _valuecontroller.value =
                              _changeQuery(calendarMonth, months);
                        });
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
                    child: ValueListenableBuilder<Query<Map<String, dynamic>>>(
                      valueListenable: _valuecontroller,
                      builder: (BuildContext context, value, Widget? child) {
                        return FutureBuilder(
                            future: value.get(),
                            builder: (context,
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
                              var calsnap = snapshot.data?.docs;
                              try {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: calsnap!.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                            "${calsnap[index].get("Subject")} ${calsnap[index].get("Date").toString().substring(0, 10)}"),
                                        subtitle: Text(snap[index]
                                            .get("Date")
                                            .toString()
                                            .substring(11, 16)),
                                      );
                                    });
                              } catch (e) {
                                if (calsnap == []) {
                                  return const Center(
                                    child: Text("No Data Found"),
                                  );
                                }
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            });
                      },
                    ),
                  )
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

Query<Map<String, dynamic>> _changeQuery(
    int calendarMonth, List<String> months) {
  print("changes" + calendarMonth.toString());
  return FirebaseFirestore.instance
      .collection("Attendance")
      .doc(DateTime.now().year.toString())
      .collection(months[calendarMonth])
      .doc("Semester 7")
      .collection("Information Technology")
      .where("Map", arrayContainsAny: [
    FirebaseAuth.instance.currentUser!.email!.toString()
  ]);
}
