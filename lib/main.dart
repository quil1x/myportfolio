import 'package:flutter/material.dart';
import 'home_page.dart';
import 'theme_notifier.dart'; 
import 'language_notifier.dart';
import 'achievement_manager.dart';

Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized(); 
  await AchievementManager.initialize(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentAppMode, __) {
        ThemeData currentThemeData;
        if (currentAppMode == AppThemeMode.light) {
          currentThemeData = lightTheme;
        } else if (currentAppMode == AppThemeMode.nether) {
          currentThemeData = netherTheme; 
        } else { 
          currentThemeData = darkTheme;
        }

        return ValueListenableBuilder<Locale>(
          valueListenable: languageNotifier,
          builder: (_, currentLocale, __) {
            // ⬇️ ДІАГНОСТИЧНИЙ PRINT ⬇️
            print('[DEBUG MaterialApp] Building with locale: ${currentLocale.languageCode} and theme: $currentAppMode');
            return MaterialApp(
              title: 'Портфоліо', 
              debugShowCheckedModeBanner: false, 
              locale: currentLocale, 
              theme: currentThemeData,
              home: HomePage(), // ⬅️ НЕМАЄ CONST!
            );
          },
        );
      },
    );
  }
}

// --- ТЕМНА ТЕМА ("НІЧ"), СВІТЛА ТЕМА ("ДЕНЬ"), НЕЗЕР ТЕМА ---
// Тут мають бути твої повні визначення ThemeData: darkTheme, lightTheme, netherTheme
// з моєї попередньої відповіді, де ми оновлювали Незер-тему.
// Я їх тут не повторюю повністю для економії місця.
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF1E1E1E),
  fontFamily: 'PressStart2P',
  primaryColor: const Color(0xFF4CAF50),
  cardColor: const Color(0xFF2D2D2D),
  dividerColor: Colors.black87, 
  hintColor: Colors.grey[600], 
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 11, height: 1.8),
    bodyMedium: TextStyle(color: Colors.white70, fontSize: 10, height: 1.6),
    titleLarge: TextStyle(color: Colors.white, fontSize: 14),
    displaySmall: TextStyle(color: Colors.grey, fontSize: 12),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData( /* ... */ ),
  switchTheme: SwitchThemeData( /* ... */ ),
  bottomSheetTheme: const BottomSheetThemeData( /* ... */ ),
  appBarTheme: const AppBarTheme( /* ... */ ),
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.grey.shade50,
  fontFamily: 'PressStart2P',
  primaryColor: const Color(0xFF4CAF50),
  cardColor: Colors.white,
  dividerColor: Colors.grey.shade300,
  hintColor: Colors.grey[700],
  iconTheme: IconThemeData(color: Colors.grey[900]),
  textTheme: TextTheme( /* ... */ ),
  elevatedButtonTheme: ElevatedButtonThemeData( /* ... */ ),
  switchTheme: SwitchThemeData( /* ... */ ),
  bottomSheetTheme: BottomSheetThemeData( /* ... */ ),
  appBarTheme: AppBarTheme( /* ... */ ),
);

final ThemeData netherTheme = ThemeData(
  brightness: Brightness.dark, 
  scaffoldBackgroundColor: const Color(0xFF2A0A0A), 
  fontFamily: 'PressStart2P',
  primaryColor: const Color(0xFFE04000), 
  cardColor: const Color(0xFF4A1C0A),    
  dividerColor: Colors.black.withAlpha(180),
  hintColor: Colors.yellow.shade400, 
  iconTheme: IconThemeData(color: Colors.orange.shade400),
  textTheme: TextTheme( /* ... */ ),
  elevatedButtonTheme: ElevatedButtonThemeData( /* ... */ ),
  switchTheme: SwitchThemeData( /* ... */ ),
  bottomSheetTheme: const BottomSheetThemeData( /* ... */ ),
  appBarTheme: AppBarTheme( /* ... */ ),
);