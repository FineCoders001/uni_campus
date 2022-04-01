import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/Attendance/Models/attend.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';
import 'package:intl/intl.dart';

class ViewList extends StatefulHookConsumerWidget {
  final Attend d;

  const ViewList({Key? key, required this.d}) : super(key: key);

  @override
  _ViewListState createState() => _ViewListState();
}

class _ViewListState extends ConsumerState<ViewList> {
  late Map<String, dynamic> user;
  @override
  void initState() {
    user = ref.read(userCrudProvider).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await addAttendance();
        },
        label: const Text(
          "Submit",
          style: TextStyle(fontSize: 20),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 138, 63),
        elevation: 0,
        centerTitle: true,
        title: const Text("Attendance List"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(33.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [BoxShadow(blurRadius: 4)]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: user['profilePicture'] == ""
                        ? SizedBox(
                            height: 96,
                            width: 96,
                            child: ClipOval(
                              child: Material(
                                elevation: 5.0,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                color: const Color.fromARGB(255, 65, 198, 255),
                                child: Center(
                                  child: Text(
                                    user['userName'][0],
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.white,
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : CachedNetworkImage(
                            fit: BoxFit.cover,
                            width: 96,
                            height: 96,
                            imageUrl: user['profilePicture'],
                            placeholder: (context, url) => ClipOval(
                              child: Material(
                                elevation: 5.0,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                color: const Color.fromARGB(255, 65, 198, 255),
                                child: Center(
                                  child: Text(
                                    user['userName'][0],
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.white,
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => ClipOval(
                              child: Material(
                                elevation: 5.0,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                color: const Color.fromARGB(255, 65, 198, 255),
                                child: Center(
                                  child: Text(
                                    user['userName'][0],
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.white,
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      widget.d.facultyName.toString(),
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.d.dept.toString()}   ${widget.d.semester}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Divider(thickness: 1),
                  ),
                  ListTile(
                    title: Text(" Subject : " + widget.d.subject),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Date : " +
                            DateFormat('dd MMM yyyy')
                                .format(DateTime.parse(
                                    widget.d.date.toString().substring(0, 10)))
                                .toString()),
                        Text("Time : " +
                            widget.d.date.toString().substring(11, 16))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ListTile(
          //   title: Text("Faculty : " + widget.d.facultyName),
          //   subtitle: Text("Department : " + widget.d.dept),
          // ),
          // ListTile(
          //   title: Text("Subject : " +
          //       widget.d.subject +
          //       " Semester : " +
          //       widget.d.semester),
          // ),
          // ListTile(
          //   title: Text(
          //     "Date : " +
          //         widget.d.date.substring(0, 10) +
          //         " Time : " +
          //         widget.d.date.substring(11, 16),
          //   ),
          // ),
          widget.d.map.isEmpty
              ? const Text(
                  "No students added",
                  style: TextStyle(fontSize: 25),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 18.0, left: 25, right: 25),
                    child: Scrollbar(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (3 / 1),
                          mainAxisSpacing: 10,
                        ),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color.fromARGB(255, 60, 138, 63),
                              ),
                              child: Text(
                                widget.d.map[index],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          );
                        },
                        itemCount: widget.d.map.length,
                      ),
                    ),
                  ),
                ),

          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.60,
          //   child: Container(
          //     child: widget.d.map.isEmpty
          //         ? const Center(
          //             child: Text("No Data Added"),
          //           )
          //         : ListView.builder(
          //             itemCount: widget.d.map.length,
          //             itemBuilder: (context, index) {
          //               return Padding(
          //                 padding: const EdgeInsets.all(10.0),
          //                 child: Container(
          //                   decoration: BoxDecoration(
          //                       color: Colors.white,
          //                       borderRadius: BorderRadius.circular(5),
          //                       boxShadow: const [BoxShadow(blurRadius: 4)]),
          //                   child: ListTile(
          //                     leading: CircleAvatar(
          //                       backgroundColor: Colors.grey,
          //                       child: Text(
          //                         index.toString(),
          //                         style: const TextStyle(color: Colors.white),
          //                       ),
          //                     ),
          //                     title: Text(widget.d.map[index]),
          //                   ),
          //                 ),
          //               );
          //             },
          //           ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<void> addAttendance() async {
    await FirebaseFirestore.instance
        .collection("Attendance")
        .doc(widget.d.year)
        .collection(widget.d.month)
        .doc(widget.d.semester)
        .collection(widget.d.dept)
        .add(widget.d.toJson())
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                duration: Duration(milliseconds: 1500),
                content: Text('Data Added Successfully',
                    textAlign: TextAlign.center))));
  }
}
