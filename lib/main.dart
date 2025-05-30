import 'package:flutter/material.dart';
import 'home_page.dart';
import 'theme_notifier.dart';
import 'language_notifier.dart';
import 'achievement_manager.dart'; // ⬅️ Імпортуємо

// Робимо функцію main асинхронною, щоб дочекатися ініціалізації
Future<void> main() async {
  // Це потрібно для асинхронного main та ініціалізації плагінів до runApp
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // Ініціалізуємо наш менеджер ачівок (завантажуємо збережені)
  await AchievementManager.initialize(); // ⬅️ Новий рядок!
  
  runApp(const MyApp());
}

// Клас MyApp та його вміст залишаються такими ж, як у попередній версії,
// де ми налаштовували ValueListenableBuilder для тем та мов.
// Я не буду його тут повторювати, щоб відповідь не була занадто довгою,
// але переконайся, що він у тебе є і працює.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentMode, __) {
        return ValueListenableBuilder<Locale>(
          valueListenable: languageNotifier,
          builder: (_, currentLocale, __) {
            return MaterialApp(
              title: 'Портфоліо', 
              debugShowCheckedModeBanner: false, 
              locale: currentLocale, 
              darkTheme: ThemeData( /* ... твоя темна тема ... */ ),
              theme: ThemeData( /* ... твоя світла тема ... */ ),
              themeMode: currentMode, 
              home: const HomePage(), 
            );
          },
        );
      },
    );
  }
}