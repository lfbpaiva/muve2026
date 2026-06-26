import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import 'api_config.dart';

class UserService {
  static Future<UserModel> updateMe({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    final response = await http
        .patch(
          ApiConfig.uri('/users/me'),
          headers: {
            'Content-Type': 'application/json',
            'X-User-Id': userId,
          },
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 12));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_responseMessage(response, 'Erro ao atualizar perfil'));
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map || decoded['user'] is! Map) {
      throw Exception('Resposta invalida da API ao atualizar perfil');
    }

    return UserModel.fromMap(
      Map<String, dynamic>.from(decoded['user'] as Map),
    );
  }

  static Future<List<UserModel>> search({
    String? query,
    String? genero,
    String? cidade,
    bool? disponivelApenas,
  }) async {
    final params = <String, String>{
      if (query != null && query.isNotEmpty) 'query': query,
      if (genero != null && genero.isNotEmpty) 'genero': genero,
      if (cidade != null && cidade.isNotEmpty) 'cidade': cidade,
      if (disponivelApenas == true) 'disponivelApenas': 'true',
    };

    final response = await http
        .get(ApiConfig.uri('/artists').replace(queryParameters: params))
        .timeout(const Duration(seconds: 12));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_responseMessage(response, 'Erro ao carregar artistas'));
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Resposta invalida da API ao carregar artistas');
    }

    final artists = decoded
        .whereType<Map>()
        .map((item) => UserModel.fromMap(Map<String, dynamic>.from(item)))
        .where((user) => user.isArtista)
        .toList();

    artists.sort((a, b) {
      if (a.perfilPago && !b.perfilPago) return -1;
      if (!a.perfilPago && b.perfilPago) return 1;
      return a.nome.compareTo(b.nome);
    });

    return artists;
  }

  static String _responseMessage(http.Response response, String fallback) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['message'] != null) {
        return decoded['message'].toString();
      }
    } catch (_) {
      // Empty or non-JSON response: use the controlled fallback.
    }
    return fallback;
  }
}
