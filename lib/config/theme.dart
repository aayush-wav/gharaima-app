import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // --- PART 1: COLORS (Light) ---
  static const Color background         = Color(0xFFF5F0E8);
  static const Color surface            = Color(0xFFEDE4D0);
  static const Color surfaceSecondary   = Color(0xFFD9C9A8);
  static const Color surfaceElevated    = Color(0xFFF9F5EC);

  static const Color primary            = Color(0xFF4F46E5);
  static const Color primaryLight       = Color(0xFF818CF8);
  static const Color primaryDark        = Color(0xFF3730A3);
  static const Color primarySurface     = Color(0xFFEEF2FF);

  static const Color textPrimary        = Color(0xFF1C1408);
  static const Color textSecondary      = Color(0xFF6B5E40);
  static const Color textHint           = Color(0xFF9E8A68);
  static const Color textOnPrimary      = Color(0xFFF5F0E8);

  static const Color border             = Color(0x284F46E5);
  static const Color borderStrong       = Color(0x404F46E5);
  static const Color borderWarm         = Color(0x33A08040);

  static const Color success            = Color(0xFF1A7A4A);
  static const Color successSurface     = Color(0x1A1A7A4A);
  static const Color warning            = Color(0xFFC47B0A);
  static const Color warningSurface     = Color(0x1AC47B0A);
  static const Color error              = Color(0xFFB83232);
  static const Color errorSurface       = Color(0x1AB83232);
  static const Color info               = Color(0xFF2255CC);
  static const Color infoSurface        = Color(0x1A2255CC);

  static const Color glassFill          = Color(0x9EF5F0E8);
  static const Color glassBorder        = Color(0x2E4F46E5);
  static const double glassBlur         = 20.0;
  static const Color orbColor1          = Color(0x1E4F46E5);
  static const Color orbColor2          = Color(0x1CA08040);
  static const Color orbColor3          = Color(0x166366F1);

  // Status chip colours
  static const Color pendingBg          = Color(0x1AC47B0A);
  static const Color pendingText        = Color(0xFFC47B0A);
  static const Color confirmedBg        = Color(0x1A2255CC);
  static const Color confirmedText      = Color(0xFF2255CC);
  static const Color inProgressBg       = Color(0x1A4F46E5);
  static const Color inProgressText     = Color(0xFF4F46E5);
  static const Color completedBg        = Color(0x1A1A7A4A);
  static const Color completedText      = Color(0xFF1A7A4A);
  static const Color cancelledBg        = Color(0x1AB83232);
  static const Color cancelledText      = Color(0xFFB83232);
}

class AppColorsDark {
  // --- PART 1: COLORS (Dark) ---
  static const Color background         = Color(0xFF0E0D16);
  static const Color surface            = Color(0xFF161525);
  static const Color surfaceSecondary   = Color(0xFF1E1D35);
  static const Color surfaceElevated    = Color(0xFF232240);

  static const Color primary            = Color(0xFF818CF8);
  static const Color primaryLight       = Color(0xFFA5B4FC);
  static const Color primaryDark        = Color(0xFF6366F1);
  static const Color primarySurface     = Color(0xFF1A1940);

  static const Color textPrimary        = Color(0xFFF5EED8);
  static const Color textSecondary      = Color(0xFF9E8E68);
  static const Color textHint           = Color(0xFF6A5C3E);
  static const Color textOnPrimary      = Color(0xFF0E0D16);

  static const Color border             = Color(0x28818CF8);
  static const Color borderStrong       = Color(0x40818CF8);
  static const Color borderWarm         = Color(0x28D4B866);

  static const Color success            = Color(0xFF3DAA6A);
  static const Color successSurface     = Color(0x1A3DAA6A);
  static const Color warning            = Color(0xFFE6B030);
  static const Color warningSurface     = Color(0x1AE6B030);
  static const Color error              = Color(0xFFE05555);
  static const Color errorSurface       = Color(0x1AE05555);
  static const Color info               = Color(0xFF5B8DEF);
  static const Color infoSurface        = Color(0x1A5B8DEF);

