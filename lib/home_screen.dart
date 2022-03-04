import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/EventManagement/Screens/create_event_screen.dart';
import 'package:uni_campus/LibraryManagement/Screens/all_book_screen.dart';
import 'package:uni_campus/LibraryManagement/Screens/issued_book_screen_admin.dart';
import 'package:uni_campus/LibraryManagement/Screens/issued_book_screen.dart';
import 'package:uni_campus/LibraryManagement/library_crud.dart';
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
  void didChangeDependencies() async{
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    var data = ref.watch(userCrudProvider);
    var user = data.user;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("UniCampus"),
        //leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                bigCard(
                  context,
                  "Library Management Admin",
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
                      child: containerForGridview("Approve Book",
                          const Color.fromARGB(255, 82, 72, 200)),
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
                      child: containerForGridview("Issued Book",
                          const Color.fromARGB(255, 82, 72, 200)),
                    ),
                  ],
                ),
                bigCard(context, "Library Management",
                    Icons.local_library_outlined, [
                  
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const BookHomeScreen(),
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
                              IssuedBookScreen( user: user),
                        ),
                      );
                    },
                    child: containerForGridview(
                        "My Issued Book", const Color.fromARGB(255, 82, 72, 200)),
                  ),
                ]),
                bigCard(context, "Mark'd", Icons.perm_contact_cal_outlined, [
                  containerForGridview(
                    "Generate QR Code",
                    const Color.fromARGB(255, 60, 138, 63),
                  ),
                  containerForGridview(
                    "My Attendance",
                    const Color.fromARGB(255, 60, 138, 63),
                  ),
                ]),
                bigCard(context, "Event", Icons.event_outlined, [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const EventScreen(),
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
                          builder: (BuildContext context) =>
                              const MyEventScreen(),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 35),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    user['profilePicture'] == null ||
                                            user['profilePicture'] == ""
                                        ? user['userName'] != null
                                            ? ClipOval(
                                                child: Material(
                                                  elevation: 5.0,
                                                  shape: const CircleBorder(),
                                                  clipBehavior: Clip.hardEdge,
                                                  color: const Color.fromARGB(
                                                      255, 65, 198, 255),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            45.0),
                                                    child: Text(
                                                      user['userName'][0],
                                                      style: GoogleFonts.ubuntu(
                                                          color: Colors.white,
                                                          fontSize: 35,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const CircularProgressIndicator()
                                        : buildImage(user['profilePicture'], user),
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
                              child: buildItem(
                                  "My Profile", Icons.person_outline_outlined)),
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
                              child: buildItem("Approve Events",
                                  Icons.event_available_sharp)),

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
                              child: buildItem(
                                  "HomeScreen", Icons.event_available_sharp)),

                          InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const AllBookScreen(),
                                  ),
                                );
                              },
                              child: buildItem("AllbookScreen",
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
                            child: buildItem("Logout", Icons.logout_outlined),
                            onTap: () {
                              FirebaseAuth.instance.signOut();
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
