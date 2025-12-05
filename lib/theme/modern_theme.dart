import 'package:flutter/material.dart';
import 'dart:ui';

class ModernTheme {
  // Primary Colors - Purple/Blue gradient
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  
  // Secondary Colors - Pink/Purple gradient
  static const Color secondaryColor = Color(0xFFEC4899); // Pink
  static const Color secondaryLight = Color(0xFFF472B6);
  static const Color secondaryDark = Color(0xFFDB2777);
  
  // Accent Colors
  static const Color accentColor = Color(0xFF8B5CF6); // Violet
  static const Color accentLight = Color(0xFFA78BFA);
  static const Color accentDark = Color(0xFF7C3AED);
  
  // Status Colors
  static const Color successColor = Color(0xFF10B981); // Green
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color errorColor = Color(0xFFEF4444); // Red
  static const Color infoColor = Color(0xFF3B82F6); // Blue
  
  // Neutral Colors
  static const Color backgroundColor = Color(0xFF0F172A); // Dark Slate
  static const Color surfaceColor = Color(0xFF1E293B);
  static const Color cardColor = Color(0xFF334155);
  static const Color textColor = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFF472B6), Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient infoGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Background gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFF0F172A), // Dark Slate
      Color(0xFF1E293B), // Slate 800
      Color(0xFF334155), // Slate 700
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Mesh gradient for modern effects
  static const List<Color> meshColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF8B5CF6), // Violet
    Color(0xFFEC4899), // Pink
    Color(0xFF3B82F6), // Blue
  ];
  
  // Glass effect colors
  static Color glassLight = Colors.white.withOpacity(0.1);
  static Color glassDark = Colors.black.withOpacity(0.2);
  static Color glassBorder = Colors.white.withOpacity(0.2);
  
  // Shadows
  static List<BoxShadow> primaryShadow = [
    BoxShadow(
      color: primaryColor.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
  
  static List<BoxShadow> secondaryShadow = [
    BoxShadow(
      color: secondaryColor.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
  
  static List<BoxShadow> accentShadow = [
    BoxShadow(
      color: accentColor.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
  
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 15,
      offset: const Offset(0, 5),
    ),
  ];
  
  static List<BoxShadow> glassShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
  
  // Border Radius
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radiusXLarge = BorderRadius.all(Radius.circular(32));
  
  // Animations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  static const Curve animationCurve = Curves.easeOutCubic;
  static const Curve animationCurveIn = Curves.easeInCubic;
  static const Curve animationCurveOut = Curves.easeOutCubic;
  
  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  
  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.white,
        error: errorColor,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: radiusMedium),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: radiusMedium),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: radiusMedium),
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: radiusMedium),
        color: surfaceColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: radiusMedium),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: radiusMedium),
      ),
    );
  }
  
  // Helper methods for glass effect
  static BoxDecoration glassDecoration({
    double blur = 10,
    double opacity = 0.1,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: Colors.white.withOpacity(opacity),
      borderRadius: borderRadius ?? radiusMedium,
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1.5,
      ),
      boxShadow: boxShadow ?? glassShadow,
    );
  }
  
  // Helper methods for neumorphism effect
  static BoxDecoration neumorphicDecoration({
    Color? color,
    BorderRadius? borderRadius,
    bool isPressed = false,
  }) {
    final baseColor = color ?? surfaceColor;
    return BoxDecoration(
      color: baseColor,
      borderRadius: borderRadius ?? radiusMedium,
      boxShadow: isPressed
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(2, 2),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(-2, -2),
              ),
            ]
          : [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(5, 5),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(-5, -5),
              ),
            ],
    );
  }
  
  // Helper method for gradient text
  static ShaderMask gradientText({
    required Widget child,
    Gradient? gradient,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return (gradient ?? primaryGradient).createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: child,
    );
  }
  
  // Shimmer effect colors
  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color(0xFF334155),
      Color(0xFF475569),
      Color(0xFF334155),
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, 0.0),
    end: Alignment(1.0, 0.0),
  );
}
