import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_campus/SeatingManagement/AssistantMethod/files_io.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../AssistantMethod/upload_download.dart';

class UploadExamDetails extends StatefulWidget {
  const UploadExamDetails({Key? key}) : super(key: key);

  @override
  _UploadExamDetailsState createState() => _UploadExamDetailsState();
}

class _UploadExamDetailsState extends State<UploadExamDetails> {
  String? examType;
  String text = "No File Selected";
  Color color1 = Colors.blueAccent;
  Color color2 = Colors.blueAccent;
  Color color3 = Colors.blueAccent;
  Color color4 = Colors.blueAccent;
  FilePickerResult? arrangement;
  FilePickerResult? timeTable;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Exam Details"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Note: Uploading new Time Table will automatically delete old Seating Arrangement and Time Table.",
              style:
                  GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: DropdownButton<String>(
              hint: examType == null
                  ? Text(
                      "Select Exam Type",
                      style:
                          GoogleFonts.ubuntu(fontSize: 25, color: Colors.black),
                    )
                  : Text(
                      examType!,
                      style:
                          GoogleFonts.ubuntu(fontSize: 25, color: Colors.black),
                    ),
              items: <String>["End Semester", "Mid Semester", "Viva"]
                  .map((String v) {
                return DropdownMenuItem(value: v, child: Text(v));
              }).toList(),
              onChanged: (String? newexamType) {
                setState(() {
                  examType = newexamType as String;
                });
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Time Table",
                        style: GoogleFonts.ubuntu(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    timeTable == null
                        ? Text(
                            "No File Selected",
                            style: GoogleFonts.ubuntu(fontSize: 20),
                          )
                        : Column(
                            children: [
                              Text(
                                "File Selected:",
                                style: GoogleFonts.ubuntu(fontSize: 17),
                              ),
                              Text(
                                "${timeTable?.files.single.name}",
                                style: GoogleFonts.ubuntu(fontSize: 17),
                              )
                            ],
                          ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTapDown: (details) {
                              setState(() {
                                if (color3 == Colors.redAccent) {
                                  color3 = Colors.blueAccent;
                                } else {
                                  color3 = Colors.redAccent;
                                }
                              });
                            },
                            onTapUp: (details) {
                              setState(() {
                                if (color3 == Colors.redAccent) {
                                  color3 = Colors.blueAccent;
                                } else {
                                  color3 = Colors.redAccent;
                                }
                              });
                            },
                            onTap: () async {
                              FilesIO filesIO = FilesIO();
                              FilePickerResult temp =
                                  await filesIO.selectFile();
                              setState(() {
                                timeTable = temp;
                              });
                            },
                            child: Container(
                              color: color3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Select File",
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Seating Arrangement",
                        style: GoogleFonts.ubuntu(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    arrangement == null
                        ? Text(
                            "No File Selected",
                            style: GoogleFonts.ubuntu(fontSize: 20),
                          )
                        : Column(
                            children: [
                              Text(
                                "File Selected:",
                                style: GoogleFonts.ubuntu(fontSize: 20),
                              ),
                              Text(
                                "${arrangement?.files.single.name}",
                                style: GoogleFonts.ubuntu(fontSize: 20),
                              )
                            ],
                          ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTapDown: (details) {
                              setState(() {
                                if (color1 == Colors.redAccent) {
                                  color1 = Colors.blueAccent;
                                } else {
                                  color1 = Colors.redAccent;
                                }
                              });
                            },
                            onTapUp: (details) {
                              setState(() {
                                if (color1 == Colors.redAccent) {
                                  color1 = Colors.blueAccent;
                                } else {
                                  color1 = Colors.redAccent;
                                }
                              });
                            },
                            onTap: () async {
                              FilesIO filesIO = FilesIO();
                              FilePickerResult temp =
                                  await filesIO.selectFile();
                              setState(() {
                                arrangement = temp;
                              });
                            },
                            child: Container(
                              color: color1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Select File",
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTapDown: (details) {
                setState(() {
                  if (color4 == Colors.redAccent) {
                    color4 = Colors.blueAccent;
                  } else {
                    color4 = Colors.redAccent;
                  }
                });
              },
              onTapUp: (details) {
                setState(() {
                  if (color4 == Colors.redAccent) {
                    color4 = Colors.blueAccent;
                  } else {
                    color4 = Colors.redAccent;
                  }
                });
              },
              onTap: () async {
                if (examType == null) {
                  Fluttertoast.showToast(msg: "Select Exam Type");
                } else if (timeTable == null) {
                  Fluttertoast.showToast(msg: "Select File for Time Table");
                } else if (arrangement == null) {
                  Fluttertoast.showToast(
                      msg: "Select File for Seating Arrangement");
                } else {
                  List<String> examTypes = [
                    "Mid Semester",
                    "End Semester",
                    "Viva"
                  ];
                  for (int i = 0; i < examTypes.length; i++) {
                    firebase_storage.ListResult seatingArrangement =
                        await firebase_storage.FirebaseStorage.instance
                            .ref("ExamFiles/${examTypes[i]}/TimeTable")
                            .listAll();
                    if (seatingArrangement.items.isNotEmpty) {
                      for (var element in seatingArrangement.items) {
                        // print(
                        //     "Found Files at:${await element.getDownloadURL()}");
                        FirebaseStorage.instance
                            .refFromURL(await element.getDownloadURL())
                            .delete();
                        // print("Deleted Successfully");
                      }
                    }
                  }
                  for (int i = 0; i < examTypes.length; i++) {
                    firebase_storage.ListResult seatingArrangement =
                        await firebase_storage.FirebaseStorage.instance
                            .ref("ExamFiles/${examTypes[i]}/SeatingArrangement")
                            .listAll();
                    if (seatingArrangement.items.isNotEmpty) {
                      for (var element in seatingArrangement.items) {
                          // print(
                          //     "Found Files at:${await element.getDownloadURL()}");
                          FirebaseStorage.instance
                              .refFromURL(await element.getDownloadURL())
                              .delete();
                          // print("Deleted Successfully");
                        }
                    }
                  }
                  UploadDownload uploadDownload = UploadDownload();
                  await uploadDownload
                      .uploadFile(
                          timeTable!, "$examType/TimeTable", "TimeTable.csv")
                      .then((value) async {
                    await uploadDownload
                        .uploadFile(
                            arrangement!,
                            "$examType/SeatingArrangement",
                            "SeatingArrangement.csv")
                        .then((value) => Fluttertoast.showToast(
                            msg: "Both Files Uploaded Successfully"));
                  });
                }
              },
              child: Container(
                alignment: Alignment.center,
                color: color4,
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
          ),
        ],
      ),
    );
  }
}
