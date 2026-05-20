import '../models/user_model.dart';

class UserService {
  static final List<UserModel> _users = [
    UserModel(
      uid: 'usr_1',
      nome: 'Julia Santos',
      email: 'artista@muve.com',
      telefone: '(11) 99234-5678',
      bio:
          'Cantora e violonista apaixonada pela música brasileira. Mais de 8 anos de palco, do interior ao grande ABC. Disponível para shows, eventos corporativos e festas.',
      cidade: 'São Paulo',
      estado: 'SP',
      papeis: ['ARTISTA'],
      generos: ['Sertanejo', 'Pop'],
      redesSociais: {
        'instagram': 'https://instagram.com/juliasantos.music',
        'youtube': 'https://youtube.com/@juliasantos',
        'spotify': 'https://open.spotify.com/artist/juliasantos',
      },
      faixaCache: 'R\$ 800 – R\$ 2.500',
      disponivelContratacao: true,
      perfilPago: true,
      criadoEm: DateTime(2024, 10, 1),
    ),
    UserModel(
      uid: 'usr_2',
      nome: 'Rodrigo Lima',
      email: 'rodrigo@muve.com',
      telefone: '(31) 98765-4321',
      bio:
          'Guitarrista e vocalista. Banda de rock cover e autoral. Toco desde os 14 anos e já passei por festivais regionais em MG.',
      cidade: 'Belo Horizonte',
      estado: 'MG',
      papeis: ['ARTISTA'],
      generos: ['Rock', 'Blues'],
      redesSociais: {
        'instagram': 'https://instagram.com/rodrigolima.rock',
        'youtube': 'https://youtube.com/@rodrigolima',
      },
      faixaCache: 'R\$ 600 – R\$ 1.800',
      disponivelContratacao: true,
      perfilPago: false,
      criadoEm: DateTime(2024, 11, 3),
    ),
    UserModel(
      uid: 'usr_3',
      nome: 'Ana Beatriz Costa',
      email: 'ana@muve.com',
      telefone: '(21) 97654-3210',
      bio:
          'Pianista e compositora. Formada em música pela UFRJ. Repertório de MPB, jazz e bossa nova. Toco em bares, restaurantes, casamentos e eventos corporativos.',
      cidade: 'Rio de Janeiro',
      estado: 'RJ',
      papeis: ['ARTISTA'],
      generos: ['MPB', 'Jazz', 'Bossa Nova'],
      redesSociais: {
        'instagram': 'https://instagram.com/anabeatrizpiano',
        'spotify': 'https://open.spotify.com/artist/anabeatriz',
        'youtube': 'https://youtube.com/@anabeatrizmusic',
      },
      faixaCache: 'R\$ 1.200 – R\$ 3.500',
      disponivelContratacao: true,
      perfilPago: true,
      criadoEm: DateTime(2024, 9, 15),
    ),
    UserModel(
      uid: 'usr_4',
      nome: 'Lucas Reis',
      email: 'lucas@muve.com',
      telefone: '(11) 95432-1098',
      bio:
          'Cantor de pagode e samba. Grupo de 5 pessoas. Animamos festas de aniversário, casamentos e eventos na Grande São Paulo.',
      cidade: 'São Paulo',
      estado: 'SP',
      papeis: ['ARTISTA'],
      generos: ['Pagode', 'Samba'],
      redesSociais: {
        'instagram': 'https://instagram.com/lucasreis.pagode',
      },
      faixaCache: 'R\$ 500 – R\$ 1.500',
      disponivelContratacao: false,
      perfilPago: false,
      criadoEm: DateTime(2024, 12, 2),
    ),
    UserModel(
      uid: 'usr_5',
      nome: 'Fernanda Alves',
      email: 'fernanda@muve.com',
      telefone: '(41) 96543-2109',
      bio:
          'DJ e produtora musical. Especialista em eletrônica, house e techno. Sets de 2h a 6h. Toco em clubs, festas privadas e festivais.',
      cidade: 'Curitiba',
      estado: 'PR',
      papeis: ['ARTISTA'],
      generos: ['Eletrônica', 'House', 'Techno'],
      redesSociais: {
        'instagram': 'https://instagram.com/dj.fernandaalves',
        'soundcloud': 'https://soundcloud.com/fernandaalves',
      },
      faixaCache: 'R\$ 700 – R\$ 2.000',
      disponivelContratacao: true,
      perfilPago: false,
      criadoEm: DateTime(2024, 11, 20),
    ),
    UserModel(
      uid: 'usr_6',
      nome: 'Bruno Neto',
      email: 'ambos@muve.com',
      telefone: '(51) 94321-0987',
      bio:
          'Músico indie e produtor de eventos culturais em Porto Alegre. Conecto artistas a espaços alternativos e festivais independentes.',
      cidade: 'Porto Alegre',
      estado: 'RS',
      papeis: ['ARTISTA', 'CONTRATANTE'],
      generos: ['Indie', 'Rock Alternativo'],
      redesSociais: {
        'instagram': 'https://instagram.com/brunoneto.indie',
        'youtube': 'https://youtube.com/@brunoneto',
      },
      faixaCache: 'R\$ 400 – R\$ 1.200',
      disponivelContratacao: true,
      perfilPago: true,
      criadoEm: DateTime(2024, 8, 10),
    ),
    UserModel(
      uid: 'usr_7',
      nome: 'Bar do Zé',
      email: 'contratante@muve.com',
      telefone: '(11) 3456-7890',
      bio:
          'Bar e restaurante no centro de São Paulo. Recebemos shows ao vivo toda sexta e sábado. Procuramos artistas de sertanejo, MPB e pagode.',
      cidade: 'São Paulo',
      estado: 'SP',
      papeis: ['CONTRATANTE'],
      generos: [],
      redesSociais: {
        'instagram': 'https://instagram.com/bardoze_oficial',
      },
      faixaCache: null,
      disponivelContratacao: false,
      perfilPago: true,
      criadoEm: DateTime(2024, 7, 5),
    ),
    UserModel(
      uid: 'usr_8',
      nome: 'Espaço Cultural Mirante',
      email: 'mirante@muve.com',
      telefone: '(21) 2234-5678',
      bio:
          'Espaço cultural no coração do Rio. Palco para teatro, música e arte. Capacidade para 300 pessoas.',
      cidade: 'Rio de Janeiro',
      estado: 'RJ',
      papeis: ['CONTRATANTE'],
      generos: [],
      redesSociais: {
        'instagram': 'https://instagram.com/espacomirante',
      },
      faixaCache: null,
      disponivelContratacao: false,
      perfilPago: false,
      criadoEm: DateTime(2024, 9, 1),
    ),
  ];

