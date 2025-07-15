import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:order_tracking/screens/sing_in.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.100.52:8080/api';
  static final storage = FlutterSecureStorage();

  /// Login using username and password
  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        print("success");
        final data = jsonDecode(response.body);
        final token = data['token']; // or 'accessToken' depending on backend
        if (token != null) {
          await storage.write(key: 'jwt', value: token);
          return token;
        }
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }

    return null;
  }

  Future<bool> signup(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'role': ['ROLE_USER'],
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['message'] == 'User registered successfully!';
      } else {
        final body = jsonDecode(response.body);
        throw Exception(
          'Signup failed: ${body['message'] ?? response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Signup error: $e');
    }
  }

  /// Logout: delete stored JWT
  Future<void> logout() async {
    await storage.delete(key: 'jwt');
  }

  /// Get stored JWT
  Future<String?> getToken() async {
    return await storage.read(key: 'jwt');
  }

  /// Helper: check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
