import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_campus/EventModels/all_events.dart';
import 'EventModels/event_details.dart';

class ApproveEvent extends StatefulWidget {
  const ApproveEvent({Key? key}) : super(key: key);

  @override
  _ApproveEventState createState() => _ApproveEventState();
}

class _ApproveEventState extends State<ApproveEvent> {


  final queryEvent = FirebaseFirestore.instance
      .collection('RequestEvent')
      .withConverter(
        fromFirestore: (snapshot, _) => EventsDetail.fromJson(snapshot.data()!),
        toFirestore: (EventsDetail, _) => EventsDetail!.toJson(),
      );

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FirestoreListView<EventsDetail>(
        pageSize: 3,
        query: queryEvent,
        itemBuilder: (context, snapshot) {
          final post = snapshot.data();
          final date = DateTime.parse(post.eventDate);
          //final time = TimeOfDay
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25))
                ),
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                post.eventName,
                                style: GoogleFonts.ubuntu(fontSize: 38,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0,),
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
                                    style: GoogleFonts.ubuntu(fontSize: 18,color: Colors.grey),
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
                                style: GoogleFonts.ubuntu(fontSize: 18, color: Colors.grey),
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
                              Text("${post.deptLevel.split('.')[1]}",
                                style: GoogleFonts.ubuntu(fontSize: 18, color: Colors.grey),
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
                                  Icon(Icons.date_range),
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
                                          children:  <TextSpan>[
                                            TextSpan(text: ' ${monthName[date.month]}',
                                              style: GoogleFonts.zillaSlab(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,

                                              ),),
                                            //TextSpan(text: ' world!'),
                                          ],
                                        ),
                                      ),
                                      Text("${weekDayName[date.weekday]}",
                                        style: GoogleFonts.zillaSlab(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey
                                        ),
                                      )
                                    ],
                                  ),

                                    ],

                                  ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.access_time),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      Text('   ${post.eventStartTime.split('(')[1].
                                      substring(0,post.eventStartTime.split('(')[1].length-1)}',
                                        style: GoogleFonts.abrilFatface(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),

                                      Text("${post.eventDuration}",
                                        style: GoogleFonts.zillaSlab(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey
                                        ),
                                      )
                                ],
                                )
                                ],
                              )
                            ],
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                //context.read(eventProvider)
                                Navigator.pop((context));
                                await FinalizeEvent().approveEvent(post);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(15),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  // image: const DecorationImage(
                                  //   image: AssetImage("assets/images/Card.png"),
                                  //   fit: BoxFit.cover,
                                  // ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Colors.blue,
                                      Colors.cyan,
                                    ],
                                  ),

                                  // border: Border.all(width: 5.0, color: Colors.grey),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "Approve",
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                await FinalizeEvent().rejectEvent(post);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(15),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  // image: const DecorationImage(
                                  //   image: AssetImage("assets/images/Card.png"),
                                  //   fit: BoxFit.cover,
                                  // ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Colors.blue,
                                      Colors.cyan,
                                    ],
                                  ),

                                  // border: Border.all(width: 5.0, color: Colors.grey),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "Reject",
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
            child: ListTile(

              title: Text(post.eventName),
              subtitle: Text(post.description),
            ),
          );
        },
      ),
    );
  }
}
