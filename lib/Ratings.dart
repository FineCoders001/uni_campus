import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Ratings extends StatefulWidget {
  var book;
  double ratings;
  double ratingsCount;
  Ratings(this.book,this.ratings,this.ratingsCount, {Key? key}) : super(key: key);

  @override
  _RatingsState createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //getRating();
    CollectionReference reference =FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("Books")
        .collection('AllBooks')
        .doc(widget.book['bookId'])
        .collection("BookRating");
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) async {
        // Do something with change
        var  v=await FirebaseFirestore.instance
            .collection("LibraryManagement")
            .doc("Books")
            .collection('AllBooks')
            .doc(widget.book['bookId'])
            .collection("BookRating")
            .doc("r&r").get();
        Map<String, dynamic>? d = v.data();
        widget.ratings = d!['ratings'];
        widget.ratingsCount = d['ratingsCount'];

        print("entered into ratings ${widget.ratings}}");
        setState(() {

        });


      });
    });

  }
  @override
  Widget build(BuildContext context) {
    //var num =['ratings'];

    var num = widget.ratings;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: const Color.fromRGBO(232, 207, 9,0.9),
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right:3.0),
                    child: Text('${(num.toStringAsFixed(1))}',style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),),
                  ),
                  const Icon(Icons.star,color: Colors.white,size: 13,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text('${widget.ratingsCount} ratings',style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),),
            ),


          ],
        ),
      ),
    );
  }
}
