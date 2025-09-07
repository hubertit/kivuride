import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Tesla Robotaxi-inspired Dark Theme Colors
  static const Color primaryColor = Color(0xFFB38A58); // Goldish Chocolate Accent
  static const Color primaryVariant = Color(0xFF9A7549);
  static const Color secondaryColor = Color(0xFF1A1A1A); // Dark Gray
  static const Color backgroundColor = Color(0xFF0A0A0A); // Very Dark Background
  static const Color surfaceColor = Color(0xFF1A1A1A); // Dark Surface
  static const Color surfaceVariant = Color(0xFF2A2A2A); // Lighter Dark Surface
  static const Color errorColor = Color(0xFFFF3B30); // Tesla Red
  static const Color successColor = Color(0xFF34C759); // Tesla Green
  static const Color warningColor = Color(0xFFFF9500); // Tesla Orange
  static const Color infoColor = Color(0xFFB38A58); // Goldish Chocolate Accent

  // Text Colors
  static const Color textPrimaryColor = Color(0xFFFFFFFF); // Pure White
  static const Color textSecondaryColor = Color(0xFFB0B0B0); // Light Gray
  static const Color textTertiaryColor = Color(0xFF808080); // Medium Gray
  static const Color textHintColor = Color(0xFF606060); // Dark Gray

  // Border and Divider Colors
  static const Color borderColor = Color(0xFF333333);
  static const Color dividerColor = Color(0xFF2A2A2A);

  // Spacing System (8pt grid)
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;

  // Border Radius
  static const double borderRadius4 = 4.0;
  static const double borderRadius8 = 8.0;
  static const double borderRadius12 = 12.0;
  static const double borderRadius16 = 16.0;
  static const double borderRadius20 = 20.0;
  static const double borderRadius24 = 24.0;
  static const double borderRadius32 = 32.0;

  // Elevation/Shadow
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation4 = 4.0;
  static const double elevation8 = 8.0;
  static const double elevation16 = 16.0;

  // Typography - Tesla-inspired with Inter font
  static TextStyle get headlineLarge => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimaryColor,
    letterSpacing: -0.5,
  );

  static TextStyle get headlineMedium => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    letterSpacing: -0.25,
  );

  static TextStyle get headlineSmall => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    letterSpacing: 0,
  );

  static TextStyle get titleLarge => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    letterSpacing: 0,
  );

  static TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    letterSpacing: 0.15,
  );

  static TextStyle get titleSmall => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    letterSpacing: 0.1,
  );

  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: textPrimaryColor,
    letterSpacing: 0.15,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimaryColor,
    letterSpacing: 0.25,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondaryColor,
    letterSpacing: 0.4,
  );

  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    letterSpacing: 0.1,
  );

  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: textSecondaryColor,
    letterSpacing: 0.5,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: textTertiaryColor,
    letterSpacing: 0.5,
  );

  // Button Styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: backgroundColor,
    elevation: elevation2,
    shadowColor: primaryColor.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius12),
    ),
    padding: const EdgeInsets.symmetric(
      vertical: spacing16,
      horizontal: spacing24,
    ),
    textStyle: labelLarge,
  );

  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: surfaceColor,
    foregroundColor: textPrimaryColor,
    elevation: elevation1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius12),
      side: const BorderSide(color: borderColor),
    ),
    padding: const EdgeInsets.symmetric(
      vertical: spacing16,
      horizontal: spacing24,
    ),
    textStyle: labelLarge,
  );

  static ButtonStyle get textButtonStyle => TextButton.styleFrom(
    foregroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(
      vertical: spacing12,
      horizontal: spacing16,
    ),
    textStyle: labelLarge,
  );

  // Input Decoration Theme
  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: surfaceColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius12),
      borderSide: const BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius12),
      borderSide: const BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius12),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius12),
      borderSide: const BorderSide(color: errorColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius12),
      borderSide: const BorderSide(color: errorColor, width: 2),
    ),
    labelStyle: bodyMedium.copyWith(color: textSecondaryColor),
    hintStyle: bodyMedium.copyWith(color: textHintColor),
    contentPadding: const EdgeInsets.symmetric(
      vertical: spacing16,
      horizontal: spacing16,
    ),
  );

  // App Bar Theme
  static AppBarTheme get appBarTheme => AppBarTheme(
    backgroundColor: backgroundColor,
    foregroundColor: textPrimaryColor,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: titleLarge,
    iconTheme: const IconThemeData(color: textPrimaryColor),
    surfaceTintColor: Colors.transparent,
  );

  // Card Theme
  static CardTheme get cardTheme => CardTheme(
    color: surfaceColor,
    elevation: elevation2,
    shadowColor: Colors.black.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius16),
    ),
  );

  // Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData get bottomNavigationBarTheme => 
    const BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: textTertiaryColor,
      type: BottomNavigationBarType.fixed,
      elevation: elevation8,
    );

  // Main Theme Data
  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: backgroundColor,
      onSecondary: textPrimaryColor,
      onSurface: textPrimaryColor,
      onError: textPrimaryColor,
    ),
    textTheme: TextTheme(
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    ),
    inputDecorationTheme: inputDecorationTheme,
    appBarTheme: appBarTheme,
    cardTheme: cardTheme,
    bottomNavigationBarTheme: bottomNavigationBarTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: primaryButtonStyle,
    ),
    textButtonTheme: TextButtonThemeData(
      style: textButtonStyle,
    ),
    dividerTheme: const DividerThemeData(
      color: dividerColor,
      thickness: 1,
      space: 1,
    ),
  );

  // Snackbar Helper Methods
  static SnackBar successSnackBar({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return SnackBar(
      content: Text(
        message,
        style: bodyMedium.copyWith(color: textPrimaryColor),
      ),
      backgroundColor: successColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius12),
      ),
      margin: const EdgeInsets.all(spacing16),
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: textPrimaryColor,
              onPressed: onAction ?? () {},
            )
          : null,
    );
  }

  static SnackBar errorSnackBar({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return SnackBar(
      content: Text(
        message,
        style: bodyMedium.copyWith(color: textPrimaryColor),
      ),
      backgroundColor: errorColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius12),
      ),
      margin: const EdgeInsets.all(spacing16),
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: textPrimaryColor,
              onPressed: onAction ?? () {},
            )
          : null,
    );
  }

  static SnackBar warningSnackBar({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return SnackBar(
      content: Text(
        message,
        style: bodyMedium.copyWith(color: textPrimaryColor),
      ),
      backgroundColor: warningColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius12),
      ),
      margin: const EdgeInsets.all(spacing16),
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: textPrimaryColor,
              onPressed: onAction ?? () {},
            )
          : null,
    );
  }
}
