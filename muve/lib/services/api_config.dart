import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _baseUrlFromEnv = String.fromEnvironment(
    'MUVE_API_BASE_URL',
  );

  static String get baseUrl {
    if (_baseUrlFromEnv.trim().isNotEmpty) {
      return _normalizeBaseUrl(_baseUrlFromEnv);
    }

    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }

    return 'http://localhost:3000';
  }

  static Uri uri(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$baseUrl$normalizedPath');
  }

  static String _normalizeBaseUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.endsWith('/')) {
      return trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }
}
