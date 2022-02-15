import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 71, 123, 114),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 15),
              child: Text(
                "My Profile",
                style: GoogleFonts.ubuntu(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Positioned(
            child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 205, 240, 240),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          elevation: 5.0,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          color: Colors.transparent,
                          child: Image.asset(
                            "assets/images/Login.png",
                            height: MediaQuery.of(context).size.height / 6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "User Name",
                            style: GoogleFonts.ubuntu(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "Email",
                          style: GoogleFonts.ubuntu(
                              fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                    // )
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: Card(
                              elevation: 7,
                              color: const Color.fromARGB(255, 71, 123, 114),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "University",
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 13, color: Colors.white),
                                    ),
                                    Text(
                                      "University",
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 7,
                            child: Container(
                              decoration: const BoxDecoration(
                                //borderRadius: BorderRadius.circular(8),
                                color: Color.fromARGB(255, 247, 186, 52),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Enrollment no.",
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 13, color: Colors.white),
                                    ),
                                    Text(
                                      "1236548921",
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              width: MediaQuery.of(context).size.width * 0.42,
                            ),
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    )
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.85),
            bottom: 0,
            left: 0,
            right: 0,
          ),
          Positioned(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              height: MediaQuery.of(context).size.height * 0.4456,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: Container(
                      color: Colors.white,
                      child: const ListTile(
                        leading: Icon(
                          Icons.school_outlined,
                          size: 40,
                        ),
                        subtitle: Text(
                          "Enrollment",
                          style: TextStyle(fontSize: 18),
                        ),
                        title: Text(
                          "180310116019",
                          style: TextStyle(fontSize: 20),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: Container(
                      color: Colors.white,
                      child: const ListTile(
                        leading: Icon(Icons.school_outlined),
                        subtitle:
                            Text("2018 - 2022", style: TextStyle(fontSize: 18)),
                        title:
                            Text("LEC Morbi", style: TextStyle(fontSize: 20)),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: Container(
                      color: Colors.white,
                      child: const ListTile(
                        leading: Icon(Icons.school_outlined),
                        subtitle:
                            Text("Department", style: TextStyle(fontSize: 18)),
                        title: Text("Information Technology",
                            style: TextStyle(fontSize: 20)),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: Container(
                      color: Colors.white,
                      child: const ListTile(
                        leading: Icon(Icons.school_outlined),
                        subtitle:
                            Text("Semester", style: TextStyle(fontSize: 18)),
                        title: Text("VIII", style: TextStyle(fontSize: 20)),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            bottom: 0,
            left: 0,
            right: 0,
          )
        ],
      ),
    );
  }
}
