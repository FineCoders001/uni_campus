import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'create_event_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> documentList = [];
    Future fetchFirstList() async {
      try {
        documentList = (await FirebaseFirestore.instance
                .collection("RequestEvent")
                .limit(5)
                .get())
            .docs;
      } catch (e) {
        print("kuch nahi mila");
      }
    }

    fetchNextMovies() async {
      try {
        print("document ki length ${documentList.length}");
        List<DocumentSnapshot> newDocumentList = (await FirebaseFirestore
                .instance
                .collection("RequestEvent")
                .startAfterDocument(documentList[documentList.length - 1])
                .limit(5)
                .get())
            .docs;
        documentList.addAll(newDocumentList);
        print("document ki length ${documentList.length}");
      } catch (e) {
        print("Firse kuch nahi mila ${e}");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Unicampus"),
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
    );
  }
}

