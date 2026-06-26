class EventModel {
  final String id;
  final String titulo;
  final String? descricao;
  final String local;
  final String cidade;
  final String estado;
  final DateTime data;
  final List<String> generos;
  final String? cacheEstimado;
  final bool contratando;
  final String criadorId;
  final String criadorNome;
  final String? criadorFoto;
  final bool emDestaque;
  final DateTime criadoEm;

  const EventModel({
    required this.id,
    required this.titulo,
    this.descricao,
    required this.local,
    required this.cidade,
    required this.estado,
    required this.data,
    this.generos = const [],
    this.cacheEstimado,
    this.contratando = false,
    required this.criadorId,
    required this.criadorNome,
    this.criadorFoto,
    this.emDestaque = false,
    required this.criadoEm,
  });

  EventModel copyWith({
    String? id,
    String? titulo,
    String? descricao,
    String? local,
    String? cidade,
    String? estado,
    DateTime? data,
    List<String>? generos,
    String? cacheEstimado,
    bool? contratando,
    String? criadorId,
    String? criadorNome,
    String? criadorFoto,
    bool? emDestaque,
    DateTime? criadoEm,
  }) =>
      EventModel(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        descricao: descricao ?? this.descricao,
        local: local ?? this.local,
        cidade: cidade ?? this.cidade,
        estado: estado ?? this.estado,
        data: data ?? this.data,
        generos: generos ?? this.generos,
        cacheEstimado: cacheEstimado ?? this.cacheEstimado,
        contratando: contratando ?? this.contratando,
        criadorId: criadorId ?? this.criadorId,
        criadorNome: criadorNome ?? this.criadorNome,
        criadorFoto: criadorFoto ?? this.criadorFoto,
        emDestaque: emDestaque ?? this.emDestaque,
        criadoEm: criadoEm ?? this.criadoEm,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'titulo': titulo,
        'descricao': descricao,
        'local': local,
        'cidade': cidade,
        'estado': estado,
        'data': data.toIso8601String(),
        'generos': generos,
        'cacheEstimado': cacheEstimado,
        'contratando': contratando,
        'criadorId': criadorId,
        'criadorNome': criadorNome,
        'criadorFoto': criadorFoto,
        'emDestaque': emDestaque,
        'criadoEm': criadoEm.toIso8601String(),
      };

  Map<String, dynamic> toApiMap() => {
        'titulo': titulo,
        'descricao': descricao,
        'local': local,
        'cidade': cidade,
        'estado': estado,
        'data':
            '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}',
        'hora':
            '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}',
        'categoria': generos.isNotEmpty ? generos.first : null,
        'cacheEstimado': cacheEstimado,
        'contratando': contratando,
      };

  factory EventModel.fromMap(Map<String, dynamic> map) {
    final categoria = map['categoria'];
    final rawGeneros = map['generos'];
    final generos = rawGeneros is List
        ? List<String>.from(rawGeneros)
        : [
            if (categoria is String && categoria.isNotEmpty) categoria,
          ];

    final contratante = map['contratante'];
    final contratanteMap =
        contratante is Map ? Map<String, dynamic>.from(contratante) : null;

    return EventModel(
      id: (map['id'] ?? '').toString(),
      titulo: (map['titulo'] ?? map['title'] ?? '') as String,
      descricao: map['descricao'] as String?,
      local: map['local'] as String? ?? '',
      cidade: map['cidade'] as String? ?? '',
      estado: map['estado'] as String? ?? '',
      data: _parseEventDate(map['data'], map['hora']),
      generos: generos,
      cacheEstimado: map['cacheEstimado'] as String?,
      contratando: map['contratando'] as bool? ?? true,
      criadorId: (map['criadorId'] ??
              map['contratanteId'] ??
              contratanteMap?['id'] ??
              '')
          .toString(),
      criadorNome:
          (map['criadorNome'] ?? contratanteMap?['nome'] ?? 'Contratante')
              .toString(),
      criadorFoto: map['criadorFoto'] as String?,
      emDestaque: map['emDestaque'] as bool? ?? false,
      criadoEm: DateTime.tryParse(
            (map['criadoEm'] ?? map['createdAt'] ?? '').toString(),
          ) ??
          DateTime.now(),
    );
  }

  static DateTime _parseEventDate(dynamic rawDate, dynamic rawTime) {
    final dateText = rawDate?.toString();
    final timeText = rawTime?.toString();

    if (dateText == null || dateText.isEmpty) {
      return DateTime.now();
    }

    final iso = DateTime.tryParse(dateText);
    if (iso != null) return iso;

    final parts = dateText.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]) ?? 1;
      final month = int.tryParse(parts[1]) ?? 1;
      final year = int.tryParse(parts[2]) ?? DateTime.now().year;
      final timeParts = (timeText ?? '00:00').split(':');
      final hour = timeParts.isNotEmpty ? int.tryParse(timeParts[0]) ?? 0 : 0;
      final minute = timeParts.length > 1 ? int.tryParse(timeParts[1]) ?? 0 : 0;
      return DateTime(year, month, day, hour, minute);
    }

    return DateTime.now();
  }
}
