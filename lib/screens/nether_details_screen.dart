// lib/screens/nether_details_screen.dart
import 'package:flutter/material.dart';
import '../localization/strings.dart';
import '../language_notifier.dart'; // Якщо потрібна реакція на зміну мови

class NetherDetailsScreen extends StatelessWidget {
  const NetherDetailsScreen({super.key}); // Використовуємо super parameters

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>( // Додано для оновлення мови
      valueListenable: languageNotifier,
      builder: (context, locale, child) {
        final theme = Theme.of(context);
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