import 'package:flutter/material.dart';
import 'nav_item.dart';
import 'settings_bottom_sheet.dart';
import '../localization/strings.dart';
import '../achievement_manager.dart';
import 'creeper_explosion_effect.dart';
import 'portal_animation_overlay.dart';
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
  OverlayEntry? _portalOverlayEntry;
  int _playerNameTapCount = 0;

  void _showSettingsPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // Прибираємо backgroundColor: Colors.transparent, щоб фон брався з теми
      builder: (BuildContext context) {
        return const SettingsBottomSheet();
      },
    );
  }

  void _triggerCreeperExplosion(BuildContext context) {
    if (AchievementManager.isCreeperEffectActive || _creeperOverlayEntry != null || _portalOverlayEntry != null) return;

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
        SnackBar(
          backgroundColor: const Color(0xFF5E2612),
          content: const Text(
            'ЯƎHTƎN',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'PressStart2P', fontSize: 14, color: Color(0xFFFF7700)),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() { _playerNameTapCount = 0; });
    }
  }

  void _openNetherPortal(BuildContext context) {
    if (AchievementManager.isCreeperEffectActive || _portalOverlayEntry != null || _creeperOverlayEntry != null) return;

    _portalOverlayEntry = OverlayEntry(
      builder: (context) => PortalAnimationOverlay(
        onComplete: () {
          _portalOverlayEntry?.remove();
          _portalOverlayEntry = null;
        },
      ),
    );
    Overlay.of(context).insert(_portalOverlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentAppThemeMode = themeNotifier.value;
    bool isNetherThemeActive = currentAppThemeMode == AppThemeMode.nether;

    return Container(
      width: 260,
      color: theme.brightness == Brightness.dark && !isNetherThemeActive
              ? const Color(0xFF2D2D2D)
              : (isNetherThemeActive ? theme.cardColor.withAlpha(230) : Colors.grey[200]),
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
          NavItem(
            icon: Icons.person_outline,
            titleKey: 'nav_about',
            isSelected: widget.selectedIndex == 0,
            onTap: () {
              AchievementManager.show(context, 'view_about');
              widget.onItemTapped(0);
            },
          ),
          NavItem(
            icon: Icons.construction_outlined,
            titleKey: 'nav_projects',
            isSelected: widget.selectedIndex == 1,
            onTap: () {
              AchievementManager.show(context, 'view_projects');
              widget.onItemTapped(1);
            },
          ),
          NavItem(
            icon: Icons.chat_bubble_outline,
            titleKey: 'nav_contacts',
            isSelected: widget.selectedIndex == 2,
            onTap: () {
              AchievementManager.show(context, 'view_contacts');
              widget.onItemTapped(2);
            },
          ),
          NavItem(
            icon: isNetherThemeActive ? Icons.door_back_door_outlined : Icons.whatshot_outlined,
            titleKey: 'nav_nether_portal',
            isSelected: isNetherThemeActive,
            onTap: () {
              if (isNetherThemeActive) {
                themeNotifier.cycleThemeSetting();
              } else {
                _openNetherPortal(context);
              }
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