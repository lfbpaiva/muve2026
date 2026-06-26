import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/event_application_model.dart';
import '../models/event_model.dart';
import 'api_config.dart';

class EventService {
  static Future<List<EventModel>> getAll() async {
    final response = await http.get(ApiConfig.uri('/eventos')).timeout(
          const Duration(seconds: 12),
        );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_responseMessage(response, 'Erro ao carregar eventos'));
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Resposta invalida da API ao carregar eventos');
    }

    final events = decoded
        .whereType<Map>()
        .map((item) => EventModel.fromMap(Map<String, dynamic>.from(item)))
        .toList();

    return _sortEvents(events);
  }

  static Future<List<EventModel>> search({
    String? genero,
    String? cidade,
    bool? contratandoApenas,
  }) async {
    final events = await getAll();
    return events.where((event) {
      if (contratandoApenas == true && !event.contratando) return false;
      if (genero != null &&
          genero.isNotEmpty &&
          !event.generos.contains(genero)) {
        return false;
      }
      if (cidade != null &&
          cidade.isNotEmpty &&
          !event.cidade.toLowerCase().contains(cidade.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  static Future<EventModel> create(EventModel event, {String? userId}) async {
    final response = await http
        .post(
          ApiConfig.uri('/eventos'),
          headers: {
            'Content-Type': 'application/json',
            if (userId != null) 'X-User-Id': userId,
          },
          body: jsonEncode(event.toApiMap()),
        )
        .timeout(const Duration(seconds: 12));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_responseMessage(response, 'Erro ao criar evento'));
    }

    return EventModel.fromMap(_decodeMap(response));
  }

  static Future<({bool success, String? error})> applyToEvent({
    required String eventId,
    required String artistId,
  }) async {
    try {
      final response = await http.post(
        ApiConfig.uri('/eventos/$eventId/applications'),
        headers: {
          'Content-Type': 'application/json',
          'X-User-Id': artistId,
        },
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return (
          success: false,
          error: _responseMessage(response, 'Erro ao se inscrever no evento'),
        );
      }

      return (success: true, error: null);
    } catch (_) {
      return (
        success: false,
        error:
            'Nao foi possivel conectar a API. Verifique se o backend esta rodando.',
      );
    }
  }

  static Future<List<EventApplicationModel>> getMyApplications(
      String artistId) async {
    final response = await http.get(
      ApiConfig.uri('/artists/me/applications'),
      headers: {'X-User-Id': artistId},
    ).timeout(const Duration(seconds: 12));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        _responseMessage(response, 'Erro ao carregar eventos inscritos'),
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Resposta invalida da API ao carregar inscricoes');
    }

    return decoded
        .whereType<Map>()
        .map((item) =>
            EventApplicationModel.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  static Map<String, dynamic> _decodeMap(http.Response response) {
    if (response.body.isEmpty) return <String, dynamic>{};
    final decoded = jsonDecode(response.body);
    return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
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

  static List<EventModel> _sortEvents(List<EventModel> events) {
    events.sort((a, b) {
      if (a.emDestaque && !b.emDestaque) return -1;
      if (!a.emDestaque && b.emDestaque) return 1;
      return a.data.compareTo(b.data);
    });
    return events;
  }
}
