import 'package:flutter/material.dart';
import 'package:order_tracking/main_layout.dart';
import 'package:order_tracking/screens/auth/forgot_password_code_screen.dart';
import 'package:order_tracking/screens/auth/forgot_password_email_screen.dart';
import 'package:order_tracking/screens/auth/forgot_password_reset_screen.dart';
import 'package:order_tracking/screens/edit_profile_screen.dart';
import 'package:order_tracking/screens/pages/on_boarding_screen.dart';
import 'package:order_tracking/screens/pages/route_page.dart';
import 'package:order_tracking/screens/sign_up.dart';
import 'package:order_tracking/screens/sing_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const RootPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Inter'),
      routes: {
        '/signup': (context) => const SignUp(),
        '/signin': (context) => const SignIn(),
        '/editprofile': (context) => EditProfileScreen(),
        '/tracking-input': (context) => MainLayout(selectedIndex: 2),
        '/forgot-password': (_) => const ForgotPasswordEmailScreen(),
        '/enter-code': (context) {
          final email = ModalRoute.of(context)!.settings.arguments as String;
          return ForgotPasswordCodeScreen(email: email);
        },
        '/reset-password': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return ForgotPasswordResetScreen(
            email: args['email'],
            code: args['code'],
          );
        },
      },
    );
  }
}
