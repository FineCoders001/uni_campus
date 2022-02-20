import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';
import 'package:uni_campus/SeatingManagement/AssistantMethod/files_io.dart';
import 'package:uni_campus/SeatingManagement/AssistantMethod/upload_download.dart';

class ExamScreen extends StatefulHookConsumerWidget {
  const ExamScreen({Key? key}) : super(key: key);

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends ConsumerState<ExamScreen> {
  List<Map> timeTable = [];
  String examType = "";
  List<Map> seatingArrangement = [];
  int fetched = -1;
  int enroll = 180310116019;
  int n = 0;
  @override
  void initState() {
    fetchTimeTable().then((value) => fetchArrangement());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(userCrudProvider);
    var userData = data.user;
    enroll = int.parse(userData['enroll']);
    if (n == 0) {
      return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Syncing Time table",
              style: GoogleFonts.ubuntu(fontSize: 25),
            ),
            const SizedBox(
              height: 25,
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: CircularProgressIndicator(),
            ),
          ],
        )),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Exam Time-Table"),
        centerTitle: true,
      ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                examType,
                style: GoogleFonts.ubuntu(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.builder(
                itemCount: n,
                itemBuilder: ((BuildContext context, index) {
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    child: Text(
                                      timeTable[index]["Subject"],
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.black,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              DateFormat('dd MMM yyyy').format(
                                                  DateTime.parse(
                                                      timeTable[index]
                                                          ['Date'])),
                                              style: GoogleFonts.ubuntu(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          timeTable[index]["Time"],
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    child: fetched < 0
                                        ? Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Fetching Arrangement",
                                                    style: GoogleFonts.ubuntu(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  const CircularProgressIndicator(),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: double.infinity,
                                                  child: Text(
                                                    "Seating Arrangement",
                                                    style: GoogleFonts.ubuntu(
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 7,
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.school_outlined),
                                                  title: Text(
                                                    "Department  : ${seatingArrangement[fetched]["Department"] ?? seatingArrangement[fetched]["department"]}",
                                                    style: GoogleFonts.ubuntu(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                ListTile(
                                                  leading: const Icon(Icons
                                                      .meeting_room_outlined),
                                                  title: Text(
                                                    "Room No.       : ${seatingArrangement[fetched]["Room"] ?? seatingArrangement[fetched]["room"]}",
                                                    style: GoogleFonts.ubuntu(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                ListTile(
                                                  leading: const Icon(Icons
                                                      .event_seat_outlined),
                                                  title: Text(
                                                    "Bench              : ${seatingArrangement[fetched]["Bench"] ?? seatingArrangement[fetched]["bench"]}",
                                                    style: GoogleFonts.ubuntu(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Color.fromARGB(255, 255, 238, 212)),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Text(
                                  DateFormat('dd MMM').format(
                                      DateTime.parse(timeTable[index]['Date'])),
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                title: Text(
                                  timeTable[index]['Subject'],
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle:
                                    Text(timeTable[index]["Code"].toString()),
                                trailing: DateTime.parse(timeTable[0]["Date"])
                                        .isAfter(DateTime.now())
                                    ? const Icon(
                                        Icons.pending_actions_outlined,
                                        size: 40,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.check_outlined,
                                        size: 40,
                                        color: Color.fromARGB(255, 73, 199, 77),
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future fetchTimeTable() async {
    String tempPath = "";

    UploadDownload uploadDownload = UploadDownload();

    if (await uploadDownload.downloadFile(
            "ExamFiles/Mid Semester/TimeTable", "TimeTable.csv") ==
        0) {
      tempPath = "Mid Semester";
    } else if (await uploadDownload.downloadFile(
            "ExamFiles/End Semester/TimeTable", "TimeTable.csv") ==
        0) {
      tempPath = "End Semester";
    } else if (await uploadDownload.downloadFile(
            "ExamFiles/Viva/TimeTable", "TimeTable.csv") ==
        0) {
      tempPath = "Viva";
    }
    setState(() {
      examType = tempPath;
    });
    uploadDownload
        .downloadFile("ExamFiles/$tempPath/TimeTable", "TimeTable.csv")
        .then((value) async {
      final dir = await getExternalStorageDirectory();
      String check = dir?.path.toString() as String;
      check = check + '/TimeTable.csv';
      FilesIO filesIO = FilesIO();
      List<List<dynamic>> table = await filesIO.readFile(check);
      for (int i = 1; i < table.length; i++) {
        Map map = {};
        for (int j = 0; j < table[i].length; j++) {
          map[table[0][j]] = table[i][j];
        }
        timeTable.add(map);
      }

      DateFormat outputFormat = DateFormat('yyyy-MM-dd');
      for (int i = 0; i < timeTable.length; i++) {
        try {
          DateFormat inputFormat = DateFormat("dd/MM/yy");
          var output = inputFormat.parse(timeTable[i]["Date"]);
          timeTable[i]["Date"] =
              outputFormat.parse(output.toString()).toString();

          setState(() {
            n = timeTable.length;
          });
        } catch (e) {
          try {
            DateFormat inputFormat2 = DateFormat("dd-MM-yy");
            var output = inputFormat2.parse(timeTable[i]["Date"]);
            timeTable[i]["Date"] =
                outputFormat.parse(output.toString()).toString();

            setState(() {
              n = timeTable.length;
            });
          } catch (e) {
            rethrow;
          }
        }
      }
    });
  }

  Future fetchArrangement() async {
    UploadDownload uploadDownload = UploadDownload();

    if (await uploadDownload.downloadFile(
            "ExamFiles/$examType/SeatingArrangement",
            "SeatingArrangement.csv") ==
        0) {
      uploadDownload
          .downloadFile("ExamFiles/$examType/SeatingArrangement",
              "SeatingArrangement.csv")
          .then((value) async {
        final dir = await getExternalStorageDirectory();
        String check = dir?.path.toString() as String;
        check = check + '/SeatingArrangement.csv';

        int found = -1;
        FilesIO filesIO = FilesIO();
        List<List<dynamic>> table = await filesIO.readFile(check);
        for (int i = 1; i < table.length; i++) {
          Map map = {};
          for (int j = 0; j < table[i].length; j++) {
            map[table[0][j]] = table[i][j];
          }
          if (map["Enrollment"].toString() == enroll.toString() ||
              map["enrollment"].toString() == enroll.toString()) {
            found = i;
          }
          seatingArrangement.add(map);
        }
        setState(() {
          fetched = found - 1;
        });
      });
    }
  }
}
