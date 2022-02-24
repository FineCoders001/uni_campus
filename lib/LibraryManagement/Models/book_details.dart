class BookDetails {
  late final String bookName;
  late  List bookPic;
  late final String bookAuthor;
  late final String bookPages;
  late final String bookGenre;
  late final String bookPublication;
  late final int isbnNumber;
  late double ratings;
  late double ratingsCount;
  late final String bookId;
  late final int bookQuantity;
  late final int issuedQuantity;

  BookDetails(
      {required this.bookName,
      required this.bookAuthor,
      required this.bookGenre,
      required this.bookPages,
        required this.bookPic,
      required this.bookPublication,
      required this.isbnNumber,
        this.bookId="",
      this.ratings = 0,
      this.ratingsCount = 0,
      required this.bookQuantity,
        this.issuedQuantity=0
      });

  BookDetails.fromJson(Map json)
      : this(
      bookName: json['bookName']! as String,
    bookPic: json['bookPic'] ,
      bookAuthor: json['bookAuthor'],
    bookPages: json['bookPages'],
    bookGenre: json['bookGenre'],
    bookPublication: json['bookPublication'],
    isbnNumber: json['isbnNumber'],
    ratings: json['ratings'],
    ratingsCount: json['ratingsCount'],
    bookId: json['bookId'],
    bookQuantity: json['bookQuantity'],
    issuedQuantity: json['issuedQuantity'],

  );

  Map<String, Object> toJson() {
    return {
      'bookName':bookName,
      'bookPic':bookPic,
      'bookAuthor':bookAuthor,
      'bookPages':bookPages,
      'bookGenre':bookGenre,
      'bookPublication':bookPublication,
      'isbnNumber':isbnNumber,
      'ratings':ratings,
      'ratingsCount':ratingsCount,
      'bookId':bookId,
      'bookQuantity':bookQuantity,
      'issuedQuantity':issuedQuantity

    };
  }

}
