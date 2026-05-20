import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../theme/app_theme.dart';

// Gradiente visual por gênero (sem fotos no modelo, usamos cores temáticas)
LinearGradient _gradientForGenre(List<String> generos) {
  final first = generos.isNotEmpty ? generos.first.toLowerCase() : '';
  switch (first) {
    case 'sertanejo':
      return const LinearGradient(
          colors: [Color(0xFFB45309), Color(0xFF92400E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
    case 'rock':
      return const LinearGradient(
          colors: [Color(0xFF1F2937), Color(0xFF374151)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
    case 'pagode':
    case 'samba':
      return const LinearGradient(
          colors: [Color(0xFFEA580C), Color(0xFFB45309)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
    case 'jazz':
    case 'blues':
      return const LinearGradient(
          colors: [Color(0xFF7C2D12), Color(0xFF991B1B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
    case 'mpb':
    case 'bossa nova':
      return const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
    case 'eletrônica':
    case 'house':
      return const LinearGradient(
          colors: [Color(0xFF6D28D9), Color(0xFF4C1D95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
    case 'pop':
      return const LinearGradient(
          colors: [Color(0xFFDB2777), Color(0xFF9D174D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
    case 'forró':
      return const LinearGradient(
          colors: [Color(0xFF15803D), Color(0xFF166534)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
    default:
      return const LinearGradient(
          colors: [Color(0xFF7B4FD9), Color(0xFF3B1F8C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
  }
}

Color _colorForGenre(String genero) {
  switch (genero.toLowerCase()) {
    case 'sertanejo':
      return const Color(0xFFF59E0B);
    case 'rock':
      return const Color(0xFF6EE7B7);
    case 'pagode':
    case 'samba':
      return const Color(0xFFFB923C);
    case 'jazz':
    case 'blues':
      return const Color(0xFFF87171);
    case 'mpb':
    case 'bossa nova':
      return const Color(0xFF60A5FA);
    case 'eletrônica':
    case 'house':
      return const Color(0xFFA78BFA);
    case 'pop':
      return const Color(0xFFF9A8D4);
    case 'forró':
      return const Color(0xFF4ADE80);
    default:
      return Colors.white;
  }
}

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat("dd 'de' MMMM", 'pt_BR').format(event.data);
    final weekday = DateFormat('EEE', 'pt_BR').format(event.data);
    final timeStr = DateFormat('HH:mm', 'pt_BR').format(event.data);
    final gradient = _gradientForGenre(event.generos);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho visual 16:9 com gradiente de gênero
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(decoration: BoxDecoration(gradient: gradient)),
                  // Ícone central decorativo
                  Center(
                    child: Icon(
                      Icons.music_note_rounded,
                      color: Colors.white.withValues(alpha: 0.15),
                      size: 80,
                    ),
                  ),
                  // Badge de gênero (canto sup. esquerdo)
                  if (event.generos.isNotEmpty)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          event.generos.first,
                          style: TextStyle(
                            color: _colorForGenre(event.generos.first),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  // Badge destaque
                  if (event.emDestaque)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.gold,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '★ DESTAQUE',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Conteúdo do card
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: event.contratando
                              ? AppTheme.statusGreen.withValues(alpha: 0.12)
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: event.contratando
                                    ? AppTheme.statusGreen
                                    : const Color(0xFF9CA3AF),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              event.contratando
                                  ? 'Aceitando músicos'
                                  : 'Vagas preenchidas',
                              style: TextStyle(
                                color: event.contratando
                                    ? AppTheme.statusGreen
                                    : const Color(0xFF6B7280),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Título
                  Text(
                    event.titulo,
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Local
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 13, color: AppTheme.textLight),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${event.local} – ${event.cidade}/${event.estado}',
                          style: const TextStyle(
                              color: AppTheme.textMedium, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),

                  // Data/horário
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 13, color: AppTheme.textLight),
                      const SizedBox(width: 4),
                      Text(
                        '$weekday, $dateStr · $timeStr',
                        style: const TextStyle(
                            color: AppTheme.textMedium, fontSize: 12),
                      ),
                    ],
                  ),

                  // Cachê + Ver detalhes
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (event.cacheEstimado != null)
                        Row(
                          children: [
                            const Icon(Icons.payments_rounded,
                                size: 13, color: AppTheme.statusGreen),
                            const SizedBox(width: 4),
                            Text(
                              event.cacheEstimado!,
                              style: const TextStyle(
                                color: AppTheme.statusGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                      else
                        const SizedBox.shrink(),
                      TextButton(
                        onPressed: onTap,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor:
                              AppTheme.primary.withValues(alpha: 0.08),
                          foregroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Ver detalhes',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
