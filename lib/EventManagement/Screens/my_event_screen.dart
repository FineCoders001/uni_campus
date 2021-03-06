import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:uni_campus/EventManagement/Models/all_events.dart';
import 'package:uni_campus/EventManagement/Models/event_details.dart';
import 'package:uni_campus/EventManagement/Screens/participants_screen.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';
import 'package:uni_campus/Widgets/dialog_box.dart';

class MyEventScreen extends StatefulHookConsumerWidget {
  const MyEventScreen({Key? key}) : super(key: key);

  @override
  _MyEventScreenState createState() => _MyEventScreenState();
}

class _MyEventScreenState extends ConsumerState<MyEventScreen> {
  bool hasInternet = true;

  final queryEvent = FirebaseFirestore.instance
      .collection('ApprovedEvent')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("MyApprovedEvents")
      .withConverter(
        fromFirestore: (snapshot, _) => EventsDetail.fromJson(snapshot.data()!),
        toFirestore: (eventsDetail, _) => eventsDetail.toJson(),
      );

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      setState(() {
        hasInternet = true;
      });
      print('YAY! Free cute dog pics!');
    } else {
      setState(() {
        hasInternet = false;
      });
      print('No internet :( Reason:');
    }
  }

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
    InternetConnectionChecker().onStatusChange.listen((status) {
      print("status is $status");
      setState(() {
        switch (status) {
          case InternetConnectionStatus.connected:
            print('Data connection is available.');
            hasInternet = true;
            break;
          case InternetConnectionStatus.disconnected:
            print('You are disconnected from the internet.');
            hasInternet = false;
            break;
        }
        // hasInternet = status as bool;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "My Events",
            style: TextStyle(fontSize: 23),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 25,
              )),
        ),
        body: hasInternet
            ? FirestoreListView<EventsDetail>(
                //pageSize: 3,
                query: queryEvent,
                itemBuilder: (context, snapshot) {
                  final post = snapshot.data();
                  final date = DateTime.parse(post.eventDate);
                  bool confirm = false;
                  print("participant entry");
                  print("participants are ${post.eventStatus.runtimeType} ");
                  print("participant exit");

                  // var time = int.parse(post.eventStartTime.substring(10, 12)) +
                  //     int.parse(post.eventDuration.split(" ")[0]) +
                  //     3;
                  // var currentTime =
                  //     int.parse(TimeOfDay.now().toString().substring(10, 12));
                  // String status;

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
                        GestureDetector(
                          onTap: () {
                            ShowDialog().showBottomSheet(context, post, date);
                          },
                          child: ListTile(
                            leading: post.eventStatus == "completed" ||
                                    post.eventStatus == "cancelled"
                                ? post.eventStatus == "completed"
                                    ? const Tooltip(
                                        message: "Event successful",
                                        child: CircleAvatar(
                                            backgroundColor: Colors.green,
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )),
                                      )
                                    : const Tooltip(
                                        message: "Event cancelled",
                                        child: CircleAvatar(
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              Icons.cancel_rounded,
                                              color: Colors.white,
                                            )),
                                      )
                                : confirm
                                    ? const Tooltip(
                                        message: "Event confirmation pending",
                                        child: CircleAvatar(
                                            backgroundColor: Colors.cyan,
                                            child: Text(
                                              "!",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      )
                                    : const Tooltip(
                                        message: "Event pending",
                                        child: CircleAvatar(
                                            backgroundColor:
                                                Colors.orangeAccent,
                                            child: Icon(
                                              Icons.pending_actions,
                                              color: Colors.white,
                                            )),
                                      ),
                            title: Text(
                              post.eventName,
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Text(post.description),
                            //leading: Icon(Icons.event),
                          ),
                        ),
                        const Divider(
                          thickness: 5,
                          color: Colors.black12,
                        ),
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
                                                await EventFinishing()
                                                    .confirmEvent(
                                                        post, "completed");
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
                                                        child:
                                                            const Text('Okay'),
                                                        onPressed: () {
                                                          Navigator.of(ctx)
                                                              .pop();
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
                                                    .confirmEvent(
                                                        post, "cancelled");
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
                                                        child:
                                                            const Text('Okay'),
                                                        onPressed: () {
                                                          Navigator.of(ctx)
                                                              .pop();
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
                                  "Confirm",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.green),
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
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Center(child: Lottie.asset("assets/noInternetConnection.json")));
  }
}
