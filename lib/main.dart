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
import 'screens/stunning_home_screen.dart';
import 'theme/modern_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  final databaseService = DatabaseService();
  await databaseService.init();

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
        
        // Modern Theme with Stunning UI
        theme: ModernTheme.darkTheme,
        darkTheme: ModernTheme.darkTheme,
        themeMode: ThemeMode.dark, // Always use dark theme for stunning effect
        home: const StunningHomeScreen(),
      ),
    );
  }
}
