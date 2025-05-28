import 'package:flutter/material.dart';
import '../localization/strings.dart'; 
import '../utils.dart'; 
import '../achievement_manager.dart'; // Імпорт!

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              launchURL(context, 'https://classic.minecraft.net/');
              AchievementManager.show(context, 'play_game'); 
            },
            icon: const Icon(Icons.play_arrow, size: 30),
            label: Text(tr(context, 'play_button')),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              textStyle: const TextStyle(fontSize: 18, fontFamily: 'PressStart2P'),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(2.0),
                 side: BorderSide(color: Colors.green.shade700, width: 2)
               ),
            ),
          ),
          const SizedBox(height: 50),
          Text(tr(context, 'about_title'), style: Theme.of(context).textTheme.displaySmall,),
          const SizedBox(height: 15),
          Text(
            '${tr(context, 'about_text_p1')}\n\n' 
            '${tr(context, 'about_text_p2')}\n\n'
            '${tr(context, 'about_text_p3')}',     
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}