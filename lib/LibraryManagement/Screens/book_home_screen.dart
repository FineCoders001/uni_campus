import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:uni_campus/LibraryManagement/Models/book_details.dart';
import 'package:uni_campus/LibraryManagement/Screens/book_details_screen.dart';

class BookHomeScreen extends StatefulWidget {
  const BookHomeScreen({Key? key}) : super(key: key);

  @override
  _BookHomeScreenState createState() => _BookHomeScreenState();
}

class _BookHomeScreenState extends State<BookHomeScreen> {
  ScrollController scroll = ScrollController();
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      setState(() {
        scroll;
      });
    });

    InternetConnectionChecker().onStatusChange.listen((status) {
      print("status is $status");
      setState(() {
        switch (status) {
          case InternetConnectionStatus.connected:
            print('Data connection is available.');
            hasInternet = true;
            break;
          case InternetConnectionStatus.disconnected:
            print('You are disconnected from the internet.');
            hasInternet = false;
            break;
        }
        // hasInternet = status as bool;
      });
    });
  }

  @override
  void dispose() {
    scroll.removeListener(() {});
    super.dispose();
  }

  final queryBook = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("Books")
      .collection('AllBooks')
      .withConverter(
        fromFirestore: (snapshot, _) => BookDetails.fromJson(snapshot.data()!),
        toFirestore: (bookDetails, _) => bookDetails.toJson(),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 82, 72, 200),
          title: const Text("Library"),
          centerTitle: true,
        ),
        body: hasInternet
            ? FirestoreQueryBuilder<BookDetails>(
                pageSize: 2,
                query: queryBook,
                builder: (context, snapshot, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Scrollbar(
                      child: GridView.builder(
                        controller: scroll,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 30,
                        ),
                        itemCount: snapshot.docs.length,
                        itemBuilder: (BuildContext ctx, index) {
                          {
                            // if we reached the end of the currently obtained items, we try to
                            // obtain more items
                            if (snapshot.hasMore &&
                                index + 1 == snapshot.docs.length &&
                                scroll.position.extentAfter < 1) {
                              snapshot.fetchMore();
                              print("here: ${snapshot.docs.length}");
                            }
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    BookDetailsScreen.routename,
                                    arguments: {'book': snapshot.docs[index]});
                              },
                              child: GridTile(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color.fromARGB(255, 82, 72, 200)),
                                  padding: const EdgeInsets.all(15),
                                  child: GridTile(
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.docs[index]["bookPic"]
                                          [0],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(child: Lottie.asset("assets/loadpaperplane.json"),)
                                    ),
                                    footer: GridTileBar(
                                      backgroundColor: Colors.black87,
                                      title: Text(
                                        snapshot.docs[index]["bookName"],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                        maxLines: 3,
                                        textAlign: TextAlign.center,
                                        // softWrap: true,
                                        // overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              )
            : Center(child: Lottie.asset("assets/noInternetConnection.json")));
  }
}
