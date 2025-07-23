import 'package:flutter/material.dart';
import 'package:order_tracking/services/auth_service.dart';

class PersonalInfoTab extends StatefulWidget {
  const PersonalInfoTab({super.key});

  @override
  State<PersonalInfoTab> createState() => _PersonalInfoTabState();
}

class _PersonalInfoTabState extends State<PersonalInfoTab> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final data = await AuthService().getUserProfile();
      setState(() {
        userData = data;
      });
    } catch (e) {
      print('Failed to fetch user data: $e');
      //To do  You could set an error flag here and show a message instead.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        sectionCard("Personal Information", [
          infoRow("Username", userData!['username'] ?? 'N/A'),
          infoRow("Email", userData!['email'] ?? 'N/A'),
        ]),
        sectionCard("Address Information", [
          infoRow(
            "Street Address",
            userData!['streetAddress'] ?? 'Not provided',
          ),
          infoRow("City", userData!['city'] ?? 'Not provided'),
          infoRow("Postal Code", userData!['zipCode'] ?? 'Not provided'),
        ]),
      ],
    );
  }

  Widget sectionCard(String title, List<Widget> content) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...content,
          ],
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
