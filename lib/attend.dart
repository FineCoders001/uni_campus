class Attend {
  late final String dept;
  late final String year;
  late final String semester;
  late var map;

  Attend({
    required this.dept,
    required this.year,
    required this.semester,
    this.map,
  });
  Attend.fromJson(Map json)
      : this(
            dept: json["Dept"],
            year: json["Year"],
            semester: json["Semster"],
            map: json["Map"]);

  Map<String, Object> toJson() {
    return {'Department': dept, 'Year': year, 'Semester': semester, 'Map': map};
  }
}
