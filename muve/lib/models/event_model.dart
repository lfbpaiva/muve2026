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

  factory EventModel.fromMap(Map<String, dynamic> map) => EventModel(
        id: map['id'] as String,
        titulo: map['titulo'] as String,
        descricao: map['descricao'] as String?,
        local: map['local'] as String,
        cidade: map['cidade'] as String,
        estado: map['estado'] as String,
        data: DateTime.parse(map['data'] as String),
        generos: List<String>.from(map['generos'] ?? []),
        cacheEstimado: map['cacheEstimado'] as String?,
        contratando: map['contratando'] as bool? ?? false,
        criadorId: map['criadorId'] as String,
        criadorNome: map['criadorNome'] as String,
        criadorFoto: map['criadorFoto'] as String?,
        emDestaque: map['emDestaque'] as bool? ?? false,
        criadoEm: DateTime.parse(map['criadoEm'] as String),
      );
}
