import 'package:flutter/material.dart';

class ForgotPasswordCodeScreen extends StatefulWidget {
  final String email;
  const ForgotPasswordCodeScreen({super.key, required this.email});

  @override
  State<ForgotPasswordCodeScreen> createState() => _ForgotPasswordCodeScreenState();
}

class _ForgotPasswordCodeScreenState extends State<ForgotPasswordCodeScreen> {
  final TextEditingController codeController = TextEditingController();
  String? error;

  void goToReset() {
    if (codeController.text.trim().isEmpty) {
      setState(() => error = 'Please enter the reset code');
      return;
    }
    Navigator.pushNamed(
      context,
      '/reset-password',
      arguments: {'email': widget.email, 'code': codeController.text.trim()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Reset Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Check your email (${widget.email}) for the 6-digit code'),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Reset Code'),
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: goToReset,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
