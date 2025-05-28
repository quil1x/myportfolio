import 'package:flutter/material.dart';

class LanguageNotifier extends ValueNotifier<Locale> {
  LanguageNotifier(super.value);

  static const uk = Locale('uk', 'UA');
  static const en = Locale('en', 'US');

  void switchLanguage() {
    value = value == uk ? en : uk;
  }

  String get currentLanguageName => value == uk ? 'Українська' : 'English';
  String get switchButtonText => value == uk ? 'Switch to English' : 'Переключити на Українську';
}

final languageNotifier = LanguageNotifier(LanguageNotifier.uk);