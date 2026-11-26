import 'package:flutter/foundation.dart';

import '../model/ColaboradorModel.dart';
import '../service/LoginService.dart';

class LoginController extends ChangeNotifier {
  final LoginService _loginService;

  LoginController({LoginService? loginService})
    : _loginService = loginService ?? LoginService();

  bool _isLoading = false;
  String? _errorMessage;
  ColaboradorModel? _authenticatedColaborador;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ColaboradorModel? get authenticatedColaborador => _authenticatedColaborador;

  Future<bool> login({required String login, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final colaborador = await _loginService.signInWithLogin(
        login: login,
        password: password,
      );
      _authenticatedColaborador = colaborador;
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
