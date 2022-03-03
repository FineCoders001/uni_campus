import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/EventManagement/Models/all_events.dart';
import 'package:uni_campus/EventManagement/Models/event_details.dart';
import 'package:uni_campus/EventManagement/Screens/participants_screen.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';

class MyEventScreen extends StatefulHookConsumerWidget {
  const MyEventScreen({Key? key}) : super(key: key);

  @override
  _MyEventScreenState createState() => _MyEventScreenState();
}

class _MyEventScreenState extends ConsumerState<MyEventScreen> {
  final queryEvent = FirebaseFirestore.instance
      .collection('ApprovedEvent')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("MyApprovedEvents")
      .withConverter(
        fromFirestore: (snapshot, _) => EventsDetail.fromJson(snapshot.data()!),
        toFirestore: (eventsDetail, _) => eventsDetail.toJson(),
      );

  dynamic u;

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
        title: const Text(
          " My Events",
          style: TextStyle(color: Colors.black, fontSize: 24),
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
          int currentTime =
              int.parse(TimeOfDay.now().toString().substring(10, 12));
          bool confirm = false;
          String status;

          if (!(post.eventStatus == "completed" ||
              post.eventStatus == "cancelled")) {
            print(post.eventName);
            if (date.year >= DateTime.now().year &&
                date.month >= DateTime.now().month &&
                DateTime.now().day > date.day) {
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
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                post.eventStatus == "completed" ||
                        post.eventStatus == "cancelled"
                    ? Text(
                        post.eventStatus,
                        style: const TextStyle(fontSize: 24),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                post.eventStatus == "completed" ||
                        post.eventStatus == "cancelled"
                    ? const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                confirm == true
                    ? InkWell(
                        onTap: () async {
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
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      try {
                                        await EventFinishing()
                                            .confirmEvent(post, "completed");
                                        setState(() {
                                          confirm == false;
                                        });
                                      } catch (e) {
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
                                  ),
                                  TextButton(
                                    child: const Text('Cancelled'),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      try {
                                        await EventFinishing()
                                            .confirmEvent(post, "cancelled");
                                        setState(() {
                                          confirm == false;
                                        });
                                      } catch (e) {
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

                                      //setState(() {});
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          "!Confirm",
                          style: TextStyle(fontSize: 24),
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                confirm == true
                    ? const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ParticipantsScreen(post.participants),
                      ),
                    );
                  },
                  child: const Text(
                    "Participants",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
