import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/muve_avatar.dart';

const _redesKeys = ['instagram', 'youtube', 'spotify', 'tiktok', 'soundcloud'];

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nomeCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _cidadeCtrl;
  late final TextEditingController _estadoCtrl;
  late final TextEditingController _telefoneCtrl;
  late final Map<String, TextEditingController> _redesCtrls;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = AuthService.currentUser!;
    _nomeCtrl = TextEditingController(text: user.nome);
    _bioCtrl = TextEditingController(text: user.bio ?? '');
    _cidadeCtrl = TextEditingController(text: user.cidade);
    _estadoCtrl = TextEditingController(text: user.estado);
    _telefoneCtrl = TextEditingController(text: user.telefone ?? '');
    _redesCtrls = {
      for (final k in _redesKeys)
        k: TextEditingController(text: user.redesSociais[k] ?? ''),
    };
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _bioCtrl.dispose();
    _cidadeCtrl.dispose();
    _estadoCtrl.dispose();
    _telefoneCtrl.dispose();
    for (final c in _redesCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final nome = _nomeCtrl.text.trim();
    if (nome.isEmpty) {
      _showError('O nome não pode estar vazio');
      return;
    }

    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final redesSociais = <String, String>{};
    for (final k in _redesKeys) {
      final v = _redesCtrls[k]!.text.trim();
      if (v.isNotEmpty) redesSociais[k] = v;
    }

    final updated = AuthService.currentUser!.copyWith(
      nome: nome,
      bio: _bioCtrl.text.trim().isEmpty ? null : _bioCtrl.text.trim(),
      cidade: _cidadeCtrl.text.trim(),
      estado: _estadoCtrl.text.trim(),
      telefone: _telefoneCtrl.text.trim().isEmpty
          ? null
          : _telefoneCtrl.text.trim(),
      redesSociais: redesSociais,
    );

    AuthService.updateCurrentUser(updated);
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.pop(context);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppTheme.statusRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser!;

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar light
            Container(
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
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppTheme.textDark, size: 18),
                  ),
                  const Expanded(
                    child: Text(
                      'Editar Perfil',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppTheme.primary),
                          )
                        : const Text(
                            'Salvar',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.primary.withValues(alpha: 0.3),
                                  width: 3,
                                ),
                              ),
                              child: MuveAvatar(
                                  name: user.nome, radius: 48, showBorder: false),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Informações pessoais
                    _sectionLabel('INFORMAÇÕES PESSOAIS'),
                    _FormCard(children: [
                      _field(
                        ctrl: _nomeCtrl,
                        hint: 'Nome completo',
                        icon: Icons.person_outline,
                      ),
                      _divider(),
                      _field(
                        ctrl: _bioCtrl,
                        hint: 'Bio',
                        icon: Icons.info_outline,
                        maxLines: 3,
                      ),
                    ]),

                    const SizedBox(height: 16),

                    // Localização
                    _sectionLabel('LOCALIZAÇÃO'),
                    _FormCard(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_city_outlined,
                              color: AppTheme.textLight, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: _cidadeCtrl,
                              style: const TextStyle(
                                  color: AppTheme.textDark, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'Cidade',
                                hintStyle: TextStyle(
                                    color: AppTheme.textLight, fontSize: 14),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                              width: 1, height: 20, color: const Color(0xFFE5E7EB)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _estadoCtrl,
                              maxLength: 2,
                              textCapitalization: TextCapitalization.characters,
                              style: const TextStyle(
                                  color: AppTheme.textDark, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'UF',
                                hintStyle: TextStyle(
                                    color: AppTheme.textLight, fontSize: 14),
                                border: InputBorder.none,
                                counterText: '',
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _divider(),
                      _field(
                        ctrl: _telefoneCtrl,
                        hint: 'Telefone',
                        icon: Icons.phone_outlined,
                        type: TextInputType.phone,
                      ),
                    ]),

                    const SizedBox(height: 16),

                    // Redes sociais
                    _sectionLabel('REDES SOCIAIS'),
                    _FormCard(
                      children: _redesKeys.asMap().entries.map((e) {
                        final k = e.value;
                        final isLast = e.key == _redesKeys.length - 1;
                        final label = k[0].toUpperCase() + k.substring(1);
                        return Column(
                          children: [
                            _field(
                              ctrl: _redesCtrls[k]!,
                              hint: label,
                              icon: _iconForPlatform(k),
                              type: TextInputType.url,
                            ),
                            if (!isLast) _divider(),
                          ],
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        child: Text(
          label,
          style: const TextStyle(
            color: AppTheme.textLight,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      );

  Widget _divider() => const Divider(
        color: Color(0xFFF3F4F6),
        height: 16,
        indent: 32,
      );

  Widget _field({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    TextInputType type = TextInputType.text,
    int maxLines = 1,
  }) =>
      Row(
        crossAxisAlignment:
            maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.textLight, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: ctrl,
              keyboardType: type,
              maxLines: maxLines,
              style:
                  const TextStyle(color: AppTheme.textDark, fontSize: 14),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                    color: AppTheme.textLight, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
        ],
      );

  IconData _iconForPlatform(String platform) {
    switch (platform) {
      case 'youtube':
        return Icons.play_circle_outline_rounded;
      case 'spotify':
        return Icons.music_note_outlined;
      case 'instagram':
        return Icons.camera_alt_outlined;
      case 'tiktok':
        return Icons.music_video_outlined;
      case 'soundcloud':
        return Icons.cloud_outlined;
      default:
        return Icons.link_rounded;
    }
  }
}

class _FormCard extends StatelessWidget {
  final List<Widget> children;
  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children
            .map((c) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: c,
                ))
            .toList(),
      ),
    );
  }
}
