import 'package:flutter/material.dart';
import '../localization/strings.dart';
import '../widgets/project_card_widget.dart'; // Переконайся, що цей віджет також коректно використовує tr()
import '../language_notifier.dart'; // Важливий імпорт

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: languageNotifier, // Слухаємо зміни мови
      builder: (context, currentLocale, child) {
        // Цей builder буде викликатися щоразу, коли змінюється currentLocale
        return Padding(
          padding: const EdgeInsets.all(40.0),
          child: ListView(
            children: [
              Text(
                tr(context, 'projects_title'), // Має оновлюватися
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 30),
              const ProjectCardWidget(
                titleKey: 'project_portfolio_title',
                descriptionKey: 'project_portfolio_desc',
                techKey: 'project_portfolio_tech',
                linkUrl: 'https://github.com/quil1x/myportfolio',
                achievementIdOnClick: 'open_github_repo',
              ),
              const SizedBox(height: 25),
              const ProjectCardWidget(
                titleKey: 'projects_insta_title',
                descriptionKey: 'projects_insta_desc',
                techKey: 'projects_insta_tech',
                linkUrl: 'https://github.com/quil1x/Instagram-UI',
                achievementIdOnClick: 'open_github_repo',
              ),
              const SizedBox(height: 25),
              _buildInProgressCard( // Передаємо context для tr() всередині
                context,
                titleKey: 'projects_alpha_title',
                descriptionKey: 'projects_alpha_desc',
              ),
              const SizedBox(height: 25),
              _buildInProgressCard( // Передаємо context для tr() всередині
                context,
                titleKey: 'projects_beta_title',
                descriptionKey: 'projects_beta_desc',
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInProgressCard(
    BuildContext context, { // context потрібен для tr()
    required String titleKey,
    required String descriptionKey,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(25.0),
      color: theme.cardColor.withAlpha((150 * 255 / 255).round()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                tr(context, titleKey).toUpperCase(),
                style: TextStyle(
                  color: theme.hintColor,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Icon(Icons.hourglass_top_outlined, color: theme.hintColor, size: 18),
              const SizedBox(width: 5),
              Text(
                tr(context, 'projects_wip_tag'),
                style: TextStyle(color: theme.hintColor, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            tr(context, descriptionKey),
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 10, height: 1.6),
          ),
        ],
      ),
    );
  }
}