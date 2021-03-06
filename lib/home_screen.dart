import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:uni_campus/Attendance/Screens/display_curlist.dart';
import 'package:uni_campus/Attendance/Screens/generate_qr.dart';
import 'package:uni_campus/Attendance/Screens/select_attendance.dart';
import 'package:uni_campus/EventManagement/Screens/create_event_screen.dart';
import 'package:uni_campus/LibraryManagement/Screens/modify_book_screen.dart';
import 'package:uni_campus/LibraryManagement/Screens/issued_book_screen_admin.dart';
import 'package:uni_campus/LibraryManagement/Screens/issued_book_screen.dart';
import 'package:uni_campus/Profile/Screens/todo_list.dart';
import 'package:uni_campus/Provider/internet_provider.dart';
import 'package:uni_campus/SeatingManagement/Screens/syllabus_screen.dart';
import 'package:uni_campus/Users/Screens/onboarding_screen.dart';
import 'package:uni_campus/main.dart';
import 'package:uni_campus/LibraryManagement/Screens/approve_book_requests_screen_admin.dart';
import 'package:uni_campus/EventManagement/Screens/event_screen.dart';
import 'package:uni_campus/EventManagement/Screens/my_event_screen.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';
import 'package:uni_campus/SeatingManagement/Screens/exam_screen.dart';
import 'package:uni_campus/SeatingManagement/Screens/upload_exam_details.dart';
import 'package:uni_campus/EventManagement/Screens/approve_event_screen.dart';
import 'package:uni_campus/LibraryManagement/Screens/book_home_screen.dart';
import 'package:uni_campus/Users/user_crud.dart';
import 'package:uni_campus/Widgets/no_internet_screen.dart';
import 'package:uni_campus/notifications.dart';
import 'package:uni_campus/upload_users.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Stream stream;
  var isloading = true;

  // fetchTask() async {
  // }
  // @override
  // void initState() {
  //   super.initState();
  //   fetchTask();
  // }

  @override
  void didChangeDependencies() async {
    context.read<Internet>().checkInternet();
    super.didChangeDependencies();
    if (context.watch<Internet>().getInternet) {
      await ref.read(userCrudProvider).fetchUserProfile();
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(userCrudProvider);
    var user = data.user;
    int width(BuildContext context) =>
        MediaQuery.of(context).size.width.toInt();
    return context.watch<Internet>().getInternet == false
        ? const NoInternetScreen()
        : Scaffold(
            extendBody: true,
            appBar: AppBar(
              centerTitle: true,
              title: const Text("UniCampus"),
              //leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: width(context) < 700
                  ? homeScreenWidget(context, 1, user)
                  : width(context) < 1150
                      ? homeScreenWidget(context, 2, user)
                      : homeScreenWidget(context, 3, user),
            ),
            drawer: isloading == false
                ? Drawer(
                    child: Material(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
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
                                          vertical: 35),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          user['profilePicture'] == null ||
                                                  user['profilePicture'] == ""
                                              ? user['userName'] != null
                                                  ? ClipOval(
                                                      child: Material(
                                                        elevation: 5.0,
                                                        shape:
                                                            const CircleBorder(),
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 65, 198, 255),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(45.0),
                                                          child: Text(
                                                            user['userName'][0],
                                                            style: GoogleFonts.ubuntu(
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
                                              : buildImage(
                                                  user['profilePicture'], user),
                                          Column(
                                            children: [
                                              Text(
                                                user['userName'],
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
                                      ),
                                    ),
                                  ),
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
                                    child: buildItem("My Profile",
                                        Icons.person_outline_outlined)),
                                // InkWell(
                                //     onTap: () {
                                //       Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //           builder: (BuildContext context) =>
                                //               const ApproveEventScreen(),
                                //         ),
                                //       );
                                //     },
                                //     child: buildItem("Approve Events",
                                //         Icons.event_available_sharp)),

                                // InkWell(
                                //     onTap: () {
                                //       Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //           builder: (BuildContext context) =>
                                //               const CreateEventScreen(),
                                //         ),
                                //       );
                                //     },
                                //     child: buildItem(
                                //         "HomeScreen", Icons.event_available_sharp)),

                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const OnBoarding(),
                                        ),
                                      );
                                    },
                                    child: buildItem("OnBoarding",
                                        Icons.all_inclusive_rounded)),
                                //noti
                                InkWell(
                                    onTap: () {
                                      Notifications
                                          .callOnFcmApiSendPushNotifications(
                                              topic:
                                                  "DJfm5B0bYONbqvLUV6BPLoRtr2Z2",
                                              title: "Hello",
                                              body: "Your id is 180310116011");
                                    },
                                    child: buildItem("Notification",
                                        Icons.keyboard_arrow_left_sharp)),
                                //

                                //mul users
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const MulptipleUsers(),
                                        ),
                                      );
                                    },
                                    child: buildItem("users",
                                        Icons.keyboard_arrow_left_sharp)),

                                //
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const TodoList(),
                                        ),
                                      );
                                    },
                                    child: buildItem("To-Do List",
                                        Icons.checklist_rtl_outlined)),
                                // GestureDetector(
                                //   onTap: (() {
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) => const OnBoarding()));
                                //   }),
                                //   child: const Text("Onboarding"),
                                // ),
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
                                  child: buildItem(
                                      "Logout", Icons.logout_outlined),
                                  onTap: () async {
                                    await FirebaseAuth.instance.signOut();
                                  },
                                ),
                                InkWell(
                                  onTap: () {},
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
}

