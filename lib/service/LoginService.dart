import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/ColaboradorModel.dart';

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

  Future<ColaboradorModel> signInWithLogin({
    required String login,
    required String password,
  }) async {
    final normalizedLogin = login.trim().toLowerCase();

    try {
      final data = await _client
          .from('colaboradores')
          .select('*, perfis_acesso(nome)')
          .eq('login', normalizedLogin)
          .maybeSingle();

      if (data == null) {
        throw const LoginFailure('Login ou senha inválidos.');
      }

      final colaborador = ColaboradorModel.fromMap(data);

      // Comparação direta enquanto senha_hash guarda a senha original
      if (password != colaborador.senhaHash) {
        throw const LoginFailure('Login ou senha inválidos.');
      }

      if (colaborador.status != 'ativo') {
        throw LoginFailure(
          'Acesso bloqueado: colaborador com status "${colaborador.status}".',
        );
      }

      await _client
          .from('colaboradores')
          .update({'ultimo_acesso': DateTime.now().toUtc().toIso8601String()})
          .eq('id', colaborador.id);

      return colaborador;
    } on PostgrestException catch (e) {
      throw LoginFailure('Erro ao consultar o banco: ${e.message}');
    } on LoginFailure {
      rethrow;
    } catch (_) {
      throw const LoginFailure('Falha ao validar credenciais ou conectar ao servidor.');
    }
  }
}