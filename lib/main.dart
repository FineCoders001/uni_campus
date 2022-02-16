import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/Authentication/registration_screen.dart';
import 'package:uni_campus/EventManagement/Screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
   runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(411.42857142857144, 866.2857142857143),
      //minTextAdapt: true,
      //splitScreenMode: true,
      builder: () =>
       MaterialApp(
        debugShowCheckedModeBanner: false,
        //home: ApproveEvent()
        home: StreamBuilder(
          // stream: FirebaseAuth.instance.authStateChanges(),
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (userSnapshot.hasData) {
              return const HomeScreen();
            } else if (userSnapshot.hasError) {
              return const Center(
                child: Text(
                  "Something Went Wrong",
                  style: TextStyle(fontSize: 16),
                ),
              );
            } else {
              return const RegistrationScreen();
            }
          },
        ),
      ),
    );
  }
}
