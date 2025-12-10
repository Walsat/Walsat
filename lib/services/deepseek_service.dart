import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/ai_config.dart';

/// 🤖 خدمة DeepSeek V3 المتطورة
class DeepSeekService {
  static final DeepSeekService _instance = DeepSeekService._internal();
  factory DeepSeekService() => _instance;
  DeepSeekService._internal();

  /// 🔍 تحليل وثيقة باستخدام DeepSeek
  Future<Map<String, dynamic>> analyzeDocument(String base64Image) async {
    try {
      if (!AIConfig.hasDeepSeek) {
        throw Exception('DeepSeek API key not configured');
      }

      print('🤖 بدء تحليل الوثيقة باستخدام DeepSeek V3...');
      
      final response = await http
          .post(
            Uri.parse(AIConfig.deepseekEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${AIConfig.deepseekKey}',
            },
            body: jsonEncode({
              'model': AIConfig.deepseekModel,
              'messages': [
                {
                  'role': 'system',
                  'content': _getSystemPrompt(),
                },
                {
                  'role': 'user',
                  'content': [
                    {
                      'type': 'text',
                      'text': _getUserPrompt(),
                    },
                    {
                      'type': 'image_url',
                      'image_url': {
                        'url': 'data:image/jpeg;base64,$base64Image',
                      },
                    },
                  ],
                },
              ],
              'temperature': AIConfig.temperature,
              'max_tokens': AIConfig.maxTokens,
            }),
          )
          .timeout(Duration(seconds: AIConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        
        print('✅ تم تحليل الوثيقة بنجاح');
        
        // استخراج JSON من الرد
        final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
        if (jsonMatch != null) {
          final jsonString = jsonMatch.group(0)!;
          final result = jsonDecode(jsonString) as Map<String, dynamic>;
          
          // إضافة معلومات إضافية
          result['_metadata'] = {
            'provider': 'DeepSeek V3',
            'model': AIConfig.deepseekModel,
            'timestamp': DateTime.now().toIso8601String(),
            'cost_estimate': '\$0.001',
          };
          
          return result;
        } else {
          throw Exception('فشل في استخراج JSON من الرد');
        }
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
          'خطأ من DeepSeek (${response.statusCode}): ${error['error']?['message'] ?? 'Unknown error'}',
        );
      }
    } on SocketException {
      throw Exception('❌ لا يوجد اتصال بالإنترنت\n\nتأكد من اتصال الإنترنت ثم أعد المحاولة');
    } on TimeoutException {
      throw Exception('⏱️ انتهت مهلة الطلب\n\nالخادم يستغرق وقتاً طويلاً، حاول مرة أخرى');
    } catch (e) {
      print('❌ خطأ في تحليل الوثيقة: $e');
      rethrow;
    }
  }

