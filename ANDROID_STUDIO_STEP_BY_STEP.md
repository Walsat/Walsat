# 📱 دليل Android Studio خطوة بخطوة (مع صور توضيحية)

## 🎯 المحتويات

1. [تثبيت Android Studio](#1-تثبيت-android-studio)
2. [إعداد Android Studio الأول](#2-إعداد-android-studio-الأول)
3. [تثبيت Flutter Plugin](#3-تثبيت-flutter-plugin)
4. [إعداد Flutter SDK](#4-إعداد-flutter-sdk)
5. [فتح المشروع](#5-فتح-المشروع)
6. [إعداد المحاكي](#6-إعداد-المحاكي)
7. [تشغيل التطبيق](#7-تشغيل-التطبيق)
8. [بناء APK](#8-بناء-apk)

---

## 1. تثبيت Android Studio

### Windows

#### الخطوة 1-1: تحميل المثبت
```
🌐 اذهب إلى: https://developer.android.com/studio
📥 اضغط "Download Android Studio"
💾 احفظ الملف (حوالي 1 GB)
```

#### الخطوة 1-2: تشغيل المثبت
```
📂 افتح الملف المحمّل: android-studio-XXX-windows.exe
👤 اضغط "Next" في جميع الخطوات
✅ اقبل الشروط والأحكام
📍 اختر مكان التثبيت (الافتراضي جيد)
⏳ انتظر انتهاء التثبيت (5-10 دقائق)
🚀 اضغط "Finish"
```

### macOS

#### الخطوة 1-1: تحميل DMG
```
🌐 اذهب إلى: https://developer.android.com/studio
📥 اضغط "Download Android Studio"
💾 احفظ ملف .dmg
```

#### الخطوة 1-2: التثبيت
```
📂 افتح ملف .dmg المحمّل
🖱️ اسحب Android Studio إلى مجلد Applications
⏳ انتظر النسخ
✅ افتح Android Studio من Applications
```

### Linux (Ubuntu/Debian)

#### الخطوة 1-1: باستخدام Snap
```bash
# افتح Terminal واكتب:
sudo snap install android-studio --classic

# انتظر حتى ينتهي التثبيت
# افتح Android Studio:
android-studio
```

#### الخطوة 1-2: أو باستخدام Tar.gz
```bash
# حمّل من الموقع الرسمي
cd ~/Downloads
tar -xvf android-studio-XXX-linux.tar.gz
sudo mv android-studio /opt/
/opt/android-studio/bin/studio.sh
```

---

## 2. إعداد Android Studio الأول

### الخطوة 2-1: شاشة الترحيب

عند فتح Android Studio لأول مرة:

```
╔════════════════════════════════════╗
║   Welcome to Android Studio        ║
║                                    ║
║   [Previous project not found]     ║
║                                    ║
║   ┌──────────────────────────┐     ║
║   │  [  Next  ]              │     ║
║   └──────────────────────────┘     ║
╚════════════════════════════════════╝
```

✅ **اضغط "Next"**

### الخطوة 2-2: نوع التثبيت

```
╔════════════════════════════════════╗
║   Install Type                     ║
║                                    ║
║   ⦿ Standard (Recommended)         ║
║   ○ Custom                         ║
║                                    ║
║   Standard setup includes:         ║
║   • Android SDK                    ║
║   • Android SDK Platform           ║
║   • Android Virtual Device         ║
║                                    ║
║   ┌──────────────────────────┐     ║
║   │  [  Next  ]              │     ║
║   └──────────────────────────┘     ║
╚════════════════════════════════════╝
```

✅ **اختر "Standard" واضغط "Next"**

### الخطوة 2-3: اختيار المظهر

```
╔════════════════════════════════════╗
║   Select UI Theme                  ║
║                                    ║
║   ○ Light (IntelliJ)              ║
║   ⦿ Dark (Darcula)                ║
║                                    ║
║   [Screenshot of dark theme]       ║
║                                    ║
║   ┌──────────────────────────┐     ║
║   │  [  Next  ]              │     ║
║   └──────────────────────────┘     ║
╚════════════════════════════════════╝
```

✅ **اختر "Dark" (أسهل للعيون) واضغط "Next"**

### الخطوة 2-4: تحميل المكونات

```
╔════════════════════════════════════╗
║   Downloading Components           ║
║                                    ║
║   Android SDK Platform-Tools       ║
║   ▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░  65%       ║
║                                    ║
║   Android SDK Build-Tools          ║
║   ▓▓▓▓▓▓░░░░░░░░░░░░░░  32%       ║
║                                    ║
║   ⏳ This may take several minutes ║
║                                    ║
╚════════════════════════════════════╝
```

⏳ **انتظر حتى تكتمل التحميلات (10-20 دقيقة)**

### الخطوة 2-5: النهاية

```
╔════════════════════════════════════╗
║   Setup Complete                   ║
║                                    ║
║   ✓ Android SDK installed          ║
║   ✓ Platform tools ready           ║
║   ✓ Build tools configured         ║
║                                    ║
║   ┌──────────────────────────┐     ║
║   │  [  Finish  ]            │     ║
║   └──────────────────────────┘     ║
╚════════════════════════════════════╝
```

✅ **اضغط "Finish"**

---

## 3. تثبيت Flutter Plugin

### الخطوة 3-1: فتح Plugins

من شاشة Android Studio الرئيسية:

**Windows/Linux:**
```
File → Settings → Plugins
```

**macOS:**
```
Android Studio → Preferences → Plugins
```

أو:
```
╔════════════════════════════════════╗
║   Welcome to Android Studio        ║
║                                    ║
║   • New Project                    ║
║   • Open Project                   ║
║   ➜ Configure                      ║
║     └─ Plugins                     ║
║   • Get from VCS                   ║
║                                    ║
╚════════════════════════════════════╝
```

✅ **اضغط Configure → Plugins**

### الخطوة 3-2: البحث عن Flutter

```
╔════════════════════════════════════════════════╗
║  Plugins                                       ║
║  ┌───────────────────────────────────────┐    ║
║  │ 🔍 Search: [flutter____________]      │    ║
║  └───────────────────────────────────────┘    ║
║                                                ║
║  Marketplace                                   ║
║  ┌──────────────────────────────────────┐     ║
║  │                                      │     ║
║  │  Flutter                            │     ║
║  │  ⭐⭐⭐⭐⭐ (1.2M downloads)           │     ║
║  │  Enables Flutter development        │     ║
║  │                                     │     ║
║  │  [   Install   ]                    │     ║
║  │                                     │     ║
║  │  ─────────────────────────────────  │     ║
║  │                                     │     ║
║  │  Dart                               │     ║
║  │  Will be installed automatically    │     ║
║  │                                     │     ║
║  └──────────────────────────────────────┘     ║
╚════════════════════════════════════════════════╝
```

✅ **اضغط "Install" على Flutter plugin**

### الخطوة 3-3: تثبيت Dart (تلقائي)

```
╔════════════════════════════════════╗
║   Third-party Plugins Privacy      ║
║                                    ║
║   Flutter plugin requires:         ║
║   • Dart plugin                    ║
║                                    ║
║   Do you want to continue?         ║
║                                    ║
║   [  Cancel  ]  [  Accept  ]       ║
╚════════════════════════════════════╝
```

✅ **اضغط "Accept"**

### الخطوة 3-4: إعادة التشغيل

```
╔════════════════════════════════════╗
║   Restart Required                 ║
║                                    ║
║   Flutter plugin has been          ║
║   installed successfully.          ║
║                                    ║
║   Restart Android Studio to        ║
║   activate the plugin?             ║
║                                    ║
║   [  Later  ]  [  Restart  ]       ║
╚════════════════════════════════════╝
```

✅ **اضغط "Restart"**

---

## 4. إعداد Flutter SDK

### الخطوة 4-1: تحميل Flutter SDK

#### Windows
```powershell
# افتح PowerShell واكتب:
cd C:\
mkdir src
cd src
git clone https://github.com/flutter/flutter.git -b stable

# أو حمّل ZIP من:
# https://docs.flutter.dev/get-started/install/windows
```

#### macOS/Linux
```bash
# افتح Terminal واكتب:
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable
```

### الخطوة 4-2: إضافة إلى PATH

#### Windows
```
1. اضغط Win + X
2. اختر "System"
3. اضغط "Advanced system settings"
4. اضغط "Environment Variables"
5. في "User variables"، اختر "Path"
6. اضغط "Edit"
7. اضغط "New"
8. أضف: C:\src\flutter\bin
9. اضغط "OK" على جميع النوافذ
```

#### macOS/Linux
```bash
# افتح Terminal واكتب:

# لـ Bash (Linux):
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# لـ Zsh (macOS):
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

### الخطوة 4-3: التحقق من التثبيت

```bash
# افتح Terminal/PowerShell جديد واكتب:
flutter doctor

# يجب أن ترى:
```

```
╔═══════════════════════════════════════════════╗
║  Doctor summary (to see all details, run      ║
║  flutter doctor -v):                          ║
║                                               ║
║  [✓] Flutter (Channel stable, 3.x.x)         ║
║  [✗] Android toolchain                        ║
║      ! Some Android licenses not accepted     ║
║  [✓] Android Studio (version 202X.X)          ║
║  [!] Connected device                         ║
║      ! No devices available                   ║
║                                               ║
╚═══════════════════════════════════════════════╝
```

### الخطوة 4-4: قبول التراخيص

```bash
flutter doctor --android-licenses

# ستظهر رسائل مثل:
```

```
Review licenses that have not been accepted (y/N)? y
```

✅ **اكتب "y" واضغط Enter لكل سؤال**

### الخطوة 4-5: إعادة التحقق

```bash
flutter doctor

# الآن يجب أن ترى:
```

```
╔═══════════════════════════════════════════════╗
║  [✓] Flutter (Channel stable, 3.x.x)         ║
║  [✓] Android toolchain                        ║
║  [✓] Android Studio (version 202X.X)          ║
║  [!] Connected device (no devices)            ║
╚═══════════════════════════════════════════════╝
```

✅ **جيد! كل شيء جاهز**

---

## 5. فتح المشروع

### الخطوة 5-1: Clone المشروع

```bash
# افتح Terminal/PowerShell واكتب:
cd ~/Desktop  # أو أي مكان تريده
git clone https://github.com/Walsat/Walsat.git
cd Walsat
```

### الخطوة 5-2: فتح في Android Studio

من Android Studio:

```
╔════════════════════════════════════╗
║   Welcome to Android Studio        ║
║                                    ║
║   • New Project                    ║
║   ➜ Open                           ║
║   • Get from VCS                   ║
║                                    ║
╚════════════════════════════════════╝
```

✅ **اضغط "Open"**

### الخطوة 5-3: اختيار المجلد

```
╔════════════════════════════════════╗
║   Open File or Project             ║
║                                    ║
║   📁 Desktop                       ║
║     📁 Walsat  ← اختر هذا         ║
║       📄 pubspec.yaml              ║
║       📁 lib                       ║
║       📁 android                   ║
║       📁 ios                       ║
║                                    ║
║   [  Cancel  ]  [    OK    ]       ║
╚════════════════════════════════════╝
```

✅ **اختر مجلد "Walsat" واضغط "OK"**

### الخطوة 5-4: تحميل المكتبات

سيظهر شريط في الأسفل:

```
╔════════════════════════════════════╗
║  Flutter commands                  ║
║  ▓▓▓▓▓▓▓▓░░░░░░░░░░  45%          ║
║  Running 'flutter pub get'...      ║
╚════════════════════════════════════╝
```

⏳ **انتظر حتى ينتهي (2-5 دقائق)**

### الخطوة 5-5: المشروع جاهز!

```
╔════════════════════════════════════╗
║  Project: Walsat                   ║
║  ├─ 📁 android                     ║
║  ├─ 📁 ios                         ║
║  ├─ 📁 lib                         ║
║  │  ├─ 📁 config                   ║
║  │  ├─ 📁 models                   ║
║  │  ├─ 📁 screens                  ║
║  │  ├─ 📁 services                 ║
║  │  └─ 📄 main.dart                ║
║  ├─ 📁 test                        ║
║  └─ 📄 pubspec.yaml                ║
╚════════════════════════════════════╝
```

✅ **المشروع مفتوح وجاهز!**

---

## 6. إعداد المحاكي

### الخطوة 6-1: فتح Device Manager

في Android Studio:

```
Tools → Device Manager
```

أو اضغط على الأيقونة:
```
┌─────────────────────────────┐
│  📱  Device Manager          │
└─────────────────────────────┘
```

### الخطوة 6-2: إنشاء محاكي جديد

```
╔════════════════════════════════════╗
║   Device Manager                   ║
║                                    ║
║   No devices                       ║
║                                    ║
║   ┌──────────────────────────┐     ║
║   │  [  Create Device  ]     │     ║
║   └──────────────────────────┘     ║
╚════════════════════════════════════╝
```

✅ **اضغط "Create Device"**

### الخطوة 6-3: اختيار جهاز

```
╔════════════════════════════════════╗
║   Select Hardware                  ║
║                                    ║
║   Category: Phone                  ║
║   ┌────────────────────────────┐   ║
║   │ Pixel 6          5.4"      │   ║
║   │ Pixel 6 Pro      6.7"      │   ║
║   │ Pixel 7          6.3"  ✓   │   ║
║   │ Pixel 7 Pro      6.7"      │   ║
║   └────────────────────────────┘   ║
║                                    ║
║   [  Cancel  ]  [  Next  ]         ║
╚════════════════════════════════════╝
```

✅ **اختر "Pixel 7" (موصى به) واضغط "Next"**

### الخطوة 6-4: اختيار نظام التشغيل

```
╔════════════════════════════════════╗
║   System Image                     ║
║                                    ║
║   Release Name    API  ABI         ║
║   ┌────────────────────────────┐   ║
║   │ Tiramisu      33   x86_64  │   ║
║   │ S             31   x86_64  │   ║
║   │ R             30   x86_64  │   ║
║   └────────────────────────────┘   ║
║                                    ║
║   API 33 recommended               ║
║                                    ║
║   [  Cancel  ]  [  Next  ]         ║
╚════════════════════════════════════╝
```

✅ **اختر "Tiramisu API 33" (إذا لم يكن محمّل، اضغط Download)، ثم "Next"**

### الخطوة 6-5: تسمية المحاكي

```
╔════════════════════════════════════╗
║   Android Virtual Device (AVD)     ║
║                                    ║
║   AVD Name:                        ║
║   [Pixel_7_API_33________]         ║
║                                    ║
║   Startup orientation:             ║
║   ⦿ Portrait  ○ Landscape         ║
║                                    ║
║   [ ] Enable Device Frame          ║
║                                    ║
║   [  Cancel  ]  [  Finish  ]       ║
╚════════════════════════════════════╝
```

✅ **اترك الإعدادات الافتراضية واضغط "Finish"**

### الخطوة 6-6: تشغيل المحاكي

```
╔════════════════════════════════════╗
║   Device Manager                   ║
║                                    ║
║   ┌────────────────────────────┐   ║
║   │ Pixel_7_API_33             │   ║
║   │ Android 13.0 (Tiramisu)    │   ║
║   │                            │   ║
║   │      [  ▶  Play  ]         │   ║
║   └────────────────────────────┘   ║
╚════════════════════════════════════╝
```

✅ **اضغط "▶ Play"**

⏳ **انتظر حتى يشتغل المحاكي (1-3 دقائق)**

---

## 7. تشغيل التطبيق

### الخطوة 7-1: اختيار الجهاز

في أعلى Android Studio:

```
┌────────────────────────────────────┐
│  main.dart  │  [Pixel_7_API_33 ▼] │
└────────────────────────────────────┘
```

✅ **تأكد من اختيار المحاكي من القائمة**

### الخطوة 7-2: تشغيل التطبيق

اضغط الزر الأخضر:

```
┌──────────┐
│  ▶ Run   │
└──────────┘
```

أو:
```
Run → Run 'main.dart'
```

أو اضغط: **Shift + F10** (Windows/Linux) / **Control + R** (macOS)

### الخطوة 7-3: البناء الأول

```
╔════════════════════════════════════╗
║  Building...                       ║
║                                    ║
║  Running Gradle task 'assembleDebug'║
║  ▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░  55%        ║
║                                    ║
║  ⏳ First build may take 5-10 minutes║
╚════════════════════════════════════╝
```

⏳ **انتظر البناء الأول (5-10 دقائق)**

⚠️ **البناءات التالية ستكون أسرع (30 ثانية - دقيقة)**

### الخطوة 7-4: التطبيق يعمل!

```
╔════════════════════════════════════╗
║  Run:                              ║
║  ✓ Built build/app/outputs/...    ║
║  Installing build/app/...          ║
║  ✓ Installed                       ║
║  Launching lib/main.dart...        ║
║  ✓ App is running                  ║
╚════════════════════════════════════╝
```

على المحاكي:
```
┌─────────────────────┐
│  📱 أرشيف الوثائق   │
│                     │
│  [شاشة التطبيق]    │
│                     │
│  ✅ يعمل!          │
└─────────────────────┘
```

✅ **تم! التطبيق يعمل الآن**

---

## 8. بناء APK

### الخطوة 8-1: فتح Terminal في Android Studio

```
View → Tool Windows → Terminal
```

أو اضغط: **Alt + F12**

### الخطوة 8-2: تشغيل أمر البناء

في Terminal الموجود داخل Android Studio:

```bash
flutter build apk --release
```

### الخطوة 8-3: انتظار البناء

```
╔════════════════════════════════════╗
║  Building with sound null safety   ║
║                                    ║
║  Running Gradle task 'assembleRelease'║
║  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░  70%        ║
║                                    ║
║  ⏳ Building APK...                ║
╚════════════════════════════════════╝
```

⏳ **انتظر (2-5 دقائق)**

### الخطوة 8-4: البناء اكتمل!

```
╔════════════════════════════════════╗
║  ✓ Built build/app/outputs/        ║
║    flutter-apk/app-release.apk     ║
║    (43.1MB)                        ║
╚════════════════════════════════════╝
```

✅ **تم! لديك APK جاهز**

### الخطوة 8-5: العثور على الملف

الملف موجود في:
```
Walsat/build/app/outputs/flutter-apk/app-release.apk
```

في Android Studio:
```
1. انقر بزر الفأرة الأيمن على project root
2. اختر: Show in Explorer/Finder
3. اذهب إلى: build → app → outputs → flutter-apk
4. ستجد: app-release.apk
```

### الخطوة 8-6: نسخ APK

انسخ الملف إلى مكان آمن:

```bash
# Windows
copy build\app\outputs\flutter-apk\app-release.apk %USERPROFILE%\Desktop\my-app.apk

# macOS/Linux
cp build/app/outputs/flutter-apk/app-release.apk ~/Desktop/my-app.apk
```

---

## ✅ تم! أنت الآن محترف Android Studio + Flutter

### ما تعلمته:
- ✅ تثبيت Android Studio
- ✅ إعداد Flutter SDK
- ✅ فتح مشروع Flutter
- ✅ إنشاء وتشغيل محاكي
- ✅ تشغيل التطبيق
- ✅ بناء APK للإنتاج

### الخطوات التالية:
1. جرّب تعديل الكود في `lib/main.dart`
2. غيّر الألوان في `lib/theme/app_colors.dart`
3. أضف ميزات جديدة
4. ابنِ APK موقّع للنشر

---

## 📚 مراجع سريعة

### أوامر مفيدة في Terminal

```bash
# تشغيل التطبيق
flutter run

# بناء APK
flutter build apk --release

# تنظيف المشروع
flutter clean

# تحديث المكتبات
flutter pub get

# فحص المشاكل
flutter doctor

# عرض الأجهزة المتصلة
flutter devices
```

### اختصارات لوحة المفاتيح

| الاختصار | الوظيفة |
|----------|---------|
| **Shift + F10** | تشغيل التطبيق |
| **Ctrl + F9** | بناء المشروع |
| **Alt + F12** | فتح Terminal |
| **Ctrl + Shift + F** | البحث في كل الملفات |
| **Ctrl + Click** | الذهاب إلى التعريف |

---

**🎉 أحسنت! أنت الآن جاهز لبناء تطبيقات Flutter احترافية!**

**آخر تحديث: December 4, 2025**
