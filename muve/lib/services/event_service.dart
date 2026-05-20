import '../models/event_model.dart';

class EventService {
  static final List<EventModel> _events = [
    EventModel(
      id: 'evt_1',
      titulo: 'Festival Verão 2025',
      descricao:
          'Grande festival de verão com palco principal, food trucks e área kids. Esperamos mais de 2.000 pessoas. Buscamos artistas de sertanejo e pop para 3 slots de 45 minutos.',
      local: 'Parque do Ibirapuera',
      cidade: 'São Paulo',
      estado: 'SP',
      data: DateTime.now().add(const Duration(days: 18)),
      generos: ['Sertanejo', 'Pop'],
      cacheEstimado: 'R\$ 2.000 – R\$ 5.000',
      contratando: true,
      criadorId: 'usr_7',
      criadorNome: 'Bar do Zé',
      emDestaque: true,
      criadoEm: DateTime.now().subtract(const Duration(days: 3)),
    ),
    EventModel(
      id: 'evt_2',
      titulo: 'Noite de MPB e Jazz',
      descricao:
          'Série mensal de shows de MPB e jazz no nosso espaço cultural. Capacidade para 200 pessoas. Ambiente intimista e climatizado.',
      local: 'Espaço Cultural Mirante',
      cidade: 'Rio de Janeiro',
      estado: 'RJ',
      data: DateTime.now().add(const Duration(days: 7)),
      generos: ['MPB', 'Jazz', 'Bossa Nova'],
      cacheEstimado: 'R\$ 1.200 – R\$ 2.800',
      contratando: true,
      criadorId: 'usr_8',
      criadorNome: 'Espaço Cultural Mirante',
      emDestaque: true,
      criadoEm: DateTime.now().subtract(const Duration(days: 5)),
    ),
    EventModel(
      id: 'evt_3',
      titulo: 'Rock na Praça – Edição BH',
      descricao:
          'Festival gratuito de rock na praça principal de BH. Edição especial com 4 bandas locais. Patrocinado pela Prefeitura Municipal.',
      local: 'Praça da Liberdade',
      cidade: 'Belo Horizonte',
      estado: 'MG',
      data: DateTime.now().add(const Duration(days: 30)),
      generos: ['Rock', 'Blues'],
      cacheEstimado: null,
      contratando: false,
      criadorId: 'usr_6',
      criadorNome: 'Bruno Neto',
      emDestaque: false,
      criadoEm: DateTime.now().subtract(const Duration(days: 10)),
    ),
    EventModel(
      id: 'evt_4',
      titulo: 'Happy Hour com Música ao Vivo',
      descricao:
          'Toda sexta-feira promovemos happy hour com música ao vivo. Buscamos artistas solo ou duo para um set de 2 horas. Público de 80–120 pessoas.',
      local: 'Bar do Zé – Unidade Centro',
      cidade: 'São Paulo',
      estado: 'SP',
      data: DateTime.now().add(const Duration(days: 4)),
      generos: ['Jazz', 'MPB', 'Bossa Nova'],
      cacheEstimado: 'R\$ 600 – R\$ 1.200',
      contratando: true,
      criadorId: 'usr_7',
      criadorNome: 'Bar do Zé',
      emDestaque: false,
      criadoEm: DateTime.now().subtract(const Duration(days: 2)),
    ),
    EventModel(
      id: 'evt_5',
      titulo: 'Pagode das Sextas',
      descricao:
          'Show de pagode e samba toda sexta no quintal do bar. Ambiente descontraído, churrasco e muita música. Buscamos grupo de 4–6 pessoas.',
      local: 'Quintal do Samba',
      cidade: 'São Paulo',
      estado: 'SP',
      data: DateTime.now().add(const Duration(days: 11)),
      generos: ['Pagode', 'Samba'],
      cacheEstimado: 'R\$ 500 – R\$ 1.000',
      contratando: true,
      criadorId: 'usr_7',
      criadorNome: 'Bar do Zé',
      emDestaque: false,
      criadoEm: DateTime.now().subtract(const Duration(days: 1)),
    ),
    EventModel(
      id: 'evt_6',
      titulo: 'Festa de 15 Anos – Família Andrade',
      descricao:
          'Festa de debutante para 150 convidados em salão de festas. Buscamos artista ou duo para animar durante 2 horas. Repertório romântico e pop.',
      local: 'Salão Estrela',
      cidade: 'Curitiba',
      estado: 'PR',
      data: DateTime.now().add(const Duration(days: 45)),
      generos: ['Pop', 'Sertanejo'],
      cacheEstimado: 'R\$ 800 – R\$ 1.500',
      contratando: true,
      criadorId: 'usr_5',
      criadorNome: 'Fernanda Alves',
      emDestaque: false,
      criadoEm: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  static List<EventModel> getAll() {
    final sorted = List<EventModel>.from(_events);
    sorted.sort((a, b) {
      if (a.emDestaque && !b.emDestaque) return -1;
      if (!a.emDestaque && b.emDestaque) return 1;
      return a.data.compareTo(b.data);
    });
    return sorted;
  }

  static List<EventModel> search({
    String? genero,
    String? cidade,
    bool? contratandoApenas,
  }) {
    return getAll().where((e) {
      if (contratandoApenas == true && !e.contratando) return false;
      if (genero != null &&
          genero.isNotEmpty &&
          !e.generos.contains(genero)) {
        return false;
      }
      if (cidade != null &&
          cidade.isNotEmpty &&
          !e.cidade.toLowerCase().contains(cidade.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  static EventModel? getById(String id) {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  static void add(EventModel event) {
    _events.insert(0, event);
  }
}
