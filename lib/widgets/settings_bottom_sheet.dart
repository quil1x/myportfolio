import 'package:flutter/material.dart';
import '../theme_notifier.dart'; // Переконайся, що імпортується AppThemeMode звідси
import '../language_notifier.dart';
import '../localization/strings.dart';
import '../achievement_manager.dart';

class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: theme.bottomSheetTheme.modalBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tr(context, 'settings_title'),
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 20),

          // --- Оновлений Перемикач теми ---
          ValueListenableBuilder<AppThemeMode>( // ⬅️ Змінено на AppThemeMode!
            valueListenable: themeNotifier,
            builder: (_, currentAppMode, __) { // currentAppMode тепер типу AppThemeMode
              return ListTile(
                leading: Icon(
                  themeNotifier.currentThemeIcon, // Використовуємо геттер з themeNotifier
                  color: theme.primaryColor,
                ),
                title: Text(
                  tr(context, themeNotifier.currentThemeSwitchTextKey), // Використовуємо геттер з themeNotifier
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 10),
                ),
                onTap: () {
                  themeNotifier.cycleThemeSetting(); // ⬅️ Викликаємо правильний метод!
                  AchievementManager.show(context, 'switch_theme');
                },
              );
            },
          ),
          const SizedBox(height: 10),

          // --- Перемикач мови (залишається як є) ---
          ValueListenableBuilder<Locale>(
            valueListenable: languageNotifier,
            builder: (_, currentLocale, __) {
              return ListTile(
                leading: Icon(Icons.translate_outlined, color: theme.primaryColor),
                title: Text(
                  languageNotifier.switchButtonText,
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 10),
                ),
                subtitle: Text(
                  '${tr(context, 'settings_lang_current')} ${languageNotifier.currentLanguageName}',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 8),
                ),
                onTap: () {
                  languageNotifier.switchLanguage(); 
                  AchievementManager.show(context, 'switch_language');
                },
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}