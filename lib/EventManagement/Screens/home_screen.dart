import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';
import 'package:uni_campus/SeatingManagement/Screens/exam_screen.dart';
import 'package:uni_campus/SeatingManagement/Screens/upload_exam_details.dart';
import 'package:uni_campus/approve_event.dart';
import 'package:uni_campus/user_crud.dart';
import '../../event_screen.dart';
import '../../main.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var isloading = true;

  fetchTask() async {
    await ref.read(userCrudProvider).fetchUserProfile();
    isloading = false;
  }

  @override
  void initState() {
    super.initState();
    fetchTask();
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(userCrudProvider);
    var u = data.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("UniCampus"),
        //leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
      ),
      body: isloading
          ? const CircularProgressIndicator()
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
      drawer: isloading == false
          ? Drawer(
              child: Material(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const ProfileScreen(),
                                ),
                              );
                            },
                            focusColor: Colors.white,
                            child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.pinkAccent,
                                      Colors.redAccent,
                                      Colors.orangeAccent,
                                    ],
                                  ),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 25),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        u['profilePicture'] == null ||
                                                u['profilePicture'] == ""
                                            ? u['userName'] != null
                                                ? ClipOval(
                                                    child: Material(
                                                      elevation: 5.0,
                                                      shape:
                                                          const CircleBorder(),
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              65,
                                                              198,
                                                              255),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(45.0),
                                                        child: Text(
                                                          u['userName'][0],
                                                          style: GoogleFonts
                                                              .ubuntu(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 35,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const CircularProgressIndicator()
                                            : buildImage(u['profilePicture']),
                                        Column(
                                          children: [
                                            Text(
                                              u['userName'],
                                              style: GoogleFonts.ubuntu(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "${currentUser?.email}",
                                              style: GoogleFonts.ubuntu(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        )
                                      ],
                                    ))),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const ProfileScreen(),
                                  ),
                                );
                              },
                              child: buildItem(
                                  "My Profile", Icons.person_outline_outlined)),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const ApproveEvent(),
                                  ),
                                );
                              },
                              child: buildItem("Approve Events",
                                  Icons.event_available_sharp)),
                          // GestureDetector(
                          //   onTap: (() {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => const OnBoarding()));
                          //   }),
                          //   child: const Text("Onboarding"),
                          // ),
                          InkWell(
                            child: buildItem("Logout", Icons.logout_outlined),
                            onTap: () {
                              FirebaseAuth.instance.signOut();
                            },
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Column(
                        children: <Widget>[
                          const Divider(
                            thickness: 1.5,
                            color: Color.fromARGB(255, 104, 100, 100),
                          ),
                          InkWell(
                            onTap: () {
                            },
                            child: buildItem(
                              "Settings",
                              Icons.settings_outlined,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                            },
                            child: buildItem(
                              "Feedback",
                              Icons.feedback_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const CircularProgressIndicator(),
    );
  }

  Widget buildItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.ubuntu(fontSize: 17),
        ),
        leading: Icon(
          icon,
          size: 25,
          color: Colors.black,
        ),
      ),
    );
  }
}

buildImage(var img) {
  return ClipOval(
    child: Material(
      elevation: 5.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: Ink.image(
        image: NetworkImage(img),
        fit: BoxFit.cover,
        width: 128,
        height: 128,
      ),
    ),
  );
}
