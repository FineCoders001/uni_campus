class UserProfile {
  final String userName;
  final String email;
  final String password;
  final String enroll;
  final String collegename;
  final String deptname;
  final String styear;
  final String enyear;
  //String auth = "student";

  UserProfile(
      {required this.userName,
      required this.email,
      required this.password,
      required this.enroll,
      required this.collegename,
      required this.deptname,
      required this.enyear,
      required this.styear});
}
