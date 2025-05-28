import 'package:flutter/material.dart';
import 'home_page.dart';
import 'theme_notifier.dart';
import 'language_notifier.dart';

void main() {
  runApp(const MyApp());
}

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

              // --- ТЕМНА ТЕМА ---
              darkTheme: ThemeData(
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
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A5A5A),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontFamily: 'PressStart2P', fontSize: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
                  ),
                ),
                switchTheme: SwitchThemeData(
                  thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                    }
                    return Colors.grey[600];
                  }),
                  trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                    }
                    return Colors.grey[800];
                  }),
                ),
                bottomSheetTheme: const BottomSheetThemeData(
                  backgroundColor: Color(0xFF1E1E1E),
                  modalBackgroundColor: Color(0xFF2D2D2D),
                ),
              ),

              // --- СВІТЛА ТЕМА ---
              theme: ThemeData(
                brightness: Brightness.light,
                scaffoldBackgroundColor: Colors.grey.shade50,
                fontFamily: 'PressStart2P',
                primaryColor: const Color(0xFF4CAF50),
                cardColor: Colors.white,
                dividerColor: Colors.grey.shade300,
                hintColor: Colors.grey[700],
                iconTheme: IconThemeData(color: Colors.grey[900]),
                textTheme: TextTheme(
                  bodyLarge: TextStyle(color: Colors.black87, fontSize: 11, height: 1.8),
                  bodyMedium: TextStyle(color: Colors.black54, fontSize: 10, height: 1.6),
                  titleLarge: TextStyle(color: Colors.black87, fontSize: 14),
                  displaySmall: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontFamily: 'PressStart2P', fontSize: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
                  ),
                ),
                switchTheme: SwitchThemeData(
                  thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Color(0xFF4CAF50);
                    }
                    return Colors.grey[400];
                  }),
                  trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Color(0xFF4CAF50).withAlpha(128);
                    }
                    return Colors.grey[300];
                  }),
                ),
                bottomSheetTheme: BottomSheetThemeData(
                  backgroundColor: Colors.white,
                  modalBackgroundColor: Colors.grey.shade100,
                ),
              ),

              themeMode: currentMode,
              home: const HomePage(),
            );
          },
        );
      },
    );
  }
}