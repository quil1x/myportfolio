import 'package:flutter/material.dart';
import 'dart:ui';
import 'widgets/left_navigation_bar.dart';
import 'screens/about_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/nether_details_screen.dart';
import 'screens/minecraft_wiki_screen.dart'; // <-- ІМПОРТ ЕКРАНУ ВІКІ
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

    // Індекси:
    // 0: About/AboutNether
    // 1: Projects (тільки не Незер)
    // 2: Contacts (тільки не Незер) / NetherDetails (тільки Незер)
    // 3: Wiki (завжди)

    // Якщо ми в Незері і намагаємося вибрати Projects (індекс 1), це неможливо,
    // бо LeftNavigationBar не повинен генерувати такий тап.
    // Цей код більше для безпеки, якщо індекс зміниться якось інакше.
    if (isNether && index == 1) {
      // print("HomePage: Спроба обрати індекс 1 (Проекти) в Незері. Перенаправляємо на індекс 0 (Про Незер).");
      setState(() { _selectedIndex = 0; });
      return; 
    }
    
    // print("HomePage: _updateSelectedIndex to $index");
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedScreen() {
    final currentAppMode = themeNotifier.value;
    bool isNether = currentAppMode == AppThemeMode.nether;

    // print("HomePage _getSelectedScreen: index = $_selectedIndex, isNether = $isNether");

    if (isNether) {
      switch (_selectedIndex) {
        case 0: return const AboutScreen();         // "Про Незер"
        // індекс 1 (Проекти) недоступний в Незері
        case 2: return const NetherDetailsScreen(); // "Деталі Незеру"
        case 3: return const MinecraftWikiScreen(); // "Вікі"
        default: return const AboutScreen();       // За замовчуванням в Незері
      }
    } else { // Звичайний світ
      switch (_selectedIndex) {
        case 0: return const AboutScreen();
        case 1: return const ProjectsScreen();
        case 2: return const ContactScreen();
        case 3: return const MinecraftWikiScreen(); // "Вікі"
        default: return const AboutScreen();
      }
    }
  }

  Widget _buildMainContentArea(BuildContext context, bool isDesktop) {
    // ... (цей метод залишається без змін відносно попередньої версії з налаштуванням прозорості)
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
            onItemTapped: _updateSelectedIndex, // Передаємо метод напряму
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

    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentAppMode, __) {
        // print("--- HomePage ValueListenableBuilder Rebuild ---");
        // print("Current App Theme Mode: $currentAppMode, Selected Index: $_selectedIndex");

        bool isNetherNow = currentAppMode == AppThemeMode.nether;
        if (isNetherNow && _selectedIndex == 1) { 
          // print("HomePage: Перехід в Незер, індекс був 1 (Проекти), скидаємо на 0.");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _updateSelectedIndex(0); 
            }
          });
        }
        
        String? backgroundImagePath;
        Color overlayColor; 
        // ... (логіка backgroundImagePath та overlayColor як у попередній відповіді)
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
        // ... (логіка backgroundDisplayWidget з Image.asset та BackdropFilter як у попередній відповіді)
        if (backgroundImagePath != null) {
          Widget image = Image.asset(
            backgroundImagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              // print("!!! ПОМИЛКА ЗАВАНТАЖЕННЯ ФОНОВОГО ЗОБРАЖЕННЯ: '$backgroundImagePath' - Помилка: $error");
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
            child: LeftNavigationBar( selectedIndex: _selectedIndex, onItemTapped: _updateSelectedIndex ) 
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