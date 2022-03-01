import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IssuedBookScreen extends StatefulWidget {
  const IssuedBookScreen({Key? key}) : super(key: key);

  @override
  _IssuedBookScreenState createState() => _IssuedBookScreenState();
}

class _IssuedBookScreenState extends State<IssuedBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Issued Book"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: Text(
                "Requested Books",
                style: GoogleFonts.ubuntu(fontSize: 25),
              ),
            ),
            Card(
              child: Text(
                "Approved Books",
                style: GoogleFonts.ubuntu(fontSize: 25),
              ),
            )
          ],
        ),
      ),
    );
  }
}
