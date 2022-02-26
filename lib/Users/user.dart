class UserProfile {
  final String userName;
  final String enroll;
  final String collegeName;
  final String deptName;
  final String semester;
  final String styear;
  final String enyear;
  final String profilePicture;
  final String role;
  final List<String> favBooks;

  UserProfile(
      {required this.userName,
      this.enroll = "",
      required this.collegeName,
      this.deptName = "",
      this.semester = "",
      this.enyear = "",
      this.styear = "",
      this.profilePicture = "",
      required this.role,
      required this.favBooks});
}