Widget homeScreenWidget(
  context,
  int number,
  user,
) {
  return user["role"] == "student"
      ? StaggeredGrid.count(
          // FOR STUDENTS
          // physics: const BouncingScrollPhysics(),
          // gridDelegate: null,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: number,
          children: <Widget>[
            bigCard(
                context, "Library Management", Icons.local_library_outlined, [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const BookHomeScreen(),
                    ),
                  );
                },
                child: containerForGridview(
                    "Issue Book", const Color.fromARGB(255, 82, 72, 200)),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          IssuedBookScreen(user: user),
                    ),
                  );
                },
                child: containerForGridview(
                    "My Issued Book", const Color.fromARGB(255, 82, 72, 200)),
              ),
            ]),
            bigCard(context, "Mark'd", Icons.perm_contact_cal_outlined, [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const GenerateQr(),
                    ),
                  );
                },
                child: containerForGridview(
                  "Generate QR Code",
                  const Color.fromARGB(255, 60, 138, 63),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (BuildContext context) => const Select(),
              //       ),
              //     );
              //   },
              //   child: containerForGridview(
              //     "Scan QR Code",
              //     const Color.fromARGB(255, 60, 138, 63),
              //   ),
              // ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const MyAttendance(),
                    ),
                  );
                },
                child: containerForGridview(
                  "My Attendance",
                  const Color.fromARGB(255, 60, 138, 63),
                ),
              ),
            ]),
            bigCard(context, "Event", Icons.event_outlined, [
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (BuildContext context) => const ApproveEventScreen(),
              //       ),
              //     );
              //   },
              //   child: containerForGridview(
              //     "Approve Events Admin",
              //     Colors.orange,
              //   ),
              // ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const CreateEventScreen(),
                    ),
                  );
                },
                child: containerForGridview(
                  "Request Events",
                  Colors.orange,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const EventScreen(),
                    ),
                  );
                },
                child: containerForGridview(
                  "All Events",
                  Colors.orange,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const MyEventScreen(),
                    ),
                  );
                },
                child: containerForGridview(
                  "My Events",
                  Colors.orange,
                ),
              ),
            ]),
            bigCard(
              context,
              "Exam Details",
              Icons.event_note_outlined,
              [
                //Widget for Exam Time Table
                InkWell(
                  onTap: (() => {
                        UserCrud().fetchUserProfile(),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const ExamScreen(),
                          ),
                        ),
                      }),
                  child: containerForGridview(
                    "Exam Time Table",
                    Colors.blueAccent,
                  ),
                ),
                InkWell(
                  onTap: (() => {
                        UserCrud().fetchUserProfile(),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const SyllabusScreen(),
                          ),
                        ),
                      }),
                  child: containerForGridview(
                    "Syllabus",
                    Colors.blueAccent,
                  ),
                ),
                //Widget for Upload Exam Details
                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (BuildContext context) => const UploadExamDetails(),
                //       ),
                //     );
                //   },
                //   child: containerForGridview(
                //     "Upload Exam Details",
                //     Colors.blueAccent,
                //   ),
                // ),
              ],
            ),
            // bigCard(
            //   context,
            //   "Library Management Admin",
            //   Icons.local_library_outlined,
            //   [
            //     InkWell(
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (BuildContext context) =>
            //                 const ApproveBookRequestAdminScreen(),
            //           ),
            //         );
            //       },
            //       child: containerForGridview(
            //           "Approve Book", const Color.fromARGB(255, 82, 72, 200)),
            //     ),
            //     InkWell(
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (BuildContext context) =>
            //                 const IssuedBookAdminScreen(),
            //           ),
            //         );
            //       },
            //       child: containerForGridview(
            //           "Issued Book", const Color.fromARGB(255, 82, 72, 200)),
            //     ),
            //     InkWell(
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (BuildContext context) => const ModifyBookScreen(),
            //           ),
            //         );
            //       },
            //       child: containerForGridview(
            //           "Modify Books", const Color.fromARGB(255, 82, 72, 200)),
            //     ),
            //   ],
            // ),
          ],
        )
      : StaggeredGrid.count(
          crossAxisSpacing: 5, //for faculties
          mainAxisSpacing: 5,
          crossAxisCount: number,
          children: [
            bigCard(
              context,
              "Library Management",
              Icons.local_library_outlined,
              [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const ApproveBookRequestAdminScreen(),
                      ),
                    );
                  },
                  child: containerForGridview(
                      "Approve Book", const Color.fromARGB(255, 82, 72, 200)),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const IssuedBookAdminScreen(),
                      ),
                    );
                  },
                  child: containerForGridview(
                      "Issued Book", const Color.fromARGB(255, 82, 72, 200)),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const ModifyBookScreen(),
                      ),
                    );
                  },
                  child: containerForGridview(
                      "Modify Books", const Color.fromARGB(255, 82, 72, 200)),
                ),
              ],
            ),
            bigCard(
              context,
              "Exam Details",
              Icons.event_note_outlined,
              [
                // Widget for Exam Time Table
                InkWell(
                  onTap: (() => {
                        UserCrud().fetchUserProfile(),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const ExamScreen(),
                          ),
                        ),
                      }),
                  child: containerForGridview(
                    "Exam Time Table",
                    Colors.blueAccent,
                  ),
                ),
                InkWell(
                  onTap: (() => {
                        UserCrud().fetchUserProfile(),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const SyllabusScreen(),
                          ),
                        ),
                      }),
                  child: containerForGridview(
                    "Syllabus",
                    Colors.blueAccent,
                  ),
                ),
                //Widget for Upload Exam Details
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const UploadExamDetails(),
                      ),
                    );
                  },
                  child: containerForGridview(
                    "Upload Exam Details",
                    Colors.blueAccent,
                  ),
                ),
              ],
            ),
            bigCard(context, "Event", Icons.event_outlined, [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const ApproveEventScreen(),
                    ),
                  );
                },
                child: containerForGridview(
                  "Approve Events",
                  Colors.orange,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const CreateEventScreen(),
                    ),
                  );
                },
                child: containerForGridview(
                  "Request Events",
                  Colors.orange,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const EventScreen(),
                    ),
                  );
                },
                child: containerForGridview(
                  "All Events",
                  Colors.orange,
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (BuildContext context) => const MyEventScreen(),
              //       ),
              //     );
              //   },
              //   child: containerForGridview(
              //     "My Events",
              //     Colors.orange,
              //   ),
              // ),
            ]),
            bigCard(
              context,
              "Mark'd",
              Icons.perm_contact_cal_outlined,
              [
                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (BuildContext context) => const GenerateQr(),
                //       ),
                //     );
                //   },
                //   child: containerForGridview(
                //     "Generate QR Code",
                //     const Color.fromARGB(255, 60, 138, 63),
                //   ),
                // ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Select(),
                      ),
                    );
                  },
                  child: containerForGridview(
                    "Scan QR Code",
                    const Color.fromARGB(255, 60, 138, 63),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const MyAttendance(),
                      ),
                    );
                  },
                  child: containerForGridview(
                    "Attendance",
                    const Color.fromARGB(255, 60, 138, 63),
                  ),
                ),
              ],
            ),
          ],
        );
}

Widget bigCard(context, String title, IconData icon, List<Widget> widget) {
  return Padding(
    padding: const EdgeInsets.all(25.0),
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 7.0)],
      ),
      //height: MediaQuery.of(context).size.height / 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(
                  icon,
                  size: 45,
                ),
                title: Text(
                  title,
                  style: GoogleFonts.ubuntu(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridView.builder(
              primary: false,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // mainAxisExtent: 3,
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
              ),
              itemCount: widget.length,
              itemBuilder: (BuildContext ctx, index) {
                return widget[index];
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget containerForGridview(String title, Color colors) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5.0)],
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        color: colors,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.ubuntu(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    ),
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

Widget buildImage(var img, u) {
  return ClipOval(
    child: Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.transparent,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        width: 128,
        height: 128,
        imageUrl: img,
        placeholder: (context, url) => ClipOval(
          child: Material(
            elevation: 5.0,
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            color: const Color.fromARGB(255, 65, 198, 255),
            child: Center(
              child: Text(
                u['userName'][0],
                style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
      // Ink.image(
      //   image: NetworkImage(img),
      //   fit: BoxFit.cover,
      //   width: 128,
      //   height: 128,
      // ),
    ),
  );
}
