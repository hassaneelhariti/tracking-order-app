import 'package:flutter/material.dart';

class SecurityTab extends StatelessWidget {
  const SecurityTab({super.key});

  Widget securityTile(
    IconData icon,
    String title,
    String subtitle, {
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 0,
      color: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          securityTile(
            Icons.lock,
            "Change Password",
            "Update your account password",
          ),
          securityTile(
            Icons.security,
            "Two-Factor Authentication",
            "Add an extra layer of security",
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Disabled",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          securityTile(
            Icons.history,
            "Login History",
            "View recent account activity",
          ),
        ],
      ),
    );
  }
}
