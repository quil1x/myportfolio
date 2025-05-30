import 'package:flutter/material.dart';
import '../localization/strings.dart';
import '../utils.dart'; // Існуючий utils.dart
import '../utils/portal_utils.dart'; // Наш файл для логіки входу в портал
import '../achievement_manager.dart';
import '../theme_notifier.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentAppMode, child) {
        bool isNether = currentAppMode == AppThemeMode.nether;
        String titleKey = isNether ? 'nether_about_title' : 'about_title';
        String p1Key = isNether ? 'nether_about_p1' : 'about_text_p1';
        String p2Key = isNether ? 'nether_about_p2' : 'about_text_p2';
        String p3Key = isNether ? 'nether_about_p3' : 'about_text_p3';

        return Stack( // Обгортаємо все в Stack, щоб позиціонувати кнопку
          children: [
            // Основний контент екрану "Про мене"
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 20.0, top: 0.0),
                child: SingleChildScrollView(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tr(context, titleKey),
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            launchURL(context, 'https://classic.minecraft.net/');
                            AchievementManager.show(context, 'play_game');
                          },
                          icon: const Icon(Icons.play_arrow, size: 30),
                          label: Text(tr(context, 'play_button')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                            textStyle: const TextStyle(fontSize: 18, fontFamily: 'PressStart2P'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              side: BorderSide(color: Colors.green.shade700, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          '${tr(context, p1Key)}\n\n'
                          '${tr(context, p2Key)}\n\n'
                          '${tr(context, p3Key)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Кнопка порталу (вхід/вихід з Незеру)
            Positioned(
              bottom: 20 + MediaQuery.of(context).padding.bottom, // Відступи + безпечна зона
              right: 20 + MediaQuery.of(context).padding.right,
              child: InkWell(
                onTap: () {
                  if (isNether) {
                    // Якщо ми в Незері - виходимо з нього
                    themeNotifier.cycleThemeSetting(); // Цей метод поверне до попередньої теми
                    // Можна додати ачівку за вихід з Незеру через портал, якщо є бажання
                    // AchievementManager.show(context, 'exited_nether_via_portal');
                  } else {
                    // Якщо ми не в Незері - входимо
                    PortalUtils.triggerNetherPortalAnimation(context);
                  }
                },
                child: Tooltip(
                  // Текст підказки змінюється залежно від режиму
                  message: tr(context, isNether ? 'theme_action_exit_nether' : 'settings_action_enter_nether'),
                  child: Image.asset(
                    'assets/images/nether_portal_icon.png', // Та сама іконка порталу
                    width: 55, // Налаштуй розмір
                    height: 75, // Налаштуй розмір
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                       // print("Помилка завантаження іконки порталу на AboutScreen: $error");
                       return Icon(Icons.error, color: Colors.red.withAlpha((0.7 * 255).round()), size: 50);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}