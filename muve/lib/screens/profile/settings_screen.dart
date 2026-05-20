import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

const _allGenres = [
  'Sertanejo', 'Rock', 'Pagode', 'MPB', 'Eletrônica',
  'Indie', 'Jazz', 'Funk', 'Gospel', 'Pop', 'Hip-Hop', 'Forró',
  'Bossa Nova', 'Samba', 'Blues', 'House', 'Reggae',
];

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificacoesAtivas = true;
  late Set<String> _generosSelecionados;
  late TextEditingController _cacheCtrl;

  @override
  void initState() {
    super.initState();
    final user = AuthService.currentUser!;
    _generosSelecionados = Set.from(user.generos);
    _cacheCtrl = TextEditingController(text: user.faixaCache ?? '');
  }

  @override
  void dispose() {
    _cacheCtrl.dispose();
    super.dispose();
  }

  void _saveAndPop() {
    final user = AuthService.currentUser!;
    final updated = user.copyWith(
      generos: _generosSelecionados.toList(),
      faixaCache:
          _cacheCtrl.text.trim().isEmpty ? null : _cacheCtrl.text.trim(),
    );
    AuthService.updateCurrentUser(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser!;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            // App bar dark
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _saveAndPop,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const Expanded(
                    child: Text(
                      'Configurações',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // CONTA
                    _sectionLabel('CONTA'),
                    _DarkCard(children: [
                      _rowToggle(
                        icon: Icons.notifications_outlined,
                        label: 'Notificações',
                        value: _notificacoesAtivas,
                        onChanged: (v) =>
                            setState(() => _notificacoesAtivas = v),
                      ),
                    ]),
                    const SizedBox(height: 20),

                    // PREFERÊNCIAS
                    _sectionLabel('PREFERÊNCIAS'),
                    _DarkCard(children: [
                      _rowChevron(
                          Icons.palette_outlined, 'Tema', 'Escuro'),
                      if (user.isArtista) ...[
                        _divider(),
                        _rowInput(
                          icon: Icons.payments_outlined,
                          label: 'Cachê estimado',
                          ctrl: _cacheCtrl,
                          hint: 'Ex: R\$ 800 – R\$ 2.000',
                        ),
                      ],
                    ]),

                    // Estilos musicais (artistas)
                    if (user.isArtista) ...[
                      const SizedBox(height: 20),
                      _sectionLabel('ESTILOS MUSICAIS'),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F2937),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _allGenres.map((g) {
                            final sel = _generosSelecionados.contains(g);
                            return GestureDetector(
                              onTap: () => setState(() {
                                if (sel) {
                                  _generosSelecionados.remove(g);
                                } else {
                                  _generosSelecionados.add(g);
                                }
                              }),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: sel
                                      ? AppTheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: sel
                                        ? AppTheme.primary
                                        : const Color(0xFF4B5563),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  g,
                                  style: TextStyle(
                                    color: sel
                                        ? Colors.white
                                        : const Color(0xFF9CA3AF),
                                    fontSize: 13,
                                    fontWeight: sel
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],

                    // SOBRE
                    const SizedBox(height: 20),
                    _sectionLabel('SOBRE'),
                    _DarkCard(children: [
                      _rowChevron(
                          Icons.description_outlined, 'Termos de Uso', ''),
                      _divider(),
                      _rowChevron(Icons.security_outlined,
                          'Política de Privacidade', ''),
                      _divider(),
                      Row(
                        children: const [
                          Icon(Icons.info_outline,
                              color: Color(0xFF9CA3AF), size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Versão do App',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ),
                          Text(
                            'v1.0.0',
                            style: TextStyle(
                                color: Color(0xFF6B7280), fontSize: 14),
                          ),
                        ],
                      ),
                    ]),

                    // Botão Sair (destrutivo)
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          AuthService.logout();
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.login, (_) => false);
                        },
                        icon: const Icon(Icons.logout_rounded,
                            color: Colors.white, size: 18),
                        label: const Text(
                          'Sair da Conta',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.statusRed,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
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
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      );

  Widget _divider() => const Divider(
      color: Color(0xFF374151), height: 16, thickness: 1);

  Widget _rowToggle({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) =>
      Row(
        children: [
          Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14))),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 24,
              decoration: BoxDecoration(
                color: value ? AppTheme.primary : const Color(0xFF4B5563),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment:
                    value ? Alignment.centerRight : Alignment.centerLeft,
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
          ),
        ],
      );

  Widget _rowChevron(IconData icon, String label, String value) => Row(
        children: [
          Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14))),
          if (value.isNotEmpty)
            Text(value,
                style: const TextStyle(
                    color: Color(0xFF6B7280), fontSize: 14)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded,
              color: Color(0xFF4B5563), size: 18),
        ],
      );

  Widget _rowInput({
    required IconData icon,
    required String label,
    required TextEditingController ctrl,
    required String hint,
  }) =>
      Row(
        children: [
          Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: ctrl,
              style:
                  const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                    color: Color(0xFF4B5563), fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
        ],
      );
}

class _DarkCard extends StatelessWidget {
  final List<Widget> children;
  const _DarkCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children.map((c) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: c,
          );
        }).toList(),
      ),
    );
  }
}