  static const Color glassFill          = Color(0x820E0D22);
  static const Color glassBorder        = Color(0x2E818CF8);
  static const double glassBlur         = 20.0;
  static const Color orbColor1          = Color(0x384F46E5);
  static const Color orbColor2          = Color(0x1AD4B866);
  static const Color orbColor3          = Color(0x22818CF8);

  // Status chip colours
  static const Color pendingBg          = Color(0x1AE6B030);
  static const Color pendingText        = Color(0xFFE6B030);
  static const Color confirmedBg        = Color(0x1A5B8DEF);
  static const Color confirmedText      = Color(0xFF5B8DEF);
  static const Color inProgressBg       = Color(0x1A818CF8);
  static const Color inProgressText     = Color(0xFF818CF8);
  static const Color completedBg        = Color(0x1A3DAA6A);
  static const Color completedText      = Color(0xFF3DAA6A);
  static const Color cancelledBg        = Color(0x1AE05555);
  static const Color cancelledText      = Color(0xFFE05555);
}

class AppTextStyles {
  // --- PART 1: TYPOGRAPHY ---
  static TextStyle get displayLarge  => GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w700, height: 1.2);
  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w700, height: 1.25);
  static TextStyle get displaySmall  => GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3);
  static TextStyle get headingLarge  => GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700, height: 1.3);
  static TextStyle get headingMedium => GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3);
  static TextStyle get headingSmall  => GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.w600, height: 1.35);
  static TextStyle get priceText     => GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w700);
  static TextStyle get priceLarge    => GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w700);

  static TextStyle get bodyLarge => GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400, height: 1.6);
  static TextStyle get bodyMedium => GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, height: 1.6);
  static TextStyle get bodySmall => GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle get labelLarge => GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.02);
  static TextStyle get labelMedium => GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.05);
  static TextStyle get labelSmall => GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 0.06);
  static TextStyle get caption => GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, height: 1.4);
  static TextStyle get buttonText => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.02);
  static TextStyle get overline => GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.08);
}

class AppSpacing {
  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 24.0;
  static const double xxl  = 32.0;
  static const double xxxl = 48.0;
}

class AppRadius {
  static const double xs   = 6.0;
  static const double sm   = 10.0;
  static const double md   = 14.0;
  static const double lg   = 18.0;
  static const double xl   = 24.0;
  static const double pill = 100.0;
}

class AppTheme {
  // Helper methods to get colors based on brightness
  static Color background(BuildContext context) => Theme.of(context).brightness == Brightness.light ? AppColors.background : AppColorsDark.background;
  static Color surface(BuildContext context) => Theme.of(context).brightness == Brightness.light ? AppColors.surface : AppColorsDark.surface;
  static Color textPrimary(BuildContext context) => Theme.of(context).brightness == Brightness.light ? AppColors.textPrimary : AppColorsDark.textPrimary;
  static Color primary(BuildContext context) => Theme.of(context).brightness == Brightness.light ? AppColors.primary : AppColorsDark.primary;
  static Color border(BuildContext context) => Theme.of(context).brightness == Brightness.light ? AppColors.border : AppColorsDark.border;

  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;
    final bg = isDark ? AppColorsDark.background : AppColors.background;
    final text = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final textSec = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;
    final surf = isDark ? AppColorsDark.surface : AppColors.surface;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primary,
      scaffoldBackgroundColor: bg,
      colorScheme: isDark 
        ? ColorScheme.dark(primary: primary, background: bg, surface: surf, onPrimary: AppColorsDark.textOnPrimary)
        : ColorScheme.light(primary: primary, background: bg, surface: surf, onPrimary: AppColors.textOnPrimary),
      
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: text),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: text),
        headlineLarge: AppTextStyles.headingLarge.copyWith(color: text),
        headlineMedium: AppTextStyles.headingMedium.copyWith(color: text),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: text),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: textSec),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: text),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: isDark ? AppColorsDark.textOnPrimary : AppColors.textOnPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
          textStyle: AppTextStyles.buttonText,
          elevation: 0,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: (isDark ? AppColorsDark.glassFill : AppColors.glassFill),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: isDark ? AppColorsDark.border : AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: isDark ? AppColorsDark.border : AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: isDark ? AppColorsDark.borderStrong : AppColors.borderStrong),
        ),
      ),
    );
  }
}
