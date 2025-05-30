import 'package:flutter/material.dart';

enum AppThemeMode { light, dark, nether } 

class ThemeNotifier extends ValueNotifier<AppThemeMode> {
  ThemeNotifier(super.value); 

  AppThemeMode _previousThemeBeforeNether = AppThemeMode.dark;

  void switchToLight() {
    value = AppThemeMode.light;
    _previousThemeBeforeNether = AppThemeMode.light;
  }

  void switchToDark() {
    value = AppThemeMode.dark;
    _previousThemeBeforeNether = AppThemeMode.dark;
  }

  void switchToNether() {
    if (value != AppThemeMode.nether) { 
        _previousThemeBeforeNether = value;
    }
    value = AppThemeMode.nether;
  }

  void cycleThemeSetting() {
    if (value == AppThemeMode.nether) {
      value = _previousThemeBeforeNether;
    } else if (value == AppThemeMode.light) {
      switchToDark();
    } else { 
      switchToLight();
    }
  }

  IconData get currentThemeIcon {
    // Іконка показує, на що ми ПЕРЕЙДЕМО, або дію
    if (value == AppThemeMode.light) return Icons.nightlight_round_outlined; // Зараз світло, іконка місяця (перейти на ніч)
    if (value == AppThemeMode.dark) return Icons.wb_sunny_outlined;      // Зараз темно, іконка сонця (перейти на день)
    return Icons.door_back_door_outlined; // Зараз Незер, іконка виходу
  }

  String get currentThemeSwitchTextKey {
     // Текст описує дію або наступний режим
     if (value == AppThemeMode.light) return 'theme_action_activate_night'; 
     if (value == AppThemeMode.dark) return 'theme_action_activate_day';   
     return 'theme_action_exit_nether'; 
  }
}

final themeNotifier = ThemeNotifier(AppThemeMode.dark);