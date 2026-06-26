import 'package:flutter/material.dart';
import '../../constants/music_genres.dart';
import '../../services/auth_service.dart';
import '../../services/event_service.dart';
import '../../models/event_model.dart';
import '../../theme/app_theme.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _tituloCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _localCtrl = TextEditingController();
  final _cidadeCtrl = TextEditingController();
  final _estadoCtrl = TextEditingController();
  final _cacheCtrl = TextEditingController();

  DateTime _data = DateTime.now().add(const Duration(days: 7));
  TimeOfDay _horario = const TimeOfDay(hour: 20, minute: 0);
  bool _contratando = true;
  bool _loading = false;
  final Set<String> _generosSelecionados = {};

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descCtrl.dispose();
    _localCtrl.dispose();
    _cidadeCtrl.dispose();
    _estadoCtrl.dispose();
    _cacheCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppTheme.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _data = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _horario,
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppTheme.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _horario = picked);
  }

  Future<void> _publicar() async {
    final titulo = _tituloCtrl.text.trim();
    final local = _localCtrl.text.trim();
    final cidade = _cidadeCtrl.text.trim();
    final estado = _estadoCtrl.text.trim();

    if (titulo.isEmpty || local.isEmpty || cidade.isEmpty || estado.isEmpty) {
      _showError('Preencha título, local, cidade e estado');
      return;
    }
    if (_generosSelecionados.isEmpty) {
      _showError('Selecione pelo menos um gênero musical');
      return;
    }

    setState(() => _loading = true);

    final user = AuthService.currentUser!;
    final dataComHora = DateTime(
      _data.year,
      _data.month,
      _data.day,
      _horario.hour,
      _horario.minute,
    );
    final event = EventModel(
      id: '',
      titulo: titulo,
      descricao: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      local: local,
      cidade: cidade,
      estado: estado,
      data: dataComHora,
      generos: _generosSelecionados.toList(),
      cacheEstimado:
          _cacheCtrl.text.trim().isEmpty ? null : _cacheCtrl.text.trim(),
      contratando: _contratando,
      criadorId: user.uid,
      criadorNome: user.nome,
      emDestaque: user.perfilPago,
      criadoEm: DateTime.now(),
    );

    try {
      await EventService.create(event, userId: user.uid);

      if (!mounted) return;
      setState(() => _loading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Evento publicado com sucesso!'),
          backgroundColor: AppTheme.statusGreen,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showError(e.toString());
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
            // App bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppTheme.textDark, size: 20),
                  ),
                  const Expanded(
                    child: Text(
                      'Criar Evento',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _loading ? null : _publicar,
                    child: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppTheme.primary),
                          )
                        : const Text(
                            'Publicar',
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _label('Nome do evento *'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _tituloCtrl,
                      style: const TextStyle(
                          color: AppTheme.textDark, fontSize: 14),
                      decoration: AppTheme.lightInputDecoration(
                        hint: 'Ex: Festival de Verão',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Localização
                    _label('Localização *'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _localCtrl,
                      style: const TextStyle(
                          color: AppTheme.textDark, fontSize: 14),
                      decoration: AppTheme.lightInputDecoration(
                        hint: 'Cidade, bairro ou endereço',
                        prefixIcon: const Icon(Icons.location_on_outlined,
                            color: AppTheme.textLight, size: 20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _cidadeCtrl,
                            style: const TextStyle(
                                color: AppTheme.textDark, fontSize: 14),
                            decoration: AppTheme.lightInputDecoration(
                              hint: 'Cidade *',
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
                    const SizedBox(height: 16),

                    // Data e horário
                    _label('Data e horário *'),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: AppTheme.inputBg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today_rounded,
                                      color: AppTheme.textLight, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_data.day.toString().padLeft(2, '0')}/${_data.month.toString().padLeft(2, '0')}/${_data.year}',
                                    style: const TextStyle(
                                        color: AppTheme.textDark, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: _pickTime,
                            child: Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: AppTheme.inputBg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time_rounded,
                                      color: AppTheme.textLight, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_horario.hour.toString().padLeft(2, '0')}:${_horario.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                        color: AppTheme.textDark, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Cachê
                    _label('Cachê estimado'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _cacheCtrl,
                      style: const TextStyle(
                          color: AppTheme.textDark, fontSize: 14),
                      decoration: AppTheme.lightInputDecoration(
                        hint: 'Ex: R\$ 800 – R\$ 1.500',
                        prefixIcon: const Icon(Icons.payments_outlined,
                            color: AppTheme.textLight, size: 20),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Estilos musicais
                    _label('Estilo musical *'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: musicGenres.map((g) {
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
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color:
                                  sel ? AppTheme.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel
                                    ? AppTheme.primary
                                    : const Color(0xFFD1D5DB),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              g,
                              style: TextStyle(
                                color: sel ? Colors.white : AppTheme.textMedium,
                                fontSize: 13,
                                fontWeight:
                                    sel ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Toggle: precisa de músicos
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
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
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Precisa de músicos?',
                                  style: TextStyle(
                                    color: AppTheme.textDark,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Ative para receber candidaturas',
                                  style: TextStyle(
                                    color: AppTheme.textMedium,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _contratando = !_contratando),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 48,
                              height: 26,
                              decoration: BoxDecoration(
                                color: _contratando
                                    ? AppTheme.primary
                                    : const Color(0xFFD1D5DB),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: AnimatedAlign(
                                duration: const Duration(milliseconds: 200),
                                alignment: _contratando
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Descrição
                    _label('Descrição (opcional)'),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.inputBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _descCtrl,
                        maxLines: 4,
                        style: const TextStyle(
                            color: AppTheme.textDark, fontSize: 14),
                        decoration: const InputDecoration(
                          hintText:
                              'Conte mais sobre o evento, público esperado, requisitos...',
                          hintStyle: TextStyle(
                              color: AppTheme.textLight, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Botão criar
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _loading ? null : _publicar,
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Criar evento'),
                        style: AppTheme.primaryButtonStyle,
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

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          color: AppTheme.textDark,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      );
}
