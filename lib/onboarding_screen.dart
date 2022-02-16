import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_campus/EventManagement/Screens/home_screen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final List<Map<String, String>> l = [
    {
      "title": "EVENTS",
      "subtitle": "Know, Create and Participate.",
      "info": "Get information of events in your college.",
      "image": "assets/images/Login.png",
    },
    {
      "title": "LIBRARY",
      "subtitle": "Issue, Request and Return.",
      "info": "Now Digitally..",
      "image": "assets/images/Login.png",
    },
    {
      "title": "AND MUCH MORE...",
      "subtitle": "On your fingertips",
      "info": "Start now",
      "image": "assets/images/Login.png",
    },
    // {
    //   "title": "SET PROFILE",
    //   "subtitle": "On your fingertips",
    //   "info": "Start now",
    //   "image": "assets/images/Login.png",
    // }
  ];
  final _controller = PageController();
  var _currentpage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   shadowColor: Colors.transparent,
      // ),
      backgroundColor: Colors.white,
      body: DefaultTextStyle(
        style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 15),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: PageView.builder(
                itemCount: l.length + 1,
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  if (index <= l.length - 1) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15, top: 100),
                          child: Text(l[index]["title"]!,
                              style: const TextStyle(fontSize: 30)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            l[index]["subtitle"]!,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        Text(l[index]["info"]!),
                        Image.asset(l[index]["image"]!),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text("hello", style: TextStyle(fontSize: 27)),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                decoration:
                                    const BoxDecoration(color: Colors.blue),
                                child: const Text("Hellodasd"),
                              ),
                            ],
                          ),
                        ),
                        // const Padding(
                        //   padding: EdgeInsets.all(10),
                        //   child: Text(
                        //     "dummy",
                        //     style: TextStyle(fontSize: 20),
                        //   ),
                        // ),
                        // Text(l[index]["info"]!),
                        // Image.asset(l[index]["image"]!),
                        // const SizedBox(
                        //   height: 40,
                        // ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                          },
                          child: Container(
                            width: 3 * MediaQuery.of(context).size.width / 4,
                            padding: const EdgeInsets.all(15),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                              color: Color.fromARGB(255, 73, 128, 255),
                            ),
                            child: const Center(
                                child: Text(
                              "CREATE PROFILE",
                              style: TextStyle(fontSize: 20),
                            )),
                          ),
                        )
                      ],
                    );
                  }
                },
                onPageChanged: (value) => setState(() {
                  _currentpage = value;
                }),
              ),
            ),
            // const SizedBox(
            //   height: 100,
            // ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(l.length + 1,
                          (index) => _builddots(index, _currentpage)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

AnimatedContainer _builddots(int index, int _currentpage) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      color: Color.fromARGB(255, 73, 128, 255),
    ),
    margin: const EdgeInsets.only(right: 5),
    height: 10,
    curve: Curves.easeIn,
    width: _currentpage == index ? 20 : 10,
  );
}
