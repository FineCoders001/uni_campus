import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        title: const Text("Unicampus"),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
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
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Demo"),
              accountEmail:
                  Text(FirebaseAuth.instance.currentUser!.email.toString()),
              currentAccountPicture: const CircleAvatar(child: Text("D")),
            ),
          ],
        ),
      ),
    );
  }
}
