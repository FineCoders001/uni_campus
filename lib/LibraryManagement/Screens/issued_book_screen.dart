import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uni_campus/LibraryManagement/library_crud.dart';
import 'package:uni_campus/Provider/internet_provider.dart';
import 'package:uni_campus/Widgets/no_internet_screen.dart';

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
  void didChangeDependencies() {
    EditRequest().deleteOldRequest();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _connectivity.disposeStream();
    EditRequest().deleteOldRequest();
    super.dispose();
  }

  @override
  void initState() {
    context.read<Internet>().checkInternet();
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
    return context.watch<Internet>().getInternet == false
        ? const NoInternetScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 82, 72, 200),
              centerTitle: true,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: pendingData['bookId'].length,
                    itemBuilder: (context, index) {
                      var time = DateTime.fromMillisecondsSinceEpoch(
                              pendingData['bookId'][index]
                                      .values
                                      .elementAt(0)
                                      .seconds *
                                  1000)
                          .add(const Duration(hours: 24))
                          .difference(DateTime.now());
                      if (time.inSeconds < 0) {
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          pendingData['bookId'].removeAt(index);
                        });
                      }
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            time.inSeconds > 0
                                                ? Text(
                                                    "Time Left: ${time.toString().split('.')[0]}",
                                                    style: GoogleFonts.ubuntu(
                                                      fontSize: 20,
                                                    ),
                                                  )
                                                : Text(
                                                    "Time Up",
                                                    style: GoogleFonts.ubuntu(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
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
  bool isReissued = false;
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
    return isLoading == true
        ? Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "No Approved Books",
                  style: GoogleFonts.ubuntu(fontSize: 25),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: approvedData['bookId'].length,
              itemBuilder: (context, index) {
                var status = approvedData['bookId'][index].values.elementAt(0);

                if (status != "Rejected") {
                  status = DateTime.fromMillisecondsSinceEpoch(
                          approvedData['bookId'][index]
                                  .values
                                  .elementAt(0)
                                  .seconds *
                              1000)
                      .add(const Duration(days: 7))
                      .difference(DateTime.now());
                }
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
                                            approvedData['bookId'][index]
                                                .keys
                                                .elementAt(0)),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<dynamic>> text) {
                                          if (text.data![1] != "") {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: CachedNetworkImage(
                                                imageUrl: text.data![1],
                                                fit: BoxFit.fill,
                                              ),
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
                                  height: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FutureBuilder<List<dynamic>>(
                                          future: getBookDetails(
                                              approvedData['bookId'][index]
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
                                        FutureBuilder<String>(
                                            initialData: "loading",
                                            future: reissueStatus(
                                                status,
                                                approvedData['bookId'][index]
                                                    .keys
                                                    .elementAt(0),
                                                widget.user['enroll']),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String> check) {
                                              if (check.data == "Rejected") {
                                                return Text(
                                                  "Reissue Rejected. Please return the book to the Library.",
                                                  style: GoogleFonts.ubuntu(
                                                    color: Colors.redAccent,
                                                    fontSize: 18,
                                                  ),
                                                );
                                              } else if (check.data ==
                                                  "Time Up") {
                                                return Text(
                                                  "Time up. Please return the book to the Library.",
                                                  style: GoogleFonts.ubuntu(
                                                    color: Colors.redAccent,
                                                    fontSize: 18,
                                                  ),
                                                );
                                              } else if (check.data ==
                                                  "Reissue") {
                                                return Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          "Time Left: \n${status.inDays} days ${status.inHours % 24} hours",
                                                          style: GoogleFonts
                                                              .ubuntu(
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          await EditRequest()
                                                              .reissueBook(
                                                                  approvedData[
                                                                              'bookId']
                                                                          [
                                                                          index]
                                                                      .keys
                                                                      .elementAt(
                                                                          0),
                                                                  widget.user);
                                                          setState(() {
                                                            isReissued = true;
                                                          });
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          decoration: const BoxDecoration(
                                                              color: Colors
                                                                  .blueAccent,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          4))),
                                                          child: Text(
                                                            "Reissue",
                                                            style: GoogleFonts
                                                                .ubuntu(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else if (check.data ==
                                                  "Reissued") {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Time Left: ${status.inDays} days ${status.inHours % 24} hours",
                                                      style: GoogleFonts.ubuntu(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        "Requested for Reissue",
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .green),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else if (check.data ==
                                                  "Not Yet") {
                                                return Text(
                                                  "Time Left: ${status.inDays} days ${status.inHours % 24} hours",
                                                  style: GoogleFonts.ubuntu(
                                                    fontSize: 20,
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            }),
                                      ],
                                    ),
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
          );
  }

  Future<String> reissueStatus(var time, String bookID, String enroll) async {
    bool status = await EditRequest().bookReissued(bookID, enroll);
    if (time == "Rejected") {
      return "Rejected";
    } else if ((time.inSeconds) <= 0) {
      return "Time Up";
    } else if ((time.inDays) <= 1 && status == false) {
      return "Reissue";
    } else if ((time.inDays) <= 1 && status == true) {
      return "Reissued";
    } else {
      return "Not Yet";
    }
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
