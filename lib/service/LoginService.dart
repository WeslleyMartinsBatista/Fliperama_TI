import 'package:supabase_flutter/supabase_flutter.dart';

class LoginFailure implements Exception {
  final String message;

  const LoginFailure(this.message);

  @override
  String toString() => message;
}

class LoginService {
  final SupabaseClient _client;

  LoginService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const LoginFailure('Não foi possível obter os dados do jogador.');
      }

      return user;
    } on AuthException catch (e) {
      throw LoginFailure(_mapAuthError(e.message));
    } on LoginFailure {
      rethrow;
    } catch (_) {
      throw const LoginFailure('Falha de conexão com o servidor.');
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  String _mapAuthError(String message) {
    final normalized = message.toLowerCase();
    if (normalized.contains('invalid login credentials')) {
      return 'E-mail ou senha inválidos.';
    }
    if (normalized.contains('email not confirmed')) {
      return 'Confirme seu e-mail antes de entrar.';
    }
    return message;
  }
}
