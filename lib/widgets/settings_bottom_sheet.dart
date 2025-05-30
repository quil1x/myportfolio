import 'package:flutter/material.dart'; //
import '../theme_notifier.dart'; //
import '../language_notifier.dart'; //
import '../localization/strings.dart'; //
import '../achievement_manager.dart'; //
import '../utils/portal_utils.dart'; // ІМПОРТ НАШОГО НОВОГО ФАЙЛУ

class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key}); //

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); //
    return Container( //
      padding: const EdgeInsets.all(20.0), //
      decoration: BoxDecoration( //
        color: theme.bottomSheetTheme.modalBackgroundColor, //
        borderRadius: const BorderRadius.only( //
          topLeft: Radius.circular(16.0), //
          topRight: Radius.circular(16.0), //
        ),
      ),
      child: Column( //
        mainAxisSize: MainAxisSize.min, //
        crossAxisAlignment: CrossAxisAlignment.start, //
        children: <Widget>[
          Text( //
            tr(context, 'settings_title'), //
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 12), //
          ),
          const SizedBox(height: 20), //

          // --- Існуючий Перемикач теми (День/Ніч/Вихід з Незера) ---
          ValueListenableBuilder<AppThemeMode>( //
            valueListenable: themeNotifier, //
            builder: (_, currentAppMode, __) { //
              return ListTile( //
                leading: Icon( //
                  themeNotifier.currentThemeIcon, //
                  color: theme.primaryColor, //
                ),
                title: Text( //
                  tr(context, themeNotifier.currentThemeSwitchTextKey), //
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 10), //
                ),
                onTap: () { //
                  themeNotifier.cycleThemeSetting(); //
                  AchievementManager.show(context, 'switch_theme'); //
                },
              );
            },
          ),
          // const SizedBox(height: 10), // Цей відступ можна налаштувати або прибрати

          // --- НОВА КНОПКА: Вхід в Незер ---
          ValueListenableBuilder<AppThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, currentAppMode, __) {
              if (currentAppMode != AppThemeMode.nether) {
                // Показуємо кнопку "Портал в Незер" тільки якщо ми НЕ в Незері
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 0), // Мінімальний відступ, якщо потрібен між перемикачем теми та цією кнопкою
                    ListTile(
                      leading: Icon(Icons.whatshot_outlined, color: theme.primaryColor),
                      title: Text(
                        tr(context, 'settings_action_enter_nether'), // Використовуємо новий ключ локалізації
                        style: theme.textTheme.bodyLarge?.copyWith(fontSize: 10),
                      ),
                      onTap: () {
                        // Можна закрити BottomSheet перед початком анімації, якщо хочеш
                        // Navigator.of(context).pop();
                        PortalUtils.triggerNetherPortalAnimation(context);
                      },
                    ),
                  ],
                );
              } else {
                // Якщо ми в Незері, не показуємо цю кнопку (бо вихід з Незера вже є у перемикачі вище)
                return const SizedBox.shrink();
              }
            },
          ),
          const SizedBox(height: 10), // Відступ перед перемикачем мови


          // --- Перемикач мови (залишається як є) ---
          ValueListenableBuilder<Locale>( //
            valueListenable: languageNotifier, //
            builder: (_, currentLocale, __) { //
              return ListTile( //
                leading: Icon(Icons.translate_outlined, color: theme.primaryColor), //
                title: Text( //
                  languageNotifier.switchButtonText, //
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 10), //
                ),
                subtitle: Text( //
                  '${tr(context, 'settings_lang_current')} ${languageNotifier.currentLanguageName}', //
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 8), //
                ),
                onTap: () { //
                  languageNotifier.switchLanguage(); //
                  AchievementManager.show(context, 'switch_language'); //
                },
              );
            },
          ),
          const SizedBox(height: 20), //
        ],
      ),
    );
  }
}