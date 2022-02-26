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

class EditRequest {
  CollectionReference pendingReference = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("RequestedBooks")
      .collection("PendingRequest");
  CollectionReference allBooksReference = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("Books")
      .collection("AllBooks");
  bookIssued(String id, user) async {
    DocumentSnapshot documentSnapshot =
        await pendingReference.doc(user['enroll']).get();
    var data = documentSnapshot.data();
    if (data == null) {
      return false;
    } else {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      if (data['bookId'].contains(id) == true) {
        return true;
      } else {
        return false;
      }
    }
  }

  deleteRequest(String bookId, user) async {
    await allBooksReference
        .doc(bookId)
        .update({'bookQuantity': FieldValue.increment(1)});
    await allBooksReference
        .doc(bookId)
        .update({'issuedQuantity': FieldValue.increment(-1)});
    DocumentSnapshot documentSnapshot =
        await pendingReference.doc(user['enroll']).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    if (data['bookId'].length == 1) {
      await pendingReference.doc(user['enroll']).delete();
    } else {
      data['bookId'].remove(bookId);
      await pendingReference.doc(user['enroll']).set({
        'bookId': data['bookId'],
        'userName': data['userName'],
        'enroll': data['enroll'],
        'semester': data['semester'],
        'deptName': data['deptName']
      });
    }
  }

  approveRequest(BookDetails book, user) async {
     FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("RequestedBooks");
  }

  requestBook(String bookId, user) async {
    await allBooksReference
        .doc(bookId)
        .update({'bookQuantity': FieldValue.increment(-1)});
    await allBooksReference
        .doc(bookId)
        .update({'issuedQuantity': FieldValue.increment(1)});

    DocumentSnapshot documentSnapshot =
        await pendingReference.doc(user['enroll']).get();
    var data = documentSnapshot.data();
    if (data == null || data == {}) {
      await pendingReference.doc(user['enroll']).set({
        'bookId': FieldValue.arrayUnion([bookId]),
        'userName': user['userName'],
        'enroll': user['enroll'],
        'semester': user['semester'],
        'deptName': user['deptName']
      });
    } else {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      data['bookId'].add(bookId);
      await pendingReference.doc(user['enroll']).set({
        'bookId': data['bookId'],
        'userName': data['userName'],
        'enroll': data['enroll'],
        'semester': data['semester'],
        'deptName': data['deptName']
      });
    }
  }
}

class AddToFav {

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
