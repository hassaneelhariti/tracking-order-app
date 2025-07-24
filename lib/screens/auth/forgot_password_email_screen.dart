import 'package:flutter/material.dart';
import 'package:order_tracking/services/auth_service.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() => _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  String? error;

  void sendCode() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final success = await AuthService.sendResetCode(emailController.text);
    setState(() => isLoading = false);

    if (success) {
      Navigator.pushNamed(context, '/enter-code', arguments: emailController.text);
    } else {
      setState(() => error = 'Email not found or failed to send code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Enter your email to receive a reset code.'),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : sendCode,
              child: isLoading ? const CircularProgressIndicator() : const Text('Send Code'),
            ),
          ],
        ),
      ),
    );
  }
}
