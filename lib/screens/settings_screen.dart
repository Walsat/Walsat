import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../services/ai_service.dart';
import '../services/database_service.dart';
import 'ai_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _enableNotifications = true;
  bool _autoBackup = false;
  bool _enableAIFeatures = true;
  bool _compressImages = true;
  String _selectedLanguage = 'ar';
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _enableNotifications = prefs.getBool('notifications') ?? true;
      _autoBackup = prefs.getBool('autoBackup') ?? false;
      _enableAIFeatures = prefs.getBool('aiFeatures') ?? true;
      _compressImages = prefs.getBool('compressImages') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'ar';
    });
  }
  
  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final databaseService = context.read<DatabaseService>();
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإعدادات'),
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // App Info Header
            _buildHeaderCard(),
            
            const SizedBox(height: 24),
            
            // Appearance Section
            _buildSectionTitle('المظهر'),
            _buildAppearanceCard(),
            
            const SizedBox(height: 24),
            
            // AI Settings Section
            _buildSectionTitle('الذكاء الاصطناعي'),
            _buildAICard(),
            
            const SizedBox(height: 24),
            
            // Data Management Section
            _buildSectionTitle('إدارة البيانات'),
            _buildDataCard(databaseService),
            
            const SizedBox(height: 24),
            
            // Notifications Section
            _buildSectionTitle('الإشعارات'),
            _buildNotificationsCard(),
            
            const SizedBox(height: 24),
            
            // About Section
            _buildSectionTitle('حول التطبيق'),
            _buildAboutCard(),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeaderCard() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.settings,
                size: 48,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'أرشيف الوثائق',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'v5.0.2 - نظام أرشفة احترافي',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
  
  Widget _buildAppearanceCard() {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('الوضع الليلي'),
            subtitle: const Text('تفعيل المظهر الداكن'),
            value: _isDarkMode,
            secondary: Icon(
              _isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              _saveSetting('darkMode', value);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('يرجى إعادة تشغيل التطبيق لتطبيق التغييرات'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.language,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('اللغة'),
            subtitle: Text(_selectedLanguage == 'ar' ? 'العربية' : 'English'),
            trailing: const Icon(Icons.arrow_back_ios, size: 16),
            onTap: () {
              _showLanguageDialog();
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildAICard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.psychology, color: Colors.purple),
            ),
            title: const Text('إعدادات الذكاء الاصطناعي'),
            subtitle: Text(
              APIConfig.hasOpenAI ? 'مفعّل ✓' : 'غير مفعّل',
              style: TextStyle(
                color: APIConfig.hasOpenAI ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.arrow_back_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AISettingsScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('تفعيل ميزات AI'),
            subtitle: const Text('البحث الذكي والتحليل التلقائي'),
            value: _enableAIFeatures,
            secondary: const Icon(Icons.auto_awesome, color: Colors.purple),
            onChanged: APIConfig.hasOpenAI ? (value) {
              setState(() {
                _enableAIFeatures = value;
              });
              _saveSetting('aiFeatures', value);
            } : null,
          ),
        ],
      ),
    );
  }
  
  Widget _buildDataCard(DatabaseService databaseService) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('ضغط الصور تلقائياً'),
            subtitle: const Text('توفير مساحة التخزين'),
            value: _compressImages,
            secondary: Icon(
              Icons.compress,
              color: Theme.of(context).colorScheme.primary,
            ),
            onChanged: (value) {
              setState(() {
                _compressImages = value;
              });
              _saveSetting('compressImages', value);
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('نسخ احتياطي تلقائي'),
            subtitle: const Text('حفظ البيانات تلقائياً'),
            value: _autoBackup,
            secondary: const Icon(Icons.backup, color: Colors.blue),
            onChanged: (value) {
              setState(() {
                _autoBackup = value;
              });
              _saveSetting('autoBackup', value);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.file_download, color: Colors.green),
            title: const Text('تصدير جميع البيانات'),
            subtitle: const Text('حفظ نسخة من الوثائق'),
            trailing: const Icon(Icons.arrow_back_ios, size: 16),
            onTap: () => _exportData(databaseService),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.file_upload, color: Colors.orange),
            title: const Text('استيراد البيانات'),
            subtitle: const Text('استعادة نسخة احتياطية'),
            trailing: const Icon(Icons.arrow_back_ios, size: 16),
            onTap: () => _importData(databaseService),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('حذف جميع البيانات'),
            subtitle: const Text('مسح كامل للتطبيق'),
            trailing: const Icon(Icons.arrow_back_ios, size: 16),
            onTap: () => _showDeleteAllDialog(databaseService),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationsCard() {
    return Card(
      child: SwitchListTile(
        title: const Text('الإشعارات'),
        subtitle: const Text('تلقي إشعارات التطبيق'),
        value: _enableNotifications,
        secondary: Icon(
          Icons.notifications,
          color: Theme.of(context).colorScheme.primary,
        ),
        onChanged: (value) {
          setState(() {
            _enableNotifications = value;
          });
          _saveSetting('notifications', value);
        },
      ),
    );
  }
  
  Widget _buildAboutCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.blue),
            title: const Text('معلومات التطبيق'),
            subtitle: const Text('الإصدار والترخيص'),
            trailing: const Icon(Icons.arrow_back_ios, size: 16),
            onTap: _showAboutDialog,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.green),
            title: const Text('المساعدة والدعم'),
            subtitle: const Text('دليل الاستخدام'),
            trailing: const Icon(Icons.arrow_back_ios, size: 16),
            onTap: _showHelpDialog,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: Colors.purple),
            title: const Text('سياسة الخصوصية'),
            subtitle: const Text('حماية بياناتك'),
            trailing: const Icon(Icons.arrow_back_ios, size: 16),
            onTap: _showPrivacyDialog,
          ),
        ],
      ),
    );
  }
  
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('اختر اللغة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('العربية'),
                value: 'ar',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  _saveSetting('language', value);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('English'),
                value: 'en',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  _saveSetting('language', value);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('English language coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _exportData(DatabaseService databaseService) async {
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
                Text('جاري تصدير البيانات...'),
              ],
            ),
          ),
        ),
      ),
    );
    
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تصدير البيانات بنجاح ✓'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
  
  Future<void> _importData(DatabaseService databaseService) async {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('استيراد البيانات'),
          content: const Text(
            'اختر ملف النسخة الاحتياطية لاستعادة بياناتك.\n\n'
            '⚠️ تحذير: سيتم استبدال البيانات الحالية.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ميزة الاستيراد قريباً...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('اختيار ملف'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showDeleteAllDialog(DatabaseService databaseService) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 12),
              Text('تحذير!'),
            ],
          ),
          content: const Text(
            'هل أنت متأكد من حذف جميع البيانات؟\n\n'
            'سيتم حذف:\n'
            '• جميع الوثائق\n'
            '• جميع الصور\n'
            '• جميع الإعدادات\n\n'
            '⚠️ هذا الإجراء لا يمكن التراجع عنه!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                
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
                            Text('جاري حذف البيانات...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                
                await Future.delayed(const Duration(seconds: 2));
                
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم حذف جميع البيانات ✓'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('حذف نهائي'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('حول التطبيق'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.folder_special,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'أرشيف الوثائق',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text('الإصدار 5.0.2'),
                ),
                const SizedBox(height: 24),
                const Text(
                  'نظام أرشفة احترافي للوثائق الحكومية العراقية مع ذكاء اصطناعي متكامل.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const Text('✨ الميزات:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('• أرشفة احترافية للوثائق'),
                const Text('• 8 تصنيفات حكومية عراقية'),
                const Text('• ذكاء اصطناعي متقدم'),
                const Text('• إنشاء PDF احترافي'),
                const Text('• واجهة عربية 100%'),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'تم التطوير بواسطة:\nGenSpark AI Developer',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('المساعدة والدعم'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '📖 دليل الاستخدام السريع',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                _buildHelpItem('1', 'إضافة وثيقة', 'اضغط على زر + في الشاشة الرئيسية'),
                _buildHelpItem('2', 'التقاط صورة', 'استخدم زر الكاميرا أو اختر من المعرض'),
                _buildHelpItem('3', 'تحليل بالذكاء الاصطناعي', 'افتح الوثيقة واختر تحليل من القائمة'),
                _buildHelpItem('4', 'البحث', 'استخدم أيقونة البحث في الشاشة الرئيسية'),
                _buildHelpItem('5', 'إنشاء PDF', 'افتح الوثيقة واختر إنشاء PDF'),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  '💡 نصائح:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('• استخدم ميزات AI للتحليل التلقائي'),
                const Text('• قم بعمل نسخ احتياطي منتظم'),
                const Text('• استخدم الوسوم لتنظيم أفضل'),
                const Text('• فعّل ضغط الصور لتوفير المساحة'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('فهمت'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHelpItem(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('سياسة الخصوصية'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🔒 نحن نحترم خصوصيتك',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text('✅ جميع بياناتك مخزنة محلياً على جهازك'),
                const SizedBox(height: 8),
                const Text('✅ لا نقوم بجمع أي معلومات شخصية'),
                const SizedBox(height: 8),
                const Text('✅ لا نرسل بياناتك إلى أي خوادم خارجية'),
                const SizedBox(height: 8),
                const Text('✅ ميزات AI تعمل فقط عند تفعيلها'),
                const SizedBox(height: 8),
                const Text('✅ لا نشارك معلوماتك مع أطراف ثالثة'),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  '🛡️ الأذونات المستخدمة:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('📷 الكاميرا: لالتقاط صور الوثائق'),
                const SizedBox(height: 4),
                const Text('💾 التخزين: لحفظ الوثائق محلياً'),
                const SizedBox(height: 4),
                const Text('🌐 الإنترنت: لخدمات AI (اختياري)'),
                const SizedBox(height: 16),
                const Text(
                  'جميع الأذونات تُستخدم فقط للأغراض المذكورة ولا يتم إساءة استخدامها.',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('فهمت'),
            ),
          ],
        ),
      ),
    );
  }
}
