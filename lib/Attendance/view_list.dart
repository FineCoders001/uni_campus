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
      body: Column(
        children: [
          Center(
            child: Text(widget.d.toJson().toString()),
          ),
          // ElevatedButton(onPressed: (){
          //   widget.d.
          // }, child: const Text("Submit"),),
        ],
      ),
    );
  }
}
