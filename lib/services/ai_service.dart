import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import '../models/document.dart';

class AIService {
  // These will be loaded from environment or config
  late String _apiKey;
  late String _apiEndpoint;
  
  // Initialize with API credentials
  void init({required String apiKey, required String apiEndpoint}) {
    _apiKey = apiKey;
    _apiEndpoint = apiEndpoint;
  }

  // Analyze document image using OpenAI Vision API
  Future<String> analyzeDocumentImage(String imagePath) async {
    try {
      // Read and encode image
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Prepare request to OpenAI
      final response = await http.post(
        Uri.parse('$_apiEndpoint/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4-vision-preview',
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': '''Analyze this land document image. Please extract and provide:
1. Document type (deed, contract, survey, etc.)
2. Key information (owner name, location, area, date)
3. Any important notes or observations
4. Condition assessment
5. Suggested tags for categorization

Format your response in a clear, structured way.'''
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
          'max_tokens': 1000
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('AI Analysis failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error analyzing image: $e');
    }
  }

  // Generate document summary
  Future<String> generateSummary(Document document) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiEndpoint/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful assistant that summarizes land documents.'
            },
            {
              'role': 'user',
              'content': '''Create a concise summary of this land document:
Title: ${document.title}
Type: ${document.type}
Description: ${document.description}
Location: ${document.location ?? 'N/A'}
Area: ${document.area ?? 'N/A'}
Owner: ${document.ownerName ?? 'N/A'}
Tags: ${document.tags.join(', ')}

Provide a professional summary in 2-3 sentences.'''
            }
          ],
          'max_tokens': 200
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Summary generation failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating summary: $e');
    }
  }

  // Extract text from image using OCR (via OpenAI)
  Future<String> extractTextFromImage(String imagePath) async {
    try {
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse('$_apiEndpoint/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4-vision-preview',
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': 'Extract all text from this document image. Preserve the structure and format as much as possible.'
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
          'max_tokens': 2000
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Text extraction failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error extracting text: $e');
    }
  }

  // Generate smart tags for document
  Future<List<String>> generateTags(Document document) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiEndpoint/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'user',
              'content': '''Generate 5-7 relevant tags for this land document:
Title: ${document.title}
Type: ${document.type}
Description: ${document.description}
Location: ${document.location ?? 'N/A'}

Return only the tags as a comma-separated list.'''
            }
          ],
          'max_tokens': 100
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tagsString = data['choices'][0]['message']['content'] as String;
        return tagsString
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList();
      } else {
        throw Exception('Tag generation failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating tags: $e');
    }
  }

  // Suggest document categorization
  Future<String> suggestCategory(String title, String description) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiEndpoint/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'user',
              'content': '''Based on this information, suggest the most appropriate category:
Title: $title
Description: $description

Categories: Land Deed, Purchase Contract, Lease Agreement, Survey Document, Property Tax, Building Permit, Other

Return only the category name.'''
            }
          ],
          'max_tokens': 50
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['choices'][0]['message']['content'] as String).trim();
      } else {
        return 'Other';
      }
    } catch (e) {
      return 'Other';
    }
  }

  // Validate document completeness
  Future<Map<String, dynamic>> validateDocument(Document document) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiEndpoint/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'user',
              'content': '''Review this land document for completeness:
Title: ${document.title}
Type: ${document.type}
Description: ${document.description}
Location: ${document.location ?? 'Missing'}
Area: ${document.area?.toString() ?? 'Missing'}
Owner: ${document.ownerName ?? 'Missing'}
Images: ${document.imagePaths.length} attached

Provide:
1. Completeness score (0-100)
2. Missing critical information
3. Recommendations

Format as JSON: {"score": 85, "missing": ["item1"], "recommendations": ["rec1"]}'''
            }
          ],
          'max_tokens': 300
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        
        // Try to parse as JSON
        try {
          return jsonDecode(content) as Map<String, dynamic>;
        } catch (_) {
          // If not valid JSON, return basic structure
          return {
            'score': 70,
            'missing': [],
            'recommendations': [content]
          };
        }
      } else {
        throw Exception('Validation failed: ${response.body}');
      }
    } catch (e) {
      return {
        'score': 50,
        'missing': [],
        'recommendations': ['Error during validation: $e']
      };
    }
  }
}
