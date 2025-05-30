import 'package:flutter/material.dart';
import '../localization/strings.dart'; //
import '../utils.dart'; //
import '../achievement_manager.dart'; //
import '../theme_notifier.dart'; //
// import '../language_notifier.dart'; // Цей імпорт не використовується в цьому файлі безпосередньо

// Віджет анімації фауни прибраний, тому імпорт не потрібен
// import '../widgets/theme_animated_fauna.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key}); //

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>( //
      valueListenable: themeNotifier, //
      builder: (context, currentAppMode, child) {
        bool isNether = currentAppMode == AppThemeMode.nether; //
        String titleKey = isNether ? 'nether_about_title' : 'about_title'; //
        String p1Key = isNether ? 'nether_about_p1' : 'about_text_p1'; //
        String p2Key = isNether ? 'nether_about_p2' : 'about_text_p2'; //
        String p3Key = isNether ? 'nether_about_p3' : 'about_text_p3'; //

        return Padding( //
          // Відступи: Зверху 0! Зліва 40, Справа 40, Знизу 20.
          padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 20.0, top: 0.0), //
          child: SingleChildScrollView( //
            child: Container( // Обмежуємо максимальну ширину контенту //
              constraints: const BoxConstraints(maxWidth: 800), // Можеш змінити або прибрати, якщо текст має бути на всю ширину //
              child: Column( //
                crossAxisAlignment: CrossAxisAlignment.start, //
                mainAxisAlignment: MainAxisAlignment.start, // Явно вказуємо починати зверху //
                mainAxisSize: MainAxisSize.min, //
                children: [
                  // 1. Спочатку Заголовок "ПРО МЕНЕ:"
                  Text( //
                    tr(context, titleKey), //
                    style: Theme.of(context).textTheme.displaySmall, //
                  ),
                  // 2. Потім відступ (можеш налаштувати висоту)
                  const SizedBox(height: 20), // Відступ між заголовком та кнопкою //

                  // 3. Потім кнопка "PLAY"
                  ElevatedButton.icon( //
                    onPressed: () {
                      launchURL(context, 'https://classic.minecraft.net/'); //
                      AchievementManager.show(context, 'play_game'); //
                    },
                    icon: const Icon(Icons.play_arrow, size: 30), //
                    label: Text(tr(context, 'play_button')), //
                    style: ElevatedButton.styleFrom( //
                      backgroundColor: Theme.of(context).primaryColor, //
                      foregroundColor: Colors.white, //
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25), //
                      textStyle: const TextStyle(fontSize: 18, fontFamily: 'PressStart2P'), //
                      shape: RoundedRectangleBorder( //
                        borderRadius: BorderRadius.circular(2.0), //
                        side: BorderSide(color: Colors.green.shade700, width: 2), //
                      ),
                    ),
                  ),

                  // 4. Відступ перед основним текстом
                  const SizedBox(height: 30), // Відступ між кнопкою та основним текстом (раніше тут було 15, але після заголовка, тепер після кнопки) //

                  // 5. Основний текст
                  Text( //
                    '${tr(context, p1Key)}\n\n' //
                    '${tr(context, p2Key)}\n\n' //
                    '${tr(context, p3Key)}', //
                    style: Theme.of(context).textTheme.bodyLarge, //
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}