import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// To remove the problem
/// This class (or a class that this class inherits from) is marked as '@immutable', but one or more of its instance fields aren't final
/// vars 1,2 and 3 were made final
/// Two new late variables was made for the variables being changed (comments //4 and //5)
/// the new vars were used at comments //6 and//7
class Ratings extends StatefulWidget {
  final dynamic book; //1
  final double ratings; //2
  final double ratingsCount; //3
  const Ratings(this.book, this.ratings, this.ratingsCount, {Key? key})
      : super(key: key);

  @override
  _RatingsState createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  late double ratingsNewVariable = widget.ratings; //4
  late double ratingscountNewVariable = widget.ratingsCount; //5

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //getRating();
    CollectionReference reference = FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("Books")
        .collection('AllBooks')
        .doc(widget.book['bookId'])
        .collection("BookRating");
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) async {
        // Do something with change
        var v = await FirebaseFirestore.instance
            .collection("LibraryManagement")
            .doc("Books")
            .collection('AllBooks')
            .doc(widget.book['bookId'])
            .collection("BookRating")
            .doc("r&r")
            .get();
        Map<String, dynamic>? d = v.data();
        ratingsNewVariable = d!['ratings']; //6
        ratingscountNewVariable = d['ratingsCount']; //7

        // widget.ratings = d!['ratings'];
        // widget.ratingsCount = d['ratingsCount'];

        print("entered into ratings ${widget.ratings}}");
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //var num =['ratings'];

    var num = widget.ratings;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.amberAccent,
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 3.0),
                    child: Text(
                      (num.toStringAsFixed(1)),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 13,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '${widget.ratingsCount} ratings',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
