import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uni_campus/Users/Models/user.dart';
import 'package:uni_campus/main.dart';

class UserCrud extends ChangeNotifier {
  Map<String, dynamic> user = {};

  fetchUserProfile() async {
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.uid)
        .get();
    user = doc.data()!;
    print("data inside document is ${doc.data()}");
    notifyListeners();
  }

  addProfilePicture(String urlLink) async {
    Map<String, dynamic> v;
    if (user['role'] == 'student') {
      v = {
        'userName': user['userName'],
        'enroll': user['enroll'],
        'collegeName': user['collegeName'],
        'deptName': user['deptName'],
        'semester': user['semester'],
        'enyear': user['enyear'],
        'styear': user['styear'],
        "profilePicture": urlLink,
        "role": user['role'],
        'favBooks': user['favBooks']
      };
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser?.uid.toString())
          .update(v);
    } else {
      v = {
        'userName': user['userName'],
        'collegeName': user['collegeName'],
        "profilePicture": urlLink,
        "role": user['role']
      };
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser?.uid.toString())
          .update(v);
    }
    user = v;
    notifyListeners();
  }

  add(UserProfile u) async {
    Map<String, dynamic> v;
    print("after entry ${FirebaseAuth.instance.currentUser?.uid}");

    if (u.role == "student") {
      v = {
        'userName': u.userName,
        'enroll': u.enroll,
        'collegeName': u.collegeName,
        'deptName': u.deptName,
        'semester': u.semester,
        'enyear': u.enyear,
        'styear': u.styear,
        'role': u.role,
        'profilePicture': "",
        'favBooks': u.favBooks
      };
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set(v);
    } else {
      v = {
        'userName': u.userName,
        'collegeName': u.collegeName,
        'role': u.role,
        'profilePicture': "",
        'favBooks': u.favBooks
      };
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set(v);
    }

    v = user;

    notifyListeners();
  }

  removeFavorite(var m) async {
    try {
      user['favBooks'] = m;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser?.uid.toString())
          .update({'favBooks': m});
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  addToFav(String bookId, List favBooks) async {
    favBooks.add(bookId);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({'favBooks': favBooks});
    user['favBooks'] = favBooks;
    notifyListeners();
  }
}
