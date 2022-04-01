// Design Inspiration:https://dribbble.com/shots/16916440-Sign-Up-Login-Mobile-App/attachments/11984787?mode=media
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_campus/Authentication/forgot_password.dart';
import 'package:uni_campus/Authentication/registration_screen.dart';
import 'package:uni_campus/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Map<String, String> user = {
  //   "email": "",
  //   "password": "",
  // };
  final econ = TextEditingController();
  final pcin = TextEditingController();
  final _fkey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    econ.dispose();
    pcin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: const Color.fromARGB(255, 2, 229, 202),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Text(
                "Log In",
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
                  key: _fkey,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 10),
                          child: Image.asset("assets/images/Login.jpg"),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: econ,
                              // onSaved: (value) {
                              //   user["email"] = value.toString();
                              // },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a valid email";
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 2, 229, 202),
                                      width: 2.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 2, 229, 202),
                                      width: 2.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 2, 229, 202),
                                      width: 2.5),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: pcin,
                              // onSaved: (newValue) {
                              //   user["password"] = newValue.toString();
                              // },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a valid password";
                                } else {
                                  return null;
                                }
                              },
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 2, 229, 202),
                                      width: 2.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 2, 229, 202),
                                      width: 2.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 2, 229, 202),
                                      width: 2.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      const ForgotPassword())));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot Password?",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 15,
                                  color:
                                      const Color.fromARGB(255, 2, 229, 202)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            _submit();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 2, 229, 202),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Login",
                                style: GoogleFonts.ubuntu(
                                    fontSize: 25, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async => {
                          await Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegistrationScreen()),
                              (_) => false)
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Don't have an account? Sign Up",
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

  void _submit() async {
    if (_fkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: econ.text.trim(), password: pcin.text.trim());
        currentUser = FirebaseAuth.instance.currentUser;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1500),
            content:
                Text(e.toString().split("] ")[1], textAlign: TextAlign.center),
          ),
        );
      }
    }
  }
}
