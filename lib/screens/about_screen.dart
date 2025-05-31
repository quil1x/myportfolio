// lib/screens/about_screen.dart
import 'package:flutter/material.dart';
import '../localization/strings.dart'; 
import '../utils.dart'; 
import '../utils/portal_utils.dart'; 
import '../achievement_manager.dart';
import '../theme_notifier.dart'; 
import '../language_notifier.dart'; // <-- ДОДАЙ, ЯКЩО НЕМАЄ

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    // Обгортаємо ValueListenableBuilder для мови
    return ValueListenableBuilder<Locale>(
      valueListenable: languageNotifier,
      builder: (context, currentLocale, _) { // _ для невикористаного child
        // Існуючий ValueListenableBuilder для теми залишається всередині
        return ValueListenableBuilder<AppThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentAppMode, child) {
            bool isNether = currentAppMode == AppThemeMode.nether;
            // ... (решта твоєї логіки для titleKey, p1Key і т.д.) ...
            String titleKey;
            String p1Key;
            String p2Key;
            String p3Key;

            if (isNether) {
              titleKey = 'nether_intro_title';
              p1Key = 'nether_intro_p1';   
              p2Key = 'nether_intro_p2';   
              p3Key = 'nether_intro_p3';   
            } else {
              titleKey = 'about_title';
              p1Key = 'about_text_p1';
              p2Key = 'about_text_p2';
              p3Key = 'about_text_p3';
            }

            return Stack( 
              children: [
                Positioned.fill(
                  child: Padding(
                    // ... (твій Padding, SingleChildScrollView, Column з текстами та кнопкою PLAY) ...
                    // Важливо, щоб всі виклики tr(context, ...) були всередині цього builder'а
                    padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 20.0, top: 0.0), 
                    child: SingleChildScrollView( 
                      child: Container( 
                        constraints: const BoxConstraints(maxWidth: 800), 
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min, 
                          children: [
                            if (!isNether)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: ElevatedButton.icon(
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
                                        side: BorderSide(color: Colors.green.shade700, width: 2)
                                      ),
                                  ),
                                ),
                              ),
                            Text(
                              tr(context, titleKey), 
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 15),
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
                // Кнопка порталу
                Positioned(
                  bottom: 20 + MediaQuery.of(context).padding.bottom, 
                  right: 20 + MediaQuery.of(context).padding.right,
                  child: InkWell(
                    onTap: () {
                      if (isNether) {
                        themeNotifier.cycleThemeSetting(); 
                      } else {
                        PortalUtils.triggerNetherPortalAnimation(context);
                      }
                    },
                    child: Tooltip(
                      message: tr(context, isNether ? 'theme_action_exit_nether' : 'settings_action_enter_nether'),
                      child: Image.asset(
                        'assets/images/nether_portal_icon.png', 
                        width: 55, 
                        height: 75, 
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                           return Icon(Icons.error, color: Colors.red.withAlpha(170), size: 50);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}