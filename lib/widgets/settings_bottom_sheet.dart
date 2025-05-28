import 'package:flutter/material.dart';
import '../theme_notifier.dart'; 
import '../language_notifier.dart';
import '../localization/strings.dart';

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
              return SwitchListTile(
                title: Text(
                  tr(context, 'settings_theme_light'),
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 10),
                ),
                value: currentMode == ThemeMode.light, 
                onChanged: (bool value) {
                  themeNotifier.switchTheme(); 
                },
                secondary: Icon(
                  currentMode == ThemeMode.light ? Icons.wb_sunny : Icons.nightlight_round,
                  color: theme.primaryColor,
                  ),
                activeTrackColor: theme.primaryColor.withAlpha(128), // ⬅️ Змінено!
                activeColor: theme.primaryColor,
              );
            },
          ),
          const SizedBox(height: 10),

          ValueListenableBuilder<Locale>(
            valueListenable: languageNotifier,
            builder: (_, currentLocale, __) {
              return ListTile(
                leading: Icon(Icons.language, color: theme.primaryColor),
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