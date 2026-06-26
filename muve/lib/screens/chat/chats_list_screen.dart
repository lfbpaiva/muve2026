import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/chat_model.dart';
import '../../routes.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/muve_feedback.dart';
import '../../widgets/muve_avatar.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  List<ChatRoom> _rooms = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return;
    setState(() {
      _rooms = ChatService.getRoomsForUser(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mensagens',
                    style: TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Suas conversas com artistas e contratantes',
                    style: TextStyle(color: AppTheme.textMedium, fontSize: 13),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _rooms.isEmpty
                  ? const MuveEmptyState(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'Nenhuma conversa ainda',
                      message:
                          'Abra o perfil de um artista para iniciar uma negociação.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                      itemCount: _rooms.length,
                      separatorBuilder: (_, __) =>
                          const Divider(color: Color(0xFFF3F4F6), height: 1),
                      itemBuilder: (context, i) {
                        final room = _rooms[i];
                        final myUid = AuthService.currentUser!.uid;
                        return _ChatTile(
                          room: room,
                          myUid: myUid,
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              Routes.chat,
                              arguments: room,
                            );
                            _load();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final ChatRoom room;
  final String myUid;
  final VoidCallback onTap;

  const _ChatTile(
      {required this.room, required this.myUid, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final otherName = room.nomeDoOutro(myUid);
    final lastMsg = room.ultimaMensagem ?? 'Iniciar conversa';
    final time = room.ultimaMensagemAt;
    final timeStr = time == null ? '' : _formatTime(time);

    return InkWell(
      onTap: onTap,
      splashColor: AppTheme.primary.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.2), width: 2),
              ),
              child: MuveAvatar(name: otherName, radius: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          otherName,
                          style: const TextStyle(
                            color: AppTheme.textDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        timeStr,
                        style: const TextStyle(
                            color: AppTheme.textLight, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    lastMsg,
                    style: const TextStyle(
                        color: AppTheme.textMedium, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded,
                color: AppTheme.textLight, size: 20),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    if (now.difference(dt).inDays == 0) {
      return DateFormat('HH:mm').format(dt);
    } else if (now.difference(dt).inDays < 7) {
      return DateFormat('E', 'pt_BR').format(dt);
    } else {
      return DateFormat('dd/MM').format(dt);
    }
  }
}
