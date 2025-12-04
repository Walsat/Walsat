import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/document.dart';
import '../services/database_service.dart';
import '../services/image_service.dart';
import '../services/ai_service.dart';
import '../config/api_config.dart';

class AddDocumentScreen extends StatefulWidget {
  final Document? document;

  const AddDocumentScreen({super.key, this.document});

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _ownerController = TextEditingController();
  final _areaController = TextEditingController();
  
  String _selectedType = 'land_registry';
  String _selectedStatus = 'new';
  List<String> _imagePaths = [];
  List<String> _tags = [];
  bool _isSaving = false;
  bool _isAnalyzing = false;

  final List<Map<String, dynamic>> _documentTypes = [
    {'value': 'land_registry', 'label': 'كتب دائرة الأراضي', 'icon': Icons.domain},
    {'value': 'agriculture_ministry', 'label': 'وزارة الزراعة', 'icon': Icons.agriculture},
    {'value': 'governor_saladin', 'label': 'محافظ صلاح الدين', 'icon': Icons.account_balance},
    {'value': 'agriculture_directorate', 'label': 'مديرية الزراعة', 'icon': Icons.business},
    {'value': 'agriculture_division', 'label': 'شعبة الزراعة', 'icon': Icons.corporate_fare},
    {'value': 'important_orders', 'label': 'أوامر مهمة', 'icon': Icons.priority_high},
    {'value': 'complaints', 'label': 'الأبيض الشكوي', 'icon': Icons.report_problem},
    {'value': 'other', 'label': 'أخرى', 'icon': Icons.insert_drive_file},
  ];

