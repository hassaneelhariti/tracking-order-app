import 'package:flutter/material.dart';
import 'package:order_tracking/screens/shared_ui.dart';
import 'package:order_tracking/widgets/notification_panel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Header extends StatefulWidget {
  final String title;

  const Header({super.key, required this.title});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final storage = const FlutterSecureStorage();
  bool? isSignedIn;

  @override
  void initState() {
    super.initState();
    checkAuthStatus();
  }

  Future<bool> isUserSignedIn() async {
    final token = await storage.read(key: 'jwt');
    return token != null && token.isNotEmpty;
  }

  Future<void> checkAuthStatus() async {
    final signedIn = await isUserSignedIn();
    setState(() {
      isSignedIn = signedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isProfile = widget.title.trim().toLowerCase() == "profile";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        if (isSignedIn == true)
          IconButton(
            icon: Icon(isProfile ? Icons.logout : Icons.notifications_none),
            onPressed: () async {
              if (isProfile) {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Confirm Logout"),
                    content: const Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Confirm"),
                      ),
                    ],
                  ),
                );

                if (shouldLogout == true) {
                  await storage.delete(key: 'jwt');
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/signin',
                    (route) => false,
                  );
                }
              } else {
                showNotificationDialog(context);
              }
            },
          ),
      ],
    );
  }
}
