import 'package:flutter/material.dart';
import '../localization/strings.dart'; 
import '../utils.dart'; 
import '../achievement_manager.dart';
import './portal_animation_overlay.dart'; 
import '../theme_notifier.dart'; 

class ProjectCardWidget extends StatefulWidget {
  final String titleKey;
  final String descriptionKey;
  final String techKey;
  final String linkUrl;
  final String? achievementIdOnClick;
  final bool isPortfolioCard;

  const ProjectCardWidget({
    super.key,
    required this.titleKey,
    required this.descriptionKey,
    required this.techKey,
    required this.linkUrl,
    this.achievementIdOnClick,
    this.isPortfolioCard = false,
  });

  @override
  State<ProjectCardWidget> createState() => _ProjectCardWidgetState();
}

class _ProjectCardWidgetState extends State<ProjectCardWidget> {
  int _portfolioCardTapCount = 0;
  OverlayEntry? _portalOverlayEntry;

  void _handleCardTap(BuildContext context) {
    if (widget.isPortfolioCard && themeNotifier.value == AppThemeMode.nether) {
      launchURL(context, widget.linkUrl);
      if (widget.achievementIdOnClick != null) {
        AchievementManager.show(context, widget.achievementIdOnClick!);
      }
      return;
    }

    if (widget.isPortfolioCard) {
      setState(() {
        _portfolioCardTapCount++;
      });

      if (_portfolioCardTapCount >= 5) {
        if (_portalOverlayEntry == null && !AchievementManager.isCreeperEffectActive) { 
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
        setState(() { _portfolioCardTapCount = 0; });
      } else {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Залишилось натиснути: ${5 - _portfolioCardTapCount}...', 
              style: const TextStyle(fontFamily: 'PressStart2P', fontSize: 9, color: Colors.white)
            ),
            duration: const Duration(milliseconds: 800),
            // ⬇️ Виправлено withOpacity
            backgroundColor: Theme.of(context).primaryColor.withAlpha((0.8 * 255).round()), 
          )
        );
      }
    } else {
      launchURL(context, widget.linkUrl);
      if (widget.achievementIdOnClick != null) {
        AchievementManager.show(context, widget.achievementIdOnClick!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _handleCardTap(context),
      // ⬇️ Виправлено withOpacity
      splashColor: theme.primaryColor.withAlpha((0.2 * 255).round()), 
      highlightColor: theme.primaryColor.withAlpha((0.1 * 255).round()), 
      child: Container(
        padding: const EdgeInsets.all(25.0),
        color: theme.cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(context, widget.titleKey).toUpperCase(),
              style: TextStyle( color: theme.primaryColor, fontSize: 14, fontWeight: FontWeight.bold,),
            ),
            const SizedBox(height: 15),
            Text( tr(context, widget.descriptionKey), style: theme.textTheme.bodyLarge?.copyWith(fontSize: 10, height: 1.6),),
            const SizedBox(height: 20),
            Text( tr(context, widget.techKey), style: TextStyle(color: theme.hintColor, fontSize: 9, fontStyle: FontStyle.italic),),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerRight,
              child: AbsorbPointer(
                child: ElevatedButton.icon(
                  onPressed: () {}, 
                  icon: const Icon(Icons.touch_app_outlined, size: 16), 
                  label: Text(widget.linkUrl.contains('github.com/') && !widget.linkUrl.contains('github.io')
                              ? tr(context, 'github_button') 
                              : tr(context, 'site_button')), 
                  style: theme.elevatedButtonTheme.style,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}