import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Sexy & Sophisticated Pastel Palette ---
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFFEEF2FF);
  static const Color accent = Color(0xFFC084FC); // Soft Purple
  
  static const Color background = Color(0xFFFAFBFF); // Porcelain Blue
  static const Color surface = Color(0xFFFFFFFF);
  
  static const Color textPrimary = Color(0xFF1E293B); // Dark Slate
  static const Color textSecondary = Color(0xFF64748B); // Muted Slate
  static const Color textMuted = Color(0xFF94A3B8);
  
  static const Color success = Color(0xFF2DD4BF); // Teal Pastel
  static const Color warning = Color(0xFFFBBF24); // Amber Pastel
  static const Color error = Color(0xFFF87171); // Rose Pastel
  static const Color border = Color(0xFFF1F5F9); 

  // --- Premium Typography (Plus Jakarta Sans) ---
  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.plusJakartaSans(
      fontSize: 32,
      fontWeight: FontWeight.w900,
      color: textPrimary,
      letterSpacing: -1.2,
    ),
    displayMedium: GoogleFonts.plusJakartaSans(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: textPrimary,
      letterSpacing: -0.8,
    ),
    displaySmall: GoogleFonts.plusJakartaSans(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: textPrimary,
    ),
    headlineMedium: GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: textPrimary,
    ),
    bodyLarge: GoogleFonts.plusJakartaSans(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: textPrimary,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textSecondary,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: textMuted,
      letterSpacing: 0.2,
    ),
    labelLarge: GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: textPrimary,
    ),
  );

  // --- Theme Data Definition ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primary,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: surface,
        background: background,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onBackground: textPrimary,
        outline: border,
      ),
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: textTheme.displaySmall,
      ),
      
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: border.withOpacity(0.5), width: 1.5),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 58),
          elevation: 0,
          shadowColor: primary.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontSize: 16,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: textMuted),
        labelStyle: textTheme.bodyMedium?.copyWith(color: textSecondary, fontWeight: FontWeight.w600),
      ),
      
      tabBarTheme: TabBarThemeData(
        labelColor: primary,
        unselectedLabelColor: textMuted,
        labelStyle: textTheme.labelLarge,
        unselectedLabelStyle: textTheme.labelLarge,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: primary, width: 3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 24,
      ),
    );
  }

  // --- Design Tokens & Helpers ---
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;
  
  static const BoxShadow softShadow = BoxShadow(
    color: Color(0x08000000),
    blurRadius: 30,
    offset: Offset(0, 10),
  );

  static const BoxShadow accentShadow = BoxShadow(
    color: Color(0x206366F1), // Luminous Indigo Shadow
    blurRadius: 25,
    offset: Offset(0, 12),
  );
}
