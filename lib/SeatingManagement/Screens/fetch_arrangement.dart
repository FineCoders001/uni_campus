import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class FetchArrangement extends StatefulWidget {
  const FetchArrangement({Key? key}) : super(key: key);

  @override
  _FetchArrangementState createState() => _FetchArrangementState();
}

class _FetchArrangementState extends State<FetchArrangement> {
  var text = "";
  TextEditingController enrollment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(hintText: "enrollment"),
                controller: enrollment,
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (enrollment.text.isEmpty) {
                  Fluttertoast.showToast(msg: "enter enrollment");
                } else {
                  String found = "";
                  final _rawData =
                      await rootBundle.loadString("assets/csv/Enrollment.csv");
                  List<dynamic> _listData =
                      CsvToListConverter().convert(_rawData);
                  for (int i = 0; i < _listData.length; i++) {
                    print("${_listData[i][0]} == ${enrollment.text}");
                    if (_listData[i][0].toString() == enrollment.text) {
                      print("here");
                      found = _listData[i][1].toString() +
                          _listData[i][2].toString();
                      break;
                    }
                  }
                  setState(() {
                    text = found;
                  });
                }
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Fetch",
                    style: GoogleFonts.ubuntu(fontSize: 25),
                  ),
                ),
                color: Colors.blue,
              ),
            ),
            Text(text.toString()),
          ],
        ),
      ),
    );
  }
}
