import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class AIService {
  final String? openAIKey;
  final String? googleVisionKey;
  
  // Singleton pattern
  static final AIService _instance = AIService._internal();
  factory AIService({String? openAIKey, String? googleVisionKey}) {
    _instance.openAIKey = openAIKey;
    _instance.googleVisionKey = googleVisionKey;
    return _instance;
  }
  AIService._internal();

  String? openAIKey;
  String? googleVisionKey;

  // Check if AI services are configured
  bool get isConfigured => openAIKey != null || googleVisionKey != null;

  // Analyze document with GPT-4 Vision
  Future<Map<String, dynamic>> analyzeDocumentWithGPT4(String imagePath) async {
    if (openAIKey == null) {
      throw Exception('OpenAI API key not configured');
    }

    try {
      // Read image file
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Call GPT-4 Vision API
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': '''قم بتحليل هذه الوثيقة الحكومية العراقية واستخرج المعلومات التالية:
1. نوع الوثيقة (كتب دائرة الأراضي، وزارة الزراعة، محافظ صلاح الدين، مديرية الزراعة، شعبة الزراعة، أوامر مهمة، الأبيض الشكوي)
2. رقم الوثيقة
3. تاريخ الإصدار
4. الجهة المصدرة
5. الموضوع الرئيسي
6. الأسماء المذكورة
7. الأرقام المهمة
8. ملخص المحتوى

أرجع النتيجة بتنسيق JSON باللغة العربية.'''
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
          'max_tokens': 2000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        
        // Try to parse JSON response
        try {
          final jsonContent = jsonDecode(content);
          return jsonContent;
        } catch (e) {
          // If not JSON, return as text
          return {'analysis': content};
        }
      } else {
        throw Exception('GPT-4 Vision API error: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في تحليل GPT-4: $e');
      rethrow;
    }
  }

  // OCR with Google Vision API
  Future<String> extractTextWithGoogleVision(String imagePath) async {
    if (googleVisionKey == null) {
      throw Exception('Google Vision API key not configured');
    }

    try {
      // Read image file
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Call Google Vision API
      final response = await http.post(
        Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$googleVisionKey'),
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
    if (openAIKey == null) {
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
          'Authorization': 'Bearer $openAIKey',
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
    if (openAIKey == null) {
      return [];
    }

    try {
      final combinedText = '$text\n\n${ocrText ?? ''}';
      
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIKey',
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
    if (openAIKey == null) {
      throw Exception('OpenAI API key not configured');
    }

    try {
      final combinedText = '$text\n\n${ocrText ?? ''}';
      
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIKey',
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
    if (openAIKey == null) {
      throw Exception('OpenAI API key not configured');
    }

    try {
      final combinedText = '$documentText\n\n${ocrText ?? ''}';
      
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIKey',
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
