import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uni_campus/Attendance/Models/attend.dart';

class DisplayUserAttendace extends StatefulWidget {
  const DisplayUserAttendace({Key? key}) : super(key: key);

  @override
  State<DisplayUserAttendace> createState() => _DisplayUserAttendaceState();
}

class _DisplayUserAttendaceState extends State<DisplayUserAttendace> {
  late List<Attend> li = [];
  late Future<QuerySnapshot<Map<String, dynamic>>> list;
  // @override
  // Future<void> didChangeDependencies() async {
  //   list = await FirebaseFirestore.instance
  //       .collection("Attendance")
  //       .doc("2022")
  //       .collection("March")
  //       .doc("Semester 7")
  //       .collection("Information Technology")
  //       .where("Map",
  //           arrayContainsAny: [FirebaseAuth.instance.currentUser!.email]).get();
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    list = FirebaseFirestore.instance
        .collection("Attendance")
        .doc("2022")
        .collection("March")
        .doc("Semester 7")
        .collection("Information Technology")
        .where("Map",
            arrayContainsAny: [FirebaseAuth.instance.currentUser!.email]).get();
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: list,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              var l = snapshot.data!.docs;
              return Center(
                child: ListView.builder(
                  itemCount: l.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                        "${l[index].get("Department")} ${l[index].get("Date")}"),
                    subtitle: Text(
                        "${l[index].get("Month").toString()} ${l[index].id}"),
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      // body: FirestoreListView<Attend>(
      //   query: list,
      //   itemBuilder: (context, snapshot) {
      //     print(" data ${snapshot.data()}");
      //     final listdata = snapshot.data();
      //     print(listdata.toJson().toString());
      //     print(FirebaseAuth.instance.currentUser!.email);
      //     print(
      //         " data ${snapshot.id} ${listdata.year} ${listdata.month} ${listdata.dept}");
      //     return ListTile(
      //       // title: Text("${listdata.year} ${listdata.month} ${listdata.dept}"),
      //       subtitle: Text(listdata.map.toString()),
      //     );
      //   },
      // ),
    );
  }
}
