import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:uni_campus/Provider/internet_provider.dart';
import 'package:uni_campus/SeatingManagement/Utils/files_io.dart';
import 'package:uni_campus/SeatingManagement/Utils/upload_download.dart';
import 'package:uni_campus/Widgets/no_internet_screen.dart';
import 'package:uni_campus/main.dart';

class UploadExamDetails extends StatefulWidget {
  const UploadExamDetails({Key? key}) : super(key: key);

  @override
  _UploadExamDetailsState createState() => _UploadExamDetailsState();
}

class _UploadExamDetailsState extends State<UploadExamDetails> {
  String? examType;
  String text = "No File Selected";
  FilePickerResult? arrangement;
  FilePickerResult? timeTable;

  @override
  void initState() {
    context.read<Internet>().checkInternet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<Internet>().getInternet == false
        ? const NoInternetScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              title: const Text("Exam Details"),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                        "Note: Uploading new Time Table will automatically delete old Seating Arrangement and Time Table.",
                        style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.redAccent,
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(blurRadius: 5, color: Colors.grey)
                        ]),
                    child: Center(
                      child: DropdownButton<String>(
                        underline: const SizedBox(),
                        hint: examType == null
                            ? Text(
                                "Select Exam Type",
                                style: GoogleFonts.ubuntu(
                                    fontSize: 25, color: Colors.black),
                              )
                            : Text(
                                examType!,
                                style: GoogleFonts.ubuntu(
                                    fontSize: 25, color: Colors.black),
                              ),
                        items: <String>["End Semester", "Mid Semester", "Viva"]
                            .map((String v) {
                          return DropdownMenuItem(
                            value: v,
                            child: Text(
                              v,
                              style: GoogleFonts.ubuntu(
                                  fontSize: 20, color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newexamType) {
                          setState(() {
                            examType = newexamType as String;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Card(
                    shadowColor: Colors.grey,
                    elevation: 6,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      FilesIO filesIO = FilesIO();
                                      FilePickerResult temp =
                                          await filesIO.selectFile();
                                      setState(() {
                                        timeTable = temp;
                                      });
                                    },
                                    child: Container(
                                      color: Colors.blueAccent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Select File",
                                          style: GoogleFonts.ubuntu(
                                              fontSize: 20,
                                              color: Colors.white),
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
                    shadowColor: Colors.grey,
                    elevation: 6,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      FilesIO filesIO = FilesIO();
                                      FilePickerResult temp =
                                          await filesIO.selectFile();
                                      setState(() {
                                        arrangement = temp;
                                      });
                                    },
                                    child: Container(
                                      color: Colors.blueAccent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Select File",
                                          style: GoogleFonts.ubuntu(
                                              fontSize: 20,
                                              color: Colors.white),
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
                    child: InkWell(
                      onTap: () async {
                        if (examType == null) {
                          buildSnackBar(
                              context, Colors.blueAccent, 'Select Exam type');
                        } else if (timeTable == null) {
                          buildSnackBar(context, Colors.blueAccent,
                              'Select File for Time Table');
                        } else if (arrangement == null) {
                          buildSnackBar(context, Colors.blueAccent,
                              'Select File for Seating Arrangement');
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
                                    .ref(
                                        "ExamFiles/${examTypes[i]}/SeatingArrangement")
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
                              .uploadFile(timeTable!, "$examType/TimeTable",
                                  "TimeTable.csv")
                              .then(
                            (value) async {
                              await uploadDownload
                                  .uploadFile(
                                      arrangement!,
                                      "$examType/SeatingArrangement",
                                      "SeatingArrangement.csv")
                                  .then(
                                    (value) => buildSnackBar(
                                        context,
                                        Colors.greenAccent,
                                        'Both Files Uploaded Successfully'),
                                  );
                            },
                          );
                        }
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        alignment: Alignment.center,
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
            ),
          );
  }
}
