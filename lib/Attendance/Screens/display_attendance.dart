import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uni_campus/Attendance/Models/meeting.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';

class DisplayFacultyAttendance extends StatefulHookConsumerWidget {
  final dynamic dept;
  final dynamic year;
  final dynamic month;
  final dynamic semester;
  const DisplayFacultyAttendance(
      {Key? key,
      required this.dept,
      required this.year,
      required this.month,
      required this.semester})
      : super(key: key);

  @override
  _DisplayFacultyAttendanceState createState() =>
      _DisplayFacultyAttendanceState();
}

class _DisplayFacultyAttendanceState
    extends ConsumerState<DisplayFacultyAttendance> {
  @override
  Widget build(BuildContext context) {
    String year = widget.year;
    String month = widget.month;
    String department = widget.dept;
    String semester = widget.semester;
    var q = FirebaseFirestore.instance
        .collection("Attendance")
        .doc(year)
        .collection(month)
        .doc(semester)
        .collection(department)
        .get();
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    List<Meeting> _getds(
        List<QueryDocumentSnapshot<Map<String, dynamic>>> snap) {
      final List<Meeting> meetings = <Meeting>[];
      for (int i = 0; i < snap.length; i++) {
        meetings.add(Meeting(
          snap[i].get("Subject").toString(),
          DateTime.parse(snap[i].get("Date")),
          DateTime.parse(snap[i].get("Date")).add(const Duration(hours: 1)),
          Colors.primaries[Random().nextInt(Colors.primaries.length)],
        ));
      }
      return meetings;
    }

    ValueNotifier<Future<QuerySnapshot<Map<String, dynamic>>>> _valuenotifier =
        ValueNotifier<Future<QuerySnapshot<Map<String, dynamic>>>>(q);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 138, 63),
        elevation: 0,
        centerTitle: true,
        title: const Text("Attendance"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
      body: ValueListenableBuilder<Future<QuerySnapshot<Map<String, dynamic>>>>(
        valueListenable: _valuenotifier,
        builder: ((context, value, child) {
          return FutureBuilder(
              future: _valuenotifier.value,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  var calendata = snapshot.data!.docs;
                  return Column(
                    children: [
                      SizedBox(
                        height: 3 * MediaQuery.of(context).size.height / 4,
                        child: SfCalendar(
                          view: CalendarView.week,
                          maxDate: DateTime.now(),
                          allowedViews: const [
                            CalendarView.week,
                            CalendarView.day
                          ],
                          showDatePickerButton: true,
                          initialDisplayDate: DateTime.now(),
                          dataSource: DS(_getds(calendata)),
                          onViewChanged: (value) {
                            int calLength = value.visibleDates.length;
                            int sum = 0;
                            for (int i = 0; i < calLength; i++) {
                              sum += value.visibleDates[i].month;
                            }
                            int calendarMonth = int.parse(
                                    (sum / calLength).floor().toString()) -
                                1;
                            Future.delayed(
                              Duration.zero,
                              () {
                                _valuenotifier.value = FirebaseFirestore
                                    .instance
                                    .collection("Attendance")
                                    .doc(DateTime.now().year.toString())
                                    .collection(months[calendarMonth])
                                    .doc(semester)
                                    .collection(department)
                                    .get();
                              },
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: calendata.length,
                          itemBuilder: (context, index) {
                            return ref
                                        .watch(userCrudProvider)
                                        .user["role"]
                                        .toString() ==
                                    "student"
                                ? ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: const Color.fromARGB(
                                          255, 68, 140, 255),
                                      child: Text((index + 1).toString()),
                                    ),
                                    title: Text(
                                      calendata[index]
                                              .get("Subject")
                                              .toString() +
                                          " " +
                                          calendata[index]
                                              .get("FacultyName")
                                              .toString(),
                                    ),
                                    subtitle: Text(
                                      calendata[index]
                                              .get("Date")
                                              .toString()
                                              .substring(0, 10) +
                                          " " +
                                          calendata[index]
                                              .get("Date")
                                              .toString()
                                              .substring(11, 16),
                                    ),
                                  )
                                : ListTile(
                                    onTap: <Widget>() {
                                      return showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25),
                                          ),
                                        ),
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: ListView.builder(
                                              itemCount: calendata[index]
                                                  .get("Map")
                                                  .length,
                                              itemBuilder:
                                                  (context, indexnested) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(8),
                                                      ),
                                                      border: Border.all(),
                                                    ),
                                                    child: ListTile(
                                                      title: Text(
                                                        calendata[index]
                                                            .get("Map")[
                                                                indexnested]
                                                            .toString(),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    trailing: Text(calendata[index]
                                        .get("Map")
                                        .length
                                        .toString()),
                                    leading: CircleAvatar(
                                      backgroundColor: const Color.fromARGB(
                                          255, 68, 140, 255),
                                      child: Text((index + 1).toString()),
                                    ),
                                    title: Text(
                                      calendata[index]
                                              .get("Subject")
                                              .toString() +
                                          " " +
                                          calendata[index]
                                              .get("FacultyName")
                                              .toString(),
                                    ),
                                    subtitle: Text(
                                      calendata[index]
                                              .get("Date")
                                              .toString()
                                              .substring(0, 10) +
                                          " " +
                                          calendata[index]
                                              .get("Date")
                                              .toString()
                                              .substring(11, 16),
                                    ),
                                  );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        }),
      ),
    );
  }
}
