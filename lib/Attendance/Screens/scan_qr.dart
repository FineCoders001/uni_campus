import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/Attendance/Models/attend.dart';
import 'package:uni_campus/Attendance/Screens/view_list.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';

class ScanQR extends StatefulHookConsumerWidget {
  final dynamic department;
  final dynamic semester;
  final dynamic year;
  final dynamic month;
  final dynamic subject;
  final dynamic date;
  final dynamic facultyName;
  const ScanQR(
      {Key? key,
      required this.department,
      required this.year,
      required this.month,
      required this.subject,
      required this.semester,
      required this.date,
      required this.facultyName})
      : super(key: key);

  @override
  _ScanQRState createState() => _ScanQRState();
}

String scanRes = "";
//late List<String> l;
late Attend at;
//var at = Attend(dept: de, year: ye, semester: se);

class _ScanQRState extends ConsumerState<ScanQR> {
  late Map<String, dynamic> user;
  @override
  void initState() {
    user = ref.read(userCrudProvider).user;
    at = Attend(
        facultyName: widget.facultyName,
        dept: widget.department,
        year: widget.year,
        month: widget.month,
        subject: widget.subject,
        semester: widget.semester,
        map: <String>[],
        date: widget.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 138, 63),
        elevation: 0,
        centerTitle: true,
        title: const Text("Scan QR"),
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    color:
                                        const Color.fromARGB(255, 65, 198, 255),
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
                                    color:
                                        const Color.fromARGB(255, 65, 198, 255),
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
                                    color:
                                        const Color.fromARGB(255, 65, 198, 255),
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
                          at.facultyName.toString(),
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${at.dept.toString()}   ${at.semester}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Divider(thickness: 1),
                      ),
                      ListTile(
                        title: Text(" Subject : " + at.subject),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Date : " +
                                DateFormat('dd MMM yyyy')
                                    .format(DateTime.parse(
                                        at.date.toString().substring(0, 10)))
                                    .toString()),
                            Text("Time : " +
                                at.date.toString().substring(11, 16))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 8),
                      child: InkWell(
                        onTap: _scan,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 60, 138, 63),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Capture QR',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                              Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 8),
                      child: InkWell(
                        onTap: () {
                          if (scanRes == "") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.redAccent,
                                duration: Duration(milliseconds: 1500),
                                content: Text(
                                  'Please Scan QR first',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          } else if (at.map.contains(scanRes)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.blueAccent,
                                duration: Duration(milliseconds: 1500),
                                content: Text(
                                  'Already Added',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          } else {
                            at.map.add(scanRes);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.greenAccent,
                                duration: const Duration(milliseconds: 1500),
                                content: Text(
                                  'Added $scanRes to the list',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 60, 138, 63),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              scanRes == ""
                                  ? const Text(
                                      'Add Enrollment',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.white),
                                    )
                                  : Text(
                                      'Add: $scanRes',
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.white),
                                    ),
                              const Icon(
                                Icons.person_add_outlined,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ViewList(d: at),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 60, 138, 63),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Check Student list',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                              Icon(
                                Icons.list_alt_rounded,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scan() async {
    final result = await BarcodeScanner.scan();
    setState(
      () {
        scanRes = result.rawContent.toString().substring(0, 12);
      },
    );
  }
}
