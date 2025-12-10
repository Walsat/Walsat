# 📱 دليل بناء التطبيق على Android Studio

## 🎯 نظرة عامة

هذا الدليل الشامل يشرح كيفية بناء تطبيق أرشيف الوثائق على Android Studio من الصفر.

---

## 📋 المتطلبات الأساسية

### 1. تثبيت Android Studio

#### Windows
1. قم بتحميل Android Studio من:
   ```
   https://developer.android.com/studio
   ```

2. قم بتشغيل المثبت واتبع التعليمات

3. اختر التثبيت القياسي (Standard Installation)

4. انتظر حتى يتم تحميل SDK Components

#### macOS
```bash
# باستخدام Homebrew
brew install --cask android-studio

# أو قم بالتحميل المباشر من الموقع الرسمي
```

#### Linux (Ubuntu/Debian)
```bash
sudo snap install android-studio --classic

# أو باستخدام apt
sudo apt-add-repository ppa:maarten-fonville/android-studio
sudo apt update
sudo apt install android-studio
```

---

### 2. تثبيت Flutter SDK

#### Windows
1. قم بتحميل Flutter SDK:
   ```
   https://docs.flutter.dev/get-started/install/windows
   ```

2. استخرج الملف إلى مكان مناسب (مثلاً: `C:\src\flutter`)

3. أضف Flutter إلى PATH:
   - افتح System Environment Variables
   - أضف `C:\src\flutter\bin` إلى Path

4. تحقق من التثبيت:
   ```cmd
   flutter doctor
   ```

#### macOS
```bash
# قم بتحميل Flutter SDK
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# أضف إلى PATH في ~/.zshrc أو ~/.bash_profile
export PATH="$PATH:$HOME/development/flutter/bin"

# طبّق التغييرات
source ~/.zshrc  # أو source ~/.bash_profile

# تحقق من التثبيت
flutter doctor
```

#### Linux
```bash
# قم بتحميل Flutter SDK
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# أضف إلى PATH في ~/.bashrc
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# تثبيت المتطلبات
sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev

# تحقق من التثبيت
flutter doctor
```

---

### 3. إعداد Android Studio للعمل مع Flutter

#### خطوة 1: تثبيت Flutter Plugin
1. افتح Android Studio
2. اذهب إلى:
   - **Windows/Linux:** `File` → `Settings` → `Plugins`
   - **macOS:** `Android Studio` → `Preferences` → `Plugins`

3. ابحث عن "Flutter"
4. اضغط "Install"
5. سيتم تثبيت Dart plugin تلقائياً
6. أعد تشغيل Android Studio

#### خطوة 2: تكوين Flutter SDK Path
1. اذهب إلى Settings/Preferences
2. ابحث عن "Flutter"
3. قم بتحديد مسار Flutter SDK:
   - **Windows:** `C:\src\flutter`
   - **macOS/Linux:** `~/development/flutter`

---

### 4. إعداد Android SDK

#### في Android Studio
1. اذهب إلى:
   - `Tools` → `SDK Manager`

2. تحقق من تثبيت:
   - ✅ Android SDK Platform (أحدث إصدار)
   - ✅ Android SDK Build-Tools
   - ✅ Android SDK Platform-Tools
   - ✅ Android SDK Command-line Tools

3. في تبويب "SDK Tools"، تحقق من:
   - ✅ Android SDK Build-Tools
   - ✅ Android Emulator
   - ✅ Android SDK Platform-Tools

4. اضغط "Apply" لتحميل المكونات الناقصة

#### تكوين المتغيرات البيئية

**Windows:**
```cmd
setx ANDROID_HOME "C:\Users\[YourUsername]\AppData\Local\Android\Sdk"
setx PATH "%PATH%;%ANDROID_HOME%\tools;%ANDROID_HOME%\platform-tools"
```

**macOS/Linux:**
```bash
# أضف إلى ~/.bashrc أو ~/.zshrc
export ANDROID_HOME=$HOME/Library/Android/sdk  # macOS
# أو
export ANDROID_HOME=$HOME/Android/Sdk  # Linux

export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

---

### 5. التحقق من الإعداد

قم بتشغيل:
```bash
flutter doctor -v
```

يجب أن ترى:
```
✅ Flutter (Channel stable, version X.X.X)
✅ Android toolchain - develop for Android devices
✅ Android Studio (version X.X)
✅ Connected device
```

إذا كان هناك مشاكل:
```bash
# قبول تراخيص Android
flutter doctor --android-licenses

