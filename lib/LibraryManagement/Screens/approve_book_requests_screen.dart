import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_campus/LibraryManagement/Models/book_details.dart';

class ApproveBookRequestScreen extends StatefulWidget {
  const ApproveBookRequestScreen({Key? key}) : super(key: key);

  @override
  _ApproveBookRequestScreenState createState() =>
      _ApproveBookRequestScreenState();
}

class _ApproveBookRequestScreenState extends State<ApproveBookRequestScreen> {
  ScrollController scroll = ScrollController();
  @override
  void initState() {
    scroll.addListener(() {
      setState(() {
        scroll;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    scroll.removeListener(() {});
    super.dispose();
  }

  final queryBook = FirebaseFirestore.instance
      .collection("LibraryManagement").doc("AvailableBooks").collection("IT")
      .withConverter(
        fromFirestore: (snapshot, _) => BookDetails.fromJson(snapshot.data()!),
        toFirestore: (BookDetails, _) => BookDetails.toJson(),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("library"),
      ),
      body: FirestoreQueryBuilder<BookDetails>(
        pageSize: 2,
        query: queryBook,
        builder: (context, snapshot, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Scrollbar(
              child: GridView.builder(
                controller: scroll,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 100,
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
                    return GridTile(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey),
                        padding: EdgeInsets.all(15),
                        child: GridTile(
                          child: CachedNetworkImage(
                            imageUrl: snapshot.docs[index]["bookPic"][0],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                                alignment: Alignment.center,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Text(
                                    "Loading",
                                    style: GoogleFonts.ubuntu(fontSize: 25),
                                  ),
                                )),
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
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
