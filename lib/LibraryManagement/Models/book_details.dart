List<String> l=[];
class BookDetails {
  late final String bookName;
  late List bookPic;
  late final String bookAuthor;
  late final String bookPages;
  late final String bookDepartment;
  late final String bookPublication;
  late final int isbnNumber;
  late final List<dynamic> bookReviews;
  late final List<dynamic> bookReviewedUsers;
  late final String bookId;
  late final int bookQuantity;
  late final int issuedQuantity;


  BookDetails(
      {required this.bookName,
      required this.bookAuthor,
      required this.bookDepartment,
      required this.bookPages,
      required this.bookPic,
      required this.bookPublication,
      required this.isbnNumber,
      this.bookId = "",
         required this.bookReviews,
        required this.bookReviewedUsers,
      required this.bookQuantity,
      this.issuedQuantity = 0});

  BookDetails.fromJson(Map json)
      : this(
          bookName: json['bookName']! as String,
          bookPic: json['bookPic'],
          bookAuthor: json['bookAuthor'],
          bookPages: json['bookPages'],
          bookDepartment: json['bookDepartment'],
          bookPublication: json['bookPublication'],
          isbnNumber: json['isbnNumber'],
          bookReviews:json['bookReviews'],
          bookReviewedUsers: json['bookReviewedUsers'],
          bookId: json['bookId'],
          bookQuantity: json['bookQuantity'],
          issuedQuantity: json['issuedQuantity'],
        );

  Map<String, Object> toJson() {
    return {
      'bookName': bookName,
      'bookPic': bookPic,
      'bookAuthor': bookAuthor,
      'bookPages': bookPages,
      'bookDepartment': bookDepartment,
      'bookPublication': bookPublication,
      'isbnNumber': isbnNumber,
      'bookReviews':bookReviews,
      'bookReviewedUsers':bookReviewedUsers,
      'bookId': bookId,
      'bookQuantity': bookQuantity,
      'issuedQuantity': issuedQuantity
    };
  }
}


class Review{
  late String review;
  Review({this.review=""});

  Review.fromJson(Map json)
      : this(
    review: json['review'],
  );

  Map<String, Object> toJson() {
    return {
      'review': review,

    };
  }

}

class Rating{
  late double ratings;
  late double ratingsCount;

  Rating({this.ratings=0,this.ratingsCount=0});

  Rating.fromJson(Map json)
      : this(
    ratings: json['ratings'],
    ratingsCount: json['ratingsCount']
  );

  Map<String, Object> toJson() {
    return {
      'ratings':ratings,
      'ratingsCount':ratingsCount
    };
  }

}