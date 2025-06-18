import 'package:flutter/material.dart';

import '../services/authservices.dart';

class LoginViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String error = '';

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    notifyListeners();

    final result = await _authService.login(email, password);

    isLoading = false;
    notifyListeners();

    return result;
  }
}
