import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/LibraryManagement/library_crud.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';
import 'package:uni_campus/Users/user_crud.dart';

class ApproveBookRequestAdminScreen extends StatefulHookConsumerWidget {
  const ApproveBookRequestAdminScreen({Key? key}) : super(key: key);

  @override
  _ApproveBookRequestAdminScreenState createState() =>
      _ApproveBookRequestAdminScreenState();
}

class _ApproveBookRequestAdminScreenState
    extends ConsumerState<ApproveBookRequestAdminScreen> {
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
      .collection("PendingRequest")
      .withConverter(
        fromFirestore: (snapshot, _) =>
            RequestedDetails.fromJson(snapshot.data()!),
        toFirestore: (requestedDetails, _) => requestedDetails.toJson(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  if (isLoading == false) {
                    return SizedBox(
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
                                child: FutureBuilder<List<dynamic>>(
                                  initialData: const ["",""],
                                    future: getBookDetails(post.bookId[index].keys
                                                .elementAt(0)),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<dynamic>> text) {
                                          
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
                            Expanded(
                              child: SizedBox(
                                height: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FutureBuilder<List<dynamic>>(
                                        future:
                                            getBookDetails(post.bookId[index].keys
                                                .elementAt(0)),
                                        initialData: const [" ", " "],
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<dynamic>> text) {
                                          return Text(text.data![0],
                                              style: GoogleFonts.ubuntu(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold));
                                        }),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: (() async {
                                            await EditRequestAdmin()
                                                .rejectRequest(
                                                    post.enroll,
                                                    {
                                                      "bookId": post.bookId,
                                                      "deptName": post.deptName,
                                                      "enroll": post.enroll,
                                                      "semester": post.semester,
                                                      "userName": post.userName,
                                                      "contact":post.contact
                                                    },
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
                                                            'Book Rejected',
                                                            textAlign: TextAlign
                                                                .center),
                                                      ),
                                                    ),
                                                  },
                                                );
                                          }),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius: BorderRadius.all(
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
                                            await EditRequestAdmin()
                                                .approveRequest(
                                                    post.enroll,
                                                    {
                                                      "bookId": post.bookId,
                                                      "deptName": post.deptName,
                                                      "enroll": post.enroll,
                                                      "semester": post.semester,
                                                      "userName": post.userName,
                                                      "contact":post.contact
                                                    },
                                                    post.bookId[index].keys
                                                .elementAt(0))
                                                .then((value) => {
                                                      ScaffoldMessenger.of(
                                                              _scaffoldKey
                                                                  .currentState!
                                                                  .context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          duration: Duration(
                                                              seconds: 1),
                                                          content: Text(
                                                              'Book Approved',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        ),
                                                      )
                                                    });
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.all(
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
                    );
                  } else {
                    return const ListTile(title: Text("Loading"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> getBookDetails(String bookId) async {
    var snapshot = await allBooksReference.doc(bookId).get();
    var data = snapshot.data() as Map<String, dynamic>;
    return [data['bookName'], data['bookPic'][0]];
  }
}

class RequestedDetails {
  final List<dynamic> bookId;
  final String deptName;
  final String enroll;
  final String semester;
  final String userName;
  final String contact;

  const RequestedDetails(
      {required this.bookId,
      required this.deptName,
      required this.enroll,
      required this.semester,
      required this.userName,
      required this.contact});

  factory RequestedDetails.fromJson(Map<String, dynamic> json) =>
      RequestedDetails(
        bookId: json['bookId'],
        deptName: json['deptName'],
        enroll: json['enroll'],
        semester: json['semester'],
        userName: json['userName'],
        contact: json['contact'],
      );

  Map<String, Object?> toJson() => {
        'bookId': bookId,
        'deptName': deptName,
        'enroll': enroll,
        'semester': semester,
        'userName': userName,
        'contact': contact,
      };
}
