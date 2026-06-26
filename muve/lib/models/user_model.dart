class UserModel {
  final String uid;
  final String nome;
  final String email;
  final String? telefone;
  final String? cpf;
  final String? cnpj;
  final String? fotoPerfil;
  final String? bio;
  final String cidade;
  final String estado;
  final List<String> papeis;
  final List<String> generos;
  final Map<String, String> redesSociais;
  final String? faixaCache;
  final bool disponivelContratacao;
  final bool perfilPago;
  final DateTime criadoEm;

  const UserModel({
    required this.uid,
    required this.nome,
    required this.email,
    this.telefone,
    this.cpf,
    this.cnpj,
    this.fotoPerfil,
    this.bio,
    required this.cidade,
    required this.estado,
    required this.papeis,
    this.generos = const [],
    this.redesSociais = const {},
    this.faixaCache,
    this.disponivelContratacao = false,
    this.perfilPago = false,
    required this.criadoEm,
  });

  bool get isArtista => papeis.contains('ARTISTA');
  bool get isContratante => papeis.contains('CONTRATANTE');

  String get iniciaisNome {
    final partes = nome.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    return nome.substring(0, nome.length >= 2 ? 2 : 1).toUpperCase();
  }

  UserModel copyWith({
    String? uid,
    String? nome,
    String? email,
    String? telefone,
    String? cpf,
    String? cnpj,
    String? fotoPerfil,
    String? bio,
    String? cidade,
    String? estado,
    List<String>? papeis,
    List<String>? generos,
    Map<String, String>? redesSociais,
    String? faixaCache,
    bool? disponivelContratacao,
    bool? perfilPago,
    DateTime? criadoEm,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        nome: nome ?? this.nome,
        email: email ?? this.email,
        telefone: telefone ?? this.telefone,
        cpf: cpf ?? this.cpf,
        cnpj: cnpj ?? this.cnpj,
        fotoPerfil: fotoPerfil ?? this.fotoPerfil,
        bio: bio ?? this.bio,
        cidade: cidade ?? this.cidade,
        estado: estado ?? this.estado,
        papeis: papeis ?? this.papeis,
        generos: generos ?? this.generos,
        redesSociais: redesSociais ?? this.redesSociais,
        faixaCache: faixaCache ?? this.faixaCache,
        disponivelContratacao:
            disponivelContratacao ?? this.disponivelContratacao,
        perfilPago: perfilPago ?? this.perfilPago,
        criadoEm: criadoEm ?? this.criadoEm,
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'id': uid,
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'fotoPerfil': fotoPerfil,
        'bio': bio,
        'cidade': cidade,
        'estado': estado,
        'papeis': papeis,
        'generos': generos,
        'redesSociais': redesSociais,
        'faixaCache': faixaCache,
        'disponivelContratacao': disponivelContratacao,
        'perfilPago': perfilPago,
        'criadoEm': criadoEm.toIso8601String(),
      };

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final tipoConta = map['tipoConta'] as String?;
    final papeis = map['papeis'] != null
        ? List<String>.from(map['papeis'])
        : [
            if (tipoConta != null) tipoConta,
          ];

    return UserModel(
      uid: (map['uid'] ?? map['id'] ?? '') as String,
      nome: map['nome'] as String? ?? '',
      email: map['email'] as String? ?? '',
      telefone: map['telefone'] as String?,
      cpf: map['cpf'] as String?,
      cnpj: map['cnpj'] as String?,
      fotoPerfil: map['fotoPerfil'] as String?,
      bio: map['bio'] as String?,
      cidade: map['cidade'] as String? ?? '',
      estado: map['estado'] as String? ?? '',
      papeis: papeis,
      generos: List<String>.from(map['generos'] ?? []),
      redesSociais: Map<String, String>.from(map['redesSociais'] ?? {}),
      faixaCache: map['faixaCache'] as String?,
      disponivelContratacao: map['disponivelContratacao'] as bool? ?? false,
      perfilPago: map['perfilPago'] as bool? ?? false,
      criadoEm: DateTime.tryParse(
            (map['criadoEm'] ?? map['createdAt'] ?? '').toString(),
          ) ??
          DateTime.now(),
    );
  }
}
