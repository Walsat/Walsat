import 'package:hive_flutter/hive_flutter.dart';
import '../models/document.dart';

class DatabaseService {
  static const String _boxName = 'documents';
  late Box<Document> _box;

  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Initialize Hive database
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DocumentAdapter());
    _box = await Hive.openBox<Document>(_boxName);
  }

  // Add new document
  Future<void> addDocument(Document document) async {
    await _box.put(document.id, document);
  }

  // Get all documents
  List<Document> getAllDocuments() {
    return _box.values.toList();
  }

  // Get document by ID
  Document? getDocument(String id) {
    return _box.get(id);
  }

  // Update document
  Future<void> updateDocument(Document document) async {
    document.updatedAt = DateTime.now();
    await _box.put(document.id, document);
  }

  // Delete document
  Future<void> deleteDocument(String id) async {
    await _box.delete(id);
  }

  // Search documents
  List<Document> searchDocuments(String query) {
    if (query.isEmpty) return getAllDocuments();

    final lowercaseQuery = query.toLowerCase();
    return _box.values.where((doc) {
      return doc.title.toLowerCase().contains(lowercaseQuery) ||
          doc.description.toLowerCase().contains(lowercaseQuery) ||
          doc.type.toLowerCase().contains(lowercaseQuery) ||
          doc.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)) ||
          (doc.ownerName?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          (doc.location?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  // Filter by type
  List<Document> filterByType(String type) {
    return _box.values.where((doc) => doc.type == type).toList();
  }

  // Filter by status
  List<Document> filterByStatus(String status) {
    return _box.values.where((doc) => doc.status == status).toList();
  }

  // Get favorites
  List<Document> getFavorites() {
    return _box.values.where((doc) => doc.isFavorite).toList();
  }

  // Get statistics
  Map<String, int> getStatistics() {
    final docs = getAllDocuments();
    return {
      'total': docs.length,
      'new': docs.where((d) => d.status == 'new').length,
      'review': docs.where((d) => d.status == 'review').length,
      'completed': docs.where((d) => d.status == 'completed').length,
      'archived': docs.where((d) => d.status == 'archived').length,
      'favorites': docs.where((d) => d.isFavorite).length,
    };
  }

  // Get documents by date range
  List<Document> getDocumentsByDateRange(DateTime start, DateTime end) {
    return _box.values.where((doc) {
      return doc.createdAt.isAfter(start) && doc.createdAt.isBefore(end);
    }).toList();
  }

  // Close database
  Future<void> close() async {
    await _box.close();
  }
}
