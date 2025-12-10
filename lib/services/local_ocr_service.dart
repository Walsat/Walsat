import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// خدمة OCR المحلية المجانية
/// Free Local OCR Service using Google ML Kit
class LocalOCRService {
  static final LocalOCRService _instance = LocalOCRService._internal();
  factory LocalOCRService() => _instance;
  LocalOCRService._internal();

  // Text recognizer instance
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin, // للإنجليزية والعربية
  );

  /// استخراج النص من الصورة (مجاناً!)
  /// Extract text from image (Free!)
  Future<String> extractText(String imagePath) async {
    try {
      print('🔤 بدء استخراج النص من الصورة...');
      
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      if (recognizedText.text.isEmpty) {
        print('⚠️ لم يتم العثور على نص في الصورة');
        return '';
      }
      
      print('✅ تم استخراج ${recognizedText.text.length} حرف');
      return recognizedText.text;
      
    } catch (e) {
      print('❌ خطأ في استخراج النص: $e');
      rethrow;
    }
  }

  /// استخراج النص مع التفاصيل (نص + معلومات إضافية)
  /// Extract text with details
  Future<Map<String, dynamic>> extractTextWithDetails(String imagePath) async {
    try {
      print('🔤 بدء استخراج النص التفصيلي...');
      
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      // استخراج معلومات تفصيلية
      List<String> lines = [];
      List<String> blocks = [];
      List<String> words = [];
      
      for (TextBlock block in recognizedText.blocks) {
        blocks.add(block.text);
        
        for (TextLine line in block.lines) {
          lines.add(line.text);
          
          for (TextElement element in line.elements) {
            words.add(element.text);
          }
        }
      }
      
      print('✅ تم استخراج: ${blocks.length} كتل، ${lines.length} أسطر، ${words.length} كلمة');
      
      return {
        'fullText': recognizedText.text,
        'blocks': blocks,
        'lines': lines,
        'words': words,
        'blockCount': blocks.length,
        'lineCount': lines.length,
        'wordCount': words.length,
        'characterCount': recognizedText.text.length,
      };
      
    } catch (e) {
      print('❌ خطأ في استخراج النص التفصيلي: $e');
      rethrow;
    }
  }

  /// تحليل بسيط للوثيقة (مجاناً!)
  /// Simple document analysis (Free!)
  Future<Map<String, dynamic>> analyzeDocument(String imagePath) async {
    try {
      print('🔍 بدء تحليل الوثيقة...');
      
      final textDetails = await extractTextWithDetails(imagePath);
      final fullText = textDetails['fullText'] as String;
      
      // تحليل بسيط بدون AI
      Map<String, dynamic> analysis = {
        'hasText': fullText.isNotEmpty,
        'textLength': fullText.length,
        'wordCount': textDetails['wordCount'],
        'lineCount': textDetails['lineCount'],
        'language': _detectLanguage(fullText),
        'extractedText': fullText,
        'suggestedType': _guessDocumentType(fullText),
        'containsNumbers': _containsNumbers(fullText),
        'containsDates': _containsDates(fullText),
        'possibleNames': _extractPossibleNames(fullText),
      };
      
      print('✅ تم تحليل الوثيقة بنجاح');
      return analysis;
      
    } catch (e) {
      print('❌ خطأ في تحليل الوثيقة: $e');
      rethrow;
    }
  }

  /// كشف اللغة
  String _detectLanguage(String text) {
    if (text.isEmpty) return 'unknown';
    
    // التحقق من وجود أحرف عربية
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    final hasArabic = arabicRegex.hasMatch(text);
    
    // التحقق من وجود أحرف إنجليزية
    final englishRegex = RegExp(r'[a-zA-Z]');
    final hasEnglish = englishRegex.hasMatch(text);
    
    if (hasArabic && hasEnglish) return 'mixed';
    if (hasArabic) return 'arabic';
    if (hasEnglish) return 'english';
    
    return 'unknown';
  }

  /// تخمين نوع الوثيقة بناءً على الكلمات المفتاحية
  String _guessDocumentType(String text) {
    final lowerText = text.toLowerCase();
    
    // الكلمات المفتاحية لكل نوع
    final keywords = {
      'land_registry': ['دائرة الأراضي', 'سند', 'ملكية', 'عقار', 'قطعة'],
      'agriculture_ministry': ['وزارة الزراعة', 'زراعي', 'محاصيل', 'مزرعة'],
      'governor_saladin': ['محافظ', 'صلاح الدين', 'محافظة'],
      'agriculture_directorate': ['مديرية الزراعة', 'مدير زراعة'],
      'agriculture_division': ['شعبة الزراعة', 'شعبة زراعية'],
      'important_orders': ['أمر', 'قرار', 'تعليمات', 'توجيه'],
      'complaints': ['شكوى', 'تظلم', 'اعتراض'],
    };
    
    // البحث عن تطابقات
    for (var entry in keywords.entries) {
      for (var keyword in entry.value) {
        if (lowerText.contains(keyword)) {
          return entry.key;
        }
      }
    }
    
    return 'other';
  }

  /// التحقق من وجود أرقام
  bool _containsNumbers(String text) {
    return RegExp(r'\d+').hasMatch(text);
  }

  /// التحقق من وجود تواريخ
  bool _containsDates(String text) {
    // تواريخ بصيغ مختلفة
    final datePatterns = [
      r'\d{1,2}/\d{1,2}/\d{2,4}',  // 12/31/2023
      r'\d{1,2}-\d{1,2}-\d{2,4}',  // 12-31-2023
      r'\d{4}/\d{1,2}/\d{1,2}',    // 2023/12/31
      r'\d{4}-\d{1,2}-\d{1,2}',    // 2023-12-31
    ];
    
    for (var pattern in datePatterns) {
      if (RegExp(pattern).hasMatch(text)) {
        return true;
      }
    }
    
    return false;
  }

  /// استخراج الأسماء المحتملة (بسيط)
  List<String> _extractPossibleNames(String text) {
    List<String> names = [];
    
    // البحث عن كلمات تبدأ بحرف كبير (للإنجليزية)
    final englishNameRegex = RegExp(r'\b[A-Z][a-z]+(?:\s+[A-Z][a-z]+)*\b');
    final englishMatches = englishNameRegex.allMatches(text);
    
    for (var match in englishMatches) {
      final name = match.group(0);
      if (name != null && name.split(' ').length >= 2) {
        names.add(name);
      }
    }
    
    // للعربية: البحث عن كلمات بعد "السيد" أو "الأستاذ" أو "المهندس"
    final arabicTitles = ['السيد', 'الأستاذ', 'المهندس', 'الدكتور', 'المحامي'];
    
    for (var title in arabicTitles) {
      final titleIndex = text.indexOf(title);
      if (titleIndex != -1) {
        final afterTitle = text.substring(titleIndex + title.length).trim();
        final words = afterTitle.split(RegExp(r'\s+'));
        if (words.isNotEmpty && words.length >= 2) {
          names.add('${words[0]} ${words[1]}');
        }
      }
    }
    
    return names.take(5).toList(); // أول 5 أسماء فقط
  }

  /// تنظيف الموارد
  void dispose() {
    _textRecognizer.close();
  }
}
