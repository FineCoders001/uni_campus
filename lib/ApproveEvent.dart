import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'EventModels/event_details.dart';

class ApproveEvent extends StatefulWidget {
  const ApproveEvent({Key? key}) : super(key: key);

  @override
  _ApproveEventState createState() => _ApproveEventState();
}

class _ApproveEventState extends State<ApproveEvent> {
  final queryEvent = FirebaseFirestore.instance.collection('RequestEvent').withConverter (
  fromFirestore: (snapshot, _) => EventsDetail.fromJson(snapshot.data()!),
  toFirestore: (EventsDetail, _) => EventsDetail.toJson(),
  );
  @override
   build(BuildContext context)  {


    return Scaffold(
      appBar: AppBar(

      ),

      body: FirestoreListView<EventsDetail>(
        pageSize:3,

        query: queryEvent,

        itemBuilder: (context,snapshot){

          final post = snapshot.data();

          return GestureDetector(
            onTap: (){
              showModalBottomSheet(
                  context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.only(left: 5),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text("${post.eventName}",
                                 style:GoogleFonts.ubuntu(
                                   fontSize: 28
                                 ),
                                ),
                              ),
                            ],
                          ),


                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("About Event",
                                  style:GoogleFonts.ubuntu(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text("${post.description}",
                                  style:GoogleFonts.ubuntu(
                                      fontSize: 18
                                  ),
                                ),

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Venue",
                                  style:GoogleFonts.ubuntu(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text("${post.venue}",
                                  style:GoogleFonts.ubuntu(
                                      fontSize: 18
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                Text("",
                                  style:GoogleFonts.ubuntu(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text("${post.venue}",
                                  style:GoogleFonts.ubuntu(
                                      fontSize: 18
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                  );
                },

              );
            },
            child: ListTile(

              title:Text("${post.eventName}"),
              subtitle: Text("${post.description}"),

            ),
          );

        },
      ),
      );

  }
}
