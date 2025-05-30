// lib/utils/portal_utils.dart
import 'package:flutter/material.dart';
import '../widgets/portal_animation_overlay.dart'; // Перевір шлях, якщо твій віджет порталу лежить інакше
import '../achievement_manager.dart';             // Перевір шлях

class PortalUtils {
  static OverlayEntry? _portalOverlayEntry;

  static bool get isPortalAnimationActive => _portalOverlayEntry != null;

  static void triggerNetherPortalAnimation(BuildContext context) {
    // Запобіжники, щоб не запускати кілька анімацій одночасно
    // або під час вибуху кріпера
    if (AchievementManager.isCreeperEffectActive || isPortalAnimationActive) {
      return;
    }

    _portalOverlayEntry = OverlayEntry(
      builder: (overlayContext) => PortalAnimationOverlay(
        onComplete: () {
          _portalOverlayEntry?.remove();
          _portalOverlayEntry = null;
          // PortalAnimationOverlay сам перемкне тему на Незер
          // та покаже досягнення 'nether_portal_opened'
        },
      ),
    );
    // Переконайся, що context має доступ до Overlay
    // Зазвичай це так, якщо context з build методу віджета
    Overlay.of(context).insert(_portalOverlayEntry!);
  }

  // Цей метод може бути корисним для примусового закриття оверлею в рідкісних випадках,
  // але PortalAnimationOverlay повинен сам себе закривати по завершенню.
  // static void disposeOverlay() {
  //   _portalOverlayEntry?.remove();
  //   _portalOverlayEntry = null;
  // }
}