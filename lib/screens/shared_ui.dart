import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<bool> isUserSignedIn() async {
  final token = await storage.read(key: 'jwt');
  return token != null && token.isNotEmpty;
}

