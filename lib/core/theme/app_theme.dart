import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // === PALETA DE COLORES PERSONALIZADA ===
  static const Color color1 = Color(
    0xFFE3EBF0,
  ); // #E3EBF0 - Gris azulado muy claro
  static const Color color2 = Color(0xFFBDC0BE); // #BDC0BE - Gris plateado
  static const Color color3 = Color(0xFF949088); // #949088 - Gris cálido medio
  static const Color color4 = Color(0xFF706C64); // #706C64 - Gris taupe oscuro
  static const Color color5 = Color(0xFF23282C); // #23282C - Gris carbón
  static const Color color6 = Color(0xFF0B1014); // #0B1014 - Casi negro

  static const Color white = Color(0xFFFFFFFF); // #FFF - Blanco

  // Alias para compatibilidad con código existente
  static const Color limeGreen =
      color1; // Ahora mapea a gris azulado muy claro (más visible)
  static const Color peach = color3; // Ahora mapea a gris cálido medio
  static const Color darkTeal = color5; // Ahora mapea a gris carbón
  static const Color mintGreen = color2; // Ahora mapea a gris plateado

  // Colores adicionales para estados
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = color3;

  // Colores de fondo
  static const Color darkBackground = color6; // Fondo oscuro (#0B1014)
  static const Color darkSurface = color5; // Superficie oscura (#23282C)
  static const Color lightBackground = color1; // Fondo claro (#E3EBF0)
  static const Color lightSurface = white; // Superficie clara

  // Colores de texto
  static const Color darkTextPrimary =
      color1; // Texto principal modo oscuro - gris azulado muy claro
  static const Color darkTextSecondary =
      color2; // Texto secundario modo oscuro - gris plateado
  static const Color lightTextPrimary =
      color6; // Texto principal modo claro - azul noche
  static const Color lightTextSecondary =
      color5; // Texto secundario modo claro - gris carbón

  // === TIPOGRAFÍA INTER ===
  static TextTheme _getTextTheme(Color textColor) {
    return TextTheme(
      // Display - Títulos grandes
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w600, // SemiBold
        color: textColor,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),

      // Headlines - Encabezados
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w500, // Medium
        color: textColor,
      ),

      // Titles - Títulos
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),

      // Body - Texto de cuerpo
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400, // Regular
        color: textColor,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.4,
      ),

      // Labels - Etiquetas
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.5,
      ),
    );
  }

  // === TEMA OSCURO ===
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: color1,
      secondary: color2,
      tertiary: color2,
      surface: darkSurface,
      surfaceContainerHighest: color4,
      error: error,
      onPrimary: color6, // Texto sobre primary
      onSecondary: color6, // Texto sobre secondary
      onSurface: darkTextPrimary,
      onSurfaceVariant: darkTextSecondary,
    ),
    scaffoldBackgroundColor: darkBackground,
    textTheme: _getTextTheme(darkTextPrimary),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: color1),
      titleTextStyle: GoogleFonts.inter(
        color: darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: color1,
      unselectedItemColor: darkTextSecondary,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: color1, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: error, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: darkTextSecondary,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: darkTextSecondary,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: color2,
        foregroundColor: color6,
        elevation: 2,
        shadowColor: color2.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color2,
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: color2,
        side: const BorderSide(color: color2, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),

    // Card
    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: darkSurface,
      selectedColor: color1,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkTextPrimary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Divider
    dividerTheme: DividerThemeData(
      color: darkTextSecondary.withValues(alpha: 0.2),
      thickness: 1,
      space: 1,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: color1, size: 24),
  );

  // === TEMA CLARO ===
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: color4,
      secondary: color3,
      tertiary: color2,
      surface: lightSurface,
      surfaceContainerHighest: color1,
      error: error,
      onPrimary: white,
      onSecondary: white,
      onSurface: lightTextPrimary,
      onSurfaceVariant: lightTextSecondary,
    ),
    scaffoldBackgroundColor: lightBackground,
    textTheme: _getTextTheme(lightTextPrimary),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: white,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: color4),
      titleTextStyle: GoogleFonts.inter(
        color: lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: white,
      selectedItemColor: color4,
      unselectedItemColor: lightTextSecondary,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: color1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: color1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: color4, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: error, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: lightTextSecondary,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: lightTextSecondary,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: color5,
        foregroundColor: white,
        elevation: 2,
        shadowColor: color5.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color5,
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: color5,
        side: const BorderSide(color: color5, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),

    // Card
    cardTheme: CardThemeData(
      color: white,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: color1,
      selectedColor: color4,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: lightTextPrimary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Divider
    dividerTheme: DividerThemeData(
      color: lightTextSecondary.withValues(alpha: 0.2),
      thickness: 1,
      space: 1,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: color4, size: 24),
  );

  // === HELPERS ===
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // Helper para obtener el TextTheme con Inter
  static TextTheme getTextTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }

  // === HELPERS PARA INPUT DECORATION ===

  /// Devuelve un InputDecoration consistente con el tema actual
  ///
  /// Parámetros:
  /// - [context]: BuildContext para obtener el tema
  /// - [labelText]: Texto del label
  /// - [hintText]: Texto del hint (opcional)
  /// - [prefixIcon]: Icono al inicio (opcional)
  /// - [suffixIcon]: Widget al final (opcional)
  /// - [suffixText]: Texto al final (opcional)
  /// - [errorText]: Texto de error (opcional)
  static InputDecoration getInputDecoration(
    BuildContext context, {
    String? labelText,
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
    String? suffixText,
    String? errorText,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      suffixText: suffixText,
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: isDark ? color1 : color4)
          : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: isDark ? color1 : color4, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error, width: 2),
      ),
      labelStyle: theme.inputDecorationTheme.labelStyle,
      hintStyle: theme.inputDecorationTheme.hintStyle,
    );
  }
}
