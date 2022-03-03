import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IssuedBookScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const IssuedBookScreen({Key? key, required this.user}) : super(key: key);

  @override
  _IssuedBookScreenState createState() => _IssuedBookScreenState();
}

class _IssuedBookScreenState extends State<IssuedBookScreen> {
  int _pageIndex = 0;
  late List<Widget> tabPages;
  late PageController _pageController;
  @override
  void initState() {
    tabPages = [
      PendingRequestScreen(
        user: widget.user,
      ),
      ApprovedRequestScreen(
        user: widget.user,
      ),
    ];
    _pageController = PageController(initialPage: _pageIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Issued Book"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions_outlined),
            label: 'Requested',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_sharp),
            label: 'Approved',
          ),
        ],
        currentIndex: _pageIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.pinkAccent,
      ),
      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}

class PendingRequestScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const PendingRequestScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<PendingRequestScreen> createState() => _PendingRequestScreenState();
}

class _PendingRequestScreenState extends State<PendingRequestScreen> {
  DateTime current = DateTime.now();
  late Stream timer;
  late StreamSubscription cancel;
  late Map<String, dynamic> pendingData;
  bool isLoading = true;
  CollectionReference pendingReference = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("RequestedBooks")
      .collection("PendingRequest");
  late DocumentSnapshot pendingSnapshot;
  @override
  Future<void> didChangeDependencies() async {
    pendingSnapshot =
        await pendingReference.doc(widget.user['enroll']).get().then((value) {
      if (value.data() != null) {
        timer = Stream.periodic(const Duration(seconds: 1), (i) {
          if (mounted) {
            setState(() {
              current = current.subtract(const Duration(seconds: 1));
            });
          }
          return current;
        });

        cancel = timer.listen((data) {});
        pendingData = value.data() as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
      return value;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (pendingSnapshot.data() != null) {
      cancel.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading == true
          ? Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "No Requested Books",
                    style: GoogleFonts.ubuntu(fontSize: 25),
                  ),
                ),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: pendingData['bookId'].length,
                      itemBuilder: (context, index) {
                        return isLoading == false
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.94,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  color: Colors.white,
                                  elevation: 1,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SizedBox(
                                          height: 150,
                                          width: 100,
                                          child: Center(
                                            child: FutureBuilder<List<dynamic>>(
                                                initialData: const ["", ""],
                                                future: getBookDetails(
                                                    pendingData['bookId'][index]
                                                        .keys
                                                        .elementAt(0)),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<List<dynamic>>
                                                        text) {
                                                  if (text.data![1] != "") {
                                                    return CachedNetworkImage(
                                                      imageUrl: text.data![1],
                                                      fit: BoxFit.fill,
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                }),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 100,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              FutureBuilder<List<dynamic>>(
                                                future: getBookDetails(
                                                    pendingData['bookId'][index]
                                                        .keys
                                                        .elementAt(0)),
                                                initialData: const [" ", " "],
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<List<dynamic>>
                                                        text) {
                                                  return Text(text.data![0],
                                                      style: GoogleFonts.ubuntu(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold));
                                                },
                                              ),
                                              Text(
                                                "Time Left: ${DateTime.fromMillisecondsSinceEpoch(pendingData['bookId'][index][pendingData['bookId'][index].keys.elementAt(0)].seconds * 1000).add(const Duration(hours: 24)).difference(DateTime.now()).toString().split('.')[0]}",
                                                style: GoogleFonts.ubuntu(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const ListTile(title: Text("Loading"));
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<List<dynamic>> getBookDetails(String bookId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("Books")
        .collection("AllBooks")
        .doc(bookId)
        .get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return [data['bookName'], data['bookPic'][0]];
  }
}

class ApprovedRequestScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const ApprovedRequestScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ApprovedRequestScreen> createState() => _ApprovedRequestScreenState();
}

class _ApprovedRequestScreenState extends State<ApprovedRequestScreen> {
  DateTime current = DateTime.now();
  late Stream timer;
  late StreamSubscription cancel;
  late Map<String, dynamic> approvedData;
  bool isLoading = true;
  CollectionReference approvedReference = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("RequestedBooks")
      .collection("ApprovedRequest");
  late DocumentSnapshot approvedSnapshot;
  @override
  Future<void> didChangeDependencies() async {
    approvedSnapshot =
        await approvedReference.doc(widget.user['enroll']).get().then((value) {
      if (value.data() != null) {
        timer = Stream.periodic(const Duration(seconds: 1), (i) {
          if (mounted) {
            setState(() {
              current = current.subtract(const Duration(seconds: 1));
            });
          }

          return current;
        });
        cancel = timer.listen((data) {});
        approvedData = value.data() as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
      return value;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (approvedSnapshot.data() != null) {
      cancel.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading == true
          ? Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "No Approved Books",
                  style: GoogleFonts.ubuntu(fontSize: 25),
                ),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: approvedData['bookId'].length,
                      itemBuilder: (context, index) {
                        return isLoading == false
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.94,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  color: Colors.white,
                                  elevation: 1,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SizedBox(
                                          height: 150,
                                          width: 100,
                                          child: Center(
                                            child: FutureBuilder<List<dynamic>>(
                                                initialData: const ["", ""],
                                                future: getBookDetails(
                                                    approvedData['bookId']
                                                            [index]
                                                        .keys
                                                        .elementAt(0)),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<List<dynamic>>
                                                        text) {
                                                  if (text.data![1] != "") {
                                                    return CachedNetworkImage(
                                                      imageUrl: text.data![1],
                                                      fit: BoxFit.fill,
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                }),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 100,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              FutureBuilder<List<dynamic>>(
                                                future: getBookDetails(
                                                    approvedData['bookId']
                                                            [index]
                                                        .keys
                                                        .elementAt(0)),
                                                initialData: const [" ", " "],
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<List<dynamic>>
                                                        text) {
                                                  return Text(text.data![0],
                                                      style: GoogleFonts.ubuntu(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold));
                                                },
                                              ),
                                              Text(
                                                "Time Left: ${DateTime.fromMillisecondsSinceEpoch(approvedData['bookId'][index][approvedData['bookId'][index].keys.elementAt(0)].seconds * 1000).add(const Duration(days: 7)).difference(DateTime.now()).inDays} days ${DateTime.fromMillisecondsSinceEpoch(approvedData['bookId'][index][approvedData['bookId'][index].keys.elementAt(0)].seconds * 1000).add(const Duration(days: 7)).difference(DateTime.now()).inHours % 24} hours",
                                                style: GoogleFonts.ubuntu(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              (DateTime.fromMillisecondsSinceEpoch(approvedData[
                                                                          'bookId']
                                                                      [index][approvedData['bookId']
                                                                          [
                                                                          index]
                                                                      .keys
                                                                      .elementAt(
                                                                          0)]
                                                                  .seconds *
                                                              1000)
                                                          .add(const Duration(
                                                              days: 7))
                                                          .difference(
                                                              DateTime.now())
                                                          .inDays) <=
                                                      1
                                                  ? const Center(
                                                      child: Text("YES"))
                                                  : const Center(
                                                      child: Text("NO"))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const ListTile(title: Text("Loading"));
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<List<dynamic>> getBookDetails(String bookId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("Books")
        .collection("AllBooks")
        .doc(bookId)
        .get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return [data['bookName'], data['bookPic'][0]];
  }
}