# تحديث Flutter
flutter upgrade
```

---

## 📂 استيراد المشروع

### الطريقة 1: Clone من GitHub

```bash
# Clone المشروع
git clone https://github.com/Walsat/Walsat.git

# انتقل إلى المجلد
cd Walsat

# تبديل إلى فرع التطوير (اختياري)
git checkout genspark_ai_developer

# تحميل المكتبات
flutter pub get
```

### الطريقة 2: فتح من Android Studio

1. افتح Android Studio
2. اختر `File` → `Open`
3. حدد مجلد المشروع
4. انتظر حتى يتم تحميل المشروع
5. سيقوم Flutter بتحميل المكتبات تلقائياً

---

## 🔧 إعداد المشروع

### 1. تحديث المكتبات

```bash
# في terminal المشروع
cd /path/to/Walsat

# تحميل المكتبات
flutter pub get

# في حال وجود مشاكل
flutter clean
flutter pub get
```

### 2. إعداد API Keys (اختياري)

إذا كنت تريد استخدام AI Features:

#### OpenAI API (اختياري)
1. افتح `lib/config/api_config.dart`
2. أضف مفتاحك:
```dart
static const String openAIKey = 'sk-your-openai-key-here';
```

#### DeepSeek API (موصى به - أرخص 50 مرة!)
1. سجل في: https://platform.deepseek.com
2. احصل على API key مجاني
3. أضف في `lib/config/api_config.dart`:
```dart
static const String deepseekKey = 'sk-your-deepseek-key-here';
static const String aiProvider = 'deepseek';  // استخدم DeepSeek بدلاً من OpenAI
```

#### Google Vision API (اختياري)
1. افتح `lib/config/api_config.dart`
2. أضف مفتاحك:
```dart
static const String googleVisionKey = 'your-google-vision-key-here';
```

**ملاحظة:** التطبيق يعمل بدون API keys باستخدام **OCR المجاني المدمج**!

---

### 3. بناء Hive Models (إذا لزم الأمر)

```bash
# إذا عدلت Models، قم بتشغيل:
flutter packages pub run build_runner build --delete-conflicting-outputs
```

---

## 🏗️ بناء التطبيق

### بناء APK للاختبار (Debug)

```bash
# APK للاختبار فقط
flutter build apk --debug

# الملف سيكون في:
# build/app/outputs/flutter-apk/app-debug.apk
```

### بناء APK للإنتاج (Release)

```bash
# APK محسّن للإنتاج
flutter build apk --release

# الملف سيكون في:
# build/app/outputs/flutter-apk/app-release.apk
```

### بناء App Bundle للـ Google Play Store

```bash
# App Bundle (AAB) - أفضل لـ Play Store
flutter build appbundle --release

# الملف سيكون في:
# build/app/outputs/bundle/release/app-release.aab
```

### بناء Split APKs (أحجام أصغر)

```bash
# بناء APKs منفصلة لكل معمارية
flutter build apk --split-per-abi

# ستحصل على:
# app-armeabi-v7a-release.apk  (للأجهزة القديمة)
# app-arm64-v8a-release.apk    (للأجهزة الحديثة)
# app-x86_64-release.apk       (للمحاكيات)
```

---

## 🔑 توقيع التطبيق (App Signing)

### إنشاء Keystore

```bash
# Windows
keytool -genkey -v -keystore C:\Users\[YourUsername]\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# macOS/Linux
keytool -genkey -v -keystore ~/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

ستُسأل عن:
- اسم المطور
- المنظمة
- المدينة/البلد
- كلمة مرور الـ keystore (احفظها!)

### إعداد Gradle للتوقيع

#### 1. إنشاء ملف key.properties

قم بإنشاء ملف `android/key.properties`:
```properties
storePassword=your-keystore-password
keyPassword=your-key-password
keyAlias=upload
storeFile=C:/Users/YourUsername/upload-keystore.jks
# أو على macOS/Linux:
# storeFile=/Users/YourUsername/upload-keystore.jks
```

