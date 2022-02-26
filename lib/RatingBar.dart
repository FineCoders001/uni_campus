import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:uni_campus/LibraryManagement/library_crud.dart';

class RatingBar extends StatefulWidget {
  double ratings;
  double ratingsCount;
  List bookReviewedUsers;
  String bookId;
  RatingBar(this.ratings,this.ratingsCount,this.bookReviewedUsers,this.bookId, {Key? key}) : super(key: key);

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  @override
  Widget build(BuildContext context) {
    print("value of items in rat var proId is ${widget.ratings}");

    return RatingDialog(
      initialRating: 0,
        title: const Text('Rate this book'),
        message:
        const Text('Tap a star to set your rating and review this product.'),
        image: const FlutterLogo(size: 50),
        submitButtonText: 'Submit',
        onSubmitted: (response) async{
          print('rating: ${response.rating}, comment: ${response.comment}');
          double ratingsCount= widget.ratingsCount+1;
          double ratings= (widget.ratings+response.rating)/ratingsCount;

         await AddReview().addReview(widget.bookId, response.comment,widget.bookReviewedUsers);
         await AddRating().addRating(widget.bookId, ratings, ratingsCount);
        }
    );

  }
}
