import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_campus/LibraryManagement/Models/book_details.dart';

Future<String> addBook(name, author, department) async {
  BookDetails bookDetails =
      BookDetails(name.text, author.text, department.text);
  Map<String, dynamic> bookData = {
    "bookName": bookDetails.bookName,
    "bookAuthor": bookDetails.bookAuthor,
    "bookDepartment": bookDetails.bookDepartment,
  };
  DocumentReference docRef =
      await FirebaseFirestore.instance.collection('Books').add(bookData);
  return docRef.id;
}
