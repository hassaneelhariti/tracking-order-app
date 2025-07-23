import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:order_tracking/const.dart';

class ProfileService {
  static final _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> getUserProfile() async {
    final token = await _storage.read(key: 'jwt');

    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<Uint8List?> getProfileImage(String url) async {
    final token = await _storage.read(key: 'jwt');

    final response = await http.get(
      Uri.parse('http://192.168.100.52:8080$url'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    return null;
  }
}
