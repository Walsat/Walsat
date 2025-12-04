import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  // Singleton pattern
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  // Request camera permission
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  // Request storage permission
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (status.isDenied) {
        final photos = await Permission.photos.request();
        return photos.isGranted;
      }
      return status.isGranted;
    }
    return true;
  }

  // Take photo from camera
  Future<String?> takePhoto() async {
    try {
      final hasPermission = await requestCameraPermission();
      if (!hasPermission) {
        throw Exception('لا توجد صلاحية للوصول إلى الكاميرا');
      }

      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (photo == null) return null;

      return await _saveImage(photo.path);
    } catch (e) {
      print('خطأ في التقاط الصورة: $e');
      rethrow;
    }
  }

  // Pick image from gallery
  Future<String?> pickImage() async {
    try {
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('لا توجد صلاحية للوصول إلى المعرض');
      }

      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (photo == null) return null;

      return await _saveImage(photo.path);
    } catch (e) {
      print('خطأ في اختيار الصورة: $e');
      rethrow;
    }
  }

  // Pick multiple images from gallery
  Future<List<String>> pickMultipleImages() async {
    try {
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('لا توجد صلاحية للوصول إلى المعرض');
      }

      final List<XFile> photos = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (photos.isEmpty) return [];

      List<String> savedPaths = [];
      for (var photo in photos) {
        final savedPath = await _saveImage(photo.path);
        if (savedPath != null) {
          savedPaths.add(savedPath);
        }
      }

      return savedPaths;
    } catch (e) {
      print('خطأ في اختيار الصور المتعددة: $e');
      rethrow;
    }
  }

  // Save image to app directory
  Future<String?> _saveImage(String imagePath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = '${appDir.path}/images/$fileName';

      // Create images directory if it doesn't exist
      final imagesDir = Directory('${appDir.path}/images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      // Compress and save image
      final originalImage = img.decodeImage(File(imagePath).readAsBytesSync());
      if (originalImage == null) return null;

      // Resize if too large
      img.Image resized = originalImage;
      if (originalImage.width > 1920 || originalImage.height > 1920) {
        resized = img.copyResize(
          originalImage,
          width: originalImage.width > originalImage.height ? 1920 : null,
          height: originalImage.height > originalImage.width ? 1920 : null,
        );
      }

      // Save compressed image
      File(savedPath).writeAsBytesSync(img.encodeJpg(resized, quality: 85));

      return savedPath;
    } catch (e) {
      print('خطأ في حفظ الصورة: $e');
      return null;
    }
  }

  // Delete image
  Future<bool> deleteImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('خطأ في حذف الصورة: $e');
      return false;
    }
  }

  // Get image size
  Future<int> getImageSize(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      print('خطأ في الحصول على حجم الصورة: $e');
      return 0;
    }
  }
}
