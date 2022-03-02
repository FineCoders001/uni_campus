import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:uni_campus/LibraryManagement/library_crud.dart';

class RatingBar extends StatefulWidget {
  double ratings;
  double ratingsCount;
  List bookReviewedUsers;
  String bookId;
  bool reviewed;
  RatingBar(this.ratings, this.ratingsCount, this.bookReviewedUsers,
      this.bookId, this.reviewed,
      {Key? key})
      : super(key: key);

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  showRatingBar() async {
    await showDialog(
        context: context,
        builder: (ctx) {
          return RatingDialog(
              initialRating: 0,
              title: const Text('Rate this book'),
              message: const Text(
                  'Tap a star to set your rating and review this product.'),
              image: const FlutterLogo(size: 50),
              submitButtonText: 'Submit',
              onSubmitted: (response) async {
                if (response.comment == "" || response.rating == 0) {
                  return;
                }
                print(
                    'rating: ${response.rating}, comment: ${response.comment}');
                double ratingsCount = widget.ratingsCount + 1;
                double ratings =
                    (widget.ratings + response.rating) / ratingsCount;

                await AddReview().addReview(
                    widget.bookId, response.comment, widget.bookReviewedUsers);
                await AddRating()
                    .addRating(widget.bookId, ratings, ratingsCount);
                setState(() {
                  widget.reviewed = true;
                });
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    print("value of items in rat var proId is ${widget.ratings}");

    return widget.reviewed
        ? Card(
            elevation: 5,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Already Rated and Reviewed",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 82, 72, 200)),
                  ),
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              showRatingBar();
            },
            child: Card(
              elevation: 5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Add Reviews',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.rate_review_outlined),
                  ],
                ),
              ),
            ),
          );
  }
}
