import 'package:flutter/material.dart';
import 'widgets/left_navigation_bar.dart';
import 'screens/about_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/contact_screen.dart';
import 'achievement_manager.dart'; 
import 'localization/strings.dart';
import 'widgets/xp_bar_widget.dart'; // ⬅️ Імпортуємо нашу шкалу XP!

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

  // Нова функція для побудови основного контенту, щоб уникнути дублювання
  Widget _buildMainContentArea(bool isDesktop) {
    if (isDesktop) {
      return Row(
        children: <Widget>[
          LeftNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: (index) {
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
      );
    } else {
      // Для мобільного, AppBar та Drawer керуються Scaffold вище
      return _getSelectedScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double breakpoint = 768.0; 
    bool isDesktop = screenWidth >= breakpoint;

    return Scaffold(
      appBar: isDesktop 
          ? null // Немає AppBar на десктопі
          : AppBar(
              title: Text(tr(context, 'portfolioTitle')),
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              centerTitle: true,
            ),
      drawer: isDesktop 
          ? null // Немає Drawer на десктопі
          : Drawer(
              backgroundColor: Theme.of(context).brightness == Brightness.dark 
                  ? const Color(0xFF2D2D2D) 
                  : Colors.grey[200],
              child: LeftNavigationBar(
                selectedIndex: _selectedIndex,
                onItemTapped: (index) {
                  _updateSelectedIndex(index);
                  Navigator.of(context).pop(); 
                },
              ),
            ),
      body: Column( // ⬅️ Головний контент тепер у Column
        children: [
          Expanded(
            child: _buildMainContentArea(isDesktop), // ⬅️ Основна частина
          ),
          const XpBarWidget(), // ⬅️ Наша шкала досвіду ВНИЗУ!
        ],
      ),
    );
  }
}