  static final Map<String, String> _senhas = {
    'artista@muve.com': '123456',
    'rodrigo@muve.com': '123456',
    'ana@muve.com': '123456',
    'lucas@muve.com': '123456',
    'fernanda@muve.com': '123456',
    'ambos@muve.com': '123456',
    'contratante@muve.com': '123456',
    'mirante@muve.com': '123456',
  };

  static List<UserModel> get allUsers => List.unmodifiable(_users);

  static List<UserModel> get artistas =>
      _users.where((u) => u.isArtista).toList();

  static UserModel? getById(String uid) {
    try {
      return _users.firstWhere((u) => u.uid == uid);
    } catch (_) {
      return null;
    }
  }

  static UserModel? getByEmail(String email) {
    try {
      return _users.firstWhere(
          (u) => u.email.toLowerCase() == email.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  static bool checkSenha(String email, String senha) {
    return _senhas[email.toLowerCase()] == senha;
  }

  static void add(UserModel user, String senha) {
    _users.add(user);
    _senhas[user.email.toLowerCase()] = senha;
  }

  static void update(UserModel updated) {
    final index = _users.indexWhere((u) => u.uid == updated.uid);
    if (index != -1) _users[index] = updated;
  }

  static List<UserModel> search({
    String? query,
    String? genero,
    String? cidade,
    bool? disponivelApenas,
  }) {
    return _users.where((u) {
      if (!u.isArtista) return false;
      if (disponivelApenas == true && !u.disponivelContratacao) return false;
      if (genero != null &&
          genero.isNotEmpty &&
          !u.generos.contains(genero)) {
        return false;
      }
      if (cidade != null &&
          cidade.isNotEmpty &&
          !u.cidade.toLowerCase().contains(cidade.toLowerCase())) {
        return false;
      }
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        return u.nome.toLowerCase().contains(q) ||
            u.bio!.toLowerCase().contains(q) ||
            u.generos.any((g) => g.toLowerCase().contains(q));
      }
      return true;
    }).toList();
  }
}
