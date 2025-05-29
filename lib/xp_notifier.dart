import 'package:flutter/foundation.dart';

class XpNotifier extends ValueNotifier<int> {
  XpNotifier() : super(0);

  static const int maxXp = 100; // Наприклад, 10 ачівок по 10 XP
  static const int xpPerAchievement = 10;

  void addXp() {
    if (value < maxXp) {
      value = value + xpPerAchievement;
      if (value > maxXp) {
        value = maxXp;
      }
      notifyListeners();
    }
  }

  void resetXp() {
    value = 0;
    notifyListeners();
  }
}

final xpNotifier = XpNotifier();