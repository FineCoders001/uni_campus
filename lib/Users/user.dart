class UserProfile {
  final String userName;
  final String enroll;
  final String collegename;
  final String deptname;
  final String semester;
  final String styear;
  final String enyear;
  final String profilePicture;
  final String role;

  UserProfile(
      {required this.userName,
     this.enroll="",
      required this.collegename,
       this.deptname = "",
        this.semester="",
       this.enyear="",
       this.styear="",
        this.profilePicture="",
        required this.role,
      });



}
