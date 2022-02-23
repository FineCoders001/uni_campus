import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_campus/LibraryManagement/Models/book_details.dart';

Future<String> addBook(name, author, department) async {
  BookDetails bookDetails = BookDetails(name, author, department);
  Map<String, dynamic> bookData = {
    "bookName": bookDetails.bookName,
    "bookAuthor": bookDetails.bookAuthor,
    "bookDepartment": bookDetails.bookDepartment,
  };
  await FirebaseFirestore.instance
      .collection('LibraryManagement')
      .doc("AvailableBooks")
      .collection(bookDetails.bookDepartment)
      .doc(bookDetails.bookName)
      .set(bookData);
  //return docRef.id;
  return "";
}
