import 'package:flutter/material.dart';
import 'package:order_tracking/main_layout.dart';
import 'package:order_tracking/screens/edit_profile_screen.dart';
import 'package:order_tracking/screens/pages/on_boarding_screen.dart';
import 'package:order_tracking/screens/sign_up.dart';
import 'package:order_tracking/screens/sing_in.dart';
import 'package:order_tracking/screens/tracking_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnBoardingScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        // You can customize further styles here if needed
      ),
      routes: {
        '/signup': (context) => const SignUp(),
        '/signin': (context) => const SignIn(),
        '/editprofile': (context) => EditProfileScreen(),
        '/tracking-input': (context) => MainLayout(selectedIndex: 2),
      },
    );
  }
}
