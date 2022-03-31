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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return addAttendance();
        },
        child: const Text("Submit"),
      ),
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
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: Text("Faculty : " + widget.d.facultyName),
            subtitle: Text("Department : " + widget.d.dept),
          ),
          ListTile(
            title: Text("Subject : " +
                widget.d.subject +
                " Semester : " +
                widget.d.semester),
          ),
          ListTile(
            title: Text("Date : " +
                widget.d.date.substring(0, 10) +
                " Time : " +
                widget.d.date.substring(11, 16)),
          ),
          SingleChildScrollView(
            child: ListView.builder(
              itemCount: widget.d.map.isNotEmpty ? widget.d.map.length : 1,
              itemBuilder: (context, index) {
                if (widget.d.map.isNotEmpty) {
                  return ListTile(
                    title: Text(widget.d.map[index]),
                  );
                } else {
                  return const ListTile(
                    title: Text("No data Added"),
                  );
                }
              },
            ),
          ),
        ],
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
