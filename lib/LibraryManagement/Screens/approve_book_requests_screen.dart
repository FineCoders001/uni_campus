import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/LibraryManagement/library_crud.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';
import 'package:uni_campus/user_crud.dart';

class ApproveBookRequestScreen extends StatefulHookConsumerWidget {
  const ApproveBookRequestScreen({Key? key}) : super(key: key);

  @override
  _ApproveBookRequestScreenState createState() =>
      _ApproveBookRequestScreenState();
}

class _ApproveBookRequestScreenState
    extends ConsumerState<ApproveBookRequestScreen> {
  fetchTask() async {
    await ref.read(userCrudProvider).fetchUserProfile();
  }

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
      .collection("PendingRequest")
      .withConverter(
        fromFirestore: (snapshot, _) =>
            RequestedDetails.fromJson(snapshot.data()!),
        toFirestore: (requestedDetails, _) => requestedDetails.toJson(),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Approve Request"),
        backgroundColor: const Color.fromARGB(255, 82, 72, 200),
        centerTitle: true,
      ),
      body: FirestoreListView<RequestedDetails>(
        query: queryDetails,
        pageSize: 5,
        itemBuilder: (context, snapshot) {
          final post = snapshot.data();
          return approveCard(post, context);
        },
      ),
    );
  }

  Widget approveCard(RequestedDetails post, BuildContext context) {
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
                              children: [const
                                Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Center(child: Text("Image"),),
                                    // child: CachedNetworkImage(
                                    //   imageUrl: Link,
                                    //   fit: BoxFit.fill,
                                    // ),
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
                                        Text(post.bookId[index],
                                            style: GoogleFonts.ubuntu(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              onTap: (() async {
                                                await EditRequest()
                                                    .deleteRequest(
                                                        post.bookId[index],
                                                        user);
                                                setState(() {
                                                  post.bookId.removeAt(index);
                                                });
                                              }),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                      5,
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Reject",
                                                    style: GoogleFonts.ubuntu(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                await EditRequest()
                                                    .approveRequest(
                                                        post.enroll,
                                                        {
                                                          "bookId": post.bookId,
                                                          "deptName":
                                                              post.deptName,
                                                          "enroll": post.enroll,
                                                          "semester":
                                                              post.semester,
                                                          "userName":
                                                              post.userName
                                                        },
                                                        post.bookId[index])
                                                    .then((value) => {
                                                          const SnackBar(
                                                            duration: Duration(
                                                                seconds: 1),
                                                            content: Text(
                                                                'Book Approved',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                          ),
                                                        });
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Approve",
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

  Future getBookDetails(String bookId) async {
    if (isLoading == true) {}
  }
}

class RequestedDetails {
  final List<dynamic> bookId;
  final String deptName;
  final String enroll;
  final String semester;
  final String userName;

  const RequestedDetails(
      {required this.bookId,
      required this.deptName,
      required this.enroll,
      required this.semester,
      required this.userName});

  factory RequestedDetails.fromJson(Map<String, dynamic> json) =>
      RequestedDetails(
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
