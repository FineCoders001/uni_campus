import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:uni_campus/Attendance/Models/attend.dart';

class DisplayUserAttendace extends StatefulWidget {
  const DisplayUserAttendace({Key? key}) : super(key: key);

  @override
  State<DisplayUserAttendace> createState() => _DisplayUserAttendaceState();
}

class _DisplayUserAttendaceState extends State<DisplayUserAttendace> {
  @override
  Widget build(BuildContext context) {
    final list = FirebaseFirestore.instance
        .collection("Attendance")
        .doc("2022")
        .collection("March")
        .doc("Semester 7")
        .collection("Information Technology")
        .where("Map", arrayContainsAny: ["SpiderMan"]).withConverter<Attend>(
            fromFirestore: (snapshot, _) => Attend.fromJson(snapshot.data()!),
            toFirestore: (attend, _) => attend.toJson());
    return Scaffold(
      body: FirestoreListView<Attend>(
        query: list,
        itemBuilder: (context, snapshot) {
          final listdata = snapshot.data();
          return ListTile(
            title: Text("${listdata.year} ${listdata.month} ${listdata.dept}"),
            subtitle: Text(listdata.map.toString()),
          );
        },
      ),
    );
  }
}
