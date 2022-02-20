import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/EventScreen.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';
import 'package:uni_campus/SeatingManagement/Screens/exam_screen.dart';
import 'package:uni_campus/SeatingManagement/Screens/upload_exam_details.dart';
import 'package:uni_campus/approve_event.dart';
import 'package:uni_campus/onboarding_screen.dart';
import 'package:uni_campus/userCrud.dart';
import '../../main.dart';
import 'create_event_screen.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var isloading = false;

  fetchTask() async {
    await ref.read(userCrudProvider).fetchUserProfile();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTask();
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(userCrudProvider);
    var u = data.user;
    var reference = FirebaseFirestore.instance
        .collection("RequestEvent")
        .doc("N0WrlsSimOQXTaDUU4J58WPiJT22")
        .get().then((value) => print("idhar: ${value.data()}"));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("UniCampus"),
        //leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
      ),
      body: isloading
          ? CircularProgressIndicator()
          : Column(
              children: [
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const EventScreen(),
                      ),
                    )
                  },
                  child: Padding(
                    padding: EdgeInsets.all(
                        (MediaQuery.of(context).size.width / 3) / 4),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 8,
                      color: Colors.blue,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Events",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const UploadExamDetails(),
                          ),
                        )
                      },
                      child: Padding(
                        padding: EdgeInsets.all(
                            (MediaQuery.of(context).size.width / 3) / 4),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.height / 8,
                          color: Colors.blue,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Upload",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                Text(
                                  "Exam Details",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {
                        UserCrud().fetchUserProfile(),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const ExamScreen(),
                          ),
                        )
                      },
                      child: Padding(
                        padding: EdgeInsets.all(
                            (MediaQuery.of(context).size.width / 3) / 4),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.height / 8,
                          color: Colors.blue,
                          child: const Center(
                            child: Text(
                              "Time Table",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
      drawer: Drawer(
        child: Material(
          color: Colors.blue,
          child: ListView(
            padding: const EdgeInsets.only(left: 8, right: 8),
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const ProfileScreen(),
                    ),
                  );
                },
                focusColor: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 20),
                    child: u['userName'] != null
                        ? Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                child: Text(
                                  u['userName'][0],
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      u['userName'],
                                      style: TextStyle(
                                          fontSize: 24, color: Colors.white),
                                    ),
                                    Text(
                                      "${currentUser?.email}",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        : CircularProgressIndicator()),
              ),
              const Divider(
                thickness: 1,
                color: Colors.white,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const ApproveEvent(),
                      ),
                    );
                  },
                  child:
                      buildItem("Approve Events", Icons.event_available_sharp)),
              GestureDetector(
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OnBoarding()));
                }),
                child: const Text("Onboarding"),
              ),
              // buildItem("Logout", Icons.logout),
              ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(String title, IconData icon) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      leading: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}