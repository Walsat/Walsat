import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class AIService {
  // Singleton pattern
  static final AIService _instance = AIService._internal();
  factory AIService({String? openAIKey, String? googleVisionKey}) {
    if (openAIKey != null) _instance._openAIKey = openAIKey;
    if (googleVisionKey != null) _instance._googleVisionKey = googleVisionKey;
    return _instance;
  }
  AIService._internal();

  String? _openAIKey;
  String? _googleVisionKey;

  // Getters
  String? get openAIKey => _openAIKey;
  String? get googleVisionKey => _googleVisionKey;

  // Check if AI services are configured
  bool get isConfigured => _openAIKey != null || _googleVisionKey != null;

  // Auto-classify document with AI (GPT-4 Vision or DeepSeek)
  Future<Map<String, dynamic>> autoClassifyDocument(String imagePath, {String? provider, String? apiKey}) async {
    // Determine which provider to use
    final effectiveProvider = provider ?? 'openai';
    final effectiveKey = apiKey ?? _openAIKey;
    
    if (effectiveKey == null) {
      throw Exception('API key not configured for $effectiveProvider');
    }

    try {
      // Read image file
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Determine endpoint and model
      final endpoint = effectiveProvider == 'deepseek' 
          ? 'https://api.deepseek.com/v1/chat/completions'
          : 'https://api.openai.com/v1/chat/completions';
      
      final model = effectiveProvider == 'deepseek'
          ? 'deepseek-chat'
          : 'gpt-4o';

      // Call AI Vision API for auto-classification
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $effectiveKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': '''قم بتحليل هذه الوثيقة الحكومية العراقية وصنفها بدقة، ثم استخرج جميع المعلومات المهمة:

**التصنيف التلقائي:**
حدد نوع الوثيقة من القائمة التالية فقط:
- كتب دائرة الأراضي
- وزارة الزراعة  
- محافظ صلاح الدين
- مديرية الزراعة
- شعبة الزراعة
- أوامر مهمة
- الأبيض الشكوي
- أخرى

**استخراج المعلومات:**
1. رقم الوثيقة (كامل ودقيق)
2. تاريخ الإصدار (بالصيغة: YYYY-MM-DD)
3. الجهة المصدرة
4. الموضوع/العنوان الرئيسي
5. الأسماء المذكورة (قائمة)
6. الأرقام المهمة (قائمة)
7. المواقع المذكورة
8. ملخص المحتوى (3-5 أسطر)
9. الكلمات المفتاحية (5-10 كلمات)
10. حالة الوثيقة المقترحة (جديد/تحت المراجعة/مكتمل)

أرجع النتيجة بتنسيق JSON دقيق باللغة العربية.'''
                },
                {
                  'type': 'image_url',
                  'image_url': {
                    'url': 'data:image/jpeg;base64,$base64Image'
                  }
                }
              ]
            }
          ],
          'max_tokens': 3000,
          'temperature': 0.3,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        
        // Try to parse JSON response
        try {
          // Remove markdown code blocks if present
          String cleanContent = content.trim();
          if (cleanContent.startsWith('```json')) {
            cleanContent = cleanContent.substring(7);
          }
          if (cleanContent.startsWith('```')) {
            cleanContent = cleanContent.substring(3);
          }
          if (cleanContent.endsWith('```')) {
            cleanContent = cleanContent.substring(0, cleanContent.length - 3);
          }
          cleanContent = cleanContent.trim();
          
          final jsonContent = jsonDecode(cleanContent);
          return jsonContent;
        } catch (e) {
          print('خطأ في تحليل JSON: $e');
          // If not JSON, return as text
          return {'analysis': content, 'raw': true};
        }
      } else {
        throw Exception('GPT-4 Vision API error: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في التصنيف التلقائي: $e');
      rethrow;
    }
  }

  // Analyze document with GPT-4 Vision (Legacy method)
  Future<Map<String, dynamic>> analyzeDocumentWithGPT4(String imagePath) async {
    return autoClassifyDocument(imagePath);
  }

  // OCR with Google Vision API
  Future<String> extractTextWithGoogleVision(String imagePath) async {
    if (_googleVisionKey == null) {
      throw Exception('Google Vision API key not configured');
    }

    try {
      // Read image file
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Call Google Vision API
      final response = await http.post(
        Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$_googleVisionKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'requests': [
            {
              'image': {'content': base64Image},
              'features': [
                {'type': 'DOCUMENT_TEXT_DETECTION'},
                {'type': 'TEXT_DETECTION'},
              ],
              'imageContext': {
                'languageHints': ['ar', 'en']
              }
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final textAnnotations = data['responses'][0]['textAnnotations'];
        
        if (textAnnotations != null && textAnnotations.isNotEmpty) {
          return textAnnotations[0]['description'];
        } else {
          return '';
        }
      } else {
        throw Exception('Google Vision API error: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في Google Vision OCR: $e');
      rethrow;
    }
  }

  // Smart search using AI
  Future<List<Map<String, dynamic>>> smartSearch(
    String query,
    List<Map<String, dynamic>> documents,
  ) async {
    if (_openAIKey == null) {
      return [];
    }

    try {
      // Prepare documents summary for AI
      final docsSummary = documents.map((doc) {
        return {
          'id': doc['id'],
          'title': doc['title'],
          'description': doc['description'],
          'type': doc['type'],
          'ocrText': doc['ocrText'] ?? '',
          'tags': doc['tags'],
        };
      }).toList();

      // Ask GPT to find relevant documents
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAIKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': 'أنت مساعد ذكي للبحث في الوثائق الحكومية العراقية. قم بتحليل استعلام المستخدم وإرجاع IDs الوثائق الأكثر صلة بتنسيق JSON.'
            },
            {
              'role': 'user',
              'content': '''استعلام البحث: $query

الوثائق المتاحة:
${jsonEncode(docsSummary)}

أرجع قائمة بـ IDs الوثائق الأكثر صلة بتنسيق JSON: {"relevant_ids": ["id1", "id2", ...], "explanation": "التفسير"}'''
            }
          ],
          'max_tokens': 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        
        try {
          final jsonContent = jsonDecode(content);
          final relevantIds = List<String>.from(jsonContent['relevant_ids'] ?? []);
          
          // Return relevant documents
          return documents.where((doc) => relevantIds.contains(doc['id'])).toList();
        } catch (e) {
          return [];
        }
      }
      
      return [];
    } catch (e) {
      print('خطأ في البحث الذكي: $e');
      return [];
    }
  }

  // Generate smart tags using AI
  Future<List<String>> generateSmartTags(String text, String? ocrText) async {
    if (_openAIKey == null) {
      return [];
    }

    try {
      final combinedText = '$text\n\n${ocrText ?? ''}';
      
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAIKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'user',
              'content': 'قم بتوليد 5-10 وسوم (tags) ذكية باللغة العربية لهذه الوثيقة. أرجع فقط القائمة بتنسيق JSON: ["وسم1", "وسم2", ...]\n\nالنص:\n$combinedText'
            }
          ],
          'max_tokens': 300,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        
        try {
          final tags = List<String>.from(jsonDecode(content));
          return tags;
        } catch (e) {
          return [];
        }
      }
      
      return [];
    } catch (e) {
      print('خطأ في توليد الوسوم الذكية: $e');
      return [];
    }
  }

  // Summarize document
  Future<String> summarizeDocument(String text, String? ocrText) async {
    if (_openAIKey == null) {
      throw Exception('OpenAI API key not configured');
    }

    try {
      final combinedText = '$text\n\n${ocrText ?? ''}';
      
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAIKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'user',
              'content': 'قم بتلخيص هذه الوثيقة الحكومية بشكل واضح ومختصر باللغة العربية:\n\n$combinedText'
            }
          ],
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      }
      
      return '';
    } catch (e) {
      print('خطأ في التلخيص: $e');
      rethrow;
    }
  }

  // Ask question about document
  Future<String> askQuestion(String question, String documentText, String? ocrText) async {
    if (_openAIKey == null) {
      throw Exception('OpenAI API key not configured');
    }

    try {
      final combinedText = '$documentText\n\n${ocrText ?? ''}';
      
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAIKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': 'أنت مساعد ذكي متخصص في الوثائق الحكومية العراقية. أجب على أسئلة المستخدم بناءً على محتوى الوثيقة فقط.'
            },
            {
              'role': 'user',
              'content': '''الوثيقة:
$combinedText

السؤال: $question'''
            }
          ],
          'max_tokens': 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      }
      
      return 'عذراً، لم أتمكن من الإجابة على السؤال.';
    } catch (e) {
      print('خطأ في الإجابة على السؤال: $e');
      rethrow;
    }
  }
}
