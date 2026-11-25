import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../service/LoginService.dart';

class LoginController extends ChangeNotifier {
  final LoginService _loginService;

  LoginController({LoginService? loginService})
    : _loginService = loginService ?? LoginService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _authenticatedUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get authenticatedUser => _authenticatedUser;

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _loginService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _authenticatedUser = user;
      return true;
    } on LoginFailure catch (e) {
      _errorMessage = e.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}
