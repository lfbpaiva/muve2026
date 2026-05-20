class ChatRoom {
  final String id;
  final List<String> participantesIds;
  final Map<String, String> participantesNomes;
  final Map<String, String?> participantesFotos;
  final String? ultimaMensagem;
  final DateTime? ultimaMensagemAt;
  final DateTime criadoEm;

  const ChatRoom({
    required this.id,
    required this.participantesIds,
    required this.participantesNomes,
    this.participantesFotos = const {},
    this.ultimaMensagem,
    this.ultimaMensagemAt,
    required this.criadoEm,
  });

  String nomeDoOutro(String meuUid) {
    final outroUid =
        participantesIds.firstWhere((id) => id != meuUid, orElse: () => '');
    return participantesNomes[outroUid] ?? 'Usuário';
  }

  String? fotoDoOutro(String meuUid) {
    final outroUid =
        participantesIds.firstWhere((id) => id != meuUid, orElse: () => '');
    return participantesFotos[outroUid];
  }

  ChatRoom copyWith({
    String? id,
    List<String>? participantesIds,
    Map<String, String>? participantesNomes,
    Map<String, String?>? participantesFotos,
    String? ultimaMensagem,
    DateTime? ultimaMensagemAt,
    DateTime? criadoEm,
  }) =>
      ChatRoom(
        id: id ?? this.id,
        participantesIds: participantesIds ?? this.participantesIds,
        participantesNomes: participantesNomes ?? this.participantesNomes,
        participantesFotos: participantesFotos ?? this.participantesFotos,
        ultimaMensagem: ultimaMensagem ?? this.ultimaMensagem,
        ultimaMensagemAt: ultimaMensagemAt ?? this.ultimaMensagemAt,
        criadoEm: criadoEm ?? this.criadoEm,
      );
}

class ChatMessage {
  final String id;
  final String remetenteId;
  final String texto;
  final DateTime enviadoEm;

  const ChatMessage({
    required this.id,
    required this.remetenteId,
    required this.texto,
    required this.enviadoEm,
  });
}
