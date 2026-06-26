class EventApplicationModel {
  final String id;
  final String status;
  final DateTime createdAt;
  final AppliedEventModel event;

  const EventApplicationModel({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.event,
  });

  String get statusLabel {
    switch (status) {
      case 'ACCEPTED':
        return 'Aceita';
      case 'REJECTED':
        return 'Recusada';
      case 'CANCELED':
        return 'Cancelada';
      case 'PENDING':
      default:
        return 'Pendente';
    }
  }

  factory EventApplicationModel.fromMap(Map<String, dynamic> map) {
    final eventMap = map['event'] is Map
        ? Map<String, dynamic>.from(map['event'] as Map)
        : <String, dynamic>{};

    return EventApplicationModel(
      id: (map['id'] ?? '').toString(),
      status: (map['status'] ?? 'PENDING').toString(),
      createdAt: DateTime.tryParse((map['createdAt'] ?? '').toString()) ??
          DateTime.now(),
      event: AppliedEventModel.fromMap(eventMap),
    );
  }
}

class AppliedEventModel {
  final String id;
  final String title;
  final DateTime? date;
  final String? location;

  const AppliedEventModel({
    required this.id,
    required this.title,
    this.date,
    this.location,
  });

  factory AppliedEventModel.fromMap(Map<String, dynamic> map) {
    final cidade = map['cidade']?.toString();
    final estado = map['estado']?.toString();
    final local = map['local']?.toString();
    final locationParts = [
      if (local != null && local.isNotEmpty) local,
      if (cidade != null && cidade.isNotEmpty)
        estado != null && estado.isNotEmpty ? '$cidade/$estado' : cidade,
    ];

    return AppliedEventModel(
      id: (map['id'] ?? '').toString(),
      title: (map['titulo'] ?? map['title'] ?? 'Evento sem nome').toString(),
      date: _parseDate(map['data'], map['hora']),
      location: locationParts.isEmpty ? null : locationParts.join(' - '),
    );
  }

  static DateTime? _parseDate(dynamic rawDate, dynamic rawTime) {
    final dateText = rawDate?.toString();
    final timeText = rawTime?.toString();

    if (dateText == null || dateText.isEmpty) return null;

    final iso = DateTime.tryParse(dateText);
    if (iso != null) return iso;

    final parts = dateText.split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;

    final timeParts = (timeText ?? '00:00').split(':');
    final hour = timeParts.isNotEmpty ? int.tryParse(timeParts[0]) ?? 0 : 0;
    final minute = timeParts.length > 1 ? int.tryParse(timeParts[1]) ?? 0 : 0;

    return DateTime(year, month, day, hour, minute);
  }
}
