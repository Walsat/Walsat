// 📋 ملف مثال - انسخه إلى api_config.dart وأضف مفاتيحك
// 
// خطوات التفعيل:
// 1. انسخ هذا الملف وسمه: api_config.dart
// 2. أضف مفاتيح API الخاصة بك
// 3. لا تشارك api_config.dart أبداً!

class APIConfig {
  // OpenAI API Key
  // احصل عليه من: https://platform.openai.com/api-keys
  static const String openAIKey = 'sk-proj-YOUR_KEY_HERE';
  
  // Google Vision API Key  
  // احصل عليه من: https://console.cloud.google.com
  static const String googleVisionKey = 'YOUR_GOOGLE_KEY_HERE';
  
  // تحقق من وجود المفاتيح
  static bool get hasOpenAI => openAIKey != 'sk-proj-YOUR_KEY_HERE' && openAIKey.isNotEmpty;
  static bool get hasGoogleVision => googleVisionKey != 'YOUR_GOOGLE_KEY_HERE' && googleVisionKey.isNotEmpty;
  
  static void printStatus() {
    print('OpenAI API: ${hasOpenAI ? "✓ Configured" : "✗ Not configured"}');
    print('Google Vision API: ${hasGoogleVision ? "✓ Configured" : "✗ Not configured"}');
  }
}
