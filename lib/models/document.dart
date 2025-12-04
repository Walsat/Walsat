import 'package:hive/hive.dart';

part 'document.g.dart';

@HiveType(typeId: 0)
class Document extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late String type; // نوع الوثيقة: صك ملكية، عقد بيع، إيجار، etc

  @HiveField(4)
  late DateTime createdAt;

  @HiveField(5)
  late DateTime? updatedAt;

  @HiveField(6)
  late List<String> imagePaths;

  @HiveField(7)
  late List<String> tags;

  @HiveField(8)
  late String status; // جديد، تحت المراجعة، مكتمل، أرشيف

  @HiveField(9)
  String? location;

  @HiveField(10)
  String? ownerName;

  @HiveField(11)
  double? area;

  @HiveField(12)
  String? aiAnalysis;

  @HiveField(13)
  bool isFavorite;

  @HiveField(14)
  String? pdfPath;

  Document({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.createdAt,
    this.updatedAt,
    required this.imagePaths,
    required this.tags,
    required this.status,
    this.location,
    this.ownerName,
    this.area,
    this.aiAnalysis,
    this.isFavorite = false,
    this.pdfPath,
  });

  // Helper method to get display name for document type
  String get typeDisplayName {
    switch (type) {
      case 'land_deed':
        return 'صك ملكية';
      case 'sale_contract':
        return 'عقد بيع';
      case 'rent_contract':
        return 'عقد إيجار';
      case 'survey':
        return 'مخطط مساحي';
      case 'license':
        return 'رخصة بناء';
      case 'other':
        return 'أخرى';
      default:
        return type;
    }
  }

  // Helper method to get display name for status
  String get statusDisplayName {
    switch (status) {
      case 'new':
        return 'جديد';
      case 'review':
        return 'تحت المراجعة';
      case 'completed':
        return 'مكتمل';
      case 'archived':
        return 'مؤرشف';
      default:
        return status;
    }
  }
}
