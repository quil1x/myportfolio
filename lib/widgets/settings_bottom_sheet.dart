import 'package:flutter/material.dart';
import '../theme_notifier.dart'; 
import '../language_notifier.dart';
import '../localization/strings.dart';
import '../achievement_manager.dart';

class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    print("!!! [SettingsBottomSheet] LOG: Build method for SettingsBottomSheet called !!!"); // ЛОГ 5
    final theme = Theme.of(context);
    return Container(
      // ... (padding, decoration без змін) ...
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

          ValueListenableBuilder<AppThemeMode>( 
            valueListenable: themeNotifier,
            builder: (context, currentAppMode, __) { 
              // print("!!! [SettingsBottomSheet] LOG: Theme Switcher VLB rebuilt. Mode: $currentAppMode !!!"); // ЛОГ 6
              if (currentAppMode == AppThemeMode.nether) {
                return ListTile( /* ... Кнопка "Покинути Незер" ... */ 
                  leading: Icon(Icons.door_back_door_outlined, color: theme.primaryColor),
                  title: Text(tr(context, 'theme_action_exit_nether'), style: theme.textTheme.bodyLarge?.copyWith(fontSize: 10)),
                  onTap: () {
                    // print("!!! [SettingsBottomSheet] LOG: Exit Nether Tapped !!!");
                    themeNotifier.cycleThemeSetting(); 
                    AchievementManager.show(context, 'switch_theme'); 
                    Navigator.pop(context); 
                  },
                );
              } else {
                return ListTile( /* ... Кнопка День/Ніч ... */ 
                  leading: Icon(themeNotifier.currentThemeIcon, color: theme.primaryColor),
                  title: Text(tr(context, themeNotifier.currentThemeSwitchTextKey), style: theme.textTheme.bodyLarge?.copyWith(fontSize: 10)),
                  onTap: () {
                    // print("!!! [SettingsBottomSheet] LOG: Cycle Day/Night Tapped !!!");
                    themeNotifier.cycleThemeSetting(); 
                    AchievementManager.show(context, 'switch_theme');
                  },
                );
              }
            },
          ),
          const SizedBox(height: 10),

          ValueListenableBuilder<Locale>( 
            valueListenable: languageNotifier,
            builder: (context, currentLocale, __) {
              // print("!!! [SettingsBottomSheet] LOG: Language Switcher VLB rebuilt. Locale: $currentLocale !!!"); // ЛОГ 7
              return ListTile( /* ... Перемикач мови ... */ 
                leading: Icon(Icons.translate_outlined, color: theme.primaryColor),
                title: Text(languageNotifier.switchButtonText, style: theme.textTheme.bodyLarge?.copyWith(fontSize: 10)),
                subtitle: Text('${tr(context, 'settings_lang_current')} ${languageNotifier.currentLanguageName}', style: theme.textTheme.bodyMedium?.copyWith(fontSize: 8)),
                onTap: () {
                  // print("!!! [SettingsBottomSheet] LOG: Switch Language Tapped !!!");
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