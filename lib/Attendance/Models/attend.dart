class Attend {
  late final String dept;
  late final String year;
  late final String month;
  late final String semester;
  late final List<dynamic> map;

  Attend({
    required this.dept,
    required this.year,
    required this.semester,
    required this.month,
    required this.map,
  });
  Attend.fromJson(Map json)
      : this(
            dept: json["Department"] as String,
            year: json["Year"] as String,
            month: json["Month"] as String,
            semester: json["Semester"] as String,
            map: json["Map"]);

  Map<String, Object?> toJson() {
    return {
      'Department': dept,
      'Year': year,
      'Month': month,
      'Semester': semester,
      'Map': map
    };
  }

  // adddata(Attend a) {
  //   return FirebaseFirestore.instance.collection("Attendance").doc(year).collection();
  // }
}
