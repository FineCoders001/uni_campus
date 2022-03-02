import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:uni_campus/LibraryManagement/Screens/add_book_screen.dart';


import 'Authentication/login_screen.dart';


import 'LibraryManagement/Screens/book_details_screen.dart';
import 'home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        name: "UniCampus",
        options: const FirebaseOptions(
            apiKey: "AIzaSyCck4jYwBKMTba1LVHrJXHFTy1zuEyBmxg",
            authDomain: "unicampus-c2d20.firebaseapp.com",
            projectId: "unicampus-c2d20",
            storageBucket: "unicampus-c2d20.appspot.com",
            messagingSenderId: "142536551485",
            appId: "1:142536551485:web:1603614567f6e4909cce54",
            measurementId: "G-FCRTTT21CT"));
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCck4jYwBKMTba1LVHrJXHFTy1zuEyBmxg",
            authDomain: "unicampus-c2d20.firebaseapp.com",
            projectId: "unicampus-c2d20",
            storageBucket: "unicampus-c2d20.appspot.com",
            messagingSenderId: "142536551485",
            appId: "1:142536551485:web:1603614567f6e4909cce54",
            measurementId: "G-FCRTTT21CT"));
  }
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

//Store o =new Store();
User? currentUser = FirebaseAuth.instance.currentUser;

class MyApp extends StatefulHookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      //designSize: Size(411.42857142857144, 866.2857142857143),
      //minTextAdapt: true,
      //splitScreenMode: true,
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        // home:ApproveBookRequestScreen(),
        home: StreamBuilder(
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
        routes: {
          BookDetailsScreen.routename: ((context) =>  const BookDetailsScreen()),
          AddBookScreen.routeName:(ctx) => const AddBookScreen(),
        },
      ),
    );
  }
}

