import 'package:flutter/material.dart';
import 'nav_item.dart';
import 'settings_bottom_sheet.dart';
import '../localization/strings.dart';
import '../achievement_manager.dart'; // Імпорт для ачівок

class LeftNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const LeftNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  void _showSettingsPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, 
      builder: (BuildContext context) {
        return const SettingsBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 260, 
      color: theme.brightness == Brightness.dark 
              ? const Color(0xFF2D2D2D) 
              : Colors.grey[200], 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(Icons.person_pin, color: theme.primaryColor, size: 30),
                const SizedBox(width: 10),
                Text(
                  tr(context, 'playerName'),
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          Divider(color: theme.dividerColor, height: 1),

          NavItem(
            icon: Icons.person_outline,
            titleKey: 'nav_about',
            isSelected: selectedIndex == 0,
            onTap: () {
              AchievementManager.show(context, 'view_about'); // Ачівка!
              onItemTapped(0);
            },
          ),
          NavItem(
            icon: Icons.construction_outlined,
            titleKey: 'nav_projects',
            isSelected: selectedIndex == 1,
            onTap: () {
              AchievementManager.show(context, 'view_projects'); // Ачівка!
              onItemTapped(1);
            },
          ),
          NavItem(
            icon: Icons.chat_bubble_outline,
            titleKey: 'nav_contacts',
            isSelected: selectedIndex == 2,
            onTap: () {
              AchievementManager.show(context, 'view_contacts'); // Ачівка!
              onItemTapped(2);
            },
          ),

          const Spacer(),

          Divider(color: theme.dividerColor, height: 1),
          Material(
             color: Colors.transparent,
             child: InkWell(
              onTap: () => _showSettingsPanel(context),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, color: theme.hintColor, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      tr(context, 'nav_settings'),
                      style: TextStyle(color: theme.hintColor, fontSize: 9),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}