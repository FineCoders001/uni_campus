import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_campus/SeatingManagement/AssistantMethod/files_io.dart';

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
            height: 30,
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
                    Row(
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
                            FilePickerResult temp = await filesIO.selectFile();
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTapDown: (details) {
                              setState(() {
                                if (color2 == Colors.redAccent) {
                                  color2 = Colors.blueAccent;
                                } else {
                                  color2 = Colors.redAccent;
                                }
                              });
                            },
                            onTapUp: (details) {
                              setState(() {
                                if (color2 == Colors.redAccent) {
                                  color2 = Colors.blueAccent;
                                } else {
                                  color2 = Colors.redAccent;
                                }
                              });
                            },
                            onTap: () async {
                              if (arrangement == null) {
                                Fluttertoast.showToast(msg: "No File Selected");
                              } else if (examType == null) {
                                Fluttertoast.showToast(msg: "Select Exam Type");
                              } else {
                                UploadDownload uploadDownload =
                                    UploadDownload();
                                await uploadDownload
                                    .uploadFile(
                                        arrangement!, "$examType/SeatingArrangement")
                                    .then((value) => Fluttertoast.showToast(
                                        msg: "File Uploaded Successfully"));
                              }
                            },
                            child: Container(
                              color: color2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Upload",
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                    Row(
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
                            FilePickerResult temp = await filesIO.selectFile();
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
                              if (timeTable == null) {
                                Fluttertoast.showToast(msg: "No File Selected");
                              } else if (examType == null) {
                                Fluttertoast.showToast(msg: "Select Exam Type");
                              } else {
                                UploadDownload uploadDownload =
                                    UploadDownload();
                                await uploadDownload
                                    .uploadFile(
                                        timeTable!, "$examType/TimeTable")
                                    .then((value) => Fluttertoast.showToast(
                                        msg: "File Uploaded Successfully"));
                              }
                            },
                            child: Container(
                              color: color4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Upload",
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
