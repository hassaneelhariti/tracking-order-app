import 'package:flutter/material.dart';
import 'package:order_tracking/main_layout.dart';
import 'package:order_tracking/screens/pages/on_boarding_screen.dart';
import 'package:order_tracking/screens/sing_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _loading = true;
  bool _showOnboarding = true;
  bool _loggedIn = false;

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if onboarding has been completed
    final onboardingDone = prefs.getBool('onboardingDone') ?? false;

    // Check if user token exists
    final token = await storage.read(key: 'jwt');

    setState(() {
      _showOnboarding = !onboardingDone;
      _loggedIn = token != null && token.isNotEmpty;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_showOnboarding) {
      return OnBoardingScreen(
        onFinished: () async {
          // Mark onboarding as done
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('onboardingDone', true);

          setState(() {
            _showOnboarding = false;
          });
        },
      );
    } else if (_loggedIn) {
      return MainLayout(selectedIndex: 0); // Home screen
    } else {
      return const SignIn();
    }
  }
}
