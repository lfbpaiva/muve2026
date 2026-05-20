import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/muve_avatar.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _openEdit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
    setState(() {});
  }

  Future<void> _openSettings() async {
    await Navigator.pushNamed(context, Routes.settings);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    if (user == null) {
      return const Scaffold(
        backgroundColor: AppTheme.bgLight,
        body: Center(
          child: Text('Não autenticado',
              style: TextStyle(color: AppTheme.textMedium)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Header: título + engrenagem (→ Settings)
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(20, 20, 12, 0),
                child: Row(
                  children: [
                    const Text(
                      'Meu Perfil',
                      style: TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _openSettings,
                      tooltip: 'Configurações',
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: AppTheme.textMedium,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Área do perfil: avatar + info + botão editar (estilo Twitter)
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Avatar com botão câmera
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primary
                                  .withValues(alpha: 0.3),
                              width: 3,
                            ),
                          ),
                          child: MuveAvatar(
                              name: user.nome,
                              radius: 44,
                              showBorder: false),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                        if (user.perfilPago)
                          Positioned(
                            top: -4,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.gold,
                                borderRadius:
                                    BorderRadius.circular(8),
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
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Nome
                    Text(
                      user.nome,
                      style: const TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on_rounded,
                            size: 13, color: AppTheme.textLight),
                        const SizedBox(width: 2),
                        Text(
                          '${user.cidade}, ${user.estado}',
                          style: const TextStyle(
                              color: AppTheme.textMedium,
                              fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Papéis
                    Wrap(
                      spacing: 6,
                      children: user.papeis
                          .map((p) => _PapelChip(p))
                          .toList(),
                    ),
                    const SizedBox(height: 14),

                    // Botão "Editar Perfil" — estilo Twitter (outline, compacto)
                    OutlinedButton.icon(
                      onPressed: _openEdit,
                      icon: const Icon(Icons.edit_rounded, size: 15),
                      label: const Text('Editar Perfil'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        side: const BorderSide(
                            color: AppTheme.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Cards de informação
            SliverPadding(
              padding:
                  const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Disponibilidade
                  if (user.isArtista) ...[
                    _disponibilidadeCard(user),
                    const SizedBox(height: 14),
                  ],

                  // Bio
                  if (user.bio != null &&
                      user.bio!.isNotEmpty) ...[
                    _ProfileCard(
                      title: 'Sobre mim',
                      child: Text(
                        user.bio!,
                        style: const TextStyle(
                          color: AppTheme.textMedium,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Estilos musicais
                  if (user.isArtista &&
                      user.generos.isNotEmpty) ...[
                    _ProfileCard(
                      title: 'Estilos Musicais',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            user.generos.asMap().entries.map((e) {
                          final isFirst = e.key == 0;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: isFirst
                                  ? AppTheme.primary
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(20),
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
                                color: isFirst
                                    ? Colors.white
                                    : AppTheme.textMedium,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Cachê
                  if (user.isArtista &&
                      user.faixaCache != null) ...[
                    _ProfileCard(
                      title: 'Cachê',
                      child: Row(
                        children: [
                          const Icon(Icons.payments_rounded,
                              color: AppTheme.statusGreen, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            user.faixaCache!,
                            style: const TextStyle(
                              color: AppTheme.statusGreen,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Links de plataforma
                  if (user.redesSociais.isNotEmpty) ...[
                    _ProfileCard(
                      title: 'Meus Links',
                      child: Column(
                        children:
                            user.redesSociais.entries.map((e) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10),
                            child: _PlatformLink(
                              platform: e.key,
                              url: e.value,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _disponibilidadeCard(user) {
    return GestureDetector(
      onTap: () {
        final updated = user.copyWith(
            disponivelContratacao: !user.disponivelContratacao);
        AuthService.updateCurrentUser(updated);
        setState(() {});
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: user.disponivelContratacao
                ? AppTheme.statusGreen.withValues(alpha: 0.4)
                : const Color(0xFFE5E7EB),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 6,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: user.disponivelContratacao
                    ? AppTheme.statusGreen
                    : AppTheme.textLight,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                user.disponivelContratacao
                    ? 'Disponível para contratação'
                    : 'Indisponível no momento',
                style: TextStyle(
                  color: user.disponivelContratacao
                      ? AppTheme.statusGreen
                      : AppTheme.textMedium,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Toggle visual
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 24,
              decoration: BoxDecoration(
                color: user.disponivelContratacao
                    ? AppTheme.primary
                    : const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: user.disponivelContratacao
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PapelChip extends StatelessWidget {
  final String papel;
  const _PapelChip(this.papel);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.3)),
      ),
      child: Text(
        papel == 'ARTISTA' ? 'Artista / Músico' : 'Contratante',
        style: const TextStyle(
            color: AppTheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ProfileCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.lightCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _PlatformLink extends StatelessWidget {
  final String platform;
  final String url;

  const _PlatformLink(
      {required this.platform, required this.url});

  IconData get _icon {
    switch (platform.toLowerCase()) {
      case 'youtube':
        return Icons.play_circle_fill_rounded;
      case 'spotify':
        return Icons.music_note_rounded;
      case 'instagram':
        return Icons.camera_alt_rounded;
      case 'tiktok':
        return Icons.music_video_rounded;
      case 'soundcloud':
        return Icons.cloud_rounded;
      default:
        return Icons.link_rounded;
    }
  }

  Color get _color {
    switch (platform.toLowerCase()) {
      case 'youtube':
        return const Color(0xFFEF4444);
      case 'spotify':
        return const Color(0xFF22C55E);
      case 'instagram':
        return const Color(0xFFE1306C);
      case 'tiktok':
        return const Color(0xFF1A1A1A);
      case 'soundcloud':
        return const Color(0xFFFF5500);
      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = platform[0].toUpperCase() + platform.substring(1);
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_icon, color: _color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                url,
                style: const TextStyle(
                    color: AppTheme.textMedium, fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Icon(Icons.open_in_new_rounded,
            size: 16, color: AppTheme.textLight),
      ],
    );
  }
}
