import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uni_campus/main.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class SyllabusScreen extends StatefulWidget {
  const SyllabusScreen({Key? key}) : super(key: key);

  @override
  State<SyllabusScreen> createState() => _SyllabusScreenState();
}

class _SyllabusScreenState extends State<SyllabusScreen> {
  int _pageIndex = 0;
  late List<Widget> tabPages;
  late PageController _pageController;
  @override
  void initState() {
    tabPages = const [DownloadSyllabusTab(), DownloadedSyllabusTab()];
    _pageController = PageController(initialPage: _pageIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text("Syllabus"),
      ),
      key: _scaffoldKey,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Search Online',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_done_rounded),
            label: 'Downloaded',
          ),
        ],
        currentIndex: _pageIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.pinkAccent,
      ),
      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}

class DownloadSyllabusTab extends StatefulWidget {
  const DownloadSyllabusTab({Key? key}) : super(key: key);

  @override
  State<DownloadSyllabusTab> createState() => _DownloadSyllabusTabState();
}

class _DownloadSyllabusTabState extends State<DownloadSyllabusTab> {
  TextEditingController subCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              controller: subCode,
              decoration: const InputDecoration(
                hintText: "Subject Code",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.5),
                ),
              ),
            ),
            InkWell(
              onTap: (() async {
                HttpClient httpClient = HttpClient();
                String localPath =
                    "/storage/emulated/0/Android/data/com.example.uni_campus/files/Syllabus";
                File file;
                var code = subCode.text.toString();
                try {
                  var request = await httpClient.getUrl(Uri.parse(
                      'https://s3-ap-southeast-1.amazonaws.com/gtusitecirculars/Syallbus/$code.pdf'));
                  var response = await request.close();
                  if (response.statusCode == 200) {
                    var bytes =
                        await consolidateHttpClientResponseBytes(response);
                    final path = Directory(localPath);
                    if (!(await path.exists())) {
                      path.create();
                    }
                    file = File("$localPath/$code.pdf");
                    await file.writeAsBytes(bytes);
                    OpenFile.open("$localPath/$code.pdf");
                  } else {
                    buildSnackBar(context, Colors.redAccent,
                        'Please Check Subject code.');
                  }
                } catch (error) {
                  buildSnackBar(
                      context, Colors.redAccent, "Something went wrong");
                }
              }),
              child: Container(
                width: 150,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Download",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DownloadedSyllabusTab extends StatefulWidget {
  const DownloadedSyllabusTab({Key? key}) : super(key: key);

  @override
  State<DownloadedSyllabusTab> createState() => _DownloadedSyllabusTabState();
}

class _DownloadedSyllabusTabState extends State<DownloadedSyllabusTab> {
  late List<FileSystemEntity> _folders;
  bool search = false;
  List<String> subjectList = [];
  List<String> searchResult = [];
  TextEditingController searchCode = TextEditingController();
  @override
  void dispose() {
    searchCode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    searchCode.addListener(() {});
    final myDir = Directory(
        "/storage/emulated/0/Android/data/com.example.uni_campus/files/Syllabus");
    if (myDir.existsSync()) {
      setState(() {
        _folders = myDir.listSync(recursive: true, followLinks: false);
      });
      for (int i = 0; i < _folders.length; i++) {
        subjectList.add(_folders[i].toString().split('/')[9].substring(0, 7));
        searchResult.add(_folders[i].toString().split('/')[9].substring(0, 7));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            color: Colors.white,
          ),
          child: ListTile(
            trailing: const Icon(Icons.search_rounded),
            title: TextFormField(
              keyboardType: TextInputType.number,
              controller: searchCode,
              onChanged: ((value) {
                setState(() {
                  searchResult = subjectList.where((element) {
                    final result = element.toLowerCase();
                    final input = value.toLowerCase();
                    return result.contains(input);
                  }).toList();
                });
              }),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Subject Code",
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: ListView.builder(
          itemCount: searchResult.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Subject Code: ${searchResult[index]}",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: (() async {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Delete this file?"),
                              content: Text(
                                  'This will delete ${searchResult[index]}.pdf permanently.'),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      var myDir = File(_folders[index].path);
                                      await myDir.delete();
                                      setState(() {
                                        subjectList.removeAt(index);
                                        searchResult = subjectList;
                                      });
                                    } catch (e) {
                                      buildSnackBar(context, Colors.redAccent,
                                          'Something Went Wrong');
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "No",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                      IconButton(
                        onPressed: (() => OpenFile.open(_folders[index].path)),
                        icon: const Icon(
                          Icons.open_in_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
