import 'package:flutter/material.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';
import 'package:uni_campus/approve_event.dart';

import 'create_event_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // List<DocumentSnapshot> documentList = [];
    //
    // // testing upcoming items in list
    //
    // // ignore: unused_element
    // Future fetchFirstList() async {
    //   try {
    //     documentList = (await FirebaseFirestore.instance
    //             .collection("RequestEvent")
    //             .limit(5)
    //             .get())
    //         .docs;
    //   } catch (e) {
    //     return 0;
    //   }
    // }
    // // ignore: unused_element
    // fetchNextMovies() async {
    //   try {
    //     List<DocumentSnapshot> newDocumentList = (await FirebaseFirestore
    //             .instance
    //             .collection("RequestEvent")
    //             .startAfterDocument(documentList[documentList.length - 1])
    //             .limit(5)
    //             .get())
    //         .docs;
    //     documentList.addAll(newDocumentList);
    //   } catch (e) {
    //     return 0;
    //   }
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text("UniCampus"),
        //leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const ApproveEvent(),
                  ),
                );
              },
              icon: const Icon(Icons.north_east_rounded))
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const CreateEventScreen(),
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
                            "Create",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            "Event",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => {},
                child: Padding(
                  padding: EdgeInsets.all(
                      (MediaQuery.of(context).size.width / 3) / 4),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 8,
                    color: Colors.blue,
                    child: const Center(
                      child: Text(
                        "Event",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                  child: Container(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          child: Text(
                            "K",
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "kartik",
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                              Text(
                                "kksingh@gmail.com",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.white,
              ),
              buildItem("Approve Events", Icons.event_available_sharp),
              buildItem("Logout", Icons.logout)
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
