/// 🤖 إعدادات الذكاء الاصطناعي الحديثة
/// DeepSeek V3 + Google Cloud Vision
class AIConfig {
  // ═══════════════════════════════════════════════════════════
  // 🔥 DeepSeek V3 - الذكاء الاصطناعي الرئيسي
  // ═══════════════════════════════════════════════════════════
  
  /// مفتاح DeepSeek API
  /// احصل عليه من: https://platform.deepseek.com
  static const String deepseekKey = 'sk-24e83becadb34f55bef4b09076a5bbfa';
  
  /// Endpoint الخاص بـ DeepSeek
  static const String deepseekEndpoint = 'https://api.deepseek.com/v1/chat/completions';
  
  /// نموذج DeepSeek المستخدم
  static const String deepseekModel = 'deepseek-chat';
  
  // ═══════════════════════════════════════════════════════════
  // ☁️ Google Cloud Vision - OCR المتقدم
  // ═══════════════════════════════════════════════════════════
  
  /// مفتاح Google Cloud Vision API
  /// احصل عليه من: https://console.cloud.google.com
  static const String googleCloudVisionKey = 'YOUR_GOOGLE_CLOUD_KEY_HERE';
  
  /// Endpoint الخاص بـ Google Cloud Vision
  static const String googleVisionEndpoint = 'https://vision.googleapis.com/v1/images:annotate';
  
  // ═══════════════════════════════════════════════════════════
  // ✅ التحقق من المفاتيح
  // ═══════════════════════════════════════════════════════════
  
  /// هل مفتاح DeepSeek متاح؟
  static bool get hasDeepSeek => 
      deepseekKey.isNotEmpty && !deepseekKey.contains('YOUR_KEY');
  
  /// هل مفتاح Google Cloud Vision متاح؟
  static bool get hasGoogleVision => 
      googleCloudVisionKey.isNotEmpty && !googleCloudVisionKey.contains('YOUR_KEY');
  
  /// هل يوجد أي خدمة AI متاحة؟
  static bool get hasAnyAI => hasDeepSeek || hasGoogleVision;
  
  // ═══════════════════════════════════════════════════════════
  // 🎯 الإعدادات المتقدمة
  // ═══════════════════════════════════════════════════════════
  
  /// درجة الحرارة للنموذج (0.0 - 1.0)
  /// قيمة أقل = أكثر دقة واتساق
  /// قيمة أعلى = أكثر إبداع وتنوع
  static const double temperature = 0.3;
  
  /// أقصى عدد tokens في الاستجابة
  static const int maxTokens = 4000;
  
  /// وقت الانتظار الأقصى للطلب (بالثواني)
  static const int timeoutSeconds = 30;
  
  // ═══════════════════════════════════════════════════════════
  // 💰 معلومات التسعير
  // ═══════════════════════════════════════════════════════════
  
  static Map<String, dynamic> get pricingInfo => {
    'deepseek': {
      'name': 'DeepSeek V3',
      'price_per_million': r'$0.27',
      'price_per_doc': r'$0.001',
      'price_per_100': r'$0.10',
      'speed': '5-15 ثانية',
      'accuracy': '90-93%',
      'features': [
        'تصنيف تلقائي للوثائق',
        'استخراج معلومات ذكي',
        'وسوم تلقائية',
        'تحليل متقدم',
      ],
    },
    'google_vision': {
      'name': 'Google Cloud Vision',
      'price_per_1000': r'$1.50',
      'price_per_doc': r'$0.0015',
      'speed': '2-5 ثواني',
      'accuracy': '95%+',
      'features': [
        'OCR متقدم',
        'دعم متعدد اللغات',
        'كشف النصوص المائلة',
        'استخراج دقيق',
      ],
    },
  };
  
  // ═══════════════════════════════════════════════════════════
  // 📊 الحالة والميزات
  // ═══════════════════════════════════════════════════════════
  
  /// الميزات المتاحة حسب الخدمات المفعّلة
  static Map<String, bool> get availableFeatures => {
    '🤖 تحليل ذكي (DeepSeek)': hasDeepSeek,
    '📝 تصنيف تلقائي': hasDeepSeek,
    '🏷️ وسوم ذكية': hasDeepSeek,
    '📊 استخراج معلومات': hasDeepSeek,
    '☁️ OCR متقدم (Google)': hasGoogleVision,
    '🔍 كشف النصوص': hasGoogleVision,
  };
  
  /// طباعة حالة الخدمات
  static void printStatus() {
    print('═══════════════════════════════════════════════════════');
    print('🤖 حالة خدمات الذكاء الاصطناعي');
    print('═══════════════════════════════════════════════════════');
    print('DeepSeek V3: ${hasDeepSeek ? "✅ مفعّل" : "❌ غير مفعّل"}');
    print('Google Cloud Vision: ${hasGoogleVision ? "✅ مفعّل" : "❌ غير مفعّل"}');
    print('═══════════════════════════════════════════════════════');
    
    if (hasDeepSeek) {
      print('💰 DeepSeek: \$0.001 لكل وثيقة');
    }
    if (hasGoogleVision) {
      print('💰 Google Vision: \$0.0015 لكل وثيقة');
    }
    print('═══════════════════════════════════════════════════════');
  }
  
  // ═══════════════════════════════════════════════════════════
  // 🎨 رسائل للمستخدم
  // ═══════════════════════════════════════════════════════════
  
  /// رسالة عند عدم توفر DeepSeek
  static const String deepseekNotAvailableMessage = '''
🤖 خدمة DeepSeek غير متاحة حالياً

للتفعيل:
1️⃣ سجل في https://platform.deepseek.com
2️⃣ احصل على API Key مجاني
3️⃣ أضفه في إعدادات التطبيق

💰 التكلفة: \$0.001 لكل وثيقة فقط!
📊 الدقة: 90-93%
⚡ السرعة: 5-15 ثانية
''';

  /// رسالة عند عدم توفر Google Vision
  static const String googleVisionNotAvailableMessage = '''
☁️ خدمة Google Cloud Vision غير متاحة

للتفعيل:
1️⃣ افتح https://console.cloud.google.com
2️⃣ فعّل Cloud Vision API
3️⃣ أنشئ API Key
4️⃣ أضفه في إعدادات التطبيق

💰 التكلفة: \$0.0015 لكل وثيقة
📊 الدقة: 95%+
⚡ السرعة: 2-5 ثواني
''';
  
  // ═══════════════════════════════════════════════════════════
  // 🔧 إعدادات المطورين
  // ═══════════════════════════════════════════════════════════
  
  /// تفعيل وضع Debug
  static const bool debugMode = false;
  
  /// تفعيل عرض الأخطاء التفصيلية
  static const bool verboseErrors = false;
  
  /// حفظ الطلبات والاستجابات للتحليل
  static const bool logRequests = false;
}
