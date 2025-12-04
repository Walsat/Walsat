import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class GoogleDriveService {
  String? accessToken;
  
  // Singleton pattern
  static final GoogleDriveService _instance = GoogleDriveService._internal();
  factory GoogleDriveService({String? accessToken}) {
    if (accessToken != null) {
      _instance.accessToken = accessToken;
    }
    return _instance;
  }
  GoogleDriveService._internal();

  bool get isConfigured => accessToken != null;

  // Upload file to Google Drive
  Future<String?> uploadFile(String filePath, String? folderId) async {
    if (accessToken == null) {
      throw Exception('Google Drive access token not configured');
    }

    try {
      final file = File(filePath);
      final fileName = path.basename(filePath);
      final fileBytes = await file.readAsBytes();

      // Create metadata
      final metadata = {
        'name': fileName,
        if (folderId != null) 'parents': [folderId],
      };

      // Upload using multipart
      final uri = Uri.parse('https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart');
      
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $accessToken'
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
        ))
        ..fields['metadata'] = jsonEncode(metadata);

      final response = await request.send();
      
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        return data['id'];
      } else {
        throw Exception('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في رفع الملف إلى Google Drive: $e');
      rethrow;
    }
  }

  // Download file from Google Drive
  Future<File?> downloadFile(String fileId, String savePath) async {
    if (accessToken == null) {
      throw Exception('Google Drive access token not configured');
    }

    try {
      final response = await http.get(
        Uri.parse('https://www.googleapis.com/drive/v3/files/$fileId?alt=media'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Download failed: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في تحميل الملف من Google Drive: $e');
      rethrow;
    }
  }

  // Delete file from Google Drive
  Future<bool> deleteFile(String fileId) async {
    if (accessToken == null) {
      throw Exception('Google Drive access token not configured');
    }

    try {
      final response = await http.delete(
        Uri.parse('https://www.googleapis.com/drive/v3/files/$fileId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      return response.statusCode == 204;
    } catch (e) {
      print('خطأ في حذف الملف من Google Drive: $e');
      return false;
    }
  }

  // List files in folder
  Future<List<Map<String, dynamic>>> listFiles({String? folderId}) async {
    if (accessToken == null) {
      throw Exception('Google Drive access token not configured');
    }

    try {
      String query = '';
      if (folderId != null) {
        query = '?q=\'$folderId\' in parents';
      }

      final response = await http.get(
        Uri.parse('https://www.googleapis.com/drive/v3/files$query'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['files'] ?? []);
      } else {
        throw Exception('List files failed: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في عرض الملفات من Google Drive: $e');
      return [];
    }
  }

  // Get file metadata
  Future<Map<String, dynamic>?> getFileMetadata(String fileId) async {
    if (accessToken == null) {
      throw Exception('Google Drive access token not configured');
    }

    try {
      final response = await http.get(
        Uri.parse('https://www.googleapis.com/drive/v3/files/$fileId?fields=*'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('خطأ في الحصول على معلومات الملف: $e');
      return null;
    }
  }

  // Create folder
  Future<String?> createFolder(String folderName, String? parentId) async {
    if (accessToken == null) {
      throw Exception('Google Drive access token not configured');
    }

    try {
      final metadata = {
        'name': folderName,
        'mimeType': 'application/vnd.google-apps.folder',
        if (parentId != null) 'parents': [parentId],
      };

      final response = await http.post(
        Uri.parse('https://www.googleapis.com/drive/v3/files'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(metadata),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['id'];
      } else {
        throw Exception('Create folder failed: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في إنشاء المجلد: $e');
      rethrow;
    }
  }

  // Share file
  Future<bool> shareFile(String fileId, String email, String role) async {
    if (accessToken == null) {
      throw Exception('Google Drive access token not configured');
    }

    try {
      final permission = {
        'type': 'user',
        'role': role, // 'reader', 'writer', 'commenter'
        'emailAddress': email,
      };

      final response = await http.post(
        Uri.parse('https://www.googleapis.com/drive/v3/files/$fileId/permissions'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(permission),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('خطأ في مشاركة الملف: $e');
      return false;
    }
  }

  // Get shareable link
  Future<String?> getShareableLink(String fileId) async {
    if (accessToken == null) {
      throw Exception('Google Drive access token not configured');
    }

    try {
      // Make file public
      await http.post(
        Uri.parse('https://www.googleapis.com/drive/v3/files/$fileId/permissions'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'type': 'anyone',
          'role': 'reader',
        }),
      );

      // Get link
      final response = await http.get(
        Uri.parse('https://www.googleapis.com/drive/v3/files/$fileId?fields=webViewLink'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['webViewLink'];
      }
      
      return null;
    } catch (e) {
      print('خطأ في الحصول على رابط المشاركة: $e');
      return null;
    }
  }
}
