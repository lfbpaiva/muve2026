import 'package:flutter/material.dart';

class AppTheme {
  // Brand
  static const Color primary = Color(0xFF7B4FD9);
  static const Color primaryDark = Color(0xFF3B1F8C);
  static const Color primaryMagenta = Color(0xFFC850C0);

  // Light surfaces
  static const Color bgLight = Color(0xFFF5F5F7);
  static const Color inputBg = Color(0xFFF3F4F6);
  static const Color cardWhite = Colors.white;
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // Dark surfaces (settings, apply screens)
  static const Color bgDark = Color(0xFF0F0F0F);
  static const Color surfaceDark = Color(0xFF1F2937);
  static const Color borderDark = Color(0xFF374151);

  // Status
  static const Color statusGreen = Color(0xFF22C55E);
  static const Color statusRed = Color(0xFFEF4444);

  // Legacy (mantidos para compatibilidade)
  static const Color primaryMedium = Color(0xFF6A1B9A);
  static const Color primaryLight = Color(0xFF9C27B0);
  static const Color accent = Color(0xFFCE93D8);
  static const Color gold = Color(0xFFFFD600);
  static const Color background = Color(0xFF0D0020);
  static const Color surface = Color(0xFF1A0A2E);
  static const Color card = Color(0xFF241040);
  static const Color divider = Color(0xFF3D1A6E);
  static const Color textMuted = Color(0xFF9E8BB5);

  // Gradients
  static LinearGradient get loginGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3B1F8C), Color(0xFFC850C0)],
      );

  static LinearGradient get mainGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF7B4FD9), Color(0xFF6A1B9A)],
      );

  static LinearGradient get backgroundGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0D0020), Color(0xFF1A0A2E), Color(0xFF241040)],
      );

  static BoxDecoration get screenBackground => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D0020), Color(0xFF1A0A2E), Color(0xFF241040)],
        ),
      );

  // Light mode card
  static BoxDecoration get lightCardDecoration => BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      );

  // Dark mode card
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: divider, width: 1),
      );

  static BoxDecoration get featuredCardDecoration => BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gold, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: gold.withValues(alpha: 0.18),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      );

  static BoxDecoration inputDecoration({bool focused = false}) => BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: focused ? primaryLight : divider,
          width: focused ? 1.5 : 1,
        ),
      );

  // Light input decoration (para TextFormField/TextField)
  static InputDecoration lightInputDecoration({
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: textLight, fontSize: 14),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: inputBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: statusRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: statusRed, width: 1.5),
        ),
      );

  // Primary button style
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      );
}
