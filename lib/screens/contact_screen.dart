import 'package:flutter/material.dart';
import '../localization/strings.dart';
import '../utils.dart';



class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(context, 'contacts_title'),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 20),
          Text(
            tr(context, 'contacts_subtitle'),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),

          _buildContactButton(
            context: context,
            labelKey: 'contact_github',
            icon: Icons.code,
            url: 'https://github.com/quil1x',
          ),
          const SizedBox(height: 15),
          _buildContactButton(
            context: context,
            labelKey: 'contact_telegram',
            icon: Icons.send,
            url: 'https://t.me/quilix1',
          ),
          const SizedBox(height: 15),
          _buildContactButton(
            context: context,
            labelKey: 'contact_instagram',
            icon: Icons.photo_camera,
            url: 'https://www.instagram.com/luch.kivnazar/',
          ),
           const SizedBox(height: 15),
          _buildContactButton(
            context: context,
            labelKey: 'contact_email',
            icon: Icons.email,
            url: 'mailto:nazarluchkiv12@gmail.com',
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required BuildContext context,
    required String labelKey,
    required IconData icon,
    required String url,
  }) {
    return ElevatedButton.icon(
      onPressed: () => launchURL(context, url),
      icon: Icon(icon, size: 18),
      label: Text(tr(context, labelKey)),
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
         minimumSize: WidgetStateProperty.all(const Size(250, 60)),
         alignment: Alignment.centerLeft,
      ),
    );
  }
}