import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class FetchArrangement extends StatefulWidget {
  const FetchArrangement({Key? key}) : super(key: key);

  @override
  _FetchArrangementState createState() => _FetchArrangementState();
}

class _FetchArrangementState extends State<FetchArrangement> {
  var text = "";
  var download = "";
  String text2 = "Select file to upload";
  FilePickerResult? fileSelected;
  Color color = Colors.blueAccent;
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
                      const CsvToListConverter().convert(_rawData);
                  for (int i = 0; i < _listData.length; i++) {
                    if (_listData[i][0].toString() == enrollment.text) {
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
            const SizedBox(height: 10),

            //FilePicker Button
            GestureDetector(
              onTapDown: (details) {
                setState(() {
                  if (color == Colors.redAccent) {
                    color = Colors.blueAccent;
                  } else {
                    color = Colors.redAccent;
                  }
                });
              },
              onTapUp: (details) {
                setState(() {
                  if (color == Colors.redAccent) {
                    color = Colors.blueAccent;
                  } else {
                    color = Colors.redAccent;
                  }
                });
              },
              onTap: () {
                selectFile();
              },
              child: Container(
                color: color,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text2,
                    style:
                        GoogleFonts.ubuntu(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            //Upload file Button
            GestureDetector(
              onTapDown: (details) {
                setState(() {
                  if (color == Colors.redAccent) {
                    color = Colors.blueAccent;
                  } else {
                    color = Colors.redAccent;
                  }
                });
              },
              onTapUp: (details) {
                setState(() {
                  if (color == Colors.redAccent) {
                    color = Colors.blueAccent;
                  } else {
                    color = Colors.redAccent;
                  }
                });
              },
              onTap: () {
                uploadFile();
              },
              child: Container(
                color: color,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Upload",
                    style:
                        GoogleFonts.ubuntu(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTapDown: (details) {
                setState(() {
                  if (color == Colors.redAccent) {
                    color = Colors.blueAccent;
                  } else {
                    color = Colors.redAccent;
                  }
                });
              },
              onTapUp: (details) {
                setState(() {
                  if (color == Colors.redAccent) {
                    color = Colors.blueAccent;
                  } else {
                    color = Colors.redAccent;
                  }
                });
              },
              onTap: () {
                downloadFile();
              },
              child: Container(
                color: color,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Download",
                    style:
                        GoogleFonts.ubuntu(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future selectFile() async {
    final file = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (file == null) {
      return;
    }
    setState(() {
      fileSelected = file;
      text2 = file.files.single.name;
    });
  }

  Future uploadFile() async {
    if (fileSelected == null) return;

    final fileName = fileSelected?.files.single.name;
    final destination = "files/$fileName";
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      final path = fileSelected?.files.single.path;

      File file = File(path!);
      UploadTask task = ref.putFile(file);
      if (task == null) {
        return;
      } else {
        final snapshot = await task.whenComplete(() => null);
        final downloadLink = await snapshot.ref.getDownloadURL();
        setState(() {
          download = downloadLink;
        });
        var temp = await http.get(Uri.parse(downloadLink.toString()));
        print(temp.headers);
        final _result = await OpenFile.open(temp.body);
        print(_result.message);
        return downloadLink;
      }
    } on FirebaseException catch (e) {
      print(e);
      return e;
    }
  }

  Future downloadFile() async {
    final dir = getApplicationSupportDirectory();
  }
}
