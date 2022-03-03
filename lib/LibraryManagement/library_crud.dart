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
        .collection("BookRating")
        .doc("r&r")
        .set({"ratings": 0.0, "ratingsCount": 0.0});
  }
}

class UpdateBook {
  updateBooks(String bookId, BookDetails book) async {
    print("entered update book ${book.bookId}");
    await FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("Books")
        .collection('AllBooks')
        .doc(bookId)
        .update({
      'bookName': book.bookName,
      'bookAuthor': book.bookAuthor,
      'bookPages': book.bookPages,
      'bookPic':book.bookPic,
      'bookDepartment': book.bookDepartment,
      'bookPublication': book.bookPublication,
      'isbnNumber': book.isbnNumber,
      'bookQuantity': book.bookQuantity
    });
  }
}

class DeleteBooks {
  deleteBooks(BookDetails book) async {
    try {
      await FirebaseFirestore.instance
          .collection("LibraryManagement")
          .doc("Books")
          .collection('AllBooks')
          .doc(book.bookId)
          .delete();
      await FirebaseFirestore.instance
          .collection("LibraryManagement")
          .doc("Books")
          .collection('AllBooks')
          .doc(book.bookId)
          .collection("BookRating")
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      await FirebaseFirestore.instance
          .collection("LibraryManagement")
          .doc("Books")
          .collection('AllBooks')
          .doc(book.bookId)
          .collection("BookReviews")
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}

class AddReview {
  addReview(String bookId, String review, List bookReviewedUsers) async {
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
        .doc("r&r")
        .set({"ratings": ratings, "ratingsCount": ratingsCount});
  }
}

class EditRequest {
  CollectionReference pendingReference = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("RequestedBooks")
      .collection("PendingRequest");
  CollectionReference reissueReference = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("RequestedBooks")
      .collection("ReissueRequest");
  CollectionReference approvedReference = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("RequestedBooks")
      .collection("ApprovedRequest");
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
      for (var map in data['bookId']) {
        if (map?.containsKey(id) == true) {
          return true;
        }
      }
      return false;
    }
  }

  bookApproved(String id, user) async {
    DocumentSnapshot documentSnapshot =
        await approvedReference.doc(user['enroll']).get();
    var data = documentSnapshot.data();
    if (data == null) {
      return false;
    } else {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      for (var map in data['bookId']) {
        if (map?.containsKey(id) == true) {
          return true;
        }
      }
      return false;
    }
  }

  bookReissued(String id, String enroll) async {
    DocumentSnapshot documentSnapshot =
        await reissueReference.doc(enroll).get();
    dynamic data = documentSnapshot.data();
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
    // await allBooksReference
    //     .doc(bookId)
    //     .update({'bookQuantity': FieldValue.increment(1)});
    await allBooksReference
        .doc(bookId)
        .update({'issuedQuantity': FieldValue.increment(-1)});
    DocumentSnapshot documentSnapshot =
        await pendingReference.doc(user['enroll']).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    if (data['bookId'].length == 1) {
      await pendingReference.doc(user['enroll']).delete();
    } else {
      List test = [];
      for (int i = 0; i < data['bookId'].length; i++) {
        if (data['bookId'][i].keys.elementAt(0) == bookId) {
          data['bookId'].removeAt(i);
          test = data['bookId'];
          break;
        }
      }
      await pendingReference.doc(user['enroll']).update({'bookId': test});
    }
  }

  reissueBook(String bookId, String enroll) async {
    // await allBooksReference
    //     .doc(bookId)
    //     .update({'bookQuantity': FieldValue.increment(-1)});
    // await allBooksReference
    //     .doc(bookId)
    //     .update({'issuedQuantity': FieldValue.increment(1)});

    DocumentSnapshot documentSnapshot =
        await reissueReference.doc(enroll).get();
    var data = documentSnapshot.data();
    if (data == null || data == {}) {
      await reissueReference.doc(enroll).set({
        'bookId': FieldValue.arrayUnion([bookId]),
        'enroll': enroll,
      });
    } else {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      data['bookId'].add(bookId);
      await reissueReference.doc(enroll).set({
        'bookId': data['bookId'],
        'enroll': data['enroll'],
      });
    }
  }

