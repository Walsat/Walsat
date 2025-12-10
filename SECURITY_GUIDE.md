# 🔐 دليل الأمان - حماية مفاتيح API

## ⚠️ مهم جداً!

**لا تشارك مفاتيح API أبداً!** هذا يمكن أن يؤدي إلى:
- 💸 استنزاف رصيدك
- 🚨 سرقة حسابك
- 📊 الوصول إلى بياناتك
- 🔓 استخدام غير مصرح

---

## 🚨 إذا شاركت مفتاحك بالخطأ

### الخطوات الفورية:

1. **ألغِ المفتاح فوراً:**
   ```
   OpenAI: https://platform.openai.com/api-keys
   Google: https://console.cloud.google.com/apis/credentials
   ```

2. **تحقق من الاستخدام:**
   ```
   OpenAI: Settings → Usage
   Google: Billing → Reports
   ```

3. **أنشئ مفتاحاً جديداً:**
   - استخدم اسماً وصفياً
   - فعّل القيود
   - احفظه بأمان

4. **فعّل القيود الأمنية:**
   - حدد ميزانية شهرية
   - فعّل تنبيهات البريد
   - حدد الخدمات المسموحة

---

## ✅ الطريقة الصحيحة لحفظ المفاتيح

### في التطبيق:

1. **انسخ ملف المثال:**
   ```bash
   cp lib/config/api_config.example.dart lib/config/api_config.dart
   ```

2. **أضف مفاتيحك:**
   ```dart
   class APIConfig {
     static const String openAIKey = 'YOUR_ACTUAL_KEY_HERE';
     static const String googleVisionKey = 'YOUR_ACTUAL_KEY_HERE';
   }
   ```

3. **تأكد من .gitignore:**
   ```
   lib/config/api_config.dart
   ```

4. **لا ترفع المفاتيح لـ Git:**
   ```bash
   git status  # تأكد أن api_config.dart غير ظاهر
   ```

---

## 🔒 أفضل الممارسات

### 1. استخدم متغيرات البيئة

بدلاً من وضع المفاتيح في الكود:

```dart
// ❌ خطأ - لا تفعل هذا
const apiKey = 'sk-proj-abc123...';

// ✅ صحيح - استخدم متغيرات البيئة
final apiKey = Platform.environment['OPENAI_API_KEY'] ?? '';
```

### 2. فعّل القيود

**OpenAI:**
```
Settings → Limits:
- Monthly budget: $10
- Per request: $0.50
- Email alerts: enabled
```

**Google Cloud:**
```
APIs & Services → Quotas:
- Daily requests: 1000
- Per minute: 60
- Budget alerts: enabled
```

### 3. استخدم مفاتيح مختلفة للبيئات

```dart
class APIConfig {
  static bool get isProduction => bool.fromEnvironment('dart.vm.product');
  
  static String get openAIKey {
    return isProduction 
      ? 'PRODUCTION_KEY'  // مفتاح الإنتاج
      : 'DEVELOPMENT_KEY'; // مفتاح التطوير
  }
}
```

### 4. راقب الاستخدام

تحقق يومياً من:
- 📊 عدد الطلبات
- 💰 التكلفة
- 🚨 أي نشاط غير عادي

---

## 📱 للمستخدمين النهائيين

### كيفية إضافة مفتاح API في التطبيق:

1. **افتح التطبيق**
2. **اذهب إلى الإعدادات** ⚙️
3. **اضغط "تكوين الذكاء الاصطناعي"**
4. **أدخل مفتاح OpenAI:**
   - الصق مفتاحك
   - لا تشاركه مع أحد
5. **أو أدخل مفتاح Google Vision**
6. **احفظ**

### الأمان في التطبيق:

✅ المفاتيح محفوظة محلياً فقط  
✅ لا ترسل لأي خادم  
✅ يمكن حذفها في أي وقت  
✅ محمية بتشفير الجهاز  

---

## 🛡️ الحماية من السرقة

### استخدم IP Whitelisting:

**OpenAI:**
```
لا يدعم حالياً
استخدم القيود الأخرى
```

**Google Cloud:**
```
APIs & Services → Credentials:
- API restrictions: Vision API only
- Application restrictions: IP addresses
- Add your IPs
```

### استخدم Referrer Restrictions:

للتطبيقات على الويب:
```
Restrict key to these referrer URLs:
- https://yourdomain.com/*
- https://www.yourdomain.com/*
```

---

## 💰 تقدير التكاليف

### OpenAI GPT-4 Vision:

| الاستخدام | التكلفة التقريبية |
|-----------|-------------------|
| 10 وثائق/يوم | ~$0.10/يوم = $3/شهر |
| 50 وثيقة/يوم | ~$0.50/يوم = $15/شهر |
| 100 وثيقة/يوم | ~$1/يوم = $30/شهر |

### Google Vision OCR:

| الاستخدام | التكلفة |
|-----------|---------|
| أول 1000 صورة | مجاناً |
| 1001-5000 صورة | $1.50/1000 |
| 5001+ صورة | $0.60/1000 |

---

## 📞 الدعم

### إذا واجهت مشكلة أمنية:

1. **أوقف المفتاح فوراً**
2. **اتصل بالدعم:**
   - OpenAI: help.openai.com
   - Google: support.google.com/cloud
3. **أبلغ عن أي نشاط مشبوه**
4. **غيّر كلمة المرور**

---

## 📋 Checklist أمان

قبل استخدام التطبيق:

- [ ] حصلت على مفتاح API
- [ ] أضفته في ملف آمن (api_config.dart)
- [ ] تأكدت من .gitignore
- [ ] فعّلت القيود الأمنية
- [ ] ضبطت الميزانية
- [ ] فعّلت التنبيهات
- [ ] قرأت شروط الاستخدام

---

## ⚡ نصائح سريعة

### ✅ افعل:
- استخدم مفاتيح مختلفة للتطوير والإنتاج
- فعّل جميع القيود الأمنية
- راقب الاستخدام يومياً
- احتفظ بنسخة احتياطية من المفاتيح في مكان آمن

### ❌ لا تفعل:
- تشارك المفاتيح في GitHub
- تضع المفاتيح في الكود مباشرة
- تشارك المفاتيح مع أحد
- تنسى مراقبة الاستخدام
- تترك القيود معطلة

---

## 🎓 تعلم المزيد

### موارد مفيدة:

**OpenAI:**
- Best Practices: https://platform.openai.com/docs/guides/production-best-practices
- Rate Limits: https://platform.openai.com/docs/guides/rate-limits

**Google Cloud:**
- Security Best Practices: https://cloud.google.com/security/best-practices
- IAM Policies: https://cloud.google.com/iam/docs/policies

---

## 🔐 الخلاصة

**تذكر دائماً:**

1. 🔑 المفاتيح = كلمات مرور
2. 🚫 لا تشاركها أبداً
3. ✅ استخدم .gitignore
4. 📊 راقب الاستخدام
5. 💰 فعّل القيود

**حافظ على أمان مفاتيحك! 🛡️**

---

**آخر تحديث:** 2025-12-04
