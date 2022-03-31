import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uni_campus/Attendance/Models/meeting.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';

class DisplayAttendance extends StatefulHookConsumerWidget {
  const DisplayAttendance({Key? key}) : super(key: key);

  @override
  _DisplayAttendanceState createState() => _DisplayAttendanceState();
}

class _DisplayAttendanceState extends ConsumerState<DisplayAttendance> {
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

  List<String> sem = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8',
  ];

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

  // late String enroll;

  // @override
  // void initState() {
  //   enroll = ref.read(userCrudProvider).user["enroll"].toString();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<Future<QuerySnapshot<Map<String, dynamic>>>> valueListenable =
        ValueNotifier<
                Future<QuerySnapshot<Map<String, dynamic>>>>(
            FirebaseFirestore.instance
                .collection("Attendance")
                .doc(DateTime.now().year.toString())
                .collection(months[calendarMonth])
                .doc(sem[
                    int.parse(ref.watch(userCrudProvider).user["semester"]) -
                        1])
                .collection(ref.watch(userCrudProvider).user["deptName"])
                .where("Map", arrayContainsAny: [
      ref.watch(userCrudProvider).user["enroll"].toString()
    ]).get());
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
      body: ValueListenableBuilder<Future<QuerySnapshot<Map<String, dynamic>>>>(
        valueListenable: valueListenable,
        builder: (context, value, child) {
          return FutureBuilder(
            future: valueListenable.value,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                var calendata = snapshot.data!.docs;
                return Column(
                  children: [
                    SizedBox(
                      height: 3 * MediaQuery.of(context).size.height / 4,
                      child: SfCalendar(
                        maxDate: DateTime.now(),
                        allowedViews: const [CalendarView.week],
                        showDatePickerButton: true,
                        initialDisplayDate: DateTime.now(),
                        dataSource: DS(_getds(calendata)),
                        onViewChanged: (value) {
                          int calLength = value.visibleDates.length;
                          int sum = 0;
                          for (int i = 0; i < calLength; i++) {
                            sum += value.visibleDates[i].month;
                          }
                          calendarMonth =
                              int.parse((sum / calLength).floor().toString()) -
                                  1;
                          Future.delayed(
                            Duration.zero,
                            () {
                              valueListenable.value = FirebaseFirestore.instance
                                  .collection("Attendance")
                                  .doc(DateTime.now().year.toString())
                                  .collection(months[calendarMonth])
                                  .doc(sem[int.parse(ref
                                          .watch(userCrudProvider)
                                          .user["semester"]) -
                                      1])
                                  .collection(ref
                                      .watch(userCrudProvider)
                                      .user["deptName"])
                                  .where("Map", arrayContainsAny: [
                                ref
                                    .watch(userCrudProvider)
                                    .user["enroll"]
                                    .toString()
                              ]).get();
                            },
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: calendata.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              calendata[index].get("Subject").toString() +
                                  " " +
                                  calendata[index]
                                      .get("FacultyName")
                                      .toString(),
                            ),
                            subtitle: Text(
                              calendata[index]
                                      .get("Date")
                                      .toString()
                                      .substring(0, 10) +
                                  " " +
                                  calendata[index]
                                      .get("Date")
                                      .toString()
                                      .substring(11, 16),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      ),
    );
  }
}
