import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';

class GenerateQr extends StatefulHookConsumerWidget {
  const GenerateQr({Key? key}) : super(key: key);

  @override
  _GenerateQrState createState() => _GenerateQrState();
}

class _GenerateQrState extends ConsumerState<GenerateQr> {
  late String enroll;
  @override
  void initState() {
    enroll = ref.read(userCrudProvider).user["enroll"].toString();
    super.initState();
  }

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
              data: enroll + " " + DateTime.now().toString(),
              version: QrVersions.auto,
              size: 200,
            ),
          ],
        ),
      ),
    );
  }
}
