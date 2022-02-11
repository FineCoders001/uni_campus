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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unipus"),
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
