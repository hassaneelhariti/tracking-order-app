import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:order_tracking/services/profile_service.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  Map<String, dynamic>? userData;
  Uint8List? profileImageBytes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final data = await ProfileService().getUserProfile();

      // If profileImageUrl exists, fetch image bytes
      Uint8List? imageBytes;
      if (data['profileImageUrl'] != null) {
        imageBytes = await ProfileService().getProfileImage(
          data['profileImageUrl'],
        );
      }

      setState(() {
        userData = data;
        profileImageBytes = imageBytes;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Failed to fetch user data: $e');
      setState(() {
        userData = null;
        profileImageBytes = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userData == null) {
      return const Center(child: Text('Failed to load user data'));
    }

    final username = userData?['username'] ?? 'User';
    final email = userData?['email'] ?? 'email@example.com';
    final firstLetter = username.isNotEmpty
        ? username.trim().substring(0, 1).toUpperCase()
        : 'U';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.teal,
                backgroundImage: profileImageBytes != null
                    ? MemoryImage(profileImageBytes!)
                    : null,
                child: profileImageBytes == null
                    ? Text(
                        firstLetter,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "@$username",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(email, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/editprofile');
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: const BorderSide(color: Colors.grey),
          ),
          child: const Text("Edit Profile", style: TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}
