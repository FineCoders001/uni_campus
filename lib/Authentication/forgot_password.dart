import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _k = GlobalKey<FormState>();

  final recon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
            key: _k,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: recon,
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
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 168, 176, 194),
                          width: 2.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 73, 128, 255), width: 2.5),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => reset(recon.text.trim()),
                  child: Container(
                    child: const Text("Reset Password"),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 73, 128, 255),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

Future reset(String em) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: em);
}
