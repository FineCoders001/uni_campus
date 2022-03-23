import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQr extends StatelessWidget {
  const GenerateQr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 138, 63),
        elevation: 0,
        centerTitle: true,
        title: const Text("Generate QR"),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Qr generated successfully",
              style:
                  GoogleFonts.ubuntu(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            QrImage(
              data: FirebaseAuth.instance.currentUser!.email.toString() +
                  " " +
                  DateTime.now().toString(),
              version: QrVersions.auto,
              size: 200,
            ),
          ],
        ),
      ),
    );
  }
}
