import 'package:flutter/material.dart';
import 'dart:ui'; 
import 'widgets/left_navigation_bar.dart';
import 'screens/about_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/nether_details_screen.dart'; 
// import 'screens/minecraft_wiki_screen.dart'; // ВИДАЛЕНО ІМПОРТ
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
      // Якщо в Незері намагаються вибрати індекс 1 (Проекти),
      // який прихований, то нічого не робимо.
      // LeftNavigationBar не має генерувати цей тап.
      return; 
    }
    // Якщо індекс поза межами для поточного режиму (наприклад, 3, а вікі немає)
    // то можна скинути на 0, але краще, щоб LeftNavigationBar не передавав такі індекси.
    // Наразі максимальний індекс, який може прийти - 2 (або 0) для Незера,
    // і 0, 1, 2 для звичайного світу.
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
        // case 3: // ВИДАЛЕНО, бо немає Вікі
        default: return const AboutScreen(); 
      }
    } else { 
      switch (_selectedIndex) {
        case 0: return const AboutScreen();
        case 1: return const ProjectsScreen();
        case 2: return const ContactScreen();
        // case 3: // ВИДАЛЕНО
        default: return const AboutScreen();
      }
    }
  }

  Widget _buildMainContentArea(BuildContext context, bool isDesktop) {
    // ... (код _buildMainContentArea залишається таким, як був у попередній відповіді)
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
    // ... (початок build) ...
    final double screenWidth = MediaQuery.of(context).size.width;
    const double breakpoint = 768.0;
    bool isDesktop = screenWidth >= breakpoint;

    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentAppMode, __) {
        bool isNetherNow = currentAppMode == AppThemeMode.nether;
        // Логіка скидання індексу, якщо він став недійсним при вході в Незер
        if (isNetherNow && _selectedIndex == 1) { // Якщо були "Проекти" (індекс 1)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _updateSelectedIndex(0); // Скидаємо на "Про Незер" (індекс 0)
              }
            });
        }
        // Якщо _selectedIndex був 3 (для вікі), а вікі тепер немає,
        // то при наступному білді _getSelectedScreen поверне AboutScreen за замовчуванням.
        // Це має бути достатньо, бо навігація на індекс 3 більше неможлива.
        
        // ... (решта коду для backgroundImagePath, overlayColor, backgroundDisplayWidget) ...
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

        Widget backgroundDisplayWidget = const SizedBox.shrink();
        if (backgroundImagePath != null) {
          Widget image = Image.asset(
            backgroundImagePath,
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
                child: BackdropFilter( 
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
          appBar: isDesktop ? null : AppBar(
            title: Text(tr(context, 'portfolioTitle')),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor?.withAlpha((0.8 * 255).round()),
            centerTitle: true,
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
          ),
          drawer: isDesktop ? null : Drawer(
            backgroundColor: (Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF2D2D2D)
                : Colors.grey[200])?.withAlpha((0.9 * 255).round()),
            child: LeftNavigationBar( selectedIndex: _selectedIndex, onItemTapped: _updateSelectedIndex ),
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