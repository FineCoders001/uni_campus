// Design Inspiration:https://dribbble.com/shots/16916440-Sign-Up-Login-Mobile-App/attachments/11984787?mode=media
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_campus/Authentication/login_screen.dart';
import 'package:uni_campus/Users/Screens/onboarding_screen.dart';

import '../Users/Screens/onboarding_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var isLoading = false;
  final _auth = FirebaseAuth.instance;
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  late UserCredential user;

  void trySubmit() async {
    setState(() {
      isLoading = true;
    });

    //CircularProgressIndicator();

    final isValid = _formkey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (!isValid!) {
      return;
    }
    // _formkey.currentState?.save();

    user = await _auth.createUserWithEmailAndPassword(
        email: emailText.text.trim(), password: passwordText.text.trim());
    await Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const OnBoarding()), (_) => false);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromARGB(255, 73, 128, 255),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 50),
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.ubuntu(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formkey,
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50.0, vertical: 10),
                              child: Image.asset("assets/images/Login.png"),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextFormField(
                                    controller: emailText,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: "Email",
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

                                    //validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextFormField(
                                    controller: passwordText,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: "Password",
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
                                    validator: (value) {
                                      if (value != null && value.length < 8) {
                                        return "Password must be atleast 8 characters long";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            // GestureDetector(
                            //   onTap: () => {},
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Container(
                            //       alignment: Alignment.centerRight,
                            //       child: Text(
                            //         "Forgot Password?",
                            //         style: GoogleFonts.ubuntu(
                            //             fontSize: 15,
                            //             color:
                            //                 const Color.fromARGB(255, 73, 128, 255)),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                trySubmit();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 73, 128, 255),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Sign Up",
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 25, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () async => {
                                await Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const LoginScreen()),
                                    (_) => false)
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Already have an account? Sign In",
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