⚠️ **هام:** أضف `key.properties` إلى `.gitignore`!

#### 2. تعديل build.gradle

افتح `android/app/build.gradle` وأضف قبل `android {`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ...
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

### بناء APK موقّع

```bash
flutter build apk --release
# أو
flutter build appbundle --release
```

الآن التطبيق موقّع وجاهز للنشر!

---

## 🚀 تشغيل التطبيق

### على جهاز حقيقي

1. فعّل Developer Options على الهاتف:
   - Settings → About Phone
   - اضغط على "Build Number" 7 مرات

2. فعّل USB Debugging:
   - Settings → Developer Options → USB Debugging

3. وصّل الهاتف بالكمبيوتر

4. قم بتشغيل:
```bash
# تحقق من اتصال الجهاز
flutter devices

# شغّل التطبيق
flutter run
```

### على المحاكي (Emulator)

#### إنشاء محاكي في Android Studio
1. افتح `Tools` → `Device Manager`
2. اضغط "Create Device"
3. اختر جهاز (مثلاً: Pixel 6)
4. اختر System Image (API 33 موصى به)
5. اضغط "Finish"
6. شغّل المحاكي

#### تشغيل التطبيق على المحاكي
```bash
# تحقق من المحاكيات المتاحة
flutter emulators

# شغّل محاكي معين
flutter emulators --launch Pixel_6_API_33

# شغّل التطبيق
flutter run
```

---

## 🎨 تخصيص التطبيق

### تغيير اسم التطبيق

#### Android
افتح `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="اسم التطبيق الجديد"
    ...>
```

#### iOS (إذا كنت تريد دعم iOS لاحقاً)
افتح `ios/Runner/Info.plist`:
```xml
<key>CFBundleName</key>
<string>اسم التطبيق الجديد</string>
```

### تغيير Package Name

⚠️ **هذا معقد - استخدم أداة مساعدة:**

```bash
# تثبيت الأداة
flutter pub global activate rename

# تغيير اسم الحزمة
flutter pub global run rename --bundleId com.yourcompany.yourapp
```

### تغيير الأيقونة

الأيقونة الحالية موجودة في:
```
android/app/src/main/res/mipmap-hdpi/ic_launcher.png
android/app/src/main/res/mipmap-mdpi/ic_launcher.png
android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
```

أو استخدم أداة تلقائية:
```bash
# تثبيت flutter_launcher_icons
flutter pub add dev:flutter_launcher_icons

# أنشئ pubspec.yaml config
flutter_icons:
  android: true
  image_path: "assets/icon/icon.png"

# قم بتوليد الأيقونات
flutter pub run flutter_launcher_icons
```

---

## 📊 تحسين الأداء

### 1. تمكين Obfuscation (تشويش الكود)

```bash
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

### 2. تقليل حجم APK

في `android/app/build.gradle`:
```gradle
android {
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

### 3. تحليل حجم APK

```bash
flutter build apk --analyze-size
```

---

## 🐛 حل المشاكل الشائعة

### مشكلة: Flutter SDK not found
```bash
# تأكد من PATH
echo $PATH  # Linux/Mac
echo %PATH%  # Windows

# أعد تشغيل Terminal/IDE
```

### مشكلة: Android licenses not accepted
```bash
flutter doctor --android-licenses
# اضغط 'y' لقبول جميع التراخيص
```

### مشكلة: Gradle build failed
```bash
# نظف المشروع
cd android
./gradlew clean  # Linux/Mac
gradlew.bat clean  # Windows

# أو من Flutter
cd ..
flutter clean
flutter pub get
```

### مشكلة: Unable to locate Android SDK
```bash
# حدد مسار SDK يدوياً
flutter config --android-sdk /path/to/android/sdk
```

### مشكلة: Device not showing
```bash
# أعد تشغيل ADB
adb kill-server
adb start-server
adb devices

# تأكد من USB Debugging مفعّل
```

### مشكلة: Build fails with "Kotlin version"
في `android/build.gradle`:
```gradle
buildscript {
    ext.kotlin_version = '1.7.10'  // حدّث إلى أحدث إصدار
    // ...
}
```

### مشكلة: Out of memory during build
في `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError
```

---

## 📦 توزيع التطبيق

### 1. التوزيع المباشر (Direct Distribution)

```bash
# بناء APK موقّع
flutter build apk --release

# شارك الملف:
# build/app/outputs/flutter-apk/app-release.apk
```

المستخدمون يحتاجون إلى:
1. تحميل APK
2. تفعيل "Install from Unknown Sources"
3. تثبيت التطبيق

### 2. Google Play Store

#### متطلبات النشر
- ✅ حساب Google Play Console ($25 رسوم مرة واحدة)
- ✅ App Bundle موقّع (.aab)
- ✅ أيقونة التطبيق (512x512 px)
- ✅ Screenshots (على الأقل 2)
- ✅ وصف التطبيق
- ✅ Privacy Policy

#### خطوات النشر
```bash
# بناء App Bundle
flutter build appbundle --release

# الملف سيكون في:
# build/app/outputs/bundle/release/app-release.aab
```

1. اذهب إلى: https://play.google.com/console
2. أنشئ تطبيق جديد
3. ارفع `app-release.aab`
4. املأ معلومات المتجر
5. قدّم للمراجعة

---

## 🎯 الخطوات السريعة (Quick Start)

### للمطورين المستعجلين 🚀

```bash
# 1. تأكد من التثبيت
flutter doctor

# 2. Clone المشروع
git clone https://github.com/Walsat/Walsat.git
cd Walsat

# 3. تحميل المكتبات
flutter pub get

# 4. شغّل على محاكي/جهاز
flutter run

# 5. بناء APK للإنتاج
flutter build apk --release

# ✅ الملف الناتج:
# build/app/outputs/flutter-apk/app-release.apk
```

---

## 📚 موارد إضافية

### الوثائق الرسمية
- [Flutter Documentation](https://docs.flutter.dev/)
- [Android Developer Guide](https://developer.android.com/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

### دروس فيديو مفيدة
- [Flutter Crash Course](https://www.youtube.com/flutter)
- [Android Studio Setup](https://www.youtube.com/c/AndroidDevelopers)

### مجتمع المطورين
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow - Flutter Tag](https://stackoverflow.com/questions/tagged/flutter)
- [r/FlutterDev Reddit](https://www.reddit.com/r/FlutterDev/)

---

## 🔐 معلومات المشروع

### تفاصيل التطبيق الحالي
- **اسم التطبيق:** Document Archive - أرشيف الوثائق
- **Package Name:** `com.example.document_archive`
- **Current Version:** 5.3.3+8
- **Min SDK:** 21 (Android 5.0)
- **Target SDK:** 33 (Android 13)
- **Size:** ~44 MB

### الميزات المتاحة
- ✅ OCR مجاني محلي (Google ML Kit)
- ✅ تحليل AI (OpenAI/DeepSeek - اختياري)
- ✅ قاعدة بيانات محلية (Hive)
- ✅ واجهة Material Design 3
- ✅ دعم اللغة العربية
- ✅ رسائل خطأ ذكية مع حلول

---

## ✅ Checklist قبل النشر

- [ ] اختبر التطبيق على أجهزة مختلفة
- [ ] تأكد من الأيقونة بجميع الأحجام
- [ ] راجع الأذونات في AndroidManifest.xml
- [ ] أضف Privacy Policy (إذا لزم)
- [ ] حدّث رقم الإصدار في pubspec.yaml
- [ ] وقّع APK بـ keystore صحيح
- [ ] اختبر APK الموقّع على جهاز نظيف
- [ ] جهّز Screenshots للمتجر
- [ ] اكتب وصف جذاب للتطبيق

---

## 📞 الدعم

إذا واجهت مشاكل:
1. راجع قسم "حل المشاكل الشائعة" أعلاه
2. شغّل `flutter doctor -v` وشارك النتائج
3. تحقق من GitHub Issues
4. اسأل في مجتمع Flutter

---

**بُني بـ ❤️ باستخدام Flutter**
**آخر تحديث: December 4, 2025**
**الإصدار: v5.3.3 Build 8**
**الحالة: 🟢 جاهز للإنتاج**