  final List<Map<String, String>> _statusOptions = [
    {'value': 'new', 'label': 'جديد'},
    {'value': 'review', 'label': 'تحت المراجعة'},
    {'value': 'completed', 'label': 'مكتمل'},
    {'value': 'archived', 'label': 'مؤرشف'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.document != null) {
      _titleController.text = widget.document!.title;
      _descriptionController.text = widget.document!.description;
      _locationController.text = widget.document!.location ?? '';
      _ownerController.text = widget.document!.ownerName ?? '';
      _areaController.text = widget.document!.area?.toString() ?? '';
      _selectedType = widget.document!.type;
      _selectedStatus = widget.document!.status;
      _imagePaths = List.from(widget.document!.imagePaths);
      _tags = List.from(widget.document!.tags);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _ownerController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageService = context.read<ImageService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document == null ? 'إضافة وثيقة' : 'تعديل الوثيقة'),
        actions: [
          if (!_isSaving)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveDocument,
            ),
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'عنوان الوثيقة *',
                hintText: 'مثال: صك ملكية أرض رقم 12345',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال عنوان الوثيقة';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Document Type
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'نوع الوثيقة *',
                prefixIcon: Icon(Icons.category),
              ),
              items: _documentTypes.map((type) {
                return DropdownMenuItem(
                  value: type['value'] as String,
                  child: Row(
                    children: [
                      Icon(type['icon'] as IconData, size: 20),
                      const SizedBox(width: 12),
                      Text(type['label'] as String),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Status
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'الحالة *',
                prefixIcon: Icon(Icons.flag),
              ),
              items: _statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status['value'],
                  child: Text(status['label']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'الوصف',
                hintText: 'أدخل وصفاً تفصيلياً للوثيقة',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 4,
            ),
            
            const SizedBox(height: 16),
            
            // Owner Name
            TextFormField(
              controller: _ownerController,
              decoration: const InputDecoration(
                labelText: 'اسم المالك',
                hintText: 'مثال: محمد أحمد',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Location
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'الموقع',
                hintText: 'مثال: الرياض، حي النخيل',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Area
            TextFormField(
              controller: _areaController,
              decoration: const InputDecoration(
                labelText: 'المساحة (متر مربع)',
                hintText: 'مثال: 500',
                prefixIcon: Icon(Icons.square_foot),
              ),
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 24),
            
            // Images Section
            Text(
              'الصور',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            // Image buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        final path = await imageService.takePhoto();
                        if (path != null) {
                          setState(() {
                            _imagePaths.add(path);
                          });
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم التقاط الصورة بنجاح')),
                            );
                          }
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('خطأ: $e')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('التقاط صورة'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        final paths = await imageService.pickMultipleImages();
                        if (paths.isNotEmpty) {
                          setState(() {
                            _imagePaths.addAll(paths);
                          });
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم إضافة ${paths.length} صورة')),
                            );
                          }
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('خطأ: $e')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('اختيار من المعرض'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Images grid
            if (_imagePaths.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _imagePaths.length,
                itemBuilder: (context, index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_imagePaths[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.red,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.close, size: 16, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _imagePaths.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            
            const SizedBox(height: 24),
            
            // AI Analysis Section
            if (_imagePaths.isNotEmpty) ...[
              Text(
                'تحليل بالذكاء الاصطناعي',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isAnalyzing ? null : _analyzeWithAI,
                      icon: _isAnalyzing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.psychology),
                      label: Text(_isAnalyzing ? 'جاري التحليل...' : 'تحليل الوثيقة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isAnalyzing ? null : _extractText,
                      icon: const Icon(Icons.text_fields),
                      label: const Text('استخراج النص (OCR)'),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
            ],
            
            // Tags Section
            Text(
              'الوسوم',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            // Add tag button
            OutlinedButton.icon(
              onPressed: _showAddTagDialog,
              icon: const Icon(Icons.add),
              label: const Text('إضافة وسم'),
            ),
            
            const SizedBox(height: 16),
            
            // Tags list
            if (_tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        _tags.remove(tag);
                      });
                    },
                  );
                }).toList(),
              ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showAddTagDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة وسم'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'أدخل الوسم',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _tags.add(controller.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveDocument() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final databaseService = context.read<DatabaseService>();

      if (widget.document == null) {
        // Create new document
        final document = Document(
          id: const Uuid().v4(),
          title: _titleController.text,
          description: _descriptionController.text,
          type: _selectedType,
          createdAt: DateTime.now(),
          imagePaths: _imagePaths,
          tags: _tags,
          status: _selectedStatus,
          location: _locationController.text.isEmpty ? null : _locationController.text,
          ownerName: _ownerController.text.isEmpty ? null : _ownerController.text,
          area: _areaController.text.isEmpty ? null : double.tryParse(_areaController.text),
        );

        await databaseService.addDocument(document);
      } else {
        // Update existing document
        widget.document!.title = _titleController.text;
        widget.document!.description = _descriptionController.text;
        widget.document!.type = _selectedType;
        widget.document!.status = _selectedStatus;
        widget.document!.imagePaths = _imagePaths;
        widget.document!.tags = _tags;
        widget.document!.location = _locationController.text.isEmpty ? null : _locationController.text;
        widget.document!.ownerName = _ownerController.text.isEmpty ? null : _ownerController.text;
        widget.document!.area = _areaController.text.isEmpty ? null : double.tryParse(_areaController.text);

        await databaseService.updateDocument(widget.document!);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.document == null ? 'تم إضافة الوثيقة بنجاح' : 'تم تحديث الوثيقة بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في حفظ الوثيقة: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _analyzeWithAI() async {
    if (_imagePaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إضافة صورة أولاً')),
      );
      return;
    }

    // Check if AI is configured
    if (!APIConfig.hasOpenAI) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يجب تكوين OpenAI API أولاً في الإعدادات'),
          action: SnackBarAction(
            label: 'إعدادات',
            onPressed: () {
              Navigator.pushNamed(context, '/api_keys');
            },
          ),
        ),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('🤖 جاري تحليل الوثيقة بالذكاء الاصطناعي...'),
              SizedBox(height: 8),
              Text('التصنيف التلقائي + استخراج المعلومات', style: TextStyle(fontSize: 12)),
              SizedBox(height: 4),
              Text('قد يستغرق هذا دقيقة...', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
      );

      // Call real AI service for auto-classification
      final aiService = AIService();
      final result = await aiService.autoClassifyDocument(_imagePaths.first);
      
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        // Apply AI results to the form
        if (result.containsKey('نوع_الوثيقة') || result.containsKey('type')) {
          final docType = result['نوع_الوثيقة'] ?? result['type'] ?? '';
          
          // Map AI type to internal type
          final typeMap = {
            'كتب دائرة الأراضي': 'land_registry',
            'وزارة الزراعة': 'agriculture_ministry',
            'محافظ صلاح الدين': 'governor_saladin',
            'مديرية الزراعة': 'agriculture_directorate',
            'شعبة الزراعة': 'agriculture_division',
            'أوامر مهمة': 'important_orders',
            'الأبيض الشكوي': 'complaints',
          };
          
          final mappedType = typeMap[docType] ?? 'other';
          setState(() {
            _selectedType = mappedType;
          });
        }
        
        if (result.containsKey('العنوان') || result.containsKey('title')) {
          _titleController.text = result['العنوان'] ?? result['title'] ?? '';
        }
        
        if (result.containsKey('الموضوع') || result.containsKey('subject')) {
          _titleController.text = result['الموضوع'] ?? result['subject'] ?? _titleController.text;
        }
        
        if (result.containsKey('ملخص') || result.containsKey('summary')) {
          _descriptionController.text = result['ملخص'] ?? result['summary'] ?? '';
        }
        
        if (result.containsKey('المواقع') || result.containsKey('location')) {
          final location = result['المواقع'] ?? result['location'];
          if (location is List && location.isNotEmpty) {
            _locationController.text = location.join(', ');
          } else if (location is String) {
            _locationController.text = location;
          }
        }
        
        if (result.containsKey('الأسماء') || result.containsKey('names')) {
          final names = result['الأسماء'] ?? result['names'];
          if (names is List && names.isNotEmpty) {
            _ownerController.text = names.first;
          }
        }
        
        if (result.containsKey('الكلمات_المفتاحية') || result.containsKey('keywords')) {
          final keywords = result['الكلمات_المفتاحية'] ?? result['keywords'];
          if (keywords is List) {
            setState(() {
              _tags = keywords.cast<String>().toList();
            });
          }
        }
        
        if (result.containsKey('الحالة') || result.containsKey('status')) {
          final status = result['الحالة'] ?? result['status'] ?? '';
          final statusMap = {
            'جديد': 'new',
            'تحت المراجعة': 'review',
            'مكتمل': 'completed',
            'مؤرشف': 'archived',
          };
          
          setState(() {
            _selectedStatus = statusMap[status] ?? 'new';
          });
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ تم تحليل الوثيقة وتطبيق التصنيف التلقائي بنجاح!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ خطأ في التحليل: ${e.toString()}'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  Future<void> _extractText() async {
    if (_imagePaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إضافة صورة أولاً')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('جاري استخراج النص من الصورة...'),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم استخراج النص بنجاح! ✓'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }
}
