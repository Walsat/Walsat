import 'package:flutter/material.dart';

/// مجموعة ألوان التطبيق الحديثة - مصممة حسب Material Design 3
class AppColors {
  // الألوان الأساسية
  static const primary = Color(0xFF1565C0); // أزرق داكن أنيق
  static const primaryLight = Color(0xFF42A5F5); // أزرق فاتح
  static const primaryDark = Color(0xFF0D47A1); // أزرق عميق
  
  static const secondary = Color(0xFF00897B); // أخضر مائل للأزرق (Teal)
  static const secondaryLight = Color(0xFF26A69A);
  static const secondaryDark = Color(0xFF00695C);
  
  static const accent = Color(0xFFFF6F00); // برتقالي دافئ
  
  // ألوان التدرجات (Gradients)
  static const gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1565C0), // primary
      Color(0xFF0D47A1), // primaryDark
    ],
  );
  
  static const gradientSecondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF26A69A), // secondaryLight
      Color(0xFF00695C), // secondaryDark
    ],
  );
  
  static const gradientAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF8F00),
      Color(0xFFFF6F00),
    ],
  );
  
  // تدرج خاص بالذكاء الاصطناعي
  static const gradientAI = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7B1FA2), // بنفسجي
      Color(0xFF9C27B0), // أرجواني
    ],
  );
  
  // تدرج OCR
  static const gradientOCR = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00897B), // Teal
      Color(0xFF00695C), // Teal dark
    ],
  );
  
  // ألوان الحالة
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFA726);
  static const error = Color(0xFFE53935);
  static const info = Color(0xFF42A5F5);
  
  // ألوان الخلفيات
  static const surfaceLight = Color(0xFFFAFAFA);
  static const surfaceDark = Color(0xFF121212);
  
  // ألوان البطاقات وأنواع الوثائق
  static const cardLandRegistry = Color(0xFF1565C0); // أزرق
  static const cardAgriculture = Color(0xFF388E3C); // أخضر
  static const cardGovernor = Color(0xFF7B1FA2); // بنفسجي
  static const cardDirectorate = Color(0xFFD32F2F); // أحمر
  static const cardDivision = Color(0xFFF57C00); // برتقالي
  static const cardOrders = Color(0xFF00897B); // Teal
  static const cardComplaints = Color(0xFF303F9F); // Indigo
  static const cardOther = Color(0xFF616161); // رمادي
  
  // ألوان حالة الوثيقة
  static const statusNew = Color(0xFF42A5F5); // أزرق فاتح
  static const statusReview = Color(0xFFFF9800); // برتقالي
  static const statusCompleted = Color(0xFF4CAF50); // أخضر
  static const statusArchived = Color(0xFF9E9E9E); // رمادي
  
  // ألوان النصوص
  static const textPrimaryLight = Color(0xFF212121);
  static const textSecondaryLight = Color(0xFF757575);
  static const textPrimaryDark = Color(0xFFFFFFFF);
  static const textSecondaryDark = Color(0xFFB0B0B0);
  
  /// الحصول على لون نوع الوثيقة
  static Color getDocumentTypeColor(String type) {
    switch (type) {
      case 'land_registry':
        return cardLandRegistry;
      case 'agriculture_ministry':
        return cardAgriculture;
      case 'governor_saladin':
        return cardGovernor;
      case 'agriculture_directorate':
        return cardDirectorate;
      case 'agriculture_division':
        return cardDivision;
      case 'important_orders':
        return cardOrders;
      case 'complaints':
        return cardComplaints;
      default:
        return cardOther;
    }
  }
  
  /// الحصول على لون حالة الوثيقة
  static Color getStatusColor(String status) {
    switch (status) {
      case 'new':
        return statusNew;
      case 'review':
        return statusReview;
      case 'completed':
        return statusCompleted;
      case 'archived':
        return statusArchived;
      default:
        return statusNew;
    }
  }
  
  /// الحصول على تدرج لون نوع الوثيقة
  static LinearGradient getDocumentTypeGradient(String type) {
    final baseColor = getDocumentTypeColor(type);
    final darkColor = Color.lerp(baseColor, Colors.black, 0.3)!;
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [baseColor, darkColor],
    );
  }
}
