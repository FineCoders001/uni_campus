class Attend {
  late final String Dept;
  late final String Year;
  late final String Semester;
  late var map;

  Attend({
    required this.Dept,
    required this.Year,
    required this.Semester,
    this.map,
  });
  Attend.fromJson(Map json)
      : this(
            Dept: json["Dept"],
            Year: json["Year"],
            Semester: json["Semster"],
            map: json["Map"]);

  Map<String, Object> toJson() {
    return {'Department': Dept, 'Year': Year, 'Semester': Semester, 'Map': map};
  }
}
