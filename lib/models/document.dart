import 'package:hive/hive.dart';

part 'document.g.dart';

@HiveType(typeId: 0)
class Document extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String type; // e.g., "Land Deed", "Contract", "Survey"

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? updatedAt;

  @HiveField(6)
  List<String> imagePaths;

  @HiveField(7)
  String? pdfPath;

  @HiveField(8)
  Map<String, dynamic>? metadata;

  @HiveField(9)
  List<String> tags;

  @HiveField(10)
  String? aiAnalysis;

  @HiveField(11)
  String status; // e.g., "active", "archived", "pending"

  @HiveField(12)
  String? location;

  @HiveField(13)
  double? area;

  @HiveField(14)
  String? ownerName;

  Document({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.createdAt,
    this.updatedAt,
    required this.imagePaths,
    this.pdfPath,
    this.metadata,
    required this.tags,
    this.aiAnalysis,
    this.status = 'active',
    this.location,
    this.area,
    this.ownerName,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'imagePaths': imagePaths,
      'pdfPath': pdfPath,
      'metadata': metadata,
      'tags': tags,
      'aiAnalysis': aiAnalysis,
      'status': status,
      'location': location,
      'area': area,
      'ownerName': ownerName,
    };
  }

  // Create from JSON
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      imagePaths: List<String>.from(json['imagePaths'] as List),
      pdfPath: json['pdfPath'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      tags: List<String>.from(json['tags'] as List),
      aiAnalysis: json['aiAnalysis'] as String?,
      status: json['status'] as String? ?? 'active',
      location: json['location'] as String?,
      area: json['area'] as double?,
      ownerName: json['ownerName'] as String?,
    );
  }

  // Copy with
  Document copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? imagePaths,
    String? pdfPath,
    Map<String, dynamic>? metadata,
    List<String>? tags,
    String? aiAnalysis,
    String? status,
    String? location,
    double? area,
    String? ownerName,
  }) {
    return Document(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imagePaths: imagePaths ?? this.imagePaths,
      pdfPath: pdfPath ?? this.pdfPath,
      metadata: metadata ?? this.metadata,
      tags: tags ?? this.tags,
      aiAnalysis: aiAnalysis ?? this.aiAnalysis,
      status: status ?? this.status,
      location: location ?? this.location,
      area: area ?? this.area,
      ownerName: ownerName ?? this.ownerName,
    );
  }
}
