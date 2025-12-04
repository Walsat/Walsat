import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/document.dart';
import '../services/database_service.dart';
import '../services/pdf_service.dart';
import 'add_document_screen.dart';

class DocumentDetailScreen extends StatefulWidget {
  final Document document;

  const DocumentDetailScreen({super.key, required this.document});

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الوثيقة'),
        actions: [
          IconButton(
            icon: Icon(
              widget.document.isFavorite ? Icons.star : Icons.star_border,
              color: widget.document.isFavorite ? Colors.amber : null,
            ),
            onPressed: () {
              setState(() {
                widget.document.isFavorite = !widget.document.isFavorite;
              });
              context.read<DatabaseService>().updateDocument(widget.document);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDocumentScreen(document: widget.document),
                ),
              );
              if (result == true) {
                setState(() {});
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog();
              } else if (value == 'pdf') {
                _generatePdf();
              } else if (value == 'share') {
                _sharePdf();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf),
                    SizedBox(width: 8),
                    Text('إنشاء PDF'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('مشاركة'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('حذف', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Title Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.document.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(
                        label: Text(widget.document.typeDisplayName),
                        avatar: const Icon(Icons.category, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(widget.document.statusDisplayName),
                        backgroundColor: _getStatusColor(widget.document.status),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المعلومات الأساسية',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.document.ownerName != null)
                    _buildInfoRow(Icons.person, 'المالك', widget.document.ownerName!),
                  if (widget.document.location != null)
                    _buildInfoRow(Icons.location_on, 'الموقع', widget.document.location!),
                  if (widget.document.area != null)
                    _buildInfoRow(Icons.square_foot, 'المساحة', '${widget.document.area} م²'),
                  _buildInfoRow(
                    Icons.access_time,
                    'تاريخ الإنشاء',
                    _formatDate(widget.document.createdAt),
                  ),
                  if (widget.document.updatedAt != null)
                    _buildInfoRow(
                      Icons.update,
                      'آخر تحديث',
                      _formatDate(widget.document.updatedAt!),
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Description Card
          if (widget.document.description.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الوصف',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.document.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Tags Card
          if (widget.document.tags.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الوسوم',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.document.tags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Images Card
          if (widget.document.imagePaths.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الصور (${widget.document.imagePaths.length})',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: widget.document.imagePaths.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _showImageDialog(index),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(widget.document.imagePaths[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'new':
        return Colors.blue;
      case 'review':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'archived':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showImageDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(File(widget.document.imagePaths[index])),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذه الوثيقة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<DatabaseService>().deleteDocument(widget.document.id);
              if (mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context, true); // Return to previous screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حذف الوثيقة بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _generatePdf() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final pdfService = context.read<PdfService>();
      final pdfPath = await pdfService.generatePdf(widget.document);

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إنشاء PDF بنجاح: $pdfPath'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إنشاء PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _sharePdf() async {
    try {
      if (widget.document.pdfPath == null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        final pdfService = context.read<PdfService>();
        final pdfPath = await pdfService.generatePdf(widget.document);
        
        if (mounted) {
          Navigator.pop(context);
          await pdfService.sharePdf(pdfPath);
        }
      } else {
        final pdfService = context.read<PdfService>();
        await pdfService.sharePdf(widget.document.pdfPath!);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في المشاركة: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
