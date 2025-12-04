import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// خدمة المصادقة والتسجيل
/// Authentication and Login Service
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'https://www.googleapis.com/auth/drive.file',
    ],
  );

  // الحالة الحالية للمستخدم
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => currentUser != null;
  
  // Stream للاستماع لتغييرات حالة المستخدم
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// تسجيل الدخول بحساب Google
  /// Sign in with Google Account
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // بدء عملية تسجيل الدخول
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // المستخدم ألغى عملية التسجيل
        return null;
      }

      // الحصول على بيانات المصادقة
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // إنشاء بيانات الاعتماد
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // تسجيل الدخول في Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      
      // حفظ معلومات المستخدم
      await _saveUserInfo(userCredential.user);
      
      print('✅ تم تسجيل الدخول بنجاح: ${userCredential.user?.email}');
      return userCredential;
      
    } catch (e) {
      print('❌ خطأ في تسجيل الدخول بحساب Google: $e');
      rethrow;
    }
  }

  /// تسجيل الخروج
  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      
      // حذف معلومات المستخدم المحفوظة
      await _clearUserInfo();
      
      print('✅ تم تسجيل الخروج بنجاح');
    } catch (e) {
      print('❌ خطأ في تسجيل الخروج: $e');
      rethrow;
    }
  }

  /// الحصول على Access Token لـ Google Drive
  /// Get Google Drive Access Token
  Future<String?> getGoogleAccessToken() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account == null) return null;
      
      final auth = await account.authentication;
      return auth.accessToken;
    } catch (e) {
      print('❌ خطأ في الحصول على Access Token: $e');
      return null;
    }
  }

  /// حفظ معلومات المستخدم
  Future<void> _saveUserInfo(User? user) async {
    if (user == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.uid);
    await prefs.setString('user_email', user.email ?? '');
    await prefs.setString('user_name', user.displayName ?? '');
    await prefs.setString('user_photo', user.photoURL ?? '');
    await prefs.setBool('is_logged_in', true);
  }

  /// حذف معلومات المستخدم
  Future<void> _clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_photo');
    await prefs.setBool('is_logged_in', false);
  }

  /// الحصول على معلومات المستخدم المحفوظة
  Future<Map<String, String>> getSavedUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'user_id': prefs.getString('user_id') ?? '',
      'user_email': prefs.getString('user_email') ?? '',
      'user_name': prefs.getString('user_name') ?? '',
      'user_photo': prefs.getString('user_photo') ?? '',
    };
  }

  /// التحقق من حالة تسجيل الدخول المحفوظة
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  /// إعادة تسجيل الدخول بصمت (Silent Sign In)
  Future<GoogleSignInAccount?> silentSignIn() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (e) {
      print('⚠️ لم يتم العثور على تسجيل دخول سابق');
      return null;
    }
  }

  /// الحصول على بيانات المستخدم الحالي
  Map<String, dynamic> getCurrentUserData() {
    final user = currentUser;
    if (user == null) {
      return {
        'isLoggedIn': false,
        'email': null,
        'name': null,
        'photoUrl': null,
        'uid': null,
      };
    }

    return {
      'isLoggedIn': true,
      'email': user.email,
      'name': user.displayName,
      'photoUrl': user.photoURL,
      'uid': user.uid,
      'emailVerified': user.emailVerified,
      'creationTime': user.metadata.creationTime,
      'lastSignInTime': user.metadata.lastSignInTime,
    };
  }

  /// التحقق من صلاحيات Google Drive
  Future<bool> hasDrivePermission() async {
    try {
      final account = _googleSignIn.currentUser;
      if (account == null) return false;
      
      // التحقق من أن الحساب لديه صلاحيات Drive
      return _googleSignIn.scopes.contains('https://www.googleapis.com/auth/drive.file');
    } catch (e) {
      return false;
    }
  }

  /// طلب صلاحيات إضافية
  Future<bool> requestDrivePermission() async {
    try {
      await _googleSignIn.requestScopes([
        'https://www.googleapis.com/auth/drive.file',
      ]);
      return true;
    } catch (e) {
      print('❌ خطأ في طلب صلاحيات Drive: $e');
      return false;
    }
  }
}
