import 'package:flutter/material.dart';

class PersonalInfoTab extends StatelessWidget {
  const PersonalInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Later: replace these with values from your API response
    final userData = {
      'firstName': 'John',
      'lastName': 'Doe',
      'email': 'john.doe@email.com',
      'phone': '+1 (555) 123-4567',
      'street': '123 Main Street',
      'city': 'New York',
      'zip': '10001',
    };

    return Column(
      children: [
        sectionCard("Personal Information", [
          infoRow("First Name", userData['firstName']!),
          infoRow("Last Name", userData['lastName']!),
          infoRow("Email", userData['email']!),
          infoRow("Phone", userData['phone']!),
        ]),
        sectionCard("Address Information", [
          infoRow("Street Address", userData['street']!),
          infoRow("City", userData['city']!),
          infoRow("Postal Code", userData['zip']!),
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
                Text("Edit", style: TextStyle(color: Colors.teal.shade700)),
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
