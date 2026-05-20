import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GenreChip extends StatelessWidget {
  final String label;
  final bool small;
  final bool selected;

  const GenreChip({
    super.key,
    required this.label,
    this.small = false,
    this.selected = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 12,
        vertical: small ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: selected ? AppTheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppTheme.primary : const Color(0xFFD1D5DB),
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : AppTheme.textMedium,
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
