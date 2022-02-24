import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/EventModels/all_events.dart';

import 'EventModels/event_details.dart';
import 'Participants.dart';
import 'Profile/Screens/profile_screen.dart';

class MyEvent extends StatefulHookConsumerWidget {
  const MyEvent({Key? key}) : super(key: key);

  @override
  _MyEventState createState() => _MyEventState();
}

class _MyEventState extends ConsumerState<MyEvent> {
  final queryEvent = FirebaseFirestore.instance
      .collection('ApprovedEvent')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("MyApprovedEvents")
      .withConverter(
    fromFirestore: (snapshot, _) => EventsDetail.fromJson(snapshot.data()!),
    toFirestore: (EventsDetail, _) => EventsDetail.toJson(),
  );

  var u;

  show() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Status'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Was event successfully finished'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('completed'),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            ),
            TextButton(
              child: const Text('Cancelled'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

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
            " My Events",
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
              final date = DateTime.parse(post.eventDate);
              print("participant entry");
              print("participants are ${post.eventStatus.runtimeType} ");
              print("participant exit");
              var time = int.parse(post.eventStartTime.substring(10, 12)) +
                  int.parse(post.eventDuration.split(" ")[0]) +
                  3;
              var currentTime =
              int.parse(TimeOfDay.now().toString().substring(10, 12));
              bool confirm = false;
              String status;

             if(!(post.eventStatus=="completed" || post.eventStatus=="cancelled")){
               print(post.eventName);
               if (date.year >= DateTime
                   .now()
                   .year &&
                   date.month >= DateTime
                       .now()
                       .month &&
                   DateTime
                       .now()
                       .day > date.day) {
                 //show();
                 confirm = true;
               }
             }

              return Container(
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

                    post.eventStatus == "completed" ||
                        post.eventStatus == "cancelled" ?
                    Text(
                      post.eventStatus,
                      style: const TextStyle(fontSize: 24),
                    ):SizedBox(height: 0,),

                    post.eventStatus == "completed" ||
                        post.eventStatus == "cancelled" ? Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ):SizedBox(height: 0,),




                    confirm == true
                        ? InkWell(
                      onTap: () async {
                        await showDialog<void>(
                          context: context,
                          barrierDismissible:
                          false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Status'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const <Widget>[
                                    Text(
                                        'Was event successfully finished'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('completed'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    try {
                                      await EventFinishing().confirmEvent(
                                          post, "completed");
                                      setState(() {
                                        confirm == false;
                                      });
                                    } catch (e) {
                                      await showDialog(
                                        context: context,
                                        builder: (ctx) =>
                                            AlertDialog(
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
                                ),
                                TextButton(
                                  child: const Text('Cancelled'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    try {
                                      await EventFinishing().confirmEvent(
                                          post, "cancelled");
                                      setState(() {
                                        confirm == false;
                                      });
                                    } catch (e) {
                                      await showDialog(
                                        context: context,
                                        builder: (ctx) =>
                                            AlertDialog(
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

                                    //setState(() {});
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "!Confirm",
                        style: const TextStyle(fontSize: 24),
                      ),
                    )
                        : SizedBox(
                      height: 0,
                    ),
                    confirm == true
                        ? Divider(
                      thickness: 1,
                      color: Colors.grey,
                    )
                        : SizedBox(
                      height: 0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Participants(post.participants),
                          ),
                        );
                      },
                      child: Text(
                        "Participants",
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
