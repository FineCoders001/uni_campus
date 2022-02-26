import 'package:cached_network_image/cached_network_image.dart';
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

  late UserCrud userCrud;
  late Map<String, dynamic> user;
  CollectionReference allBooksReference = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("Books")
      .collection("AllBooks");
  List<Map<String, dynamic>> bookDetails = [];

  final queryDetails = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("RequestedBooks")
      .collection("PendingRequest")
      .withConverter(
        fromFirestore: (snapshot, _) =>
            RequestedDetails.fromJson(snapshot.data()!),
        toFirestore: (requestedDetails, _) => requestedDetails.toJson(),
      );

  bool isLoading = true;
  @override
  void didChangeDependencies() {
    userCrud = ref.watch(userCrudProvider);
    user = userCrud.user;
    super.didChangeDependencies();
  }

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
          return Column(
            children: [
              approveCard(post, context),
            ],
          );
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
                  getBookDetails(post.bookId[index]).then((value) {});
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
                                    child: CachedNetworkImage(
                                      imageUrl: bookDetails[index]['bookPic']
                                          [0],
                                      fit: BoxFit.fill,
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
                                        Text(bookDetails[index]["bookName"],
                                            style: GoogleFonts.ubuntu(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              onTap: (() async {
                                                print('index: $index');
                                                print(
                                                    'index: ${bookDetails[index]["bookName"]}');

                                                await EditRequest()
                                                    .deleteRequest(
                                                        bookDetails[index]
                                                            ["bookId"],
                                                        user);
                                                setState(() {
                                                  bookDetails;
                                                  print(
                                                      "Index: ${post.bookId.elementAt(index)}");
                                                  print(
                                                      "deleted: ${bookDetails[index]["bookId"]} ${bookDetails[index]["bookName"]} ${post.bookId} ");
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
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
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

  Future getBookDetails(String id) async {
    if (isLoading == true) {
      print("now set to false");
      print("Idhar firse $id");

      var data = await allBooksReference.doc(id).get();
      print("idhar:  ${data.data()}");
      setState(() {
        bookDetails.add(data.data() as Map<String, dynamic>);
        isLoading = false;
      });
    }
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
