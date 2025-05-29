import 'package:flutter/material.dart';
import 'nav_item.dart';
import 'settings_bottom_sheet.dart';
import '../localization/strings.dart';
import '../achievement_manager.dart'; 
import 'creeper_explosion_effect.dart'; 

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

  void _showSettingsPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, 
      builder: (BuildContext context) {
        return const SettingsBottomSheet();
      },
    );
  }

  void _triggerCreeperExplosion(BuildContext context) {
    // ⬇️ Використовуємо публічний прапорець
    if (AchievementManager.isCreeperEffectActive || _creeperOverlayEntry != null) return;

    _creeperOverlayEntry = OverlayEntry(
      builder: (context) => CreeperExplosionEffect(
        onEffectComplete: () { 
          _creeperOverlayEntry?.remove();
          _creeperOverlayEntry = null;
          // Ачівку 'survived_creeper' тепер показує сам CreeperExplosionEffect
          // або AchievementManager всередині ефекту.
          // Тут важливо, щоб AchievementManager.setCreeperEffectStatus(false); викликався
          // всередині CreeperExplosionEffect після завершення всіх його дій.
        },
      ),
    );
    Overlay.of(context).insert(_creeperOverlayEntry!);
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
          InkWell(
            onTap: () => _triggerCreeperExplosion(context),
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