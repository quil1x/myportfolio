import 'package:flutter/material.dart';
import 'dart:ui'; // Залишаємо для ImageFilter та BackdropFilter для явності
import 'widgets/left_navigation_bar.dart';
import 'screens/about_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/nether_details_screen.dart'; 
import 'screens/ghast_game_screen.dart'; // Якщо ти додав гру
import 'achievement_manager.dart'; 
import 'localization/strings.dart'; // Потрібен для tr() в AppBar
import 'widgets/xp_bar_widget.dart'; 
import 'theme_notifier.dart';
import 'language_notifier.dart'; 

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
           _firstVisitAchievementShown = true; 
        }
      });
    }
  }

  void _updateSelectedIndex(int index) {
    final currentAppMode = themeNotifier.value;
    bool isNether = currentAppMode == AppThemeMode.nether;

    if (isNether && index == 1) {
      return; 
    }
    if (isNether && (index < 0 || index == 1 || index > 3)) { // 3 - індекс гри
      index = 0;
    }
    if (!isNether && (index < 0 || index > 3)) { // 3 - індекс гри
       index = 0;
    }
    
    setState(() {
      _selectedIndex = index;
    });
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
        case 3: return const GhastGameScreen(); 
        default: return const AboutScreen();
      }
    }
  }

  Widget _buildMainContentArea(BuildContext context, bool isDesktop) {
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
                  if (mounted) {
                    _updateSelectedIndex(0); 
                  }
                });
            }
            
            String? backgroundImagePath;
            Color overlayColor; // Ініціалізуємо пізніше

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
              // Забезпечуємо, що overlayColor завжди ініціалізований
              backgroundImagePath = null;
              overlayColor = Colors.transparent; 
            }

            Widget backgroundDisplayWidget = const SizedBox.shrink();
            if (backgroundImagePath != null) { // Ця перевірка вже гарантує, що backgroundImagePath не null
              Widget image = Image.asset( // ВИПРАВЛЕНО: додано аргумент шляху
                backgroundImagePath, // Не може бути null тут через перевірку вище
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container( 
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
                    child: BackdropFilter( // ВИПРАВЛЕНО: Додано filter
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), 
                      child: Container(
                        color: Colors.black.withAlpha((0.01 * 255).round()), 
                      ),
                    ),
                  ),
                ],
              );
            }

            return Scaffold(
              backgroundColor: Colors.transparent, 
              appBar: isDesktop 
                  ? null 
                  : AppBar(
                      title: Text(tr(context, 'portfolioTitle')), // tr() використовується тут
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
                  // Умова if (backgroundImagePath != null) тут вже не потрібна,
                  // бо backgroundDisplayWidget буде SizedBox.shrink(), якщо шлях null
                  Positioned.fill(child: backgroundDisplayWidget),
                  Positioned.fill(child: Container(color: overlayColor)), // overlayColor тепер завжди ініціалізований
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