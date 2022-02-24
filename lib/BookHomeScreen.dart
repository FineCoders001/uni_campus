import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:uni_campus/LibraryManagement/Models/book_details.dart';

class BookHomeScreen extends StatefulWidget {
  const BookHomeScreen({Key? key}) : super(key: key);

  @override
  _BookHomeScreenState createState() => _BookHomeScreenState();
}

class _BookHomeScreenState extends State<BookHomeScreen> {

  final queryBook = FirebaseFirestore.instance
      .collection('Books')
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
      body: FirestoreListView<BookDetails>(
        query: queryBook,
        pageSize: 8,
        itemBuilder: (context, snapshot) {
          final book = snapshot.data();
          return InkWell(
            onTap: () {},
            child: GridTile(
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey),
                padding: EdgeInsets.all(15),
                child: GridTile(
                  child: Image.network(
                    book.bookPic[0],
                    fit: BoxFit.cover,
                  ),
                  footer: GridTileBar(
                    backgroundColor: Colors.black87,
                    title: Text(
                      book.bookName,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400),
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
        },
      ),
    );
  }
}
