class BookDetails {
  late final String bookName;
  late final List<String> bookPic;
  late final String bookAuthor;
  late final String bookPages;
  late final String bookGenre;
  late final String bookPublication;
  late final List<String> isbnNumbers;
  late double ratings;
  late double ratingsCount;
  late String bookId;
  late final int bookQuantity;
  late final int issuedQuantity;

  BookDetails(
      {required this.bookName,
      required this.bookAuthor,
      required this.bookGenre,
      required this.bookPages,
      required this.bookPic,
      required this.bookPublication,
      required this.isbnNumbers,
      this.ratings = 0,
      this.ratingsCount = 0,
      required this.bookQuantity,
        this.issuedQuantity=0
      });
}
