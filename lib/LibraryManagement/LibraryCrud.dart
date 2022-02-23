
 import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_campus/LibraryManagement/Models/book_details.dart';

class AddBooks{

  addBook(BookDetails book ) async {
    var docRef = await FirebaseFirestore.instance
        .collection("Books").add(
      {
        'bookName':book.bookName,
        // 'bookPic':book.bookPic,
        // 'bookAuthor':book.bookAuthor,
        // 'bookPages':book.bookPages,
        // 'bookGenre':book.bookGenre,
        // 'bookPublication':book.bookPublication,
        // 'isbnNumbers':book.isbnNumbers,
        // 'ratings':book.ratings,
        // 'ratingsCount':book.ratingsCount,
        // 'bookQuantity':book.bookQuantity
      }
    );

    await FirebaseFirestore.instance
        .collection("Books").add(
        {
          'bookName':book.bookName,
          'bookPic':book.bookPic,
          'bookAuthor':book.bookAuthor,
          'bookPages':book.bookPages,
          'bookGenre':book.bookGenre,
          'bookPublication':book.bookPublication,
          'isbnNumbers':book.isbnNumbers,
          'ratings':book.ratings,
          'ratingsCount':book.ratingsCount,
          'bookId':book.bookId,
          'bookQuantity':book.bookQuantity
        }
    );
  }

 }


 class UpdateBook{

  updateBooks(BookDetails book) async {
    await FirebaseFirestore.instance.collection("Books").doc(book.bookId).update(
      {
        'bookName':book.bookName,
        'bookPic':book.bookPic,
        'bookAuthor':book.bookAuthor,
        'bookPages':book.bookPages,
        'bookGenre':book.bookGenre,
        'bookPublication':book.bookPublication,
        'isbnNumbers':book.isbnNumbers,
        'ratings':book.ratings,
        'ratingsCount':book.ratingsCount,
        'bookId':book.bookId,
        'bookQuantity':book.bookQuantity
      }
    );
  }

 }


 class DeleteBooks{

  deleteBooks(BookDetails book) async {
    await FirebaseFirestore.instance.collection("Books").doc(book.bookId).delete();
  }

 }


 class RequestBooks{
  RequestBook(BookDetails book,) async {
    await FirebaseFirestore.instance
        .collection("Books").doc(book.bookId).updateData(
        {
          'bookName':book.bookName,
          'bookPic':book.bookPic,
          'bookAuthor':book.bookAuthor,
          'bookPages':book.bookPages,
          'bookGenre':book.bookGenre,
          'bookPublication':book.bookPublication,
          'isbnNumbers':book.isbnNumbers,
          'ratings':book.ratings,
          'ratingsCount':book.ratingsCount,
          'bookId':book.bookId,
          'bookQuantity':book.bookQuantity,
          'issuedQuantity':book.issuedQuantity-1
        }
    );
    await FirebaseFirestore.instance
        .collection("RequestBooks").doc(book.bookId).update(
        {
          'bookId':book.bookId,

        }
    );
  }

 }