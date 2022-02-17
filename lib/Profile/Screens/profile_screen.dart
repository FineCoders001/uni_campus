import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_campus/Profile/Screens/TodoList.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    print("Screen heigth is ${MediaQuery.of(context).size.height}");
    print("Screen heigth is ${MediaQuery.of(context).size.width}");

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            "Profile",
            style: TextStyle(fontSize: 22.h),
          ),
          centerTitle: true,
          leading: Icon(Icons.arrow_back),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.red,
                      Color.fromARGB(0,174, 18, 227)
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Material(
                        elevation: 5.0,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        color: Colors.transparent,
                        child: Image.asset(
                          "assets/images/Login.png",
                          height: 866.2857142857143.h / 7,
                        ),
                      ),
                    ),
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
                      padding:  EdgeInsets.symmetric(vertical:8.0.h,
                       horizontal: 8.w
                      ),
                      child: Row(
                        children: [
                          Material(
                              color: Colors.amber,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: InkWell(
                                onTap: (){

                                },

                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20.0.h, horizontal: 15.w),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "My",
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 12.sp,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "Results",
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 24.sp,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          Material(
                            color: Colors.amber,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                     TodoList(),
                                  ),
                                );
                              },

                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.h, horizontal: 10.w),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "My",
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 12.sp,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "TODO List",
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 24.sp,
                                          color: Colors.white),
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
        )

        // body: Column(
        //   children: [
        //
        //     Container(
        //      // color: const Color.fromARGB(255, 71, 123, 114),
        //      // height: 100.h,
        //       height: MediaQuery.of(context).size.height*0.15,
        //       width: 411.42857142857144.w,
        //       child: Padding(
        //        padding:  EdgeInsets.only(top: 45.h, left: 15.w,bottom: 15.h),
        //         child: Text(
        //           "My Profile",
        //           style: GoogleFonts.ubuntu(
        //               fontSize: 25.sp,
        //               fontWeight: FontWeight.bold,
        //               color: Colors.white),
        //         ),
        //       ),
        //     ),
        //
        //     Container(
        //         decoration:   BoxDecoration(
        //             color: Color.fromARGB(255, 205, 240, 240),
        //             borderRadius: BorderRadius.only(
        //                 topLeft: Radius.circular(30.r),
        //                 topRight: Radius.circular(30.r))),
        //         child: Column(
        //           children: [
        //             Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Padding(
        //                   padding: const EdgeInsets.only(top: 10.0),
        //                   child: Material(
        //                     elevation: 5.0,
        //                     shape: const CircleBorder(),
        //                     clipBehavior: Clip.hardEdge,
        //                     color: Colors.transparent,
        //                     child: Image.asset(
        //                       "assets/images/Login.png",
        //                       height: 866.2857142857143.h / 6,
        //                     ),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding:  EdgeInsets.symmetric(vertical:10.0.h,horizontal: 10.w),
        //                   child: Text(
        //                     "User Name",
        //                     style: GoogleFonts.ubuntu(
        //                         fontSize: 25.sp, fontWeight: FontWeight.bold),
        //                   ),
        //                 ),
        //                 Text(
        //                   "Email",
        //                   style: GoogleFonts.ubuntu(
        //                       fontSize: 15.sp, color: Colors.grey),
        //                 ),
        //               ],
        //             ),
        //             // )
        //             Row(
        //               children: [
        //                 Expanded(
        //                   flex:1,
        //                   child: Padding(
        //                     padding:  EdgeInsets.symmetric(vertical:8.0.h,horizontal: 20.w),
        //                     child: SizedBox(
        //                       //width: MediaQuery.of(context).size.width.w * 0.40,
        //                       child: Card(
        //                         elevation: 7,
        //
        //                         child: Container(
        //                           height: 100.h,
        //                           decoration: const BoxDecoration(
        //                             //borderRadius: BorderRadius.circular(8),
        //                             color: Color.fromARGB(255, 247, 186, 52),
        //                           ),
        //                           child: Padding(
        //                             padding:  EdgeInsets.symmetric(vertical:20.0.h,horizontal: 15.w),
        //                             child: Column(
        //                               crossAxisAlignment: CrossAxisAlignment.start,
        //                               children: [
        //                                 Text(
        //                                   "My",
        //                                   style: GoogleFonts.ubuntu(
        //                                       fontSize: 12.sp, color: Colors.white),
        //                                 ),
        //
        //                                 Text(
        //                                   "Results",
        //                                   style: GoogleFonts.ubuntu(
        //                                       fontSize: 24.sp, color: Colors.white),
        //                                 ),
        //
        //                               ],
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 Expanded(
        //                   flex:1,
        //                   child: Padding(
        //                     padding:  EdgeInsets.symmetric(vertical:8.0.h,horizontal:20.w),
        //                     child: Card(
        //                       elevation: 7,
        //                       child: Container(
        //                         height: 100.h,
        //                         decoration: const BoxDecoration(
        //                           //borderRadius: BorderRadius.circular(8),
        //                           color: Color.fromARGB(255, 247, 186, 52),
        //                         ),
        //                         child: Padding(
        //                           padding:  EdgeInsets.symmetric(vertical: 20.h,horizontal: 10.w),
        //                           child: Column(
        //                             crossAxisAlignment: CrossAxisAlignment.start,
        //                             children: [
        //                               Text(
        //                                 "My",
        //                                 style: GoogleFonts.ubuntu(
        //                                     fontSize: 12.sp, color: Colors.white),
        //                               ),
        //                               Text(
        //                                 "TODO List",
        //                                 style: GoogleFonts.ubuntu(
        //                                     fontSize: 24.sp, color: Colors.white),
        //                               ),
        //
        //                             ],
        //                           ),
        //                         ),
        //
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             ),
        //           ],
        //         ),
        //         height:MediaQuery.of(context).size.height*0.45),
        //      Container(
        //       // margin:EdgeInsets.only(top: 8.h) ,
        //       // padding: EdgeInsets.only(top: 8.h),
        //
        //        height: MediaQuery.of(context).size.height*0.40,
        //        child: ListView(
        //          children: [
        //            // Padding(
        //            //   padding:  EdgeInsets.symmetric(
        //            //       horizontal: 10.0.h),
        //            //   child: Container(
        //            //     height: 100.h,
        //            //     color: Colors.white,
        //            //     child:  ListTile(
        //            //       leading: Icon(
        //            //         Icons.school_outlined,
        //            //         size: 40.sp,
        //            //       ),
        //            //       subtitle: Text(
        //            //         "Enrollment",
        //            //         style: TextStyle(fontSize: 18.sp),
        //            //       ),
        //            //       title: Text(
        //            //         "180310116019",
        //            //         style: TextStyle(fontSize: 20.sp),
        //            //       ),
        //            //       trailing: Icon(Icons.arrow_forward_ios),
        //            //     ),
        //            //   ),
        //            // ),
        //            // Padding(
        //            //   padding: EdgeInsets.symmetric(
        //            //       horizontal: 20.0.w, vertical: 5.h),
        //            //   child: Divider(
        //            //     thickness: 1,
        //            //     color: Colors.grey,
        //            //   ),
        //            // ),
        //            // Padding(
        //            //   padding:  EdgeInsets.symmetric(
        //            //       horizontal: 10.0.w, vertical: 5.h),
        //            //   child: Container(
        //            //     color: Colors.white,
        //            //     child:  ListTile(
        //            //       leading: Icon(Icons.school_outlined),
        //            //       subtitle:
        //            //       Text("2018 - 2022", style: TextStyle(fontSize: 18.sp)),
        //            //       title:
        //            //       Text("LEC Morbi", style: TextStyle(fontSize: 20.sp)),
        //            //       trailing: Icon(Icons.arrow_forward_ios),
        //            //     ),
        //            //   ),
        //            // ),
        //            // Padding(
        //            //   padding: EdgeInsets.symmetric(
        //            //       horizontal: 20.0.w, vertical: 5.h),
        //            //   child: Divider(
        //            //     thickness: 1,
        //            //     color: Colors.grey,
        //            //   ),
        //            // ),
        //            // Padding(
        //            //   padding:  EdgeInsets.symmetric(
        //            //       horizontal: 10.0.w, vertical: 5.h),
        //            //   child: Container(
        //            //     color: Colors.white,
        //            //     child:  ListTile(
        //            //       leading: Icon(Icons.school_outlined),
        //            //       subtitle:
        //            //       Text("Department", style: TextStyle(fontSize: 18.sp)),
        //            //       title: Text("Information Technology",
        //            //           style: TextStyle(fontSize: 20.sp)),
        //            //       trailing: Icon(Icons.arrow_forward_ios),
        //            //     ),
        //            //   ),
        //            // ),
        //            // Padding(
        //            //   padding: EdgeInsets.symmetric(
        //            //       horizontal: 20.0.w, vertical: 5.h),
        //            //   child: Divider(
        //            //     thickness: 1,
        //            //     color: Colors.grey,
        //            //   ),
        //            // ),
        //            // Padding(
        //            //   padding: EdgeInsets.symmetric(
        //            //       horizontal: 10.0.w, vertical: 5.h),
        //            //   child: Container(
        //            //     color: Colors.white,
        //            //     child:  ListTile(
        //            //       leading: Icon(Icons.school_outlined),
        //            //       subtitle:
        //            //       Text("Semester", style: TextStyle(fontSize: 18.sp)),
        //            //       title: Text("VIII", style: TextStyle(fontSize: 20.sp)),
        //            //       trailing: Icon(Icons.arrow_forward_ios),
        //            //     ),
        //            //   ),
        //            // ),
        //            // Padding(
        //            //   padding: EdgeInsets.symmetric(
        //            //       horizontal: 20.0.w, vertical: 5.h),
        //            //   child: Divider(
        //            //     thickness: 1,
        //            //     color: Colors.grey,
        //            //   ),
        //            // ),
        //
        //            buildItem("180310116019", "Enrollment"),
        //            Divider(
        //              thickness: 1,
        //            ),
        //            buildItem("2018 - 2022", "LEC Morbi"),
        //            Divider(
        //              thickness: 1,
        //            ),
        //            buildItem("Information Technology", "Department"),
        //            Divider(
        //              thickness: 1,
        //            ),
        //            buildItem("VIII", "Semester")
        //          ],
        //        ),
        //      )
        //   ],
        // ),
        );
  }

  Widget buildItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(Icons.school),
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
