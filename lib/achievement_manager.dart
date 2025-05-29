import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'widgets/achievement_toast.dart';
import 'xp_notifier.dart'; // Переконайся, що цей імпорт є

class AchievementManager {
  static final Set<String> _unlockedInSession = {};
  static OverlayEntry? _overlayEntry;
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static bool _audioPlayerListenersAdded = false;
  static void _setupAudioPlayerListeners() {
    if (_audioPlayerListenersAdded) return;
    _audioPlayerListenersAdded = true;
    // _audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
    //   print('[AchievementManager] AudioPlayer State: $s');
    // }, onError: (msg) {
    //   print('[AchievementManager] AudioPlayer State Error: $msg');
    // });
    // _audioPlayer.onLog.listen((String msg) {
    //    print('[AchievementManager] AudioPlayer Log: $msg');
    // }, onError: (msg) {
    //     print('[AchievementManager] AudioPlayer Log Error: $msg');
    // });
  }

  static final Map<String, ({IconData icon, String titleKey, String descriptionKey})> _achievementsData = {
    'first_visit': (icon: Icons.explore_outlined, titleKey: 'ach_get_title', descriptionKey: 'ach_first_visit_desc'),
    'play_game': (icon: Icons.sports_esports_outlined, titleKey: 'ach_get_title', descriptionKey: 'ach_play_game_desc'),
    'view_about': (icon: Icons.face_retouching_natural, titleKey: 'ach_get_title', descriptionKey: 'ach_view_about_desc'),
    'view_projects': (icon: Icons.construction_outlined, titleKey: 'ach_get_title', descriptionKey: 'ach_view_projects_desc'),
    'view_contacts': (icon: Icons.connect_without_contact_outlined, titleKey: 'ach_get_title', descriptionKey: 'ach_view_contacts_desc'),
    'open_github_repo': (icon: Icons.code_outlined, titleKey: 'ach_get_title', descriptionKey: 'ach_open_github_repo_desc'),
    'switch_theme': (icon: Icons.brightness_6_outlined, titleKey: 'ach_get_title', descriptionKey: 'ach_switch_theme_desc'),
    'switch_language': (icon: Icons.translate_outlined, titleKey: 'ach_get_title', descriptionKey: 'ach_switch_language_desc'),
    'survived_creeper': (icon: Icons.shield_outlined, titleKey: 'ach_get_title', descriptionKey: 'ach_survived_creeper_desc'),
  };

  static bool isCreeperEffectActive = false; 
  static void setCreeperEffectStatus(bool isActive) {
    isCreeperEffectActive = isActive;
  }

  static void show(BuildContext context, String achievementId) {
    _setupAudioPlayerListeners(); 

    if (_unlockedInSession.contains(achievementId) || !_achievementsData.containsKey(achievementId)) {
      return;
    }
    if (isCreeperEffectActive && achievementId != 'survived_creeper') return;

    _unlockedInSession.add(achievementId);
    // Додаємо XP, тільки якщо це не ачівка за виживання після кріпера,
    // бо XP скидається при смерті.
    if (achievementId != 'survived_creeper') {
      xpNotifier.addXp(); 
    }
    
    final achievementData = _achievementsData[achievementId]!;

    bool shouldPlayAchievementSound = achievementId != 'survived_creeper' && achievementId != 'first_visit';

    if (shouldPlayAchievementSound) {
      final String soundPath = 'audio/minecraft-rare-achievement.mp3';
      _audioPlayer.play(AssetSource(soundPath)).catchError((error) {
        // print('[AchievementManager] Error initiating achievement sound for "$achievementId": $error');
      });
    }

    _overlayEntry?.remove();
    _overlayEntry = null;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        right: 20.0,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, opacity, child) {
            return Opacity(opacity: opacity, child: child);
          },
          child: AchievementToast(
            icon: achievementData.icon,
            titleKey: achievementData.titleKey,
            descriptionKey: achievementData.descriptionKey,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Timer(const Duration(seconds: 4), () {
      if (_overlayEntry != null && _overlayEntry!.mounted) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
  }

  static void resetSessionAchievements() {
    _unlockedInSession.clear();
  }
}