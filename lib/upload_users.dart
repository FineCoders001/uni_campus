import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:uni_campus/Provider/internet_provider.dart';
import 'package:uni_campus/SeatingManagement/Utils/files_io.dart';
import 'package:uni_campus/Widgets/no_internet_screen.dart';

import 'main.dart';

class MulptipleUsers extends StatefulWidget {
  const MulptipleUsers({Key? key}) : super(key: key);

  @override
  State<MulptipleUsers> createState() => _MulptipleUsersState();
}

class _MulptipleUsersState extends State<MulptipleUsers> {
  String text = "No File Selected";
  FilePickerResult? res;
  FilesIO filesIO = FilesIO();
  String localPath =
      "/storage/emulated/0/Android/data/com.example.uni_campus/files/Passwords";

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
              backgroundColor: Colors.redAccent,
              title: const Text("Add multiple users"),
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
                                "Users",
                                style: GoogleFonts.ubuntu(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                            res == null
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
                                        "${res?.files.single.name}",
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
                                      FilePickerResult temp =
                                          await filesIO.selectFile();
                                      setState(() {
                                        res = temp;
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        if (res == null) {
                          buildSnackBar(context, Colors.blueAccent,
                              'Select File For Users');
                        } else {
                          List<List<dynamic>> table = await filesIO
                              .readFile(res!.files.single.path.toString());
                          if (!(await Directory(localPath).exists())) {
                            Directory(localPath).create();
                          }
                          table[0].add("password");
                          for (int i = 1; i < table.length; i++) {
                            var password = base64UrlEncode(List<int>.generate(
                                    8, (index) => Random.secure().nextInt(255)))
                                .toString();
                            print(password);
                            table[i].add(password);
                          }
                          String csv =
                              const ListToCsvConverter().convert(table);
                          File file = File("$localPath/password.csv");
                          await file.writeAsString(csv);
                          print(csv);
                          print(file.path);
                          OpenFile.open("$localPath/password.csv");
                          print(table);
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
