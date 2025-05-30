import 'package:flutter/material.dart';
import 'widgets/left_navigation_bar.dart';
import 'screens/about_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/contact_screen.dart';
import 'achievement_manager.dart'; 
import 'localization/strings.dart';
import 'widgets/xp_bar_widget.dart'; 

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
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedScreen() {
    // ⬇️ ДІАГНОСТИЧНИЙ PRINT ⬇️
    print('[DEBUG HomePage _getSelectedScreen] Selected index: $_selectedIndex, building new screen instance.');
    switch (_selectedIndex) {
      case 0:
        return AboutScreen(); // ⬅️ НЕМАЄ CONST!
      case 1:
        return ProjectsScreen(); // ⬅️ НЕМАЄ CONST!
      case 2:
        return ContactScreen(); // ⬅️ НЕМАЄ CONST!
      default:
        return AboutScreen(); // ⬅️ НЕМАЄ CONST!
    }
  }

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
      return _getSelectedScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double breakpoint = 768.0; 
    bool isDesktop = screenWidth >= breakpoint;
    
    // ⬇️ ДІАГНОСТИЧНИЙ PRINT ⬇️
    print('[DEBUG HomePage build] Building HomePage. isDesktop: $isDesktop. Current locale from context: ${Localizations.localeOf(context).languageCode}');

    return Scaffold(
      appBar: isDesktop 
          ? null 
          : AppBar(
              title: Text(tr(context, 'portfolioTitle')),
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              centerTitle: true,
              iconTheme: Theme.of(context).appBarTheme.iconTheme,
            ),
      drawer: isDesktop 
          ? null 
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
      body: Column(
        children: [
          Expanded(
            child: _buildMainContentArea(isDesktop),
          ),
          const XpBarWidget(), 
        ],
      ),
    );
  }
}