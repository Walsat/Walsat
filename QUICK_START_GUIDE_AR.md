# 🚀 دليل البداية السريع - تطبيق أرشيف الوثائق

## 📱 خطوات سريعة للبدء (10 دقائق)

### ✅ المتطلبات

قبل أن تبدأ، تأكد من تثبيت:
1. **Android Studio** - [تحميل من هنا](https://developer.android.com/studio)
2. **Flutter SDK** - [تحميل من هنا](https://docs.flutter.dev/get-started/install)
3. **Git** - [تحميل من هنا](https://git-scm.com/)

---

## 🎯 الخطوات (5 خطوات فقط!)

### 1️⃣ تثبيت الأدوات الأساسية

#### Windows
```cmd
# تحميل وتثبيت Android Studio من الموقع

# تثبيت Flutter
# 1. حمّل Flutter SDK من الموقع
# 2. استخرجه إلى C:\src\flutter
# 3. أضف C:\src\flutter\bin إلى PATH

# تحقق من التثبيت
flutter doctor
```

#### macOS
```bash
# تثبيت Android Studio
brew install --cask android-studio

# تثبيت Flutter
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# تحقق من التثبيت
flutter doctor
```

#### Linux
```bash
# تثبيت Android Studio
sudo snap install android-studio --classic

# تثبيت المتطلبات
sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev

# تثبيت Flutter
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# تحقق من التثبيت
flutter doctor
```

---

### 2️⃣ إعداد Android Studio

```bash
# افتح Android Studio
# اذهب إلى: File → Settings → Plugins (Windows/Linux)
# أو: Android Studio → Preferences → Plugins (macOS)

# ابحث عن "Flutter" وثبّته
# سيتم تثبيت Dart plugin تلقائياً

# أعد تشغيل Android Studio
```

#### قبول التراخيص
```bash
flutter doctor --android-licenses
# اضغط 'y' لكل سؤال
```

---

### 3️⃣ تحميل المشروع

```bash
# Clone من GitHub
git clone https://github.com/Walsat/Walsat.git

# انتقل إلى المجلد
cd Walsat

# تحميل المكتبات
flutter pub get
```

---

### 4️⃣ تشغيل التطبيق

#### على محاكي Android

```bash
# إنشاء محاكي من Android Studio
# Tools → Device Manager → Create Device

# أو من Terminal
flutter emulators
flutter emulators --launch <emulator_name>

# تشغيل التطبيق
flutter run
```

#### على جهاز حقيقي

```bash
# 1. فعّل Developer Options على هاتفك:
#    Settings → About Phone → اضغط "Build Number" 7 مرات

# 2. فعّل USB Debugging:
#    Settings → Developer Options → USB Debugging

# 3. وصّل الهاتف بالكمبيوتر

# 4. تحقق من الاتصال
flutter devices

# 5. شغّل التطبيق
flutter run
```

---

### 5️⃣ بناء APK النهائي

```bash
# بناء APK للإنتاج
flutter build apk --release

# الملف الناتج سيكون في:
# build/app/outputs/flutter-apk/app-release.apk

# انسخه لمكان آخر
cp build/app/outputs/flutter-apk/app-release.apk ~/Desktop/my-app.apk
```

✅ **تم! لديك الآن APK جاهز للتثبيت والتوزيع!**

---

## 🎨 تخصيص سريع

### تغيير اسم التطبيق

افتح `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="اسم تطبيقك هنا"
    ...>
```

### تغيير الأيقونة

استبدل الملفات في:
```
android/app/src/main/res/mipmap-hdpi/ic_launcher.png    (72x72)
android/app/src/main/res/mipmap-mdpi/ic_launcher.png    (48x48)
android/app/src/main/res/mipmap-xhdpi/ic_launcher.png   (96x96)
android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png  (144x144)
android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png (192x192)
```

### تغيير الألوان

افتح `lib/theme/app_colors.dart` وعدّل:
```dart
static const primaryStart = Color(0xFF1565C0);  // لون أساسي
static const secondaryStart = Color(0xFF26A69A); // لون ثانوي
```

---

## 🔧 حل المشاكل السريع

### مشكلة: Flutter command not found
```bash
# أضف Flutter إلى PATH:

# Windows (في CMD كـ Administrator)
setx PATH "%PATH%;C:\src\flutter\bin"

# macOS/Linux
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

### مشكلة: Android licenses not accepted
```bash
flutter doctor --android-licenses
# اضغط 'y' لجميع الأسئلة
```

### مشكلة: Gradle build failed
```bash
# نظّف وأعد البناء
flutter clean
flutter pub get
flutter build apk --release
```

### مشكلة: Device not found
```bash
# أعد تشغيل ADB
adb kill-server
adb start-server

# تحقق من الأجهزة
adb devices
flutter devices
```

---

## 📦 ملفات APK الجاهزة

إذا كنت تريد فقط استخدام التطبيق بدون تعديل:

### الإصدار الأخير: v5.3.3 Build 8

**التحميل المباشر:**
```
https://github.com/Walsat/Walsat/raw/genspark_ai_developer/document-archive-v5.3.3-better-errors.apk
```

**معلومات الملف:**
- 📦 الحجم: 44 MB
- 📅 التاريخ: December 4, 2025
- 🔐 MD5: `61d027b9cbd5ade69013aac063e26743`
- 🎯 الحالة: 🟢 جاهز للإنتاج

**الميزات:**
- ✅ OCR مجاني محلي (بدون API keys!)
- ✅ تحليل AI (DeepSeek/OpenAI - اختياري)
- ✅ واجهة عصرية Material Design 3
- ✅ رسائل خطأ ذكية مع حلول
- ✅ دعم كامل للعربية

---

## 💡 نصائح مهمة

### 1. لا تحتاج API Keys للبدء!
التطبيق يعمل بالكامل بدون أي مفاتيح API:
- **OCR المجاني** يعمل بدون إنترنت
- **قاعدة البيانات المحلية** تخزن كل شيء على الجهاز
- **جميع الميزات الأساسية** متاحة مجاناً

### 2. إضافة AI (اختياري)
إذا أردت ميزات AI المتقدمة لاحقاً:

#### DeepSeek (موصى به - رخيص جداً!)
```dart
// في lib/config/api_config.dart
static const String deepseekKey = 'sk-your-key';
static const String aiProvider = 'deepseek';
```
- التكلفة: $0.001 لكل وثيقة (100 وثيقة = $0.10)
- التسجيل: https://platform.deepseek.com
- 50 مرة أرخص من OpenAI!

#### OpenAI (اختياري)
```dart
// في lib/config/api_config.dart
static const String openAIKey = 'sk-your-key';
static const String aiProvider = 'openai';
```
- التكلفة: $0.05 لكل وثيقة (100 وثيقة = $5)
- دقة أعلى قليلاً: 95%+ vs 90-93%

### 3. حجم APK
- **بناء عادي:** ~44 MB
- **تقليل الحجم:** استخدم `--split-per-abi`
```bash
flutter build apk --split-per-abi
# ستحصل على 3 ملفات أصغر:
# armeabi-v7a: ~20 MB (أجهزة قديمة)
# arm64-v8a: ~22 MB (أجهزة حديثة)
# x86_64: ~24 MB (محاكيات)
```

---

## 📊 مقارنة الإصدارات

| الإصدار | الميزات الرئيسية | الحجم | التاريخ |
|---------|-------------------|-------|---------|
| **v5.3.3** | رسائل خطأ محسّنة | 44 MB | Dec 4, 2025 |
| v5.3.1 | إصلاح DeepSeek | 44 MB | Dec 4, 2025 |
| v5.3.0 | دعم DeepSeek | 44 MB | Dec 4, 2025 |
| v5.2.1 | واجهة عصرية | 44 MB | Dec 4, 2025 |
| v5.2.0 | OCR مجاني | 43 MB | Dec 3, 2025 |

**الإصدار الموصى به:** v5.3.3 ⭐

---

## 🎯 حالات الاستخدام

### للمستخدمين النهائيين
1. حمّل APK الجاهز من GitHub
2. ثبّته على هاتفك
3. استخدم OCR المجاني مباشرة - بدون إعداد!

### للمطورين المبتدئين
1. ثبّت Android Studio + Flutter
2. افتح المشروع في Android Studio
3. اضغط Run (▶️) - سيعمل مباشرة!

### للمطورين المتقدمين
1. عدّل الكود حسب احتياجاتك
2. غيّر الألوان والأيقونات
3. أضف ميزات جديدة
4. ابنِ APK موقّع للنشر

---

## 📚 الوثائق الكاملة

لمزيد من التفاصيل، راجع:
- [دليل Android Studio الشامل](ANDROID_STUDIO_BUILD_GUIDE.md)
- [دليل DeepSeek](DEEPSEEK_INTEGRATION.md)
- [دليل الواجهة العصرية](README_V5.2.1_MODERN_UI.md)
- [دليل OCR المجاني](V5.2.0_FREE_OCR_README.md)
- [دليل رسائل الخطأ](ERROR_MESSAGES_v5.3.3.md)

---

## 🎬 فيديو تعليمي (قريباً)

سنضيف قريباً:
- [ ] فيديو إعداد البيئة (5 دقائق)
- [ ] فيديو بناء أول APK (3 دقائق)
- [ ] فيديو التخصيص الأساسي (7 دقائق)
- [ ] فيديو النشر على Play Store (10 دقائق)

---

## ✅ Checklist السريع

قبل البناء:
- [ ] ثبّتَ Flutter SDK
- [ ] ثبّتَ Android Studio + Flutter Plugin
- [ ] قبلتَ Android licenses
- [ ] فحصتَ `flutter doctor` (كل شيء ✓)

أثناء التطوير:
- [ ] نفّذتَ `flutter pub get`
- [ ] شغّلتَ التطبيق على محاكي/جهاز
- [ ] اختبرتَ الميزات الأساسية

للنشر:
- [ ] غيّرتَ اسم التطبيق (اختياري)
- [ ] غيّرتَ الأيقونة (اختياري)
- [ ] بنيتَ APK موقّع
- [ ] اختبرتَ APK على جهاز نظيف

---

## 💬 الدعم والمساعدة

### أسئلة شائعة

**س: هل أحتاج macOS لبناء التطبيق؟**
ج: لا! التطبيق Android فقط - يعمل على Windows/Linux/macOS

**س: هل أحتاج API keys للبدء؟**
ج: لا! OCR المجاني يعمل بدون أي إعداد

**س: ما هو أرخص خيار AI؟**
ج: DeepSeek - 50 مرة أرخص من OpenAI ($0.10 vs $5 لـ 100 وثيقة)

**س: كيف أنشر على Play Store؟**
ج: راجع قسم "توزيع التطبيق" في [الدليل الشامل](ANDROID_STUDIO_BUILD_GUIDE.md)

**س: هل يمكنني تعديل الكود؟**
ج: نعم! المشروع مفتوح المصدر - عدّل كما تشاء

---

## 🚀 ابدأ الآن!

```bash
# خطوة واحدة للبدء:
git clone https://github.com/Walsat/Walsat.git
cd Walsat
flutter pub get
flutter run

# 🎉 التطبيق يعمل!
```

---

**بُني بـ ❤️ من العراق 🇮🇶**
**آخر تحديث: December 4, 2025**
**الإصدار: v5.3.3**
**الحالة: 🟢 جاهز للاستخدام**
