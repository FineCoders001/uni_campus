import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  late Future<QuerySnapshot<Map<String, dynamic>>> list;

  @override
  Widget build(BuildContext context) {
    // print("Data " +
    //     FirebaseAuth.instance.currentUser!.email!.toString() +
    //     " " +
    //     RegExp.escape(DateTime.now().toString()));
    // print(RegExp(FirebaseAuth.instance.currentUser!.email!.toString() +
    //         r'^\s+[0-9]+:+[0-9]+:[0-9]+\.+[0-9]+$')
    //     .hasMatch(dad));
    // print(RegExp(FirebaseAuth.instance.currentUser!.email!.toString() +
    //         r"(\s)([0-9]+-)([0-9]+-)([0-9]+)(\s)([0-9]+:)([0-9]+:)([0-9]+)(\.)([0-9]+)")
    //     .stringMatch(FirebaseAuth.instance.currentUser!.email!.toString()));
    list = FirebaseFirestore.instance
        .collection("Attendance")
        .doc(DateTime.now().year.toString())
        .collection("March")
        .doc("Semester 7")
        .collection("Information Technology")
        .where("Map", arrayContainsAny: [
      FirebaseAuth.instance.currentUser!.email!.toString()
    ]).get();
    return Scaffold(
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
          future: list,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.data?.size != null) {
              var snap = snapshot.data!.docs;
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: SfCalendar(
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snap.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                          "${snap[index].get("Department")} ${snap[index].get("Date")}"),
                      subtitle: Text(
                          "${snap[index].get("Month").toString()} ${snap[index].id}"),
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
          snap[i].get("Date").toString(),
          DateTime.parse(snap[i].get("Date")),
          DateTime.parse(snap[i].get("Date")).add(const Duration(hours: 1)),
          Colors.primaries[Random().nextInt(Colors.primaries.length)]));
    }
    return meetings;
  }
}
