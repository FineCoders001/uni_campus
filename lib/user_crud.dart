import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uni_campus/Users/user.dart';
import 'main.dart';

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
      print("ghus gya");
      v = {
        'userName': user['userName'],
        'enroll': user['enroll'],
        'collegename': user['collegename'],
        'deptname': user['deptname'],
        'semester': user['semester'],
        'enyear': user['enyear'],
        'styear': user['styear'],
        "profilePicture": urlLink,
        "role": user['role'],
        'favBooks':user['favBooks']
      };
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser?.uid.toString())
          .update(v);
    } else {
      v = {
        'userName': user['userName'],
        'collegename': user['collegename'],
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
        'collegename': u.collegename,
        'deptname': u.deptname,
        'semester': u.semester,
        'enyear': u.enyear,
        'styear': u.styear,
        'role': u.role,
        'profilePicture': "",
        'favBooks':u.favBooks
      };
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set(v);
    } else {
      v = {
        'userName': u.userName,
        'collegename': u.collegename,
        'role': u.role,
        'profilePicture': "",
        'favBooks':u.favBooks
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
   try{
     user['favBooks']=m;
     await FirebaseFirestore.instance
         .collection("users")
         .doc(currentUser?.uid.toString())
         .update({'favBooks':m});
     notifyListeners();
   }catch(e){
     rethrow;
   }
  }
}
