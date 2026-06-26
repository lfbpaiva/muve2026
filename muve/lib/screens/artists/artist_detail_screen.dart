import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../routes.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/muve_avatar.dart';

class ArtistDetailScreen extends StatelessWidget {
  final UserModel artist;

  const ArtistDetailScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    final me = AuthService.currentUser;
    final isSelf = me?.uid == artist.uid;

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: CustomScrollView(
        slivers: [
          // Sliver app bar com header
          SliverAppBar(
            backgroundColor: AppTheme.primary,
            expandedHeight: 220,
            pinned: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primaryDark, AppTheme.primary],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 3,
                            ),
                          ),
                          child: MuveAvatar(
                              name: artist.nome, radius: 44, showBorder: false),
                        ),
                        if (artist.perfilPago)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.gold,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'PRO',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      artist.nome,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on_rounded,
                            size: 13, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          '${artist.cidade}, ${artist.estado}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Conteúdo
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status disponibilidade
                  _StatusRow(artist: artist),
                  const SizedBox(height: 12),
                  _HiringInfoCard(artist: artist),
                  const SizedBox(height: 20),

                  // Gêneros musicais
                  if (artist.generos.isNotEmpty) ...[
                    const _SectionTitle('Gêneros Musicais'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: artist.generos.asMap().entries.map((e) {
                        final isFirst = e.key == 0;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color:
                                isFirst ? AppTheme.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isFirst
                                  ? AppTheme.primary
                                  : const Color(0xFFD1D5DB),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            e.value,
                            style: TextStyle(
                              color:
                                  isFirst ? Colors.white : AppTheme.textMedium,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Bio
                  if (artist.bio != null) ...[
                    const _SectionTitle('Sobre'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x08000000),
                            blurRadius: 6,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        artist.bio!,
                        style: const TextStyle(
                          color: AppTheme.textMedium,
                          fontSize: 14,
                          height: 1.65,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Cachê
                  if (artist.faixaCache != null) ...[
                    const _SectionTitle('Cachê'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppTheme.statusGreen.withValues(alpha: 0.3)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x06000000),
                            blurRadius: 6,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.payments_rounded,
                              color: AppTheme.statusGreen, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            artist.faixaCache!,
                            style: const TextStyle(
                              color: AppTheme.statusGreen,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Redes sociais
                  if (artist.redesSociais.isNotEmpty) ...[
                    const _SectionTitle('Redes e portfólio'),
                    const SizedBox(height: 10),
                    _SocialLinks(links: artist.redesSociais),
                    const SizedBox(height: 20),
                  ],

                  // Botão contato
                  if (!isSelf && me != null) ...[
                    const Divider(color: Color(0xFFE5E7EB)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => _openChat(context, me, artist),
                        icon: const Icon(Icons.chat_bubble_rounded, size: 18),
                        label: const Text('Enviar mensagem'),
                        style: AppTheme.primaryButtonStyle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openChat(BuildContext context, UserModel me, UserModel other) {
    final room = ChatService.getOrCreateRoom(me, other);
    Navigator.pushNamed(context, Routes.chat, arguments: room);
  }
}

class _StatusRow extends StatelessWidget {
  final UserModel artist;
  const _StatusRow({required this.artist});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: artist.disponivelContratacao
              ? AppTheme.statusGreen.withValues(alpha: 0.3)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: artist.disponivelContratacao
                  ? AppTheme.statusGreen
                  : AppTheme.textLight,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            artist.disponivelContratacao
                ? 'Disponível para contratação'
                : 'Indisponível no momento',
            style: TextStyle(
              color: artist.disponivelContratacao
                  ? AppTheme.statusGreen
                  : AppTheme.textMedium,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HiringInfoCard extends StatelessWidget {
  final UserModel artist;

  const _HiringInfoCard({required this.artist});

  @override
  Widget build(BuildContext context) {
    final genres =
        artist.generos.isEmpty ? 'Não informado' : artist.generos.join(', ');
    final location = [
      if (artist.cidade.isNotEmpty) artist.cidade,
      if (artist.estado.isNotEmpty) artist.estado,
    ].join(artist.cidade.isNotEmpty && artist.estado.isNotEmpty ? ', ' : '');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _DetailRow(
            label: 'Localização',
            value: location.isEmpty ? 'Não informada' : location,
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          _DetailRow(
            label: 'Estilos',
            value: genres,
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          _DetailRow(
            label: 'Cachê',
            value: artist.faixaCache ?? 'A combinar',
            valueColor: AppTheme.statusGreen,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppTheme.textDark,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textMedium,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: valueColor ?? AppTheme.textDark,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialLinks extends StatelessWidget {
  final Map<String, String> links;
  const _SocialLinks({required this.links});

  IconData _iconFor(String key) {
    switch (key.toLowerCase()) {
      case 'instagram':
        return Icons.camera_alt_rounded;
      case 'youtube':
        return Icons.play_circle_fill_rounded;
      case 'spotify':
        return Icons.music_note_rounded;
      case 'soundcloud':
        return Icons.cloud_rounded;
      case 'tiktok':
        return Icons.music_video_rounded;
      default:
        return Icons.link_rounded;
    }
  }

  Color _colorFor(String key) {
    switch (key.toLowerCase()) {
      case 'youtube':
        return const Color(0xFFEF4444);
      case 'spotify':
        return const Color(0xFF22C55E);
      case 'instagram':
        return const Color(0xFFE1306C);
      case 'tiktok':
        return Colors.black;
      case 'soundcloud':
        return const Color(0xFFFF5500);
      default:
        return AppTheme.primary;
    }
  }

  String _labelFor(String key) => key[0].toUpperCase() + key.substring(1);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: links.entries.map((e) {
        final color = _colorFor(e.key);
        return GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Abrindo ${_labelFor(e.key)}...'),
                backgroundColor: AppTheme.primary,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(_iconFor(e.key), color: color, size: 15),
                ),
                const SizedBox(width: 8),
                Text(
                  _labelFor(e.key),
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.open_in_new_rounded,
                    size: 12, color: AppTheme.textLight),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
