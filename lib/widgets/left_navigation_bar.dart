import 'package:flutter/material.dart';
import 'nav_item.dart';
import 'settings_bottom_sheet.dart';
import '../localization/strings.dart';
import '../achievement_manager.dart';
import 'creeper_explosion_effect.dart';
import '../theme_notifier.dart';

class LeftNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const LeftNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<LeftNavigationBar> createState() => _LeftNavigationBarState();
}

class _LeftNavigationBarState extends State<LeftNavigationBar> {
  OverlayEntry? _creeperOverlayEntry;
  int _playerNameTapCount = 0;

  void _showSettingsPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const SettingsBottomSheet();
      },
    );
  }

  void _triggerCreeperExplosion(BuildContext context) {
    if (AchievementManager.isCreeperEffectActive || _creeperOverlayEntry != null) return;
    _creeperOverlayEntry = OverlayEntry(
      builder: (context) => CreeperExplosionEffect(
        onEffectComplete: () {
          _creeperOverlayEntry?.remove();
          _creeperOverlayEntry = null;
        },
      ),
    );
    Overlay.of(context).insert(_creeperOverlayEntry!);
  }

  void _handlePlayerNameTap(BuildContext context) {
    setState(() { _playerNameTapCount++; });
    if (_playerNameTapCount >= 3) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF5E2612),
          content: Text('ЯƎHTƎN', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'PressStart2P', fontSize: 14, color: Color(0xFFFF7700))),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() { _playerNameTapCount = 0; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentAppMode = themeNotifier.value;
    bool isNetherThemeActive = currentAppMode == AppThemeMode.nether;

    double navBarOpacity = 0.85;
    Color navBarColor;
    if (theme.brightness == Brightness.dark && !isNetherThemeActive) {
      navBarColor = const Color(0xFF2D2D2D).withAlpha((navBarOpacity * 255).round());
    } else if (isNetherThemeActive) {
      navBarColor = theme.cardColor.withAlpha((navBarOpacity * 230).round());
    } else {
      navBarColor = (Colors.grey[200] ?? Colors.grey.shade200).withAlpha((navBarOpacity * 255).round());
    }

    List<Widget> navItems = [];

    navItems.add(
      NavItem(
        icon: Icons.person_outline,
        titleKey: isNetherThemeActive ? 'nav_about_nether' : 'nav_about',
        isSelected: widget.selectedIndex == 0,
        onTap: () => widget.onItemTapped(0),
      ),
    );

    if (!isNetherThemeActive) {
      navItems.add(
        NavItem(
          icon: Icons.construction_outlined,
          titleKey: 'nav_projects',
          isSelected: widget.selectedIndex == 1,
          onTap: () => widget.onItemTapped(1),
        ),
      );
      navItems.add(
        NavItem(
          icon: Icons.chat_bubble_outline,
          titleKey: 'nav_contacts',
          isSelected: widget.selectedIndex == 2,
          onTap: () => widget.onItemTapped(2),
        ),
      );
    } else {
      navItems.add(
        NavItem(
          icon: Icons.explore_outlined, 
          titleKey: 'nav_nether_details',
          isSelected: widget.selectedIndex == 2,
          onTap: () => widget.onItemTapped(2),
        ),
      );
    }

    // Додаємо Вікі як останній пункт основного меню (індекс 3)
    navItems.add(
      NavItem(
        icon: Icons.menu_book_outlined, 
        titleKey: 'nav_wiki',           
        isSelected: widget.selectedIndex == 3, // Новий індекс
        onTap: () {
          // AchievementManager.show(context, 'used_wiki'); // Можна додати ачівку
          widget.onItemTapped(3); // Новий індекс
        },
      ),
    );

    return Container(
      width: 260,
      color: navBarColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () => _handlePlayerNameTap(context),
            onLongPress: () => _triggerCreeperExplosion(context),
            child: Padding(
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
          ),
          Divider(color: theme.dividerColor, height: 1),
          ...navItems,
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