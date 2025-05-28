import 'package:flutter/material.dart';
import '../localization/strings.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String titleKey; 
  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.titleKey,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: isSelected ? theme.primaryColor.withAlpha(38) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: theme.primaryColor.withAlpha(77),
        highlightColor: theme.primaryColor.withAlpha(25),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isSelected ? theme.primaryColor : Colors.transparent,
                width: 4.0,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: theme.iconTheme.color, size: 20),
              const SizedBox(width: 15),
              Text(
                tr(context, titleKey),
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}