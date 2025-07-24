import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:order_tracking/const.dart';

class AuthService {
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
        final token =
            data['accessToken']; // or 'accessToken' depending on backend
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

  // profile
  Future<Map<String, dynamic>> getUserProfile() async {
    final token = await storage.read(key: 'jwt');
    print("token is $token");
    if (token == null) throw Exception("JWT token not found");

    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  static const _storage = FlutterSecureStorage();
  static const _jwtKey = 'jwt'; // change if your key is different

  /// Checks whether the JWT token exists (i.e. user is signed in)
  static Future<bool> isUserSignedIn() async {
    final token = await _storage.read(key: _jwtKey);
    return token != null && token.isNotEmpty;
  }

  // Send reset code to email
  static Future<bool> sendResetCode(String email) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password?email=$email');
    final response = await http.post(url);
    return response.statusCode == 200;
  }

  // Reset password with email, code and new password
  static Future<bool> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'code': code,
        'newPassword': newPassword,
      }),
    );
    return response.statusCode == 200;
  }

  // change password

  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final token = await _storage.read(key: 'jwt');
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/auth/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    return response.statusCode == 200;
  }
}
