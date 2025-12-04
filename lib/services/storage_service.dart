import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/document.dart';

class StorageService {
  static const String _documentsBox = 'documents';
  Box<Document>? _box;

  // Initialize Hive
  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(DocumentAdapter());
    }

    // Open box
    _box = await Hive.openBox<Document>(_documentsBox);
  }

  // Get all documents
  List<Document> getAllDocuments() {
    return _box?.values.toList() ?? [];
  }

  // Get document by ID
  Document? getDocumentById(String id) {
    return _box?.values.firstWhere(
      (doc) => doc.id == id,
      orElse: () => throw Exception('Document not found'),
    );
  }

  // Add document
  Future<void> addDocument(Document document) async {
    await _box?.put(document.id, document);
  }

  // Update document
  Future<void> updateDocument(Document document) async {
    document.updatedAt = DateTime.now();
    await _box?.put(document.id, document);
  }

  // Delete document
  Future<void> deleteDocument(String id) async {
    await _box?.delete(id);
  }

  // Search documents
  List<Document> searchDocuments(String query) {
    if (query.isEmpty) return getAllDocuments();

    final lowerQuery = query.toLowerCase();
    return _box?.values.where((doc) {
      return doc.title.toLowerCase().contains(lowerQuery) ||
          doc.description.toLowerCase().contains(lowerQuery) ||
          doc.type.toLowerCase().contains(lowerQuery) ||
          doc.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
          (doc.ownerName?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList() ?? [];
  }

  // Filter documents by type
  List<Document> filterByType(String type) {
    return _box?.values.where((doc) => doc.type == type).toList() ?? [];
  }

  // Filter documents by status
  List<Document> filterByStatus(String status) {
    return _box?.values.where((doc) => doc.status == status).toList() ?? [];
  }

  // Get documents by date range
  List<Document> getDocumentsByDateRange(DateTime start, DateTime end) {
    return _box?.values.where((doc) {
      return doc.createdAt.isAfter(start) && doc.createdAt.isBefore(end);
    }).toList() ?? [];
  }

  // Get recent documents
  List<Document> getRecentDocuments({int limit = 10}) {
    final docs = getAllDocuments();
    docs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return docs.take(limit).toList();
  }

  // Export all documents
  List<Map<String, dynamic>> exportAllDocuments() {
    return getAllDocuments().map((doc) => doc.toJson()).toList();
  }

  // Import documents
  Future<void> importDocuments(List<Map<String, dynamic>> jsonList) async {
    for (var json in jsonList) {
      final doc = Document.fromJson(json);
      await addDocument(doc);
    }
  }

  // Clear all documents
  Future<void> clearAll() async {
    await _box?.clear();
  }

  // Get statistics
  Map<String, int> getStatistics() {
    final docs = getAllDocuments();
    return {
      'total': docs.length,
      'active': docs.where((d) => d.status == 'active').length,
      'archived': docs.where((d) => d.status == 'archived').length,
      'pending': docs.where((d) => d.status == 'pending').length,
    };
  }

  // Close box
  Future<void> close() async {
    await _box?.close();
  }
}
