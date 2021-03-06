import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:uni_campus/LibraryManagement/Models/book_details.dart';

class Reviews extends StatefulWidget {
  final String bookId;
  const Reviews(this.bookId, {Key? key}) : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print("reviews of product is ${}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 82, 72, 200),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Reviews',
            style: TextStyle(
                color: Colors.white,
                //fontSize: 30,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: FirestoreListView<Review>(
        pageSize: 3,
        query: FirebaseFirestore.instance
            .collection("LibraryManagement")
            .doc("Books")
            .collection('AllBooks')
            .doc(widget.bookId)
            .collection('BookReviews')
            .withConverter(
                fromFirestore: (snapshot, _) =>
                    Review.fromJson(snapshot.data()!),
                toFirestore: (review, _) => review.toJson()),
        itemBuilder: (context, snapshot) {
          final post = snapshot.data();
          print("dbhj dbnjkf $post");

          //final time = TimeOfDay
          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 10),
                    child: Text(
                      'Verified Student',
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 10),
                    child: Icon(Icons.assignment_turned_in_sharp),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20, top: 20, bottom: 20),
                child: Text(
                  post.review,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
