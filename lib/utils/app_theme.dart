import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dark Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColorDark = Color(0xFF0A0A0A);
  static const Color surfaceColorDark = Color(0xFF1E1E1E);
  static const Color cardColorDark = Color(0xFF2D2D2D);
  static const Color textPrimaryColorDark = Color(0xFFFFFFFF);
  static const Color textSecondaryColorDark = Color(0xFFB0B0B0);
  static const Color accentColor = Color(0xFF64FFDA);
  
  // Light Colors - #bae2f5 teması
  static const Color backgroundColorLight = Color(0xFFBAE2F5);
  static const Color surfaceColorLight = Color(0xFFDCF1FF);
  static const Color cardColorLight = Color(0xFFFFFFFF);
  static const Color textPrimaryColorLight = Color(0xFF1A1A1A);
  static const Color textSecondaryColorLight = Color(0xFF4A4A4A);
  
  // Dynamic Colors (getter methods for theme-aware colors)
  static Color getBackgroundColor(bool isDark) => 
      isDark ? backgroundColorDark : backgroundColorLight;
  static Color getSurfaceColor(bool isDark) => 
      isDark ? surfaceColorDark : surfaceColorLight;
  static Color getCardColor(bool isDark) => 
      isDark ? cardColorDark : cardColorLight;
  static Color getTextPrimaryColor(bool isDark) => 
      isDark ? textPrimaryColorDark : textPrimaryColorLight;
  static Color getTextSecondaryColor(bool isDark) => 
      isDark ? textSecondaryColorDark : textSecondaryColorLight;
  
  // Legacy static colors for backward compatibility
  static const Color backgroundColor = backgroundColorDark;
  static const Color surfaceColor = surfaceColorDark;
  static const Color cardColor = cardColorDark;
  static const Color textPrimaryColor = textPrimaryColorDark;
  static const Color textSecondaryColor = textSecondaryColorDark;
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient getBackgroundGradient(bool isDark) => LinearGradient(
    colors: isDark 
        ? [backgroundColorDark, Color(0xFF1A1A1A)]
        : [Color(0xFFBAE2F5), Color(0xFFA5D8F0)], // #bae2f5 gradient
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Text Styles
  static TextStyle getHeadingLarge(bool isDark) => GoogleFonts.montserrat(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: getTextPrimaryColor(isDark),
    height: 1.2,
  );

  static TextStyle getHeadingMedium(bool isDark) => GoogleFonts.montserrat(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: getTextPrimaryColor(isDark),
    height: 1.3,
  );

  static TextStyle getHeadingSmall(bool isDark) => GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: getTextPrimaryColor(isDark),
    height: 1.4,
  );

  static TextStyle getBodyLarge(bool isDark) => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: getTextSecondaryColor(isDark),
    height: 1.6,
  );

  static TextStyle getBodyMedium(bool isDark) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: getTextSecondaryColor(isDark),
    height: 1.5,
  );

  static TextStyle getBodySmall(bool isDark) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: getTextSecondaryColor(isDark),
    height: 1.4,
  );

  static TextStyle getLabelLarge(bool isDark) => GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: getTextPrimaryColor(isDark),
  );

  static TextStyle getLabelMedium(bool isDark) => GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: getTextSecondaryColor(isDark),
  );

  // Legacy static text styles for backward compatibility
  static TextStyle get headingLarge => getHeadingLarge(true);
  static TextStyle get headingMedium => getHeadingMedium(true);
  static TextStyle get headingSmall => getHeadingSmall(true);
  static TextStyle get bodyLarge => getBodyLarge(true);
  static TextStyle get bodyMedium => getBodyMedium(true);
  static TextStyle get bodySmall => getBodySmall(true);
  static TextStyle get labelLarge => getLabelLarge(true);
  static TextStyle get labelMedium => getLabelMedium(true);

  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColorDark,
      cardColor: cardColorDark,
      dividerColor: textSecondaryColorDark.withOpacity(0.1),
      
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColorDark,
        background: backgroundColorDark,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: textPrimaryColorDark,
        onBackground: textPrimaryColorDark,
      ),
      
      textTheme: TextTheme(
        headlineLarge: getHeadingLarge(true),
        headlineMedium: getHeadingMedium(true),
        headlineSmall: getHeadingSmall(true),
        bodyLarge: getBodyLarge(true),
        bodyMedium: getBodyMedium(true),
        bodySmall: getBodySmall(true),
        labelLarge: getLabelLarge(true),
        labelMedium: getLabelMedium(true),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: getHeadingSmall(true),
        iconTheme: const IconThemeData(color: textPrimaryColorDark),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColorDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: getBodyMedium(true),
        hintStyle: getBodyMedium(true).copyWith(color: textSecondaryColorDark.withOpacity(0.6)),
      ),
      
      cardTheme: CardTheme(
        color: cardColorDark,
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColorLight,
      cardColor: cardColorLight,
      dividerColor: textSecondaryColorLight.withOpacity(0.1),
      
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColorLight,
        background: backgroundColorLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryColorLight,
        onBackground: textPrimaryColorLight,
      ),
      
      textTheme: TextTheme(
        headlineLarge: getHeadingLarge(false),
        headlineMedium: getHeadingMedium(false),
        headlineSmall: getHeadingSmall(false),
        bodyLarge: getBodyLarge(false),
        bodyMedium: getBodyMedium(false),
        bodySmall: getBodySmall(false),
        labelLarge: getLabelLarge(false),
        labelMedium: getLabelMedium(false),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: getHeadingSmall(false),
        iconTheme: const IconThemeData(color: textPrimaryColorLight),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColorLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: getBodyMedium(false),
        hintStyle: getBodyMedium(false).copyWith(color: textSecondaryColorLight.withOpacity(0.6)),
      ),
      
      cardTheme: CardTheme(
        color: cardColorLight,
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 400);
  static const Duration longDuration = Duration(milliseconds: 600);

  // Box Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // Border Radius
  static BorderRadius get smallRadius => BorderRadius.circular(8);
  static BorderRadius get mediumRadius => BorderRadius.circular(12);
  static BorderRadius get largeRadius => BorderRadius.circular(16);
  static BorderRadius get extraLargeRadius => BorderRadius.circular(24);
} 