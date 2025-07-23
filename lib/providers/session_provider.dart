import 'package:flutter/material.dart';
import 'package:order_tracking/services/auth_service.dart';

class SessionProvider with ChangeNotifier {
  bool? _isSignedIn; // null = loading, true/false = result
  bool? get isSignedIn => _isSignedIn;

  Future<void> checkAuthStatus() async {
    _isSignedIn = await AuthService.isUserSignedIn();
    notifyListeners();
  }

  void setSignedIn(bool value) {
    _isSignedIn = value;
    notifyListeners();
  }
}
