import 'package:flutter/material.dart';
import '../localization/strings.dart';
import '../utils.dart';
import '../achievement_manager.dart'; // Імпорт для ачівок

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: ListView( 
        children: [
          Text(
            tr(context, 'projects_title'),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 30),

          // Картка для Портфоліо
           _buildProjectCard(
            context: context,
            title: tr(context, 'project_portfolio_title'),
            description: tr(context, 'project_portfolio_desc'),
            tech: tr(context, 'project_portfolio_tech'),
            linkUrl: 'https://github.com/quil1x/myportfolio', 
            achievementIdOnClick: 'open_github_repo', // Ачівка для цього посилання
          ),
          const SizedBox(height: 25),

          // Картка для Instagram UI
          _buildProjectCard(
            context: context,
            title: tr(context, 'projects_insta_title'),
            description: tr(context, 'projects_insta_desc'),
            tech: tr(context, 'projects_insta_tech'),
            linkUrl: 'https://github.com/quil1x/Instagram-UI',
            achievementIdOnClick: 'open_github_repo', // Можна ту саму, або іншу
          ),
          const SizedBox(height: 25),

          _buildInProgressCard(
            context: context,
            title: tr(context, 'projects_alpha_title'),
            description: tr(context, 'projects_alpha_desc'),
          ),
          const SizedBox(height: 25),
          _buildInProgressCard(
            context: context,
            title: tr(context, 'projects_beta_title'),
            description: tr(context, 'projects_beta_desc'),
          ),
           const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildProjectCard({
    required BuildContext context,
    required String title,
    required String description,
    required String tech,
    required String linkUrl,
    String? achievementIdOnClick, // Новий параметр для ID ачівки
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(25.0),
      color: theme.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle( color: theme.primaryColor, fontSize: 14, fontWeight: FontWeight.bold,),
          ),
          const SizedBox(height: 15),
          Text( description, style: theme.textTheme.bodyLarge?.copyWith(fontSize: 10, height: 1.6),),
          const SizedBox(height: 20),
          Text( tech, style: TextStyle(color: theme.hintColor, fontSize: 9, fontStyle: FontStyle.italic),),
          const SizedBox(height: 25),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                launchURL(context, linkUrl);
                if (achievementIdOnClick != null) {
                  AchievementManager.show(context, achievementIdOnClick); // Ачівка!
                }
              },
              icon: const Icon(Icons.link, size: 16),
              label: Text(linkUrl.contains('github.com/') && !linkUrl.contains('github.io')
                          ? tr(context, 'github_button') 
                          : tr(context, 'site_button')), 
              style: theme.elevatedButtonTheme.style,
            ),
          ),
        ],
      ),
    );
  }

   Widget _buildInProgressCard({ required BuildContext context, required String title, required String description, }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(25.0),
      color: theme.cardColor.withAlpha(150), // Для візуального розрізнення
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text( title.toUpperCase(), style: TextStyle( color: theme.hintColor, fontSize: 14,),),
              const Spacer(),
              Icon(Icons.hourglass_top_outlined, color: theme.hintColor, size: 18),
              const SizedBox(width: 5),
              Text( tr(context, 'projects_wip_tag'), style: TextStyle(color: theme.hintColor, fontSize: 9),),
            ],
          ),
          const SizedBox(height: 15),
          Text( description, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 10, height: 1.6),),
        ],
      ),
    );
   }
}