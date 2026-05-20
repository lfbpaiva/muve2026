import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../services/event_service.dart';
import '../../models/event_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/event_card.dart';
import 'create_event_screen.dart';

const _generosFiltro = [
  'Todos', 'Sertanejo', 'Rock', 'Pagode', 'MPB', 'Jazz',
  'Eletrônica', 'Indie', 'Pop', 'Funk', 'Gospel', 'Forró',
];

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _generoSelecionado = 'Todos';
  bool _apenasContratando = false;
  List<EventModel> _events = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      _events = EventService.search(
        genero:
            _generoSelecionado == 'Todos' ? null : _generoSelecionado,
        contratandoApenas: _apenasContratando ? true : null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(
              onCreateEvent: user != null && user.isContratante
                  ? () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CreateEventScreen()),
                      );
                      _load();
                    }
                  : null,
            ),
            _FilterBar(
              generoSelecionado: _generoSelecionado,
              apenasContratando: _apenasContratando,
              onGeneroChanged: (g) {
                setState(() => _generoSelecionado = g);
                _load();
              },
              onContratandoChanged: (v) {
                setState(() => _apenasContratando = v);
                _load();
              },
            ),
            Expanded(
              child: _events.isEmpty
                  ? const _EmptyState()
                  : RefreshIndicator(
                      onRefresh: () async => _load(),
                      color: AppTheme.primary,
                      backgroundColor: Colors.white,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                        itemCount: _events.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, i) {
                          final event = _events[i];
                          return EventCard(
                            event: event,
                            onTap: () => _showEventDetail(context, event),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventDetail(BuildContext context, EventModel event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EventDetailSheet(event: event),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback? onCreateEvent;
  const _Header({this.onCreateEvent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Eventos',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'Encontre ou publique shows',
                  style: TextStyle(
                      color: AppTheme.textMedium, fontSize: 13),
                ),
              ],
            ),
          ),
          if (onCreateEvent != null)
            ElevatedButton.icon(
              onPressed: onCreateEvent,
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Publicar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
                elevation: 0,
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final String generoSelecionado;
  final bool apenasContratando;
  final ValueChanged<String> onGeneroChanged;
  final ValueChanged<bool> onContratandoChanged;

  const _FilterBar({
    required this.generoSelecionado,
    required this.apenasContratando,
    required this.onGeneroChanged,
    required this.onContratandoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _generosFiltro.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final g = _generosFiltro[i];
              final active = g == generoSelecionado;
              return GestureDetector(
                onTap: () => onGeneroChanged(g),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: active ? AppTheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active
                          ? AppTheme.primary
                          : const Color(0xFFD1D5DB),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      g,
                      style: TextStyle(
                        color: active ? Colors.white : AppTheme.textMedium,
                        fontSize: 13,
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => onContratandoChanged(!apenasContratando),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: apenasContratando
                        ? AppTheme.statusGreen.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: apenasContratando
                          ? AppTheme.statusGreen
                          : const Color(0xFFD1D5DB),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.work_outline_rounded,
                        size: 13,
                        color: apenasContratando
                            ? AppTheme.statusGreen
                            : AppTheme.textMedium,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Contratando',
                        style: TextStyle(
                          color: apenasContratando
                              ? AppTheme.statusGreen
                              : AppTheme.textMedium,
                          fontSize: 12,
                          fontWeight: apenasContratando
                              ? FontWeight.w700
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_busy_rounded,
              size: 36,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nenhum evento encontrado',
            style: TextStyle(
              color: AppTheme.textDark,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tente outros filtros',
            style: TextStyle(color: AppTheme.textMedium, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// Bottom Sheet de detalhe — tema dark (Tela 7 do spec)
class _EventDetailSheet extends StatelessWidget {
  final EventModel event;
  const _EventDetailSheet({required this.event});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat("EEEE, dd 'de' MMMM 'de' yyyy", 'pt_BR')
        .format(event.data);

    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF111827),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF374151),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(24),
                children: [
                  if (event.emDestaque)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: const [
                          Icon(Icons.star_rounded,
                              color: AppTheme.gold, size: 14),
                          SizedBox(width: 6),
                          Text(
                            'EVENTO EM DESTAQUE',
                            style: TextStyle(
                              color: AppTheme.gold,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Chip de gênero
                  if (event.generos.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: event.generos
                          .map((g) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(g,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ))
                          .toList(),
                    ),
                  const SizedBox(height: 14),

                  Text(
                    event.titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Por ${event.criadorNome}',
                    style: const TextStyle(
                        color: Color(0xFF9CA3AF), fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  _DarkDetailRow(
                      icon: Icons.calendar_today_rounded, text: dateStr),
                  const SizedBox(height: 10),
                  _DarkDetailRow(
                    icon: Icons.location_on_rounded,
                    text:
                        '${event.local}\n${event.cidade}, ${event.estado}',
                  ),
                  if (event.cacheEstimado != null) ...[
                    const SizedBox(height: 10),
                    _DarkDetailRow(
                      icon: Icons.payments_rounded,
                      text: event.cacheEstimado!,
                      color: AppTheme.statusGreen,
                    ),
                  ],

                  if (event.descricao != null) ...[
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFF374151)),
                    const SizedBox(height: 16),
                    const Text(
                      'Sobre o evento',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.descricao!,
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),
                  if (event.contratando &&
                      AuthService.currentUser != null &&
                      AuthService.currentUser!.isArtista)
                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  '✅ Candidatura enviada! O contratante receberá sua notificação.'),
                              backgroundColor: AppTheme.statusGreen,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        },
                        icon: const Icon(Icons.send_rounded, size: 18),
                        label: const Text(
                          'Aplicar para este Evento',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        style: AppTheme.primaryButtonStyle,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DarkDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _DarkDetailRow({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16,
            color: color ?? const Color(0xFF6B7280)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: color ?? const Color(0xFF9CA3AF),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
