import 'package:flutter/material.dart';
import '../localization/strings.dart'; // Для tr()
import '../language_notifier.dart';   // <-- ДОДАЙ ЦЕЙ ІМПОРТ, ЯКЩО ЙОГО НЕМАЄ
// import '../theme_notifier.dart'; // Не потрібен тут, якщо екран не реагує на зміну теми окремо

class NetherDetailsScreen extends StatelessWidget {
  const NetherDetailsScreen({super.key}); // Використовуємо super.key

  @override
  Widget build(BuildContext context) {
    // Обгортаємо основний вміст у ValueListenableBuilder,
    // який слухатиме зміни в languageNotifier
    return ValueListenableBuilder<Locale>(
      valueListenable: languageNotifier, // Слухаємо наш languageNotifier
      builder: (context, currentLocale, child) {
        // Тепер tr() буде викликатися з оновленим контекстом щоразу,
        // як змінюється мова, і весь цей блок буде перебудовуватися.
        final theme = Theme.of(context);
        // Ключі для опису Незеру, які ми визначили раніше
        const String p1Key = 'nether_about_p1';
        const String p2Key = 'nether_about_p2';
        const String p3Key = 'nether_about_p3';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(context, 'nether_details_title'), 
                  style: theme.textTheme.displaySmall,
                ),
                const SizedBox(height: 30),
                Text(
                  '${tr(context, p1Key)}\n\n'
                  '${tr(context, p2Key)}\n\n'
                  '${tr(context, p3Key)}',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}