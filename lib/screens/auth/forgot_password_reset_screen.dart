import 'package:flutter/material.dart';
import 'package:order_tracking/services/auth_service.dart';

class ForgotPasswordResetScreen extends StatefulWidget {
  final String email;
  final String code;

  const ForgotPasswordResetScreen({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<ForgotPasswordResetScreen> createState() =>
      _ForgotPasswordResetScreenState();
}

class _ForgotPasswordResetScreenState extends State<ForgotPasswordResetScreen> {
  final TextEditingController passwordController = TextEditingController();
  String? error;
  bool isLoading = false;

  void resetPassword() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final success = await AuthService.resetPassword(
      email: widget.email,
      code: widget.code,
      newPassword: passwordController.text,
    );

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successful')),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      setState(() => error = 'Reset failed. Check code or try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : resetPassword,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