  /// 📝 استخراج نص من صورة باستخدام DeepSeek
  Future<String> extractText(String base64Image) async {
    try {
      if (!AIConfig.hasDeepSeek) {
        throw Exception('DeepSeek API key not configured');
      }

      print('📝 بدء استخراج النص باستخدام DeepSeek...');
      
      final response = await http
          .post(
            Uri.parse(AIConfig.deepseekEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${AIConfig.deepseekKey}',
            },
            body: jsonEncode({
              'model': AIConfig.deepseekModel,
              'messages': [
                {
                  'role': 'user',
                  'content': [
                    {
                      'type': 'text',
                      'text': '''استخرج كل النص الموجود في هذه الصورة بدقة.
                      
اتبع هذه القواعد:
- استخرج النص كما هو بالضبط
- حافظ على التنسيق والفراغات
- لا تضف أي شرح أو تعليق
- إذا كان النص بالعربية، اكتبه بالعربية
- إذا كان النص بالإنجليزية، اكتبه بالإنجليزية

أرجع النص فقط بدون أي إضافات.''',
                    },
                    {
                      'type': 'image_url',
                      'image_url': {
                        'url': 'data:image/jpeg;base64,$base64Image',
                      },
                    },
                  ],
                },
              ],
              'temperature': 0.1,
              'max_tokens': 2000,
            }),
          )
          .timeout(Duration(seconds: AIConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final text = data['choices'][0]['message']['content'];
        
        print('✅ تم استخراج النص بنجاح');
        return text.trim();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
          'خطأ من DeepSeek (${response.statusCode}): ${error['error']?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      print('❌ خطأ في استخراج النص: $e');
      rethrow;
    }
  }

  /// 💬 سؤال عن وثيقة
  Future<String> askQuestion(String base64Image, String question) async {
    try {
      if (!AIConfig.hasDeepSeek) {
        throw Exception('DeepSeek API key not configured');
      }

      print('💬 طرح سؤال على DeepSeek: $question');
      
      final response = await http
          .post(
            Uri.parse(AIConfig.deepseekEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${AIConfig.deepseekKey}',
            },
            body: jsonEncode({
              'model': AIConfig.deepseekModel,
              'messages': [
                {
                  'role': 'user',
                  'content': [
                    {
                      'type': 'text',
                      'text': 'انظر إلى هذه الوثيقة وأجب على السؤال التالي:\n\n$question',
                    },
                    {
                      'type': 'image_url',
                      'image_url': {
                        'url': 'data:image/jpeg;base64,$base64Image',
                      },
                    },
                  ],
                },
              ],
              'temperature': 0.3,
              'max_tokens': 1000,
            }),
          )
          .timeout(Duration(seconds: AIConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final answer = data['choices'][0]['message']['content'];
        
        print('✅ تم الحصول على الإجابة');
        return answer.trim();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
          'خطأ من DeepSeek (${response.statusCode}): ${error['error']?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      print('❌ خطأ في الحصول على الإجابة: $e');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // 📋 Prompts المحسّنة
  // ═══════════════════════════════════════════════════════════

  String _getSystemPrompt() {
    return '''أنت محلل وثائق عراقي محترف متخصص في الوثائق الحكومية والرسمية.

مهمتك: تحليل الوثائق العراقية واستخراج المعلومات بدقة عالية.

التزم بما يلي:
1. حدد نوع الوثيقة بدقة
2. استخرج جميع المعلومات المهمة
3. اقترح عنواناً واضحاً ومختصراً
4. اكتب ملخصاً مفيداً
5. اقترح وسوماً (tags) مناسبة
6. حدد الحالة المناسبة للوثيقة

الأنواع المتاحة:
- كتب دائرة الأراضي
- وزارة الزراعة
- المحافظة
- أوامر مهمة
- شكاوى
- أخرى

الحالات المتاحة:
- جديد (new)
- قيد المراجعة (review)
- مكتمل (completed)
- مؤرشف (archived)

أرجع النتيجة بتنسيق JSON فقط بدون أي نص إضافي.''';
  }

  String _getUserPrompt() {
    return '''حلل هذه الوثيقة العراقية واستخرج المعلومات التالية بدقة:

{
  "document_type": "نوع الوثيقة (اختر من الأنواع المتاحة)",
  "title": "عنوان مختصر وواضح للوثيقة",
  "description": "وصف تفصيلي للوثيقة",
  "document_number": "رقم الوثيقة إن وجد",
  "issue_date": "تاريخ الإصدار (YYYY-MM-DD) إن وجد",
  "issuer": "الجهة المصدرة",
  "subject": "موضوع الوثيقة الرئيسي",
  "names": ["قائمة بالأسماء المذكورة"],
  "important_numbers": ["الأرقام المهمة (أرقام العقار، الهوية، إلخ)"],
  "locations": ["المواقع المذكورة"],
  "summary": "ملخص شامل للمحتوى",
  "keywords": ["كلمات مفتاحية مناسبة"],
  "status": "الحالة المقترحة (new/review/completed/archived)",
  "confidence": "نسبة الثقة بالتحليل (0-100)"
}

ملاحظات مهمة:
- إذا لم تجد معلومة، ضع قيمة فارغة
- اكتب التواريخ بصيغة YYYY-MM-DD
- اقترح 5-10 كلمات مفتاحية مناسبة
- الثقة يجب أن تكون رقم من 0 إلى 100''';
  }
}