  requestBook(String bookId, user) async {
    // await allBooksReference
    //     .doc(bookId)
    //     .update({'bookQuantity': FieldValue.increment(-1)});
    await allBooksReference
        .doc(bookId)
        .update({'issuedQuantity': FieldValue.increment(1)});

    DocumentSnapshot documentSnapshot =
        await pendingReference.doc(user['enroll']).get();
    var data = documentSnapshot.data();
    if (data == null || data == {}) {
      await pendingReference.doc(user['enroll']).set({
        'bookId': FieldValue.arrayUnion([
          {bookId: DateTime.now()}
        ]),
        'userName': user['userName'],
        'enroll': user['enroll'],
        'semester': user['semester'],
        'deptName': user['deptName'],
        //change contact here
        'contact': user['enroll']
      });
    } else {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      data['bookId'].add({bookId: DateTime.now()});
      await pendingReference.doc(user['enroll']).set({
        'bookId': data['bookId'],
        'userName': data['userName'],
        'enroll': data['enroll'],
        'semester': data['semester'],
        'deptName': data['deptName'],
        //change contact here
        'contact': data['enroll']
      });
    }
  }
}

class EditRequestAdmin {
  CollectionReference pendingReference = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("RequestedBooks")
      .collection("PendingRequest");
  CollectionReference approvedReference = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("RequestedBooks")
      .collection("ApprovedRequest");
  CollectionReference allBooksReference = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("Books")
      .collection("AllBooks");

  approveRequest(
      String enroll, Map<String, dynamic> passedData, String bookId) async {
    //Adding data
    DocumentSnapshot documentSnapshot =
        await approvedReference.doc(enroll).get();
    if (documentSnapshot.data() == null || documentSnapshot.data() == {}) {
      await approvedReference.doc(enroll).set({
        'bookId': FieldValue.arrayUnion([
          {bookId: DateTime.now()}
        ]),
        'userName': passedData['userName'],
        'enroll': passedData['enroll'],
        'semester': passedData['semester'],
        'deptName': passedData['deptName'],
        'contact': passedData['contact']
      });
    } else {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      data['bookId'].add({bookId: DateTime.now()});
      await approvedReference.doc(enroll).set({
        'bookId': FieldValue.arrayUnion(data['bookId']),
        'userName': data['userName'],
        'enroll': data['enroll'],
        'semester': data['semester'],
        'deptName': data['deptName'],
        'contact': passedData['contact']
      });
    }

    //Deleting Data
    if (passedData['bookId'].length == 1) {
      await pendingReference.doc(enroll).delete();
    } else {
      List test = [];
      for (int i = 0; i < passedData['bookId'].length; i++) {
        if (passedData['bookId'][i].keys.elementAt(0) == bookId) {
          passedData['bookId'].removeAt(i);
          test = passedData['bookId'];
          break;
        }
      }
      await pendingReference.doc(enroll).update({'bookId': test});
    }
  }

  rejectRequest(
      String enroll, Map<String, dynamic> passedData, String bookId) async {
    // await allBooksReference
    //     .doc(bookId)
    //     .update({'bookQuantity': FieldValue.increment(1)});
    await allBooksReference
        .doc(bookId)
        .update({'issuedQuantity': FieldValue.increment(-1)});

    //Deleting Data
    if (passedData['bookId'].length == 1) {
      await pendingReference.doc(enroll).delete();
    } else {
      List test = [];
      for (int i = 0; i < passedData['bookId'].length; i++) {
        if (passedData['bookId'][i].keys.elementAt(0) == bookId) {
          passedData['bookId'].removeAt(i);
          test = passedData['bookId'];
          break;
        }
      }
      await pendingReference.doc(enroll).update({'bookId': test});
    }
  }
}

class BookStatus {
  CollectionReference pendingReference = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("RequestedBooks")
      .collection("PendingRequest");
  CollectionReference approvedReference = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("RequestedBooks")
      .collection("ApprovedRequest");
  CollectionReference allBooksReference = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("Books")
      .collection("AllBooks");
  // bookCollected(String enroll, String bookId) async {
  //   await approvedReference.doc(enroll).update({
  //     'bookId': FieldValue.arrayRemove([
  //       {bookId: "Approved"}
  //     ]),
  //   });
  //   await approvedReference.doc(enroll).update({
  //     'bookId': FieldValue.arrayUnion([
  //       {bookId: "Collected"}
  //     ]),
  //   });
  // }

  bookReturned(String enroll, List<dynamic> passedData, String bookId) async {
    // await allBooksReference
    //     .doc(bookId)
    //     .update({'bookQuantity': FieldValue.increment(1)});
    await allBooksReference
        .doc(bookId)
        .update({'issuedQuantity': FieldValue.increment(-1)});

    //Deleting Data
    if (passedData.length == 1) {
      await approvedReference.doc(enroll).delete();
    } else {
      DocumentSnapshot snapshot = await approvedReference.doc(enroll).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List test = [];
      for (int i = 0; i < data['bookId'].length; i++) {
        if (data['bookId'][i].keys.elementAt(0) == bookId) {
          print("wow");
          data['bookId'].removeAt(i);
          test = data['bookId'];
          break;
        }
      }
      await approvedReference.doc(enroll).update({'bookId': test});
    }
  }
}
