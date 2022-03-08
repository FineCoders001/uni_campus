import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:uni_campus/LibraryManagement/library_crud.dart';

/// To remove the problem
/// This class (or a class that this class inherits from) is marked as '@immutable', but one or more of its instance fields aren't final
/// vars 1,2,3,4 and 5 were made final
/// A new late variable was made for the variable being changed (comment //6)
/// the new var was used at comment //7
class RatingBar extends StatefulWidget {
  final double ratings; //1
  final double ratingsCount; //2
  final List bookReviewedUsers; //3
  final String bookId; //4
  final bool reviewed; //5
  const RatingBar(this.ratings, this.ratingsCount, this.bookReviewedUsers,
      this.bookId, this.reviewed,
      {Key? key})
      : super(key: key);

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  late bool reviewedNewValue = widget.reviewed; //6
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
                  reviewedNewValue = true; //7
                  //widget.reviewed = true;
                });
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    print("value of items in rat var proId is ${widget.ratings}");

    return widget.reviewed
        ? Card(
            elevation: 3,
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
