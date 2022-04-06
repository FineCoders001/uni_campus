import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uni_campus/Users/user_crud.dart';
import 'package:uni_campus/main.dart';

Map semRoman = {
  1: 'I',
  2: 'II',
  3: 'III',
  4: 'IV',
  5: 'V',
  6: 'VI',
  7: 'VII',
  8: 'VIII',
  9: 'IX',
  10: 'X',
};

final userCrudProvider = ChangeNotifierProvider((ref) {
  return UserCrud();
});

class ProfileScreen extends StatefulHookConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late PlatformFile file1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(userCrudProvider);
    var u = data.user;

    // buildEditIcon() {
    //   return Container(
    //     margin: const EdgeInsets.all(8),
    //     //padding: EdgeInsets.all(8),
    //     child: CircleAvatar(
    //       backgroundColor: Colors.amber,
    //       child: Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: InkWell(
    //           onTap: () {},
    //           child: const Icon(
    //             Icons.edit,
    //             color: Colors.white,
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 22.h),
        ),
        centerTitle: true,
        //leading: Icon(Icons.arrow_back),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              // height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.pinkAccent,
                    Colors.redAccent,
                    Colors.orangeAccent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ProfilePic(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0.h, horizontal: 10.w),
                    child: Text(
                      u['userName'],
                      style: GoogleFonts.ubuntu(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: Text(
                      "${currentUser?.email}",
                      style: GoogleFonts.ubuntu(
                          fontSize: 15.sp, color: Colors.white),
                    ),
                  ),
                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.w),
                  //   child: Row(
                  //     children: [
                  // Material(
                  //   color: Colors.amber,
                  //   elevation: 5,
                  //   shape: const RoundedRectangleBorder(
                  //       borderRadius:
                  //           BorderRadius.all(Radius.circular(10))),
                  //   child: InkWell(
                  //     onTap: () {},
                  //     child: Padding(
                  //       padding: EdgeInsets.symmetric(
                  //           vertical: 20.0.h, horizontal: 15.w),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "My",
                  //             style: GoogleFonts.ubuntu(
                  //                 fontSize: 12.sp, color: Colors.white),
                  //           ),
                  //           Text(
                  //             "Results",
                  //             style: GoogleFonts.ubuntu(
                  //                 fontSize: 24.sp, color: Colors.white),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // Material(
                  //   color: Colors.amber,
                  //   elevation: 5,
                  //   shape: const RoundedRectangleBorder(
                  //       borderRadius:
                  //           BorderRadius.all(Radius.circular(10))),
                  //   child: InkWell(
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (BuildContext context) =>
                  //               const TodoList(),
                  //         ),
                  //       );
                  //     },
                  //     child: Padding(
                  //       padding: EdgeInsets.symmetric(
                  //           vertical: 20.h, horizontal: 10.w),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "My",
                  //             style: GoogleFonts.ubuntu(
                  //                 fontSize: 12.sp, color: Colors.white),
                  //           ),
                  //           Text(
                  //             "TODO List",
                  //             style: GoogleFonts.ubuntu(
                  //                 fontSize: 24.sp, color: Colors.white),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  //     ],
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   ),
                  // ),
                ],
              ),
            ),
            // buildItem(u['enroll'], "Enrollment"),
            // buildItem(u['collegeName'], "2018 - 2022"),
            // buildItem(u['deptName'], "Department"),
            // buildItem(semRoman[int.parse(u['semester'])], "Semester")
            u['role'] == "student"
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 7,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: const Icon(Icons.library_books_outlined),
                              // trailing: buildEditIcon(),
                              title: Text(
                                u['enroll'],
                              ),
                              subtitle: const Text(
                                "Enrollment",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: const Icon(Icons.school_outlined),
                              // trailing: buildEditIcon(),
                              title: Text(
                                u['collegeName'],
                              ),
                              subtitle: Text(
                                "${u['styear']} - ${u['enyear']}",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: const Icon(Icons.local_library_outlined),
                              // trailing: buildEditIcon(),
                              title: Text(
                                u['deptName'],
                              ),
                              subtitle: const Text(
                                "Department",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: const Icon(Icons.arrow_forward),
                              // trailing: buildEditIcon(),
                              title: Text(
                                semRoman[int.parse(u['semester'])],
                              ),
                              subtitle: const Text(
                                "Semester",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 5,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: const Icon(Icons.school_outlined),
                              // trailing: buildEditIcon(),
                              title: Text(
                                u['collegeName'],
                              ),
                              subtitle: const Text(
                                "College",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: const Icon(Icons.arrow_forward),
                              // trailing: buildEditIcon(),
                              title: Text(
                                u['role'].toString().toUpperCase(),
                              ),
                              subtitle: const Text(
                                "Role",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(Icons.school),
            title: Text(
              title,
            ),
            subtitle: Text(
              subtitle,
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePic extends StatefulHookConsumerWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends ConsumerState<ProfilePic> {
  @override
  Widget build(BuildContext context) {
    // print(currentUser?.uid);
    var pic = ref.watch(userCrudProvider);
    var u = pic.user;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Stack(
            children: [
              u['profilePicture'] == null || u['profilePicture'] == ""
                  ? u['userName'] != null
                      ? ClipOval(
                          child: Material(
                            elevation: 5.0,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            color: const Color.fromARGB(255, 65, 198, 255),
                            child: Padding(
                              padding: const EdgeInsets.all(45.0),
                              child: Text(
                                u['userName'][0],
                                style: GoogleFonts.ubuntu(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const CircularProgressIndicator()
                  : buildImage(u['profilePicture'], u),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.image);

                    if (result != null) {
                      PlatformFile file = result.files.first;

                      // print(file.name);
                      // print(file.bytes);
                      // print("");
                      // print(file.extension);
                      // print(file.path);

                      File f = File(file.path.toString());
                      // firebase_storage.UploadTask uploadTask;

                      // Create a Reference to the file
                      firebase_storage.Reference ref = firebase_storage
                          .FirebaseStorage.instance
                          .ref()
                          .child('profile')
                          .child(file.name);

                      UploadTask task = ref.putFile(f);
                      final snapshot = await task.whenComplete(() => null);
                      final downloadLink = await snapshot.ref.getDownloadURL();
                      print("download link $downloadLink");
                      await pic.addProfilePicture(downloadLink);
                      //setState(() {});

                    } else {
                      // User canceled the picker
                    }
                    //setState(() {});
                  },
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.amber,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildImage(var img, u) {
    return ClipOval(
      child: Material(
        elevation: 5.0,
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          imageUrl: img,
          placeholder: (context, url) => ClipOval(
            child: Material(
              elevation: 5.0,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: const Color.fromARGB(255, 65, 198, 255),
              child: Center(
                child: Text(
                  u['userName'][0],
                  style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        // Ink.image(
        //   image: NetworkImage(img),
        //   fit: BoxFit.cover,
        //   width: 128,
        //   height: 128,
        // ),
      ),
    );
  }
}
