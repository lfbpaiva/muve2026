import '../models/chat_model.dart';
import '../models/user_model.dart';

class ChatService {
  static final List<ChatRoom> _rooms = [];
  static final Map<String, List<ChatMessage>> _messages = {};

  static List<ChatRoom> getRoomsForUser(String uid) {
    return _rooms.where((r) => r.participantesIds.contains(uid)).toList()
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
