import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadedExamDetails extends StatefulWidget {
  const UploadedExamDetails({Key? key}) : super(key: key);

  @override
  _UploadedExamDetailsState createState() => _UploadedExamDetailsState();
}

class _UploadedExamDetailsState extends State<UploadedExamDetails> {
  @override
  void initState() {
    super.initState();
    listExample();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: const Text("Uploaded Exam Details"),)
    );
  }
}

Future<void> listExample() async {
  firebase_storage.ListResult result =
      await firebase_storage.FirebaseStorage.instance.ref("ExamFiles/Mid Semester").listAll();

  result.items.forEach((firebase_storage.Reference ref) {
    print('Found file: $ref');
  });

  result.prefixes.forEach((firebase_storage.Reference ref) {
    print('Found directory: $ref');
  });
}
