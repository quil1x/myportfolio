import 'package:flutter/material.dart';
import '../localization/strings.dart'; 

class AchievementToast extends StatelessWidget {
  final IconData icon;
  final String titleKey; 
  final String descriptionKey;

  const AchievementToast({
    super.key,
    required this.icon,
    required this.titleKey,
    required this.descriptionKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black87;
    final iconColor = theme.primaryColor;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor.withAlpha((0.85 * 255).round()), // ⬅️ Змінено!
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: theme.brightness == Brightness.dark ? Colors.black54 : Colors.grey.shade400,
            width: 2,
          ),
           boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.2 * 255).round()), // ⬅️ Змінено!
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tr(context, titleKey),
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 11,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tr(context, descriptionKey),
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 9,
                    color: textColor.withAlpha((0.8 * 255).round()), // ⬅️ Змінено!
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}