import 'package:flutter/material.dart';

class HelpWidget extends StatelessWidget {
  const HelpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      color: const Color.fromARGB(255, 248, 249, 250),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need Help?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              '- Tracking Number can be found in your confirmation email',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 106, 105, 104),
              ),
            ),
            const Text(
              '- Try sample tracking numbers: COD1752766536978, COD1752766536979',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 106, 105, 104),
              ),
            ),
            const Text(
              '- Contact support if you need assistance',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 106, 105, 104),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
