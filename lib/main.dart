import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/Authentication/login_screen.dart';
import 'package:uni_campus/Authentication/registration_screen.dart';
import 'package:uni_campus/EventManagement/Screens/home_screen.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';
import 'package:uni_campus/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions _f = const FirebaseOptions(
      apiKey: "AIzaSyCck4jYwBKMTba1LVHrJXHFTy1zuEyBmxg",
      authDomain: "unicampus-c2d20.firebaseapp.com",
      projectId: "unicampus-c2d20",
      storageBucket: "unicampus-c2d20.appspot.com",
      messagingSenderId: "142536551485",
      appId: "1:142536551485:web:1603614567f6e4909cce54",
      measurementId: "G-FCRTTT21CT");
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(name: "UniCampus", options: _f);
  } else {
    await Firebase.initializeApp(options: _f);
  }
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
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: Onboarding(),
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
              return const LoginScreen();
              // return const RegistrationScreen();
            }
          },
        ),
      ),
    );
  }
}
