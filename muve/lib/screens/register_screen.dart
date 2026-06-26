import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import '../constants/music_genres.dart';
import '../routes.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _cidadeCtrl = TextEditingController();
  final _estadoCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _cnpjCtrl = TextEditingController();

  bool _obscureSenha = true;
  bool _loading = false;

  final Set<String> _papeis = {};
  final Set<String> _generosSelecionados = {};

  bool get _hasArtista => _papeis.contains('ARTISTA');
  bool get _hasContratante => _papeis.contains('CONTRATANTE');

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    _cidadeCtrl.dispose();
    _estadoCtrl.dispose();
    _telefoneCtrl.dispose();
    _cpfCtrl.dispose();
    _cnpjCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final nome = _nomeCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final senha = _senhaCtrl.text;
    final cidade = _cidadeCtrl.text.trim();
    final estado = _estadoCtrl.text.trim();

    if (nome.isEmpty ||
        email.isEmpty ||
        senha.isEmpty ||
        cidade.isEmpty ||
        estado.isEmpty) {
      _showError('Preencha todos os campos obrigatórios');
      return;
    }
    if (senha.length < 6) {
      _showError('A senha deve ter pelo menos 6 caracteres');
      return;
    }
    if (_papeis.isEmpty) {
      _showError('Selecione pelo menos um papel');
      return;
    }
    if (_hasArtista && _generosSelecionados.isEmpty) {
      _showError('Selecione ao menos um gênero musical');
      return;
    }
    if (_hasArtista) {
      final digits = _cpfCtrl.text.replaceAll(RegExp(r'[^\d]'), '');
      if (digits.length != 11) {
        _showError('CPF inválido — preencha os 11 dígitos');
        return;
      }
    }
    if (_hasContratante) {
      final digits = _cnpjCtrl.text.replaceAll(RegExp(r'[^\d]'), '');
      if (digits.length != 14) {
        _showError('CNPJ inválido — preencha os 14 dígitos');
        return;
      }
    }

    setState(() => _loading = true);
    final result = await AuthService.register(
      nome: nome,
      email: email,
      senha: senha,
      cidade: cidade,
      estado: estado,
      papeis: _papeis.toList(),
      telefone:
          _telefoneCtrl.text.trim().isEmpty ? null : _telefoneCtrl.text.trim(),
      cpf: _hasArtista ? _cpfCtrl.text.trim() : null,
      cnpj: _hasContratante ? _cnpjCtrl.text.trim() : null,
      generos: _generosSelecionados.toList(),
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (result.success) {
      Navigator.pushReplacementNamed(context, Routes.main);
    } else {
      _showError(result.error ?? 'Erro ao criar conta');
    }
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
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header com botão voltar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppTheme.textDark, size: 20),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo header
                    FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.music_note_rounded,
                                  color: AppTheme.primary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Muve',
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Crie sua conta e comece a se conectar',
                            style: TextStyle(
                              color: AppTheme.textMedium,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Tipo de conta
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: const Text(
                        'Como você quer usar o Muve?',
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    FadeInUp(
                      delay: const Duration(milliseconds: 120),
                      child: const Text(
                        'Você poderá alterar isso depois',
                        style: TextStyle(
                          color: AppTheme.textMedium,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    FadeInUp(
                      delay: const Duration(milliseconds: 150),
                      child: Column(
                        children: [
                          _RoleCard(
                            icon: Icons.mic_rounded,
                            label: 'Somente Artista',
                            description: 'Mostre seu talento e seja encontrado',
                            selected: _hasArtista && !_hasContratante,
                            onTap: () => setState(() {
                              _papeis.clear();
                              _papeis.add('ARTISTA');
                            }),
                          ),
                          const SizedBox(height: 10),
                          _RoleCard(
                            icon: Icons.business_center_rounded,
                            label: 'Somente Contratante',
                            description: 'Encontre artistas para seus eventos',
                            selected: _hasContratante && !_hasArtista,
                            onTap: () => setState(() {
                              _papeis.clear();
                              _papeis.add('CONTRATANTE');
                            }),
                          ),
                          const SizedBox(height: 10),
                          _RoleCard(
                            icon: Icons.theater_comedy_rounded,
                            label: 'Artista e Contratante',
                            description: 'Perfil híbrido com acesso completo',
                            selected: _hasArtista && _hasContratante,
                            onTap: () => setState(() {
                              _papeis.clear();
                              _papeis.add('ARTISTA');
                              _papeis.add('CONTRATANTE');
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Dados pessoais
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: _sectionLabel('Dados pessoais'),
                    ),
                    const SizedBox(height: 10),
                    FadeInUp(
                      delay: const Duration(milliseconds: 220),
                      child: TextField(
                        controller: _nomeCtrl,
                        style: const TextStyle(
                            color: AppTheme.textDark, fontSize: 14),
                        decoration: AppTheme.lightInputDecoration(
                          hint: 'Nome completo *',
                          prefixIcon: const Icon(Icons.person_outline,
                              color: AppTheme.textLight, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeInUp(
                      delay: const Duration(milliseconds: 240),
                      child: TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                            color: AppTheme.textDark, fontSize: 14),
                        decoration: AppTheme.lightInputDecoration(
                          hint: 'E-mail *',
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: AppTheme.textLight, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeInUp(
                      delay: const Duration(milliseconds: 260),
                      child: TextField(
                        controller: _senhaCtrl,
                        obscureText: _obscureSenha,
                        style: const TextStyle(
                            color: AppTheme.textDark, fontSize: 14),
                        decoration: AppTheme.lightInputDecoration(
                          hint: 'Senha * (mín. 6 caracteres)',
                          prefixIcon: const Icon(Icons.lock_outline_rounded,
                              color: AppTheme.textLight, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureSenha
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppTheme.textLight,
                              size: 20,
                            ),
                            onPressed: () =>
                                setState(() => _obscureSenha = !_obscureSenha),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeInUp(
                      delay: const Duration(milliseconds: 280),
                      child: TextField(
                        controller: _telefoneCtrl,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                            color: AppTheme.textDark, fontSize: 14),
                        decoration: AppTheme.lightInputDecoration(
                          hint: 'Telefone (opcional)',
                          prefixIcon: const Icon(Icons.phone_outlined,
                              color: AppTheme.textLight, size: 20),
                        ),
                      ),
                    ),

                    // CPF — apenas para artistas
                    if (_hasArtista) ...[
                      const SizedBox(height: 12),
                      FadeInUp(
                        duration: const Duration(milliseconds: 300),
                        child: TextField(
                          controller: _cpfCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [_CpfInputFormatter()],
                          style: const TextStyle(
                              color: AppTheme.textDark, fontSize: 14),
                          decoration: AppTheme.lightInputDecoration(
                            hint: 'CPF *',
                            prefixIcon: const Icon(Icons.badge_outlined,
                                color: AppTheme.textLight, size: 20),
                          ),
                        ),
                      ),
                    ],

                    // CNPJ — apenas para contratantes
                    if (_hasContratante) ...[
                      const SizedBox(height: 12),
                      FadeInUp(
                        duration: const Duration(milliseconds: 300),
                        child: TextField(
                          controller: _cnpjCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [_CnpjInputFormatter()],
                          style: const TextStyle(
                              color: AppTheme.textDark, fontSize: 14),
                          decoration: AppTheme.lightInputDecoration(
                            hint: 'CNPJ *',
                            prefixIcon: const Icon(Icons.corporate_fare_rounded,
                                color: AppTheme.textLight, size: 20),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Localização
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: _sectionLabel('Localização'),
                    ),
                    const SizedBox(height: 10),
                    FadeInUp(
                      delay: const Duration(milliseconds: 320),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: _cidadeCtrl,
                              style: const TextStyle(
                                  color: AppTheme.textDark, fontSize: 14),
                              decoration: AppTheme.lightInputDecoration(
                                hint: 'Cidade *',
                                prefixIcon: const Icon(
                                    Icons.location_city_outlined,
                                    color: AppTheme.textLight,
                                    size: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _estadoCtrl,
                              maxLength: 2,
                              style: const TextStyle(
                                  color: AppTheme.textDark, fontSize: 14),
                              decoration: AppTheme.lightInputDecoration(
                                hint: 'UF *',
                              ).copyWith(counterText: ''),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Gêneros musicais (apenas para artistas)
                    if (_hasArtista) ...[
                      const SizedBox(height: 24),
                      FadeInUp(
                        delay: const Duration(milliseconds: 340),
                        child: _sectionLabel('Gêneros musicais *'),
                      ),
                      const SizedBox(height: 10),
                      FadeInUp(
                        delay: const Duration(milliseconds: 360),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: musicGenres.map((g) {
                            final isSelected = _generosSelecionados.contains(g);
                            return GestureDetector(
                              onTap: () => setState(() {
                                if (isSelected) {
                                  _generosSelecionados.remove(g);
                                } else {
                                  _generosSelecionados.add(g);
                                }
                              }),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.primary
                                        : const Color(0xFFD1D5DB),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  g,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : AppTheme.textMedium,
                                    fontSize: 13,
                                    fontWeight: isSelected
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

                    const SizedBox(height: 32),

                    // Botão cadastrar
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _register,
                          style: AppTheme.primaryButtonStyle,
                          child: _loading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('Cadastrar →'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Link login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Já tem conta?',
                          style: TextStyle(
                              color: AppTheme.textMedium, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Fazer login',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          color: AppTheme.textDark,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      );
}

class _CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final limited = digits.length > 11 ? digits.substring(0, 11) : digits;

    final buf = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i == 3 || i == 6) buf.write('.');
      if (i == 9) buf.write('-');
      buf.write(limited[i]);
    }

    final formatted = buf.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _CnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final limited = digits.length > 14 ? digits.substring(0, 14) : digits;

    final buf = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i == 2 || i == 5) buf.write('.');
      if (i == 8) buf.write('/');
      if (i == 12) buf.write('-');
      buf.write(limited[i]);
    }

    final formatted = buf.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppTheme.primary : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [
                  const BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  )
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primary.withValues(alpha: 0.1)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: selected ? AppTheme.primary : AppTheme.textMedium,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppTheme.textMedium,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppTheme.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppTheme.primary : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
