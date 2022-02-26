import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_campus/LibraryManagement/Models/book_details.dart';

class AddBooks {
  addBook(BookDetails book) async {
    var docRef = await FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("Books")
        .collection('AllBooks')
        .add({
      'bookName': book.bookName,
      // 'bookPic':book.bookPic,
      // 'bookAuthor':book.bookAuthor,
      // 'bookPages':book.bookPages,
      // 'bookDepartment':book.bookDepartment,
      // 'bookPublication':book.bookPublication,
      // 'isbnNumber':book.isbnNumber,
      // 'ratings':book.ratings,
      // 'ratingsCount':book.ratingsCount,
      // 'bookQuantity':book.bookQuantity
    });

    await FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("Books")
        .collection('AllBooks')
        .doc(docRef.id)
        .update({
      'bookName': book.bookName,
      'bookPic': book.bookPic,
      'bookAuthor': book.bookAuthor,
      'bookPages': book.bookPages,
      'bookDepartment': book.bookDepartment,
      'bookPublication': book.bookPublication,
      'isbnNumber': book.isbnNumber,
      'bookReviews': book.bookReviews,
      'bookReviewedUsers': book.bookReviewedUsers,
      'bookId': docRef.id,
      'issuedQuantity': 0,
      'bookQuantity': book.bookQuantity
    });

    await FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("Books")
        .collection('AllBooks')
        .doc(docRef.id)
        .collection("BookRating").doc("r&r")
        .set({"ratings": 0.0, "ratingsCount": 0.0});

  }
}

class UpdateBook {
  updateBooks(BookDetails book) async {
    await FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("Books")
        .collection('AllBooks')
        .doc(book.bookId)
        .update({
      'bookName': book.bookName,
      'bookPic': book.bookPic,
      'bookAuthor': book.bookAuthor,
      'bookPages': book.bookPages,
      'bookDepartment': book.bookDepartment,
      'bookPublication': book.bookPublication,
      'isbnNumber': book.isbnNumber,
      'bookReviews': book.bookReviews,
      'bookId': book.bookId,
      'bookQuantity': book.bookQuantity
    });
  }
}

class DeleteBooks {
  deleteBooks(BookDetails book) async {
    await FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("Books")
        .collection('AllBooks')
        .doc(book.bookId)
        .delete();
  }
}

class RequestBooks {
  requestBook(BookDetails book, user) async {
    await FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("AvailableBooks")
        .collection(book.bookDepartment)
        .doc(book.bookId)
        .update({'issuedQuantity': book.issuedQuantity - 1});
    await FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("RequestBooks")
        .collection(book.bookDepartment)
        .doc(book.bookId)
        .update({
      'bookId': book.bookId,
      'userName': user['userName'],
      'enroll': user['enroll'],
      'semester': user['semester'],
      'deptname': user['deptname']
    });
  }
}

class ApproveRequest {
  approveRequest() {}
}

class AddToFav {
  addToFav(String bookId, List favBooks) async {
    favBooks.add(bookId);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({'favBooks': favBooks});
  }
}

class AddReview {
  addReview(String bookId, String review,
      List bookReviewedUsers) async {
    bookReviewedUsers.add(FirebaseAuth.instance.currentUser?.uid);
    await FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("Books")
        .collection('AllBooks')
        .doc(bookId)
        .collection("BookReviews")
        .add({"review": review});
    await FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("Books")
        .collection('AllBooks')
        .doc(bookId)
        .update({
      'bookReviewedUsers': bookReviewedUsers,
    });
  }
}

class AddRating {
  addRating(String bookId, double ratings, double ratingsCount) async {
    await FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("Books")
        .collection('AllBooks')
        .doc(bookId)
        .collection("BookRating")
        .doc("r&r").update({"ratings": ratings, "ratingsCount": ratingsCount});
  }
}
