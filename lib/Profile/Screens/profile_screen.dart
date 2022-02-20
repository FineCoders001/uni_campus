import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/Profile/Screens/TodoList.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uni_campus/userCrud.dart';

import '../../main.dart';

final userCrudProvider = ChangeNotifierProvider((ref) {
  return UserCrud();
});

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late PlatformFile file1;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Screen heigth is ${MediaQuery.of(context).size.height}");
    print("Screen heigth is ${MediaQuery.of(context).size.width}");

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
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
                // height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.red, Color.fromARGB(0, 174, 18, 227)],
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
                        "User Name",
                        style: GoogleFonts.ubuntu(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Text(
                        "Email",
                        style: GoogleFonts.ubuntu(
                            fontSize: 15.sp, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0.h, horizontal: 8.w),
                      child: Row(
                        children: [
                          Material(
                            color: Colors.amber,
                            elevation: 5,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.0.h, horizontal: 15.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "My",
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 12.sp, color: Colors.white),
                                    ),
                                    Text(
                                      "Results",
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 24.sp, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.amber,
                            elevation: 5,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const TodoList(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.h, horizontal: 10.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "My",
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 12.sp, color: Colors.white),
                                    ),
                                    Text(
                                      "TODO List",
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 24.sp, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                    ),
                  ],
                ),
              ),
              buildItem("180310116027", "Enrollment"),
              buildItem("LEC Morbi", "2018 - 2022"),
              buildItem("Information Technology", "Department"),
              buildItem("VIII", "Semester")
            ],
          ),
        ));
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
                u['profilePicture'] == ""
                    ? CircleAvatar(
                        child: Image.asset(
                        "assets/images/Login.png",
                        //height: 866.2857142857143.h / 9,
                      ))
                    : buildImage(u['profilePicture']),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () async {
                        // var result = await FilePicker.platform.pickFiles(type: FileType.image);
                        // if (result == null) return;
                        // var file = result!.files.first;
                        FilePickerResult? result =
                        await FilePicker.platform.pickFiles(type: FileType.image);

                        if (result != null) {
                          PlatformFile file = result.files.first;

                          print(file.name);
                          print(file.bytes);
                          print("");
                          print(file.extension);
                          print(file.path);

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
                          print("download link ${downloadLink}");
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
                          )),
                    ))

              ],
            )),

      ],
    );
  }

  buildImage(var img) {
    return ClipOval(
      child: Material(
        elevation: 5.0,
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: Ink.image(
          image: NetworkImage(img),
          fit: BoxFit.cover,
          width: 128,
          height: 128,
        ),
      ),
    );
  }
}
