import 'package:flutter/material.dart';
import 'dart:ui'; // Для ImageFilter та BackdropFilter
import 'widgets/left_navigation_bar.dart';
import 'screens/about_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/contact_screen.dart';
import 'achievement_manager.dart';
import 'localization/strings.dart';
import 'widgets/xp_bar_widget.dart';
import 'theme_notifier.dart';

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
    // Додамо слухача для themeNotifier, щоб бачити зміни теми в консолі
    // themeNotifier.addListener(_logThemeChange); // Можна додати, якщо потрібно
  }

  // void _logThemeChange() {
  //   print("HomePage Listener: Тема змінилася на ${themeNotifier.value}");
  // }

  @override
  void dispose() {
    // themeNotifier.removeListener(_logThemeChange); // Не забути видалити слухача
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_firstVisitAchievementShown && mounted) {
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) {
           AchievementManager.show(context, 'first_visit');
           _firstVisitAchievementShown = true;
        }
      });
    }
  }

  void _updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedScreen() {
    // print('[DEBUG HomePage _getSelectedScreen] Selected index: $_selectedIndex, building new screen instance.');
    switch (_selectedIndex) {
      case 0:
        return const AboutScreen();
      case 1:
        return const ProjectsScreen();
      case 2:
        return const ContactScreen();
      default:
        return const AboutScreen();
    }
  }

  Widget _buildMainContentArea(BuildContext context, bool isDesktop) {
    final currentTheme = Theme.of(context);
    Color contentBackgroundColor = currentTheme.scaffoldBackgroundColor;
    
    double opacityFactor = 0.75; 
    // if (themeNotifier.value == AppThemeMode.light) {
    //   opacityFactor = 0.85; 
    // }
    contentBackgroundColor = contentBackgroundColor.withAlpha((opacityFactor * 255).round());

    // --- Тимчасова візуальна дебаг-підказка для фону контенту ---
    // Color tempDebugContentBg;
    // final currentAppModeForDebug = themeNotifier.value; // Отримуємо поточну тему для дебагу
    // if (currentAppModeForDebug == AppThemeMode.light) {
    //   tempDebugContentBg = Colors.yellow.withAlpha(80);
    //   print("DEBUG: _buildMainContentArea -> Light Theme -> Yellowish BG");
    // } else if (currentAppModeForDebug == AppThemeMode.dark) {
    //   tempDebugContentBg = Colors.blue.withAlpha(80);
    //   print("DEBUG: _buildMainContentArea -> Dark Theme -> Bluish BG");
    // } else if (currentAppModeForDebug == AppThemeMode.nether) {
    //   tempDebugContentBg = Colors.purple.withAlpha(80);
    //   print("DEBUG: _buildMainContentArea -> Nether Theme -> Purplish BG");
    // } else {
    //   tempDebugContentBg = Colors.grey.withAlpha(80);
    //   print("DEBUG: _buildMainContentArea -> Unknown Theme -> Greyish BG");
    // }
    // Замість contentBackgroundColor нижче можна тимчасово поставити tempDebugContentBg
    // ---------------------------------------------------------

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch, 
        children: <Widget>[
          LeftNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: (index) {
              _updateSelectedIndex(index);
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: contentBackgroundColor, // Або tempDebugContentBg для тесту
              child: _getSelectedScreen(),
            ),
          ),
        ],
      );
    } else {
      return Container(
        color: contentBackgroundColor, // Або tempDebugContentBg для тесту
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

    // print("[DEBUG HomePage build] Rebuilding HomePage. Current selectedIndex: $_selectedIndex");

    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentAppMode, __) {
        print("--- HomePage ValueListenableBuilder Rebuild ---");
        print("Current App Theme Mode from Notifier: $currentAppMode");

        String? backgroundImagePath;
        Color overlayColor; 

        if (currentAppMode == AppThemeMode.light) {
          backgroundImagePath = 'assets/images/minecraft_day_bg.png'; // ЗАМІНИ НА СВІЙ ШЛЯХ
          overlayColor = Colors.white.withAlpha((0.05 * 255).round());
          print("Selected for Light Theme: $backgroundImagePath");
        } else if (currentAppMode == AppThemeMode.dark) {
          backgroundImagePath = 'assets/images/minecraft_night_bg.png'; // ЗАМІНИ НА СВІЙ ШЛЯХ
          overlayColor = Colors.black.withAlpha((0.15 * 255).round()); 
          print("Selected for Dark Theme: $backgroundImagePath");
        } else if (currentAppMode == AppThemeMode.nether) {
          backgroundImagePath = 'assets/images/minecraft_nether_bg.png'; // ЗАМІНИ НА СВІЙ ШЛЯХ
          overlayColor = Colors.black.withAlpha((0.4 * 255).round());
          print("Selected for Nether Theme: $backgroundImagePath");
        } else {
          backgroundImagePath = null;
          overlayColor = Colors.transparent;
          print("No theme matched, no background image.");
        }

        Widget backgroundDisplayWidget = const SizedBox.shrink();
        if (backgroundImagePath != null) {
          Widget image = Image.asset(
            backgroundImagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              print("!!! ПОМИЛКА ЗАВАНТАЖЕННЯ ФОНОВОГО ЗОБРАЖЕННЯ: '$backgroundImagePath' - Помилка: $error");
              return Container( // Візуальна підказка про помилку
                color: Colors.red.withAlpha(150),
                child: Center(
                  child: Text(
                    "ПОМИЛКА ФОНУ:\nНе вдалося завантажити\n'$backgroundImagePath'",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );

          backgroundDisplayWidget = Stack(
            fit: StackFit.expand,
            children: [
              image,
              ClipRect(
                child: BackdropFilter( 
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), 
                  child: Container(
                    color: Colors.black.withAlpha((0.01 * 255).round()), 
                  ),
                ),
              ),
            ],
          );
        } else {
          print("backgroundImagePath is null, backgroundDisplayWidget will be SizedBox.shrink()");
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
                  child: LeftNavigationBar(
                    selectedIndex: _selectedIndex,
                    onItemTapped: (index) {
                      _updateSelectedIndex(index);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
          body: Stack(
            children: [
              if (backgroundImagePath != null) Positioned.fill(child: backgroundDisplayWidget),
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
}