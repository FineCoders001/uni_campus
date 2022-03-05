import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/LibraryManagement/library_crud.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';
import 'package:uni_campus/Users/user_crud.dart';

class IssuedBookAdminScreen extends StatefulHookConsumerWidget {
  const IssuedBookAdminScreen({Key? key}) : super(key: key);

  @override
  _IssuedBookAdminScreenState createState() => _IssuedBookAdminScreenState();
}

class _IssuedBookAdminScreenState extends ConsumerState<IssuedBookAdminScreen> {
  fetchTask() async {
    await ref.read(userCrudProvider).fetchUserProfile();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> bookData = [];
  late UserCrud userCrud;
  late Map<String, dynamic> user;
  CollectionReference allBooksReference = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("Books")
      .collection("AllBooks");
  bool isLoading = false;
  @override
  void didChangeDependencies() {
    userCrud = ref.watch(userCrudProvider);
    user = userCrud.user;
    super.didChangeDependencies();
  }

  final queryDetails = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("RequestedBooks")
      .collection("ApprovedRequest")
      .withConverter(
        fromFirestore: (snapshot, _) =>
            IssuedDetails.fromJson(snapshot.data()!),
        toFirestore: (issuedDetails, _) => issuedDetails.toJson(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Issued Books"),
        backgroundColor: const Color.fromARGB(255, 82, 72, 200),
        centerTitle: true,
      ),
      body: FirestoreListView<IssuedDetails>(
        query: queryDetails,
        pageSize: 5,
        itemBuilder: (context, snapshot) {
          final post = snapshot.data();
          return approveCard(post, context);
        },
      ),
    );
  }

  Widget approveCard(IssuedDetails post, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person_outline,
                    size: 35,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: GoogleFonts.ubuntu(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Department: ${post.deptName}"),
                          Padding(
                            padding: const EdgeInsets.only(right: 25),
                            child: Text(post.enroll),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Divider(
                color: Colors.grey,
                thickness: 1.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: post.bookId.length,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Center(
                                      child: FutureBuilder<List<dynamic>>(
                                          initialData: const ["", ""],
                                          future: getBookDetails(post
                                              .bookId[index].keys
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
                                            future: getBookDetails(post
                                                .bookId[index].keys
                                                .elementAt(0)),
                                            initialData: const [" ", " "],
                                            builder: (BuildContext context,
                                                AsyncSnapshot<List<dynamic>>
                                                    text) {
                                              return Text(text.data![0],
                                                  style: GoogleFonts.ubuntu(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold));
                                            }),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // InkWell(
                                            //   onTap: (() async {
                                            //     await BookStatus()
                                            //         .bookCollected(
                                            //             post.enroll,
                                            //             post.bookId[index].keys
                                            //                 .elementAt(0))
                                            //         .then(
                                            //           (value) => {
                                            //             ScaffoldMessenger.of(
                                            //                     _scaffoldKey
                                            //                         .currentState!
                                            //                         .context)
                                            //                 .showSnackBar(
                                            //               const SnackBar(
                                            //                 duration: Duration(
                                            //                     seconds: 1),
                                            //                 content: Text(
                                            //                   'Book marked as collected',
                                            //                   textAlign:
                                            //                       TextAlign
                                            //                           .center,
                                            //                 ),
                                            //               ),
                                            //             ),
                                            //           },
                                            //         );
                                            //   }),
                                            //   child: Container(
                                            //     decoration: const BoxDecoration(
                                            //       color: Colors.blueAccent,
                                            //       borderRadius:
                                            //           BorderRadius.all(
                                            //         Radius.circular(
                                            //           5,
                                            //         ),
                                            //       ),
                                            //     ),
                                            //     child: Padding(
                                            //       padding:
                                            //           const EdgeInsets.all(8.0),
                                            //       child: Text(
                                            //         "Collected",
                                            //         style: GoogleFonts.ubuntu(
                                            //           fontSize: 20,
                                            //           color: Colors.white,
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),

                                            InkWell(
                                              onTap: () async {
                                                await BookStatus()
                                                    .bookReturned(
                                                        post.enroll,
                                                        post.bookId,
                                                        post.bookId[index].keys
                                                            .elementAt(0))
                                                    .then(
                                                      (value) => {
                                                        ScaffoldMessenger.of(
                                                                _scaffoldKey
                                                                    .currentState!
                                                                    .context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            duration: Duration(
                                                                seconds: 1),
                                                            content: Text(
                                                              'Book marked as returned',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      },
                                                    );
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.blueAccent,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Mark as returned",
                                                    style: GoogleFonts.ubuntu(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
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
      ),
    );
  }

  Future<List<dynamic>> getBookDetails(String bookId) async {
    DocumentSnapshot snapshot = await allBooksReference.doc(bookId).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return [data['bookName'], data['bookPic'][0]];
  }
}

class IssuedDetails {
  final List<dynamic> bookId;
  final String deptName;
  final String enroll;
  final String semester;
  final String userName;

  const IssuedDetails(
      {required this.bookId,
      required this.deptName,
      required this.enroll,
      required this.semester,
      required this.userName});

  factory IssuedDetails.fromJson(Map<String, dynamic> json) => IssuedDetails(
        bookId: json['bookId'],
        deptName: json['deptName'],
        enroll: json['enroll'],
        semester: json['semester'],
        userName: json['userName'],
      );

  Map<String, Object?> toJson() => {
        'bookId': bookId,
        'deptName': deptName,
        'enroll': enroll,
        'semester': semester,
        'userName': userName,
      };
}
