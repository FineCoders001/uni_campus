import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({Key? key}) : super(key: key);

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  List<Map> map = [
    {"date": "15 Jan", "subject": "DSA", "code": "311001", "status": "Done"},
    {"date": "16 Jan", "subject": "DBMS", "code": "311002", "status": "Done"},
    {"date": "17 Jan", "subject": "CN", "code": "311003", "status": "Done"},
    {"date": "18 Jan", "subject": "OS", "code": "311004", "status": "No"},
    {"date": "19 Jan", "subject": "COA", "code": "311005", "status": "No"}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   title: const Text(
        //     "Exam",
        //     style: TextStyle(color: Colors.black),
        //   ),
        // ),
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            "Time Table",
            style: GoogleFonts.ubuntu(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: ((BuildContext context, index) {
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                child: Text(
                                  map[index]["subject"],
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                          map[index]["date"],
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
                                      "12:00 PM",
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
                                child: Padding(
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
                                        leading: const Icon(Icons.school_outlined),
                                        title: Text(
                                          "Department  : IT",
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        leading:
                                            const Icon(Icons.meeting_room_outlined),
                                        title: Text(
                                          "Room No.       : 5",
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        leading:
                                            const Icon(Icons.event_seat_outlined),
                                        title: Text(
                                          "Bench              : 15",
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
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color.fromARGB(255, 255, 238, 212)),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Text(
                              map[index]["date"],
                              style: GoogleFonts.ubuntu(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            title: Text(
                              map[index]['subject'],
                              style: GoogleFonts.ubuntu(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(map[index]["code"]),
                            trailing: map[index]["status"] == "Done"
                                ? const Icon(
                                    Icons.check_outlined,
                                    size: 40,
                                    color: Color.fromARGB(255, 73, 199, 77),
                                  )
                                : const Icon(
                                    Icons.pending_actions_outlined,
                                    size: 40,
                                    color: Colors.red,
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
    ));
  }
}
