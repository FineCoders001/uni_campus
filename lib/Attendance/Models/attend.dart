class Attend {
  late final String dept;
  late final String year;
  late final String month;
  late final String facultyName;
  late final String date;
  late final String subject;
  late final String semester;
  late final List<dynamic> map;

  Attend({
    required this.dept,
    required this.year,
    required this.semester,
    required this.month,
    required this.facultyName,
    required this.subject,
    required this.map,
    required this.date,
  });
  Attend.fromJson(Map json)
      : this(
            dept: json["Department"] as String,
            year: json["Year"] as String,
            facultyName: json["Faculty_Name"] as String,
            month: json["Month"] as String,
            subject: json["Subject"] as String,
            semester: json["Semester"] as String,
            map: json["Map"],
            date: json["Date"] as String);

  Map<String, Object?> toJson() {
    return {
      'Department': dept,
      'FacultyName': facultyName,
      'Year': year,
      'Month': month,
      'Subject': subject,
      'Semester': semester,
      'Map': map,
      'Date': date
    };
  }
}
