import 'package:flutter/material.dart';
import '../theme_notifier.dart'; 
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

          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (_, currentMode, __) {
              bool isLightMode = currentMode == ThemeMode.light;
              return ListTile(
                leading: Icon(
                  isLightMode ? Icons.nightlight_round_outlined : Icons.wb_sunny_outlined,
                  color: theme.primaryColor,
                ),
                title: Text(
                  isLightMode ? tr(context, 'settings_theme_switch_to_dark') : tr(context, 'settings_theme_switch_to_light'),
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 10),
                ),
                onTap: () {
                  themeNotifier.switchTheme(); 
                  AchievementManager.show(context, 'switch_theme');
                },
              );
            },
          ),
          const SizedBox(height: 10),

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