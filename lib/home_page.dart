import 'package:flutter/material.dart';
import 'widgets/left_navigation_bar.dart';
import 'screens/about_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/contact_screen.dart';
import 'achievement_manager.dart'; 
import 'localization/strings.dart'; // Для заголовка AppBar

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
    AchievementManager.resetSessionAchievements();
  }

  @override
  void didChangeDependencies() { 
    super.didChangeDependencies();
    if (!_firstVisitAchievementShown && mounted) {
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) {
           AchievementManager.show(context, 'first_visit'); 
           setState(() { 
             _firstVisitAchievementShown = true;
           });
        }
      });
    }
  }

  // Ця функція оновлює вибраний індекс
  void _updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedScreen() {
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

  @override
  Widget build(BuildContext context) {
    // Отримуємо ширину екрана
    final double screenWidth = MediaQuery.of(context).size.width;
    // Визначаємо "точку зламу" - ширину, при якій макет змінюється
    const double breakpoint = 768.0; // Можеш підібрати інше значення

    if (screenWidth < breakpoint) {
      // --- МОБІЛЬНИЙ МАКЕТ ---
      return Scaffold(
        appBar: AppBar(
          title: Text(tr(context, 'portfolioTitle')), // Використовуємо перекладений заголовок
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor, // Колір з теми
          centerTitle: true, // Центруємо заголовок
        ),
        // Бічне меню, що висувається
        drawer: Drawer(
          backgroundColor: Theme.of(context).brightness == Brightness.dark 
              ? const Color(0xFF2D2D2D) 
              : Colors.grey[200], // Колір фону Drawer
          child: LeftNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: (index) {
              _updateSelectedIndex(index);
              Navigator.of(context).pop(); // Закриваємо Drawer після вибору
            },
          ),
        ),
        // Основний контент займає весь екран
        body: _getSelectedScreen(),
      );
    } else {
      // --- ДЕСКТОПНИЙ МАКЕТ (як було раніше) ---
      return Scaffold(
        body: Row(
          children: <Widget>[
            LeftNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) { // Просто оновлюємо індекс для десктопу
                _updateSelectedIndex(index);
              },
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: _getSelectedScreen(),
              ),
            ),
          ],
        ),
      );
    }
  }
}