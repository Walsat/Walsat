import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// خدمة المصادقة والتسجيل (Simplified - No Firebase)
/// Authentication and Login Service
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'https://www.googleapis.com/auth/drive.file',
    ],
  );

  // الحالة الحالية للمستخدم
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
  bool get isLoggedIn => currentUser != null;

  /// تسجيل الدخول بحساب Google (بدون Firebase)
  /// Sign in with Google Account (Without Firebase)
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      // بدء عملية تسجيل الدخول
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // المستخدم ألغى عملية التسجيل
        return null;
      }

      // حفظ معلومات المستخدم
      await _saveUserInfo(googleUser);
      
      print('✅ تم تسجيل الدخول بنجاح: ${googleUser.email}');
      return googleUser;
      
    } catch (e) {
      print('❌ خطأ في تسجيل الدخول بحساب Google: $e');
      rethrow;
    }
  }

  /// تسجيل الخروج
  /// Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      
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
  Future<void> _saveUserInfo(GoogleSignInAccount? user) async {
    if (user == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_name', user.displayName ?? '');
    await prefs.setString('user_photo', user.photoUrl ?? '');
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
        'id': null,
      };
    }

    return {
      'isLoggedIn': true,
      'email': user.email,
      'name': user.displayName,
      'photoUrl': user.photoUrl,
      'id': user.id,
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
