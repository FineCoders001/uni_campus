import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final List<Map<String, String>> l = [
    {
      "title": "Page 1",
      "subtitle": "Page 1 info",
      "image": "assets/images/Login.png",
    },
    {
      "title": "Page 2",
      "subtitle": "Page 2 info",
      "image": "assets/images/Login.png",
    },
    {
      "title": "Page 3",
      "subtitle": "Page info",
      "image": "assets/images/Login.png",
    }
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
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: PageView.builder(
              itemCount: l.length,
              controller: _controller,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, top: 100),
                      child: Text(l[index]["title"]!,
                          style: const TextStyle(fontSize: 27)),
                    ),
                    Text(l[index]["subtitle"]!),
                    Image.asset(l[index]["image"]!),
                  ],
                );
              },
              onPageChanged: (value) => setState(() {
                _currentpage = value;
              }),
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          l.length, (index) => _builddots(index, _currentpage)),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}

AnimatedContainer _builddots(int index, int _currentpage) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: Colors.cyan),
    margin: const EdgeInsets.only(right: 5),
    height: 10,
    curve: Curves.easeIn,
    width: _currentpage == index ? 20 : 10,
  );
}
