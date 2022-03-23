import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uni_campus/Attendance/Models/attend.dart';

class ViewList extends StatefulWidget {
  final Attend d;

  const ViewList({Key? key, required this.d}) : super(key: key);

  @override
  _ViewListState createState() => _ViewListState();
}

class _ViewListState extends State<ViewList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 138, 63),
        elevation: 0,
        centerTitle: true,
        title: const Text("View List"),
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
            Center(
              child: Text(widget.d.toJson().toString()),
            ),
            ElevatedButton(
              onPressed: () {
                return addAttendance();
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  void addAttendance() {
    FirebaseFirestore.instance
        .collection("Attendance")
        .doc(widget.d.year)
        .collection(widget.d.month)
        .doc(widget.d.semester)
        .collection(widget.d.dept)
        .add(widget.d.toJson());
  }
}
