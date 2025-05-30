import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/achievement_toast.dart';
import 'xp_notifier.dart'; 

class AchievementManager {
  static const String _prefsKey = 'unlocked_achievements_v1';
  static Set<String> _unlockedAchievements = {};
  static SharedPreferences? _prefs;

  static OverlayEntry? _overlayEntry;
  static final AudioPlayer _audioPlayer = AudioPlayer();
  // static bool _audioPlayerListenersAdded = false; // Можна прибрати, якщо логування не потрібне
  
  static bool isCreeperEffectActive = false; 

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    final List<String>? unlockedList = _prefs?.getStringList(_prefsKey);
    if (unlockedList != null) {
      _unlockedAchievements = unlockedList.toSet();
    }
    // _setupAudioPlayerListeners(); // Можна викликати, якщо потрібне логування плеєра
    // print('[AchievementManager] Initialized. Unlocked achievements: $_unlockedAchievements');
  }

  // static void _setupAudioPlayerListeners() {
  //   if (_audioPlayerListenersAdded) return;
  //   _audioPlayerListenersAdded = true;
  // }
  
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
  
  static void setCreeperEffectStatus(bool isActive) {
    isCreeperEffectActive = isActive;
  }

  static void show(BuildContext context, String achievementId) {
    // _setupAudioPlayerListeners(); // Якщо потрібне логування

    if (_prefs == null) {
      // print("[AchievementManager] SharedPreferences not initialized! Achievements may not persist correctly.");
      // В екстреному випадку можна спробувати ініціалізувати тут, але це не ідеально
      // initialize().then((_) => _processShow(context, achievementId)); 
      // return; 
       _processShow(context, achievementId); // Продовжуємо, але з можливим ризиком для персистенції
    } else {
      _processShow(context, achievementId);
    }
  }

  static void _processShow(BuildContext context, String achievementId) {
     if (_unlockedAchievements.contains(achievementId) || !_achievementsData.containsKey(achievementId)) {
      return;
    }
    if (isCreeperEffectActive && achievementId != 'survived_creeper') return;

    _unlockedAchievements.add(achievementId); 
    _saveUnlockedAchievements(); 

    if (achievementId != 'survived_creeper' && achievementId != 'first_visit') {
      xpNotifier.addXp(); 
    }
    
    final achievementData = _achievementsData[achievementId]!;
    bool shouldPlaySound = achievementId != 'survived_creeper' && achievementId != 'first_visit';

    if (shouldPlaySound) {
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


  static Future<void> _saveUnlockedAchievements() async {
    await _prefs?.setStringList(_prefsKey, _unlockedAchievements.toList());
    // print('[AchievementManager] Saved unlocked achievements: $_unlockedAchievements');
  }
  
  static Future<void> clearAllPersistedAchievements() async {
    if (_prefs == null) await initialize(); 
    _unlockedAchievements.clear();
    await _prefs?.remove(_prefsKey);
    // print("[AchievementManager] All persisted achievements cleared.");
  }
}