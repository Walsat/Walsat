import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/api_config.dart';
import '../services/ai_service.dart';
import '../services/google_drive_service.dart';

class AISettingsScreen extends StatefulWidget {
  const AISettingsScreen({super.key});

  @override
  State<AISettingsScreen> createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends State<AISettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final aiService = Provider.of<AIService>(context, listen: false);
    final driveService = Provider.of<GoogleDriveService>(context, listen: false);
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إعدادات الذكاء الاصطناعي'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.psychology,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'خدمات الذكاء الاصطناعي',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'استفد من قوة الذكاء الاصطناعي لتحليل ومعالجة وثائقك',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // OpenAI Status
            _buildServiceCard(
              context: context,
              title: 'OpenAI GPT-4',
              icon: Icons.auto_awesome,
              isConfigured: APIConfig.hasOpenAI,
              features: [
                'تحليل ذكي للوثائق',
                'استخراج المعلومات تلقائياً',
                'بحث ذكي متقدم',
                'توليد وسوم ذكية',
                'تلخيص الوثائق',
                'الأسئلة والأجوبة',
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Google Vision Status
            _buildServiceCard(
              context: context,
              title: 'Google Vision API',
              icon: Icons.document_scanner,
              isConfigured: APIConfig.hasGoogleVision,
              features: [
                'استخراج النص من الصور (OCR)',
                'دعم اللغة العربية',
                'تحليل الجداول والنماذج',
                'التعرف على الخطوط المختلفة',
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Google Drive Status
            _buildServiceCard(
              context: context,
              title: 'Google Drive',
              icon: Icons.cloud,
              isConfigured: driveService.isConfigured,
              features: [
                'النسخ الاحتياطي السحابي',
                'مزامنة تلقائية',
                'مشاركة الملفات',
                'الوصول من أي جهاز',
              ],
              setupInstructions: 'يتطلب تسجيل دخول Google',
            ),
            
            const SizedBox(height: 24),
            
            // Features Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'الميزات المفعّلة',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...APIConfig.availableFeatures.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(
                              entry.value ? Icons.check_circle : Icons.cancel,
                              color: entry.value ? Colors.green : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry.key,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: entry.value ? null : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Setup Instructions
            if (!APIConfig.hasOpenAI || !APIConfig.hasGoogleVision)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'لتفعيل جميع الميزات',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '1. راجع ملف: SECURITY_GUIDE.md\n'
                        '2. راجع ملف: API_SETUP_GUIDE.md\n'
                        '3. أضف مفاتيح API في ملف:\n'
                        '   lib/config/api_config.dart',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Test Button
            if (APIConfig.hasOpenAI)
              ElevatedButton.icon(
                onPressed: () => _testAIServices(context),
                icon: const Icon(Icons.play_arrow),
                label: const Text('اختبار خدمات AI'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildServiceCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isConfigured,
    required List<String> features,
    String? setupInstructions,
  }) {
    return Card(
      elevation: isConfigured ? 4 : 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isConfigured
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isConfigured
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isConfigured ? Icons.check_circle : Icons.cancel,
                            size: 16,
                            color: isConfigured ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isConfigured ? 'مفعّل' : 'غير مفعّل',
                            style: TextStyle(
                              color: isConfigured ? Colors.green : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            if (features.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              ...features.map((feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_left,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          color: isConfigured ? null : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ],
            
            if (!isConfigured && setupInstructions != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        setupInstructions,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  void _testAIServices(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جاري اختبار خدمات AI...'),
              ],
            ),
          ),
        ),
      ),
    );
    
    try {
      final aiService = Provider.of<AIService>(context, listen: false);
      
      // Test tag generation
      final tags = await aiService.generateSmartTags(
        'وثيقة صك ملكية لأرض زراعية في محافظة صلاح الدين',
        null,
      );
      
      Navigator.pop(context);
      
      if (!mounted) return;
      
      showDialog(
        context: context,
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 12),
                Text('الاختبار ناجح!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('تم الاتصال بخدمات AI بنجاح'),
                const SizedBox(height: 12),
                const Text('وسوم مقترحة:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...tags.map((tag) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('• $tag'),
                )).toList(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('حسناً'),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      
      if (!mounted) return;
      
      showDialog(
        context: context,
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 12),
                Text('فشل الاختبار'),
              ],
            ),
            content: Text('حدث خطأ: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('حسناً'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
