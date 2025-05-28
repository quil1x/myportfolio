import 'package:flutter/material.dart';
import 'widgets/left_navigation_bar.dart';
import 'screens/about_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/contact_screen.dart';
import 'achievement_manager.dart'; 

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
           // ⬇️ Викликаємо ачівку БЕЗ ЗВУКУ
           AchievementManager.show(context, 'first_visit', playSound: false); 
           setState(() { 
             _firstVisitAchievementShown = true;
           });
        }
      });
    }
  }

  void _onItemTapped(int index) {
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
    return Scaffold(
      body: Row(
        children: <Widget>[
          LeftNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
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