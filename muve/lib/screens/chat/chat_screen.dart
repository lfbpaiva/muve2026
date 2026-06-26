import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/chat_model.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/muve_avatar.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom room;

  const ChatScreen({super.key, required this.room});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  List<ChatMessage> _messages = [];

  String get _myUid => AuthService.currentUser!.uid;
  String get _otherName => widget.room.nomeDoOutro(_myUid);

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      _messages = ChatService.getMessages(widget.room.id);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send() {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    _inputCtrl.clear();
    ChatService.sendMessage(widget.room.id, _myUid, text);
    _load();
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(name: _otherName, onBack: () => Navigator.pop(context)),
            Expanded(
              child: _messages.isEmpty
                  ? const _EmptyConversation()
                  : ListView.builder(
                      controller: _scrollCtrl,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: _messages.length,
                      itemBuilder: (context, i) {
                        final msg = _messages[i];
                        final isMe = msg.remetenteId == _myUid;
                        final showDate = i == 0 ||
                            !_sameDay(
                                _messages[i - 1].enviadoEm, msg.enviadoEm);
                        return Column(
                          children: [
                            if (showDate) _DateDivider(msg.enviadoEm),
                            _MessageBubble(
                              message: msg,
                              isMe: isMe,
                              senderName: isMe ? '' : _otherName,
                            ),
                          ],
                        );
                      },
                    ),
            ),
            _InputBar(controller: _inputCtrl, onSend: _send),
          ],
        ),
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _AppBar extends StatelessWidget {
  final String name;
  final VoidCallback onBack;

  const _AppBar({required this.name, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppTheme.textDark, size: 18),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.3), width: 2),
            ),
            child: MuveAvatar(name: name, radius: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final String senderName;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm').format(message.enviadoEm);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            MuveAvatar(name: senderName, radius: 14),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
                boxShadow: isMe
                    ? null
                    : const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        )
                      ],
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.texto,
                    style: TextStyle(
                      color: isMe ? Colors.white : AppTheme.textDark,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeStr,
                    style: TextStyle(
                      color: isMe
                          ? Colors.white.withValues(alpha: 0.6)
                          : AppTheme.textLight,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _DateDivider extends StatelessWidget {
  final DateTime date;
  const _DateDivider(this.date);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    String label;
    if (diff == 0) {
      label = 'Hoje';
    } else if (diff == 1) {
      label = 'Ontem';
    } else {
      label = DateFormat("dd 'de' MMMM", 'pt_BR').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: const TextStyle(color: AppTheme.textLight, fontSize: 12),
            ),
          ),
          const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.inputBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: 'Mensagem...',
                  hintStyle: TextStyle(color: AppTheme.textLight, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyConversation extends StatelessWidget {
  const _EmptyConversation();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.waving_hand_rounded,
                size: 32, color: AppTheme.primary),
          ),
          const SizedBox(height: 12),
          const Text(
            'Início da conversa',
            style: TextStyle(
              color: AppTheme.textDark,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Mande um oi e comece a negociar!',
            style: TextStyle(color: AppTheme.textMedium, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
