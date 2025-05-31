import 'package:flutter/material.dart';
import 'nav_item.dart';
import 'settings_bottom_sheet.dart';
import '../localization/strings.dart';
import '../achievement_manager.dart'; // Потрібен, якщо викликаєш тут AchievementManager.show()
import 'creeper_explosion_effect.dart'; // Якщо використовується _triggerCreeperExplosion
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
    // print("!!! [LNB] LOG: _showSettingsPanel ВИКЛИКАНО !!!");
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true, 
      builder: (BuildContext builderContext) {
        // print("!!! [LNB] LOG: showModalBottomSheet - BUILDER ВИКЛИКАНО !!!");
        return const SettingsBottomSheet();
      },
    );
  }

  void _triggerCreeperExplosion(BuildContext context) {
    // print("!!! [LNB] LOG: _triggerCreeperExplosion called !!!");
    if (AchievementManager.isCreeperEffectActive || _creeperOverlayEntry != null) return;
    
    _creeperOverlayEntry = OverlayEntry(
      builder: (context) => CreeperExplosionEffect(
        onEffectComplete: () {
          _creeperOverlayEntry?.remove();
          _creeperOverlayEntry = null;
        },
      ),
    );
    try {
      Overlay.of(context).insert(_creeperOverlayEntry!);
    } catch (e) {
      // print("!!! [LNB] LOG: Помилка при вставці CreeperOverlay: $e !!!");
    }
  }

  void _handlePlayerNameTap(BuildContext context) {
    // print("!!! [LNB] LOG: _handlePlayerNameTap called, count: $_playerNameTapCount !!!");
    setState(() { _playerNameTapCount++; });
    if (_playerNameTapCount >= 3) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF5E2612),
          content: Text(
            'ЯƎHTƎN',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'PressStart2P', fontSize: 14, color: Color(0xFFFF7700)),
          ),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() { _playerNameTapCount = 0; });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("!!! [LNB] LOG: Build method for LeftNavigationBar called. SelectedIndex: ${widget.selectedIndex} !!!"); 
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

    List<Widget> navItemsWidgets = [];
    
    navItemsWidgets.add(
      NavItem(
        icon: Icons.person_outline,
        titleKey: isNetherThemeActive ? 'nav_about_nether' : 'nav_about', // Використовує "Пекельні Вітання!"
        isSelected: widget.selectedIndex == 0,
        onTap: () { 
          // AchievementManager.show(context, 'view_about'); 
          widget.onItemTapped(0);
        },
      ),
    );

    if (!isNetherThemeActive) { // Якщо НЕ Незер-тема
      navItemsWidgets.add(
        NavItem(
          icon: Icons.construction_outlined,
          titleKey: 'nav_projects',
          isSelected: widget.selectedIndex == 1,
          onTap: () { 
            // AchievementManager.show(context, 'view_projects');
            widget.onItemTapped(1);
          }
        )
      );
      navItemsWidgets.add(
        NavItem(
          icon: Icons.chat_bubble_outline,
          titleKey: 'nav_contacts',
          isSelected: widget.selectedIndex == 2,
          onTap: () {
            // AchievementManager.show(context, 'view_contacts');
            widget.onItemTapped(2);
          }
        )
      );
    } else { // Якщо Незер-тема
      navItemsWidgets.add(
        NavItem(
          icon: Icons.explore_outlined, 
          titleKey: 'nav_nether_details', 
          isSelected: widget.selectedIndex == 2, 
          onTap: () => widget.onItemTapped(2),
        ),
      );
      // "Битва з Гастом" (індекс 3) - ТІЛЬКИ В НЕЗЕРІ
      navItemsWidgets.add(
        NavItem(
          icon: Icons.whatshot, // Іконка для гри
          titleKey: 'nav_ghast_game', // Ключ локалізації, який ми додали
          isSelected: widget.selectedIndex == 3,
          onTap: () {
            // AchievementManager.show(context, 'played_ghast_game'); // Можна додати ачівку
            widget.onItemTapped(3); // Передаємо індекс 3
          }
        ),
      );
    }
    
    // print("!!! [LNB] LOG: LeftNavigationBar збирається повернути Container. Кількість NavItems: ${navItemsWidgets.length} !!!");
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
          // Використовуємо Column + Expanded для списку елементів, щоб Spacer працював правильно
          // Або, якщо елементів мало і вони фіксовані, можна просто ...navItemsWidgets
          // Якщо навігація може скролитися (багато пунктів), то ListView/SingleChildScrollView,
          // але тоді Spacer працюватиме інакше. Для твоєї кількості пунктів Column достатньо.
          ...navItemsWidgets,
          const Spacer(), // Штовхає кнопку налаштувань вниз
          Divider(color: theme.dividerColor, height: 1),
          Material(
             color: Colors.transparent,
             child: InkWell(
              onTap: () {
                // print("!!! [LNB] LOG: Кнопку 'Налаштування' НАТИСНУТО (onTap спрацював) !!!");
                _showSettingsPanel(context); 
              },
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