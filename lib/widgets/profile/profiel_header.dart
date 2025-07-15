import 'package:flutter/material.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.teal,
                child: Text(
                  "JD",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.edit, size: 16, color: Colors.teal),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "John Doe",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const Text("john.doe@email.com", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text("Edit Profile")),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: () {}, child: const Text("Share")),
          ],
        ),
      ],
    );
  }
}
