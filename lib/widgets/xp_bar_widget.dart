import 'package:flutter/material.dart';
import '../xp_notifier.dart';

class XpBarWidget extends StatelessWidget {
  const XpBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double barHeight = 12.0; 
    const int totalSegments = XpNotifier.maxXp ~/ XpNotifier.xpPerAchievement;

    final Color filledColor = Colors.green.shade400; 
    final Color emptyColor = theme.brightness == Brightness.dark 
                              ? Colors.black.withAlpha((0.6 * 255).round())
                              : Colors.grey.shade300;
    // borderColor тут не потрібен, якщо ми використовуємо рамку контейнера
    final Color segmentSeparatorColor = theme.brightness == Brightness.dark
                                          ? Colors.black.withAlpha((0.7 * 255).round())
                                          : Colors.grey.shade400.withAlpha((0.7 * 255).round());

    return ValueListenableBuilder<int>(
      valueListenable: xpNotifier,
      builder: (context, currentXp, child) {
        int filledSegmentsCount = (currentXp / XpNotifier.xpPerAchievement).ceil().clamp(0, totalSegments);

        return Container(
          height: barHeight + 4, 
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(2), 
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark ? const Color(0xFF202020) : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(3.0), 
            border: Border.all(
              color: Colors.black.withAlpha((0.6 * 255).round()),
              width: 1.0,
            )
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1.5),
            child: Container(
              height: barHeight,
              color: theme.brightness == Brightness.dark ? const Color(0xFF383838) : Colors.grey.shade200,
              child: Row(
                children: List.generate(totalSegments, (index) {
                  bool isFilled = index < filledSegmentsCount;
                  
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0.5),
                      height: barHeight,
                      decoration: BoxDecoration(
                       color: isFilled ? filledColor : emptyColor,
                       border: index < totalSegments -1 
                        ? Border(right: BorderSide(color: segmentSeparatorColor, width: XpBarWidget.borderWidth /* Використовуємо XpBarWidget.borderWidth */ ))
                        : null,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
  static const double borderWidth = 1.0; 
}