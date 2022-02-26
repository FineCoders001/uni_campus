import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Attend {
  late final String dept;
  late final String year;
  late final String semester;
  late final List<String> map;

  Attend({
    required this.dept,
    required this.year,
    required this.semester,
    required this.map,
  });
  Attend.fromJson(Map json)
      : this(
            dept: json["Department"],
            year: json["Year"],
            semester: json["Semester"],
            map: json["Map"]);

  Map<String, Object?> toJson() {
    return {'Department': dept, 'Year': year, 'Semester': semester, 'Map': map};
  }

  // adddata(Attend a) {
  //   return FirebaseFirestore.instance.collection("Attendance").doc(year).collection();
  // }
}
