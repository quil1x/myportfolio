import 'package:flutter/material.dart';
import 'dart:ui'; // Для ImageFilter та BackdropFilter

import 'screens/about_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/ghast_game_screen.dart';
import 'screens/nether_details_screen.dart';
import 'screens/projects_screen.dart';
import 'widgets/left_navigation_bar.dart'; // Потрібен
import 'widgets/xp_bar_widget.dart';     // Потрібен
import 'localization/strings.dart';     // Потрібен для tr()
import 'theme_notifier.dart';
import 'language_notifier.dart';
import 'achievement_manager.dart'; // Потрібен для first_visit

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _firstVisitAchievementShown = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_firstVisitAchievementShown && mounted) {
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) {
          AchievementManager.show(context, 'first_visit');
          // setState(() { // Цей setState може бути зайвим, якщо _firstVisitAchievementShown не впливає на UI
            _firstVisitAchievementShown = true;
          // });
        }
      });
    }
  }

  void _updateSelectedIndex(int index) {
    final currentAppMode = themeNotifier.value;
    bool isNether = currentAppMode == AppThemeMode.nether;
    int newIndex = index;

    if (isNether) {
      if (index == 1) {newIndex = 0;}
      else if (index != 0 && index != 2 && index != 3) {newIndex = 0;}
    } else {
      if (index < 0 || index > (_isGhastGameAvailableOnlyInNether() ? 2 : 2) ) { // Індекс 3 (гра) прибрали зі звичайного світу
          newIndex = 0;
      }
    }
    
    if (mounted && _selectedIndex != newIndex) {
        setState(() {
          _selectedIndex = newIndex;
        });
    }
  }

  bool _isGhastGameAvailableOnlyInNether() {
    return true; 
  }

  Widget _getSelectedScreen() {
    final currentAppMode = themeNotifier.value;
    bool isNether = currentAppMode == AppThemeMode.nether;
    
    if (isNether) {
      switch (_selectedIndex) {
        case 0: return const AboutScreen();
        case 2: return const NetherDetailsScreen(); 
        case 3: return const GhastGameScreen(); 
        default: return const AboutScreen(); 
      }
    } else { 
      switch (_selectedIndex) {
        case 0: return const AboutScreen();
        case 1: return const ProjectsScreen();
        case 2: return const ContactScreen();
        default: return const AboutScreen();
      }
    }
  }
  
  Widget _buildMainContentArea(BuildContext context, bool isDesktop) { // Переконайся, що цей метод є
    final currentTheme = Theme.of(context);
    Color contentBackgroundColor = currentTheme.scaffoldBackgroundColor;
    double opacityFactor = 0.75; 
    contentBackgroundColor = contentBackgroundColor.withAlpha((opacityFactor * 255).round());

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch, 
        children: <Widget>[
          LeftNavigationBar( 
            selectedIndex: _selectedIndex,
            onItemTapped: _updateSelectedIndex,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: contentBackgroundColor,
              child: _getSelectedScreen(),
            ),
          ),
        ],
      );
    } else {
      return Container(
        color: contentBackgroundColor, 
        padding: const EdgeInsets.all(8.0), 
        child: _getSelectedScreen(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double breakpoint = 768.0; 
    bool isDesktop = screenWidth >= breakpoint;

    return ValueListenableBuilder<Locale>(
      valueListenable: languageNotifier,
      builder: (context, currentLocale, _) {
        return ValueListenableBuilder<AppThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentAppMode, __) {
            bool isNetherNow = currentAppMode == AppThemeMode.nether;
            
            if (isNetherNow && _selectedIndex == 1) { 
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) { _updateSelectedIndex(0); }
                });
            } else if (!isNetherNow && _selectedIndex == 3 && _isGhastGameAvailableOnlyInNether()) { 
                 WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) { _updateSelectedIndex(0); }
                });
            }
            
            String? backgroundImagePath;
            Color overlayColor; 

            if (currentAppMode == AppThemeMode.light) {
              backgroundImagePath = 'assets/images/minecraft_day_bg.png'; 
              overlayColor = Colors.white.withAlpha((0.05 * 255).round()); 
            } else if (currentAppMode == AppThemeMode.dark) {
              backgroundImagePath = 'assets/images/minecraft_night_bg.png'; 
              overlayColor = Colors.black.withAlpha((0.15 * 255).round()); 
            } else if (currentAppMode == AppThemeMode.nether) {
              backgroundImagePath = 'assets/images/minecraft_nether_bg.png'; 
              overlayColor = Colors.black.withAlpha((0.4 * 255).round());
            } else {
              backgroundImagePath = null; 
              overlayColor = Colors.transparent; 
            }

            Widget backgroundDisplayWidget;
            if (backgroundImagePath != null) {
              Widget imageWidget = Image.asset( // ВИПРАВЛЕНО: передаємо шлях
                backgroundImagePath, 
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container( 
                    color: Colors.red.withAlpha(150),
                    child: Center(
                      child: Text(
                        "ПОМИЛКА ФОНУ:\n'$backgroundImagePath'",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  );
                },
              );

              // Застосовуємо блюр, якщо це не екран гри в Незері
              bool applyGlobalBlur = !(_selectedIndex == 3 && isNetherNow);

              if (applyGlobalBlur) {
                backgroundDisplayWidget = Stack(
                  fit: StackFit.expand,
                  children: [
                    imageWidget, 
                    ClipRect(
                      child: BackdropFilter( // ВИПРАВЛЕНО: додано filter
                        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0), 
                        child: Container(
                          color: Colors.black.withAlpha((0.01 * 255).round()), 
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                backgroundDisplayWidget = imageWidget; // Без блюру для екрану гри
              }
            } else {
              backgroundDisplayWidget = const SizedBox.shrink(); 
            }

            return Scaffold(
              backgroundColor: Colors.transparent, 
              appBar: isDesktop 
                  ? null 
                  : AppBar(
                      title: Text(tr(context, 'portfolioTitle')),
                      backgroundColor: Theme.of(context).appBarTheme.backgroundColor?.withAlpha((0.8 * 255).round()),
                      centerTitle: true,
                      iconTheme: Theme.of(context).appBarTheme.iconTheme,
                    ),
              drawer: isDesktop 
                  ? null 
                  : Drawer(
                      backgroundColor: (Theme.of(context).brightness == Brightness.dark 
                          ? const Color(0xFF2D2D2D) 
                          : Colors.grey[200])?.withAlpha((0.9 * 255).round()),
                      child: LeftNavigationBar( selectedIndex: _selectedIndex, onItemTapped: _updateSelectedIndex ),
                    ),
              body: Stack(
                children: [
                  Positioned.fill(child: backgroundDisplayWidget),
                  if (!(_selectedIndex == 3 && isNetherNow)) // Не показувати глобальний оверлей, якщо це екран гри
                     Positioned.fill(child: Container(color: overlayColor)), 
                  Column(
                    children: [
                      Expanded(
                        child: _buildMainContentArea(context, isDesktop),
                      ),
                      const XpBarWidget(), 
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }
}