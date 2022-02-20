import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'EventManagement/Screens/create_event_screen.dart';
import 'EventModels/all_events.dart';
import 'EventModels/event_details.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final queryEvent = FirebaseFirestore.instance
      .collection('ApprovedEvent')
      .withConverter(
        fromFirestore: (snapshot, _) => EventsDetail.fromJson(snapshot.data()!),
        toFirestore: (EventsDetail, _) => EventsDetail.toJson(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Event screen",
          style: TextStyle(color: Colors.grey, fontSize: 24),
        ),
        leading:
            IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.arrow_back,color: Colors.grey,)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding:  EdgeInsets.only(top:8.0.h),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       GestureDetector(
            //         onTap: () => {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (BuildContext context) =>
            //               const CreateEventScreen(),
            //             ),
            //           )
            //         },
            //         child: Padding(
            //           padding: EdgeInsets.all(
            //               (MediaQuery.of(context).size.width / 3) / 4),
            //           child: Container(
            //             width: MediaQuery.of(context).size.width / 3,
            //             height: MediaQuery.of(context).size.height / 8,
            //             color: Colors.blue,
            //             child: Center(
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: const [
            //                   Text(
            //                     "Create",
            //                     style: TextStyle(color: Colors.white, fontSize: 18),
            //                   ),
            //                   Text(
            //                     "Event",
            //                     style: TextStyle(color: Colors.white, fontSize: 18),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       GestureDetector(
            //         onTap: () => {
            //
            //         },
            //         child: Padding(
            //           padding: EdgeInsets.all(
            //               (MediaQuery.of(context).size.width / 3) / 4),
            //           child: Container(
            //             width: MediaQuery.of(context).size.width / 3,
            //             height: MediaQuery.of(context).size.height / 8,
            //             color: Colors.blue,
            //             child: const Center(
            //               child: Text(
            //                 "Event",
            //                 style: TextStyle(color: Colors.white, fontSize: 18),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            Container(
              height: 500,
              child: FirestoreListView<EventsDetail>(
                //pageSize: 3,
                query: queryEvent,
                itemBuilder: (context, snapshot) {
                  final post = snapshot.data();
                  final date = DateTime.parse(post.eventDate);
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25))),
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const CircleAvatar(
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              Icons.clear_rounded,
                                              color: Colors.white,
                                            ))),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        post.eventName,
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 38,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "About Event",
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        post.description,
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 18, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Venue",
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        post.venue,
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 18, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Event Type",
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        post.deptLevel.split('.')[1],
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 18, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.date_range),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: ' ${date.day} ',
                                                  style:
                                                      GoogleFonts.abrilFatface(
                                                    fontSize: 22,
                                                    color: Colors.black,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          ' ${monthName[date.month]}',
                                                      style:
                                                          GoogleFonts.zillaSlab(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    //TextSpan(text: ' world!'),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "${weekDayName[date.weekday]}",
                                                style: GoogleFonts.zillaSlab(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.access_time),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '   ${post.eventStartTime.split('(')[1].substring(0, post.eventStartTime.split('(')[1].length - 1)}',
                                                style: GoogleFonts.abrilFatface(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                post.eventDuration,
                                                style: GoogleFonts.zillaSlab(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        //context.read(eventProvider)
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(15),
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Colors.blue,
                                              Colors.cyan,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                            "Participate",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 12.0,
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          post.eventName,
                          style: const TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(post.description),
                        //leading: Icon(Icons.event),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const CreateEventScreen(),
            ),
          );
        },
        label: const Text("Add Task"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}
