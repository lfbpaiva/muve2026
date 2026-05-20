import '../models/chat_model.dart';
import '../models/user_model.dart';

class ChatService {
  static final List<ChatRoom> _rooms = [
    ChatRoom(
      id: 'usr_1_usr_7',
      participantesIds: ['usr_1', 'usr_7'],
      participantesNomes: {'usr_1': 'Julia Santos', 'usr_7': 'Bar do Zé'},
      ultimaMensagem: 'Perfeito! Te mando o contrato por aqui.',
      ultimaMensagemAt: DateTime.now().subtract(const Duration(minutes: 35)),
      criadoEm: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ChatRoom(
      id: 'usr_1_usr_8',
      participantesIds: ['usr_1', 'usr_8'],
      participantesNomes: {
        'usr_1': 'Julia Santos',
        'usr_8': 'Espaço Cultural Mirante'
      },
      ultimaMensagem: 'Pode ser no dia 20, sem problema.',
      ultimaMensagemAt: DateTime.now().subtract(const Duration(hours: 3)),
      criadoEm: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  static final Map<String, List<ChatMessage>> _messages = {
    'usr_1_usr_7': [
      ChatMessage(
        id: 'm1',
        remetenteId: 'usr_7',
        texto: 'Olá Julia! Vi seu perfil no Muve e fiquei interessado.',
        enviadoEm:
            DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      ),
      ChatMessage(
        id: 'm2',
        remetenteId: 'usr_1',
        texto: 'Oi! Obrigada! Que tipo de show vocês buscam?',
        enviadoEm: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ChatMessage(
        id: 'm3',
        remetenteId: 'usr_7',
        texto:
            'Queremos um set de sertanejo e pop, sextas à noite. Público em torno de 100 pessoas.',
        enviadoEm:
            DateTime.now().subtract(const Duration(hours: 5)),
      ),
      ChatMessage(
        id: 'm4',
        remetenteId: 'usr_1',
        texto:
            'Perfeito! Tenho esse repertório sim. Meu cachê para 2h é R\$ 1.200. Topam?',
        enviadoEm:
            DateTime.now().subtract(const Duration(hours: 4)),
      ),
      ChatMessage(
        id: 'm5',
        remetenteId: 'usr_7',
        texto: 'Perfeito! Te mando o contrato por aqui.',
        enviadoEm:
            DateTime.now().subtract(const Duration(minutes: 35)),
      ),
    ],
    'usr_1_usr_8': [
      ChatMessage(
        id: 'm6',
        remetenteId: 'usr_8',
        texto:
            'Julia, temos uma vaga na Noite de MPB do dia 20. Você teria interesse?',
        enviadoEm: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ChatMessage(
        id: 'm7',
        remetenteId: 'usr_1',
        texto: 'Sim! Que horário seria?',
        enviadoEm:
            DateTime.now().subtract(const Duration(days: 4, hours: 22)),
      ),
      ChatMessage(
        id: 'm8',
        remetenteId: 'usr_8',
        texto: 'Das 20h às 22h. Cachê de R\$ 1.500.',
        enviadoEm:
            DateTime.now().subtract(const Duration(days: 4, hours: 20)),
      ),
      ChatMessage(
        id: 'm9',
        remetenteId: 'usr_1',
        texto: 'Pode ser no dia 20, sem problema.',
        enviadoEm: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ],
  };

  static List<ChatRoom> getRoomsForUser(String uid) {
    return _rooms
        .where((r) => r.participantesIds.contains(uid))
        .toList()
      ..sort((a, b) {
        final aTime = a.ultimaMensagemAt ?? a.criadoEm;
        final bTime = b.ultimaMensagemAt ?? b.criadoEm;
        return bTime.compareTo(aTime);
      });
  }

  static List<ChatMessage> getMessages(String roomId) {
    return List<ChatMessage>.from(_messages[roomId] ?? []);
  }

  static ChatRoom getOrCreateRoom(UserModel myUser, UserModel otherUser) {
    final ids = [myUser.uid, otherUser.uid]..sort();
    final chatId = ids.join('_');

    try {
      return _rooms.firstWhere((r) => r.id == chatId);
    } catch (_) {
      final newRoom = ChatRoom(
        id: chatId,
        participantesIds: ids,
        participantesNomes: {
          myUser.uid: myUser.nome,
          otherUser.uid: otherUser.nome,
        },
        criadoEm: DateTime.now(),
      );
      _rooms.add(newRoom);
      return newRoom;
    }
  }

  static void sendMessage(String roomId, String remetenteId, String texto) {
    final msg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      remetenteId: remetenteId,
      texto: texto,
      enviadoEm: DateTime.now(),
    );

    _messages.putIfAbsent(roomId, () => []);
    _messages[roomId]!.add(msg);

    final roomIndex = _rooms.indexWhere((r) => r.id == roomId);
    if (roomIndex != -1) {
      _rooms[roomIndex] = _rooms[roomIndex].copyWith(
        ultimaMensagem: texto,
        ultimaMensagemAt: DateTime.now(),
      );
    }
  }
}
