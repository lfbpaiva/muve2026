import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MuveAvatar extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final double radius;
  final bool showBorder;

  const MuveAvatar({
    super.key,
    this.photoUrl,
    required this.name,
    this.radius = 28,
    this.showBorder = false,
  });

  Color _colorFromName(String name) {
    final colors = [
      AppTheme.primary,
      AppTheme.primaryMedium,
      const Color(0xFF00695C),
      const Color(0xFF1565C0),
      const Color(0xFFAD1457),
      const Color(0xFF6A1B9A),
      const Color(0xFF4527A0),
    ];
    final index = name.codeUnits.fold(0, (sum, c) => sum + c) % colors.length;
    return colors[index];
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(color: AppTheme.primaryLight, width: 2)
            : null,
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: _colorFromName(name),
        child: Text(
          _initials(name),
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.65,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
