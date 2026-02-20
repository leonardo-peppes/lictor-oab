// lib/core/theme/app_theme.dart
// Lictor - Identidade visual monocromática e sofisticada

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Paleta principal - Monocromática sofisticada
  static const Color background = Color(0xFF080808);      // Preto profundo
  static const Color surface = Color(0xFF111111);         // Superfície elevada
  static const Color surfaceElevated = Color(0xFF1A1A1A); // Card elevado
  static const Color border = Color(0xFF242424);          // Borda sutil
  static const Color borderLight = Color(0xFF2E2E2E);     // Borda mais visível

  // Texto
  static const Color textPrimary = Color(0xFFF0F0F0);     // Branco suave
  static const Color textSecondary = Color(0xFF9A9A9A);   // Cinza médio
  static const Color textTertiary = Color(0xFF5A5A5A);    // Cinza escuro

  // Destaques Metálicos
  static const Color silver = Color(0xFFC0C0C0);          // Prata
  static const Color silverLight = Color(0xFFE8E8E8);     // Prata claro
  static const Color graphite = Color(0xFF3A3A3A);        // Grafite

  // Feedback (discretos, sofisticados)
  static const Color correctSoft = Color(0xFF1A2E1A);     // Verde muito escuro
  static const Color correctAccent = Color(0xFF4CAF50);   // Verde suave
  static const Color wrongSoft = Color(0xFF2E1A1A);       // Vermelho muito escuro
  static const Color wrongAccent = Color(0xFFE57373);     // Vermelho suave
  static const Color selectedSoft = Color(0xFF1A1A2E);    // Azul muito escuro

  // Premium
  static const Color premiumGold = Color(0xFFB8960C);     // Ouro apagado
  static const Color premiumGoldLight = Color(0xFFD4AF37); // Ouro
  static const Color locked = Color(0xFF2A2A2A);          // Bloqueado
}

class AppTextStyles {
  // Fonte principal da marca - Display
  static TextStyle get displayLarge => GoogleFonts.dmSans(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: 8,
  );

  static TextStyle get displayMedium => GoogleFonts.dmSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 4,
  );

  // Tipografia de leitura - confortável e clara
  static TextStyle get headlineLarge => GoogleFonts.dmSans(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get headlineMedium => GoogleFonts.dmSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle get labelLarge => GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 1.5,
  );

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  static TextStyle get brandName => GoogleFonts.dmSans(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: 10,
  );

  static TextStyle get tagline => GoogleFonts.dmSans(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 4,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        background: AppColors.background,
        surface: AppColors.surface,
        primary: AppColors.silver,
        onPrimary: AppColors.background,
        onSurface: AppColors.textPrimary,
        outline: AppColors.border,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        labelLarge: AppTextStyles.labelLarge,
        bodySmall: AppTextStyles.caption,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTextStyles.headlineMedium,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.silver, width: 1.5),
        ),
        hintStyle: AppTextStyles.bodyMedium,
        labelStyle: AppTextStyles.bodyMedium,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.textPrimary,
          foregroundColor: AppColors.background,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.silver,
        linearTrackColor: AppColors.border,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: AppColors.textTertiary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
