import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';

import 'EventManagement/Screens/create_event_screen.dart';
import 'EventModels/all_events.dart';
import 'EventModels/event_details.dart';
import 'circular_fab.dart';

class EventScreen extends StatefulHookConsumerWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventScreen> {
  // final queryEvent = FirebaseFirestore.instance
  //     .collection('ApprovedEvent')
  //     .withConverter(
  //       fromFirestore: (snapshot, _) => EventsDetail.fromJson(snapshot.data()!),
  //       toFirestore: (EventsDetail, _) => EventsDetail.toJson(),
  //     );
  //
  // final queryEvent = FirebaseFirestore.instance
  //     .collection('RequestEvent')
  //     .doc(FirebaseAuth.instance.currentUser?.uid)
  //     .collection("MyRequestedEvents")
  //     .withConverter(
  //   fromFirestore: (snapshot, _) => EventsDetail.fromJson(snapshot.data()!),
  //   toFirestore: (EventsDetail, _) => EventsDetail.toJson(),
  // );

  final queryEvent = FirebaseFirestore.instance
      .collection('AllApprovedEvents')
      .withConverter(
        fromFirestore: (snapshot, _) => EventsDetail.fromJson(snapshot.data()!),
        toFirestore: (EventsDetail, _) => EventsDetail.toJson(),
      );

  var u;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    u = ref.read(userCrudProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "All Events",
          style: TextStyle(color: Colors.grey, fontSize: 24),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.grey,
            )),
      ),
      body: FirestoreListView<EventsDetail>(
        //pageSize: 3,
        query: queryEvent,
        itemBuilder: (context, snapshot) {
          final post = snapshot.data();
          var status = "Ongoing Registration";
          final date = DateTime.parse(post.eventDate);
          print("participant entry");
          print("participants are ${ref.read(userCrudProvider).user['deptname']}");
          print("participant exit ${post.deptLevel.substring(14,post.deptLevel.length)}");

          var time = int.parse(post.eventStartTime.substring(10, 12)) +
              int.parse(post.eventDuration.split(" ")[0]) +
              3;
          var currentTime =
              int.parse(TimeOfDay.now().toString().substring(10, 12));

          if (date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              DateTime.now().day >= date.day) {
            status = "Registration closed";
          }

          if (date.year <= DateTime.now().year &&
              date.month <= DateTime.now().month &&
              ((DateTime.now().day == date.day && currentTime >= time) ||
                  DateTime.now().day > date.day)) {
            EventFinishing().eventStarted(post);
          }

          var participated = false;

          for (int i = 0; i < post.participants.length; i++) {
            if (post.participants[i]['userId'] ==
                FirebaseAuth.instance.currentUser?.uid) {
              participated = true;
            }
          }

          if(post.deptLevel.substring(0,14) == "Dept.intradept"){
            if(!(ref.read(userCrudProvider).user['deptname'].toString().trim() == post.deptLevel.substring(14,post.deptLevel.length).trim())){
              print("deptlevel ka lafda");
              return SizedBox(height:0);
            }
          }

          if(!(post.eventForSem.toString().split(" ").contains(ref.read(userCrudProvider).user['semester']))){
            print("sem ka lafda");
            return SizedBox(height:0);
          }



          return GestureDetector(
            onTap: () {
              if (status == "Registration closed") {
                return;
              }
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25))),
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
                                    fontSize: 38, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "About Event",
                                style: GoogleFonts.ubuntu(
                                    fontSize: 24, fontWeight: FontWeight.bold),
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
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Venue",
                                style: GoogleFonts.ubuntu(
                                    fontSize: 24, fontWeight: FontWeight.bold),
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
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Event Type",
                                style: GoogleFonts.ubuntu(
                                    fontSize: 24, fontWeight: FontWeight.bold),
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
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.date_range),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: ' ${date.day} ',
                                          style: GoogleFonts.abrilFatface(
                                            fontSize: 22,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ' ${monthName[date.month]}',
                                              style: GoogleFonts.zillaSlab(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.access_time),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '   ${post.eventStartTime.split('(')[1].substring(0, post.eventStartTime.split('(')[1].length - 1)}',
                                        style: GoogleFonts.abrilFatface(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
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
                        participated == true
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                        "Already  Participated",
                                        style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.green),
                                      ),

                                  ],
                                ),
                              ],
                            )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      //context.read(eventProvider)
                                      try {
                                        ParticipateEvents()
                                            .participate(post, u.user);
                                        Navigator.pop(context);
                                      } catch (e) {
                                        Navigator.pop(context);
                                        await showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Oops!'),
                                            content: const Text(
                                                'Something went wrong'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Okay'),
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                  //return;
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      }
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
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      post.eventName,
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(post.description),
                    //leading: Icon(Icons.event),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      status,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: CircularFabWidget(),
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => const CreateEventScreen(),
      //   ),
      // );
    );
  }
}
