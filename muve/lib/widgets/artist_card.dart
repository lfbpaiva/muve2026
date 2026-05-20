import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';
import 'muve_avatar.dart';

class ArtistCard extends StatelessWidget {
  final UserModel artist;
  final VoidCallback onTap;

  const ArtistCard({super.key, required this.artist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          border: artist.perfilPago
              ? Border.all(color: AppTheme.gold, width: 1.5)
              : null,
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Avatar circular com borda roxa se disponível
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: artist.disponivelContratacao
                          ? AppTheme.primary
                          : const Color(0xFFE5E7EB),
                      width: 2.5,
                    ),
                  ),
                  child: MuveAvatar(name: artist.nome, radius: 26),
                ),
                if (artist.disponivelContratacao)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppTheme.statusGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          artist.nome,
                          style: const TextStyle(
                            color: AppTheme.textDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (artist.perfilPago)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.gold.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppTheme.gold.withValues(alpha: 0.5)),
                          ),
                          child: const Text(
                            'PRO',
                            style: TextStyle(
                              color: AppTheme.gold,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 11, color: AppTheme.textLight),
                      const SizedBox(width: 2),
                      Text(
                        '${artist.cidade}, ${artist.estado}',
                        style: const TextStyle(
                          color: AppTheme.textMedium,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (artist.generos.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 5,
                      runSpacing: 4,
                      children: artist.generos.take(3).map((g) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                    AppTheme.primary.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            g,
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Cachê e status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (artist.faixaCache != null)
                  Text(
                    artist.faixaCache!,
                    style: const TextStyle(
                      color: AppTheme.statusGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textLight,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
