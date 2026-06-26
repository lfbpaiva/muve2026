import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import 'api_config.dart';

class AuthService {
  static UserModel? currentUser;

  static bool get isLoggedIn => currentUser != null;

  static Future<({bool success, String? error})> login(
      String email, String senha) async {
    try {
      final response = await http
          .post(
            ApiConfig.uri('/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'senha': senha,
            }),
          )
          .timeout(const Duration(seconds: 12));

      final data = _decodeResponse(response);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return (
          success: false,
          error: data['message']?.toString() ?? 'Erro ao entrar',
        );
      }

      final userData = data['user'];
      if (userData is! Map) {
        return (success: false, error: 'Resposta invalida da API');
      }

      currentUser = UserModel.fromMap(Map<String, dynamic>.from(userData));
      return (success: true, error: null);
    } catch (_) {
      return (
        success: false,
        error:
            'Nao foi possivel conectar a API. Verifique se o backend esta rodando.',
      );
    }
  }

  static Future<({bool success, String? error})> register({
    required String nome,
    required String email,
    required String senha,
    required String cidade,
    required String estado,
    required List<String> papeis,
    String? telefone,
    String? cpf,
    String? cnpj,
    List<String> generos = const [],
  }) async {
    try {
      final isContratanteOnly =
          papeis.contains('CONTRATANTE') && !papeis.contains('ARTISTA');
      final tipoPessoa = isContratanteOnly ? 'PJ' : 'PF';
      final tipoConta = isContratanteOnly ? 'CONTRATANTE' : 'ARTISTA';

      final response = await http
          .post(
            ApiConfig.uri('/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'nome': nome,
              'email': email,
              'senha': senha,
              'telefone': telefone,
              'cidade': cidade,
              'estado': estado,
              'generos': generos,
              'papeis': papeis,
              'tipoPessoa': tipoPessoa,
              'tipoConta': tipoConta,
              'cpf': cpf,
              'cnpj': cnpj,
              'razaoSocial': cnpj == null ? null : nome,
            }),
          )
          .timeout(const Duration(seconds: 12));

      final data = _decodeResponse(response);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return (
          success: false,
          error: data['message']?.toString() ?? 'Erro ao criar conta',
        );
      }

      final userData = data['user'];
      if (userData is! Map) {
        return (success: false, error: 'Resposta invalida da API');
      }

      currentUser = UserModel.fromMap(Map<String, dynamic>.from(userData));
      return (success: true, error: null);
    } catch (_) {
      return (
        success: false,
        error:
            'Nao foi possivel conectar a API. Verifique se o backend esta rodando.',
      );
    }
  }

  static void logout() {
    currentUser = null;
  }

  static void updateCurrentUser(UserModel updated) {
    currentUser = updated;
  }

  static Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.body.isEmpty) return <String, dynamic>{};
    final decoded = jsonDecode(response.body);
    return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
  }
}
