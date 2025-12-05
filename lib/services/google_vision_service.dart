import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/ai_config.dart';

/// ☁️ خدمة Google Cloud Vision المتقدمة
class GoogleVisionService {
  static final GoogleVisionService _instance = GoogleVisionService._internal();
  factory GoogleVisionService() => _instance;
  GoogleVisionService._internal();

  /// 📝 استخراج نص من صورة باستخدام Google Cloud Vision
  Future<String> extractText(String base64Image) async {
    try {
      if (!AIConfig.hasGoogleVision) {
        throw Exception('Google Cloud Vision API key not configured');
      }

      print('☁️ بدء استخراج النص باستخدام Google Cloud Vision...');
      
      final response = await http
          .post(
            Uri.parse('${AIConfig.googleVisionEndpoint}?key=${AIConfig.googleCloudVisionKey}'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'requests': [
                {
                  'image': {
                    'content': base64Image,
                  },
                  'features': [
                    {
                      'type': 'DOCUMENT_TEXT_DETECTION',
                      'maxResults': 1,
                    },
                  ],
                  'imageContext': {
                    'languageHints': ['ar', 'en'], // دعم العربية والإنجليزية
                  },
                },
              ],
            }),
          )
          .timeout(Duration(seconds: AIConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        
        if (data['responses'] != null && data['responses'].isNotEmpty) {
          final textAnnotations = data['responses'][0]['textAnnotations'];
          
          if (textAnnotations != null && textAnnotations.isNotEmpty) {
            // أول عنصر يحتوي على كل النص
            final fullText = textAnnotations[0]['description'] as String;
            
            print('✅ تم استخراج النص بنجاح');
            print('📊 عدد الأحرف: ${fullText.length}');
            
            return fullText.trim();
          } else {
            print('⚠️ لم يتم العثور على نص في الصورة');
            return '';
          }
        } else {
          print('⚠️ استجابة فارغة من Google Vision');
          return '';
        }
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
          'خطأ من Google Vision (${response.statusCode}): ${error['error']?['message'] ?? 'Unknown error'}',
        );
      }
    } on SocketException {
      throw Exception('❌ لا يوجد اتصال بالإنترنت\n\nتأكد من اتصال الإنترنت ثم أعد المحاولة');
    } on TimeoutException {
      throw Exception('⏱️ انتهت مهلة الطلب\n\nالخادم يستغرق وقتاً طويلاً، حاول مرة أخرى');
    } catch (e) {
      print('❌ خطأ في استخراج النص: $e');
      rethrow;
    }
  }

  /// 📊 استخراج نص متقدم مع معلومات إضافية
  Future<Map<String, dynamic>> extractTextAdvanced(String base64Image) async {
    try {
      if (!AIConfig.hasGoogleVision) {
        throw Exception('Google Cloud Vision API key not configured');
      }

      print('☁️ بدء استخراج نص متقدم...');
      
      final response = await http
          .post(
            Uri.parse('${AIConfig.googleVisionEndpoint}?key=${AIConfig.googleCloudVisionKey}'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'requests': [
                {
                  'image': {
                    'content': base64Image,
                  },
                  'features': [
                    {
                      'type': 'DOCUMENT_TEXT_DETECTION',
                      'maxResults': 1,
                    },
                    {
                      'type': 'TEXT_DETECTION',
                      'maxResults': 50,
                    },
                  ],
                  'imageContext': {
                    'languageHints': ['ar', 'en'],
                  },
                },
              ],
            }),
          )
          .timeout(Duration(seconds: AIConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        
        if (data['responses'] != null && data['responses'].isNotEmpty) {
          final responseData = data['responses'][0];
          final textAnnotations = responseData['textAnnotations'];
          final fullTextAnnotation = responseData['fullTextAnnotation'];
          
          String fullText = '';
          List<Map<String, dynamic>> words = [];
          List<String> detectedLanguages = [];
          
          if (textAnnotations != null && textAnnotations.isNotEmpty) {
            fullText = textAnnotations[0]['description'] as String;
            
            // استخراج الكلمات الفردية
            for (var i = 1; i < textAnnotations.length && i <= 50; i++) {
              final annotation = textAnnotations[i];
              words.add({
                'text': annotation['description'],
                'confidence': annotation['confidence'] ?? 0.0,
                'bounds': annotation['boundingPoly'],
              });
            }
          }
          
          // استخراج اللغات المكتشفة
          if (fullTextAnnotation != null && fullTextAnnotation['pages'] != null) {
            for (var page in fullTextAnnotation['pages']) {
              if (page['property'] != null && 
                  page['property']['detectedLanguages'] != null) {
                for (var lang in page['property']['detectedLanguages']) {
                  final langCode = lang['languageCode'];
                  if (!detectedLanguages.contains(langCode)) {
                    detectedLanguages.add(langCode);
                  }
                }
              }
            }
          }
          
          print('✅ تم الاستخراج المتقدم بنجاح');
          print('📊 عدد الكلمات: ${words.length}');
          print('🌍 اللغات: ${detectedLanguages.join(", ")}');
          
          return {
            'fullText': fullText.trim(),
            'words': words,
            'wordCount': words.length,
            'characterCount': fullText.length,
            'detectedLanguages': detectedLanguages,
            'metadata': {
              'provider': 'Google Cloud Vision',
              'timestamp': DateTime.now().toIso8601String(),
              'cost_estimate': '\$0.0015',
            },
          };
        } else {
          return {
            'fullText': '',
            'words': [],
            'wordCount': 0,
            'characterCount': 0,
            'detectedLanguages': [],
          };
        }
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
          'خطأ من Google Vision (${response.statusCode}): ${error['error']?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      print('❌ خطأ في الاستخراج المتقدم: $e');
      rethrow;
    }
  }

  /// 🔍 كشف النصوص مع المواقع
  Future<List<Map<String, dynamic>>> detectTextWithLocations(String base64Image) async {
    try {
      if (!AIConfig.hasGoogleVision) {
        throw Exception('Google Cloud Vision API key not configured');
      }

      print('🔍 كشف النصوص مع المواقع...');
      
      final response = await http
          .post(
            Uri.parse('${AIConfig.googleVisionEndpoint}?key=${AIConfig.googleCloudVisionKey}'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'requests': [
                {
                  'image': {
                    'content': base64Image,
                  },
                  'features': [
                    {
                      'type': 'TEXT_DETECTION',
                      'maxResults': 100,
                    },
                  ],
                },
              ],
            }),
          )
          .timeout(Duration(seconds: AIConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        
        if (data['responses'] != null && 
            data['responses'].isNotEmpty &&
            data['responses'][0]['textAnnotations'] != null) {
          
          final textAnnotations = data['responses'][0]['textAnnotations'] as List;
          List<Map<String, dynamic>> detectedTexts = [];
          
          // تخطي العنصر الأول (النص الكامل)
          for (var i = 1; i < textAnnotations.length; i++) {
            final annotation = textAnnotations[i];
            detectedTexts.add({
              'text': annotation['description'],
              'bounds': annotation['boundingPoly'],
              'confidence': annotation['confidence'] ?? 0.0,
            });
          }
          
          print('✅ تم كشف ${detectedTexts.length} نص');
          return detectedTexts;
        } else {
          return [];
        }
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
          'خطأ من Google Vision (${response.statusCode}): ${error['error']?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      print('❌ خطأ في كشف النصوص: $e');
      rethrow;
    }
  }

  /// 📸 معاينة سريعة للنص (للتطبيقات التفاعلية)
  Future<String> quickPreview(String base64Image) async {
    try {
      if (!AIConfig.hasGoogleVision) {
        return '';
      }

      final response = await http
          .post(
            Uri.parse('${AIConfig.googleVisionEndpoint}?key=${AIConfig.googleCloudVisionKey}'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'requests': [
                {
                  'image': {
                    'content': base64Image,
                  },
                  'features': [
                    {
                      'type': 'TEXT_DETECTION',
                      'maxResults': 10, // فقط أول 10 نصوص
                    },
                  ],
                },
              ],
            }),
          )
          .timeout(Duration(seconds: 10)); // وقت أقصر للمعاينة

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        
        if (data['responses'] != null && 
            data['responses'].isNotEmpty &&
            data['responses'][0]['textAnnotations'] != null) {
          
          final textAnnotations = data['responses'][0]['textAnnotations'];
          if (textAnnotations.isNotEmpty) {
            return (textAnnotations[0]['description'] as String).trim();
          }
        }
      }
      
      return '';
    } catch (e) {
      print('⚠️ فشلت المعاينة السريعة: $e');
      return '';
    }
  }
}
