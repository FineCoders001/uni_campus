import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_campus/EventManagement/Screens/home_screen.dart';
import 'package:uni_campus/Users/user.dart';
import 'package:uni_campus/userCrud.dart';

import 'main.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  //final _fkey = GlobalKey<FormState>;
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
              flex: 15,
              child: PageView.builder(
                itemCount: l.length,
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  if (index <= l.length - 2) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(bottom: 15, top: 100),
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
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(bottom: 15, top: 100),
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

                          GestureDetector(
                            onTap: () async {
                              await Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(
                                      builder: (_) => const ProfileForm()), (
                                      _) => false);
                            },
                            child: Container(
                              width: 3 * MediaQuery
                                  .of(context)
                                  .size
                                  .width / 4,
                              padding: const EdgeInsets.all(15),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                color: Color.fromARGB(255, 73, 128, 255),
                              ),
                              child: const Center(
                                  child: Text(
                                    "Start your journey",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  )),
                            ),
                          )
                        ],
                      ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(l.length,
                            (index) => _builddots(index, _currentpage)),
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

class ProfileForm extends StatefulWidget {
  const ProfileForm({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _fkey = GlobalKey<FormState>();
  var isLoading = false;
  String role = "";

  UserProfile user = UserProfile(
    userName: "",
    enroll: "",
    collegename: "",
    deptname: "",
    semester: "",
    enyear: "",
    styear: "",
    role: "",
  );

  UserProfile userFaculty = UserProfile(
      userName: "",
      collegename: "",
      deptname: "",
      role: ""
  );

  show(context) async {
    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            title: Text("kkj"),
            content: Text("jgjhguhhui"),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  //return;
                },
              )
            ],
          ),
    );
  }


  void trySubmit() async {
    try {
      setState(() {
        isLoading = true;
      });

      //CircularProgressIndicator();
      final isValid = _fkey.currentState?.validate();
      FocusScope.of(context).unfocus();
      if (!isValid!) {
        return;
      }
      _fkey.currentState?.save();
      if(role=="student"){
        await obj.add(user);
      }else{
        await obj.add(userFaculty);
      }

      await Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      //show('Oops!', 'Something went wrong');
    }
  }


  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(
            (_) => _showStartDialog()
    );
  }

  Future<void> _showStartDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Specify your role'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[

                Text('Are you a student or faculty'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Student'),
              onPressed: () {

                setState(() {
                  role = "student";
                  Navigator.of(context).pop();

                });
              },
            ),
            TextButton(
              child: Text('Faculty'),
              onPressed: () {
                role = "faculty";
                Navigator.of(context).pop();
               setState(() {

               });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("enter hua");

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 27,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 73, 128, 255),
                        Colors.white
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: SizedBox(
                height: 5 * MediaQuery
                    .of(context)
                    .size
                    .height / 8,
                child: Center(
                  child: Form(
                    key: _fkey,
                    child: SingleChildScrollView(
                        child: role == "student" ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a Username";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Username",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                ),
                                onSaved: (value) {
                                  user = UserProfile(
                                    userName: value.toString().trim(),
                                    enroll: user.enroll,
                                    collegename: user.collegename,
                                    deptname: user.deptname,
                                    semester: user.semester,
                                    enyear: user.enyear,
                                    styear: user.enyear,
                                    role: role,

                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a valid enrollment number";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Enrollment Number",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                ),
                                onSaved: (value) {
                                  user = UserProfile(
                                      userName: user.userName,
                                      enroll: value.toString().trim(),
                                      collegename: user.collegename,
                                      deptname: user.deptname,
                                      semester: user.semester,
                                      enyear: user.enyear,
                                      styear: user.enyear,
                                      role: user.role
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a valid string";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "College Name",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                ),
                                onSaved: (value) {
                                  user = UserProfile(
                                      userName: user.userName,
                                      enroll: user.enroll,
                                      collegename: value.toString().trim(),
                                      deptname: user.deptname,
                                      semester: user.semester,
                                      enyear: user.enyear,
                                      styear: user.enyear,
                                      role: user.role
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a valid name";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Department Name",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                ),
                                onSaved: (value) {
                                  user = UserProfile(
                                      userName: user.userName,
                                      enroll: user.enroll,
                                      collegename: user.collegename,
                                      deptname: value.toString().trim(),
                                      semester: user.semester,
                                      enyear: user.enyear,
                                      styear: user.enyear,
                                      role: user.role
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enbter a valid value";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Current Semester",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                ),
                                onSaved: (value) {
                                  user = UserProfile(
                                      userName: user.userName,
                                      enroll: user.enroll,
                                      collegename: user.collegename,
                                      deptname: user.deptname,
                                      semester: value.toString().trim(),
                                      enyear: user.enyear,
                                      styear: user.enyear,
                                      role: user.role
                                  );
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a valid value";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Batch Starting Year (Ex:2018)",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                ),
                                onSaved: (value) {
                                  user = UserProfile(
                                      userName: user.userName,
                                      enroll: user.enroll,
                                      collegename: user.collegename,
                                      deptname: user.deptname,
                                      semester: user.semester,
                                      enyear: value.toString().trim(),
                                      styear: user.enyear,
                                      role: user.role
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a valid value";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Batch Ending Year (Ex:2022)",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                ),
                                onSaved: (value) {
                                  user = UserProfile(
                                      userName: user.userName,
                                      enroll: user.enroll,
                                      collegename: user.collegename,
                                      deptname: user.deptname,
                                      semester: user.semester,
                                      enyear: user.enyear,
                                      styear: value.toString().trim(),
                                      role: user.role
                                  );
                                },
                              ),
                            ),
                          ],
                        ) : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a Username";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Username",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                ),
                                onSaved: (value) {
                                  userFaculty = UserProfile(
                                      userName:value.toString().trim(),
                                      collegename: userFaculty.collegename,
                                      role: role
                                  );
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a valid string";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "College Name",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 73, 128, 255),
                                        width: 2.5),
                                  ),
                                ),
                                onSaved: (value) {
                                  userFaculty = UserProfile(
                                      userName:userFaculty.userName,
                                      collegename: value.toString().trim(),
                                      role: role
                                  );
                                },
                              ),
                            ),

                          ],
                        )
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                trySubmit();
              },
              child: Container(
                width: 3 * MediaQuery
                    .of(context)
                    .size
                    .width / 4,
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
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_fkey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("DONE")));
    } else {}
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
