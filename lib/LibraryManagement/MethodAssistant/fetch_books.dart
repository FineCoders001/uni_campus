import 'package:cloud_firestore/cloud_firestore.dart';

Future fetchBooks() async {
  DocumentReference ref = FirebaseFirestore.instance.collection("Books").doc();
  
}
