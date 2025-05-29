import 'package:flutter/material.dart';
import '../xp_notifier.dart';
// import 'package:google_fonts/google_fonts.dart'; // Не потрібен тут

class XpBarWidget extends StatelessWidget {
  const XpBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Стилізація під Minecraft XP bar
    const double barPixelHeight = 5.0; // Висота самої зеленої/темної смужки XP (в пікселях гри)
    const double borderWidth = 1.0;    // Товщина піксельної рамки
    const double totalBarHeight = barPixelHeight + (borderWidth * 2); // Загальна висота з рамкою

    const int totalSegments = XpNotifier.maxXp ~/ XpNotifier.xpPerAchievement;

    // Кольори точно як у Minecraft XP Bar
    const Color xpBorderColor = Color(0xFF000000); // Чорна рамка
    const Color xpEmptySegmentBgColor = Color(0xFF3A3A3A); // Темно-сірий/зелений фон для порожніх
    const Color xpFilledSegmentColor = Color(0xFF54FB54); // Яскраво-зелений XP

    return ValueListenableBuilder<int>(
      valueListenable: xpNotifier,
      builder: (context, currentXp, child) {
        int filledSegmentsCount = (currentXp / XpNotifier.xpPerAchievement).ceil().clamp(0, totalSegments);

        return Container(
          height: totalBarHeight * 2.0, // Збільшуємо для кращої видимості (логічні пікселі)
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration( // Зовнішня темна обводка
            border: Border.all(color: xpBorderColor, width: borderWidth * 2.0),
          ),
          child: Container( // Внутрішня світліша обводка
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF595959), width: borderWidth * 2.0),
            ),
            child: Row(
              children: List.generate(totalSegments, (index) {
                bool isFilled = index < filledSegmentsCount;
                return Expanded(
                  child: Container(
                    height: barPixelHeight * 2.0, // Висота сегмента
                    margin: EdgeInsets.zero, // Забираємо відступи між сегментами для суцільного вигляду
                    decoration: BoxDecoration(
                      color: isFilled ? xpFilledSegmentColor : xpEmptySegmentBgColor,
                      // Додаємо темнішу лінію справа для кожного сегмента, крім останнього,
                      // щоб імітувати розділення сегментів у Minecraft
                      border: index < totalSegments -1 
                        ? Border(right: BorderSide(color: xpBorderColor.withOpacity(0.7), width: borderWidth * 2.0))
                        : null,
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}