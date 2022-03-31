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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          return addAttendance();
        },
        label: const Text("Submit"),
        icon: const Icon(Icons.add),
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
        mainAxisSize: MainAxisSize.max,
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
          widget.d.map.isEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: const Center(child: Text("No Data Added")),
                )
              : ListView.builder(
                  itemCount: widget.d.map.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(widget.d.map[index]),
                    );
                  })
        ],
      ),
    );
  }

  Future<void> addAttendance() async {
    await FirebaseFirestore.instance
        .collection("Attendance")
        .doc(widget.d.year)
        .collection(widget.d.month)
        .doc(widget.d.semester)
        .collection(widget.d.dept)
        .add(widget.d.toJson())
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                duration: Duration(milliseconds: 1500),
                content: Text('Data Added Successfully',
                    textAlign: TextAlign.center))));
  }
}
