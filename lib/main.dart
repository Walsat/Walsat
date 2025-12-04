import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'services/database_service.dart';
import 'services/image_service.dart';
import 'services/pdf_service.dart';
import 'services/ai_service.dart';
import 'services/google_drive_service.dart';
import 'services/auth_service.dart';
import 'services/print_service.dart';
import 'config/api_config.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  final databaseService = DatabaseService();
  await databaseService.init();
  
  // Initialize Auth Service
  final authService = AuthService();
  await authService.initialize();

  // Initialize AI services with API keys
  AIService(
    openAIKey: APIConfig.hasOpenAI ? APIConfig.openAIKey : null,
    googleVisionKey: APIConfig.hasGoogleVision ? APIConfig.googleVisionKey : null,
  );
  
  GoogleDriveService(); // Will be configured later with OAuth
  PrintService(); // Initialize print service

  // Print API status
  APIConfig.printStatus();
  print('✨ التطبيق جاهز مع جميع الميزات!');
  print('📱 تسجيل الدخول: ${authService.isSignedIn ? "نعم" : "لا"}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        Provider<ImageService>(
          create: (_) => ImageService(),
        ),
        Provider<PdfService>(
          create: (_) => PdfService(),
        ),
        Provider<AIService>(
          create: (_) => AIService(),
        ),
        Provider<GoogleDriveService>(
          create: (_) => GoogleDriveService(),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<PrintService>(
          create: (_) => PrintService(),
        ),
      ],
      child: MaterialApp(
        title: 'أرشيف الوثائق',
        debugShowCheckedModeBanner: false,
        
        // Arabic localization
        locale: const Locale('ar', 'SA'),
        supportedLocales: const [
          Locale('ar', 'SA'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        
        // Theme - Modern Gradient Design
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
            primary: Colors.deepPurple,
            secondary: Colors.purpleAccent,
            tertiary: Colors.tealAccent,
          ),
          fontFamily: 'Cairo',
          
          // AppBar theme
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
          ),
          
          // Card theme
          cardTheme: CardTheme(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          
          // Input decoration theme
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 18,
            ),
          ),
          
          // Button theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 36,
                vertical: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
            ),
          ),
          
          // FloatingActionButton theme
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
          ),
        ),
        
        // Dark theme - Modern Dark Design
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
            primary: Colors.deepPurpleAccent,
            secondary: Colors.purpleAccent,
            tertiary: Colors.tealAccent,
          ),
          fontFamily: 'Cairo',
          
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          
          cardTheme: CardTheme(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 18,
            ),
          ),
          
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 36,
                vertical: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
            ),
          ),
          
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
          ),
        ),
        
        themeMode: ThemeMode.system,
        home: const LoginScreen(),
      ),
    );
  }
}
