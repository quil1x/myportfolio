import 'package:flutter/material.dart';
import '../language_notifier.dart';

const Map<String, Map<String, String>> localizedStrings = {
  'uk': {
    'portfolioTitle': 'Портфоліо Назарія Лучківа',
    'playerName': 'Назарій Лучків',
    'nav_about': 'Про Мене',
    'nav_about_nether': 'Про Незер', // Для зміни назви "Про мене" в Незері
    'nav_projects': 'Проєкти',
    'nav_contacts': 'Контакти',
    'nav_nether_details': 'Про Незер',  // Для пункту меню, що веде до деталей Незеру
    'nav_settings': 'Налаштування',
    'nav_wiki': 'Minecraft Вікі', // Для нового пункту меню Вікі

    'play_button': 'PLAY (Classic)',
    'about_title': 'ПРО МЕНЕ:',
    'about_text_p1': 'Привіт! Я Назарій Лучків, мені 15 років. Я навчаюся на професію \'Оператор з обробки інформації та програмного забезпечення\'.',
    'about_text_p2': 'Я люблю грати в ігри та дивитися серіали. Мої улюблені ігри – це Red Dead Redemption 2, The Witcher 3: Wild Hunt та The Last of Us. Із серіалів можу виділити \'Пуститися берега\' (Breaking Bad), \'Краще подзвоніть Солу\' (Better Call Saul) та \'Клан Сопрано\' (The Sopranos).',
    'about_text_p3': 'У майбутньому я планую вивчати програмування.',
    
    'nether_about_title': 'ПРО НЕЗЕР (З Minecraft Wiki):', // Заголовок для AboutScreen в Незері
    'nether_about_p1': 'Незер – це небезпечний, схожий на пекло вимір у Minecraft, наповнений океанами лави, вогнем, унікальними блоками та ворожими мобами.',
    'nether_about_p2': 'Тут можна знайти фортеці Незера з цінними скарбами, бастіони піглінів, а також ресурси, такі як кварц, незер-золото, незерак та стародавні уламки для створення незеритового спорядження.',
    'nether_about_p3': 'Подорож у Незер завжди ризикована, але нагороди можуть бути вартими того!',
    
    'nether_details_title': 'Світ Незеру', // Заголовок для NetherDetailsScreen

    'projects_title': 'МОЇ ПРОЄКТИ:',
    'projects_wip_title': 'ЗАПЛАНОВАНО:', // Цей ключ не використовувався, але залишу
    'projects_wip_tag': '(В РОЗРОБЦІ)',
    'project_portfolio_title': 'Pixel Portfolio [Minecraft Style]',
    'project_portfolio_desc': 'Моє портфоліо. Цей сайт зроблено на Flutter та натхненно стилем Minecraft.',
    'project_portfolio_tech': 'Технології: Flutter Web, Dart',
    'projects_insta_title': 'Instagram UI Clone',
    'projects_insta_desc': 'Клон інтерфейсу популярної соціальної мережі Instagram, створений для практики навичок UI/UX у Flutter.',
    'projects_insta_tech': 'Технології: Flutter, Dart',
    'github_button': 'GitHub',
    'site_button': 'Сайт',
    'projects_alpha_title': 'Проєкт "Альфа"',
    'projects_alpha_desc': 'Зараз я активно працюю над цією ідеєю. Більше деталей з\'явиться незабаром!',
    'projects_beta_title': 'Проєкт "Бета"',
    'projects_beta_desc': 'Ще один проєкт у процесі розробки. Слідкуйте за оновленнями на моєму GitHub!',
    
    'contacts_title': 'КОНТАКТИ:',
    'contacts_subtitle': 'ЗАВЖДИ ВІДКРИТИЙ ДО СПІЛКУВАННЯ ТА НОВИХ ІДЕЙ! ЗВ\'ЯЖІТЬСЯ ЗІ МНОЮ:',
    'contact_github': 'GitHub',
    'contact_telegram': 'Telegram',
    'contact_instagram': 'Instagram',
    'contact_email': 'Email',
    
    'settings_title': 'НАЛАШТУВАННЯ',
    'theme_action_activate_night': 'Нічний режим', 
    'theme_action_activate_day': 'Денний режим',   
    'theme_action_exit_nether': 'Покинути Незер',
    'settings_action_enter_nether': 'Портал в Незер', // Для кнопки входу в Незер (раніше в налаштуваннях, зараз для кнопки-порталу)
    'settings_lang_switch': 'Переключити на English',
    'settings_lang_current': 'Поточна мова:',
    
    'wiki_title': 'Minecraft Вікі Пошук',
    'wiki_search_hint': 'Введи назву блоку, предмета, моба...',
    'wiki_search_button': 'Знайти',
    'wiki_no_results': 'Нічого не знайдено',
    'wiki_enter_query': 'Введи щось для пошуку!',
    'wiki_loading': 'Пошук...',

    'error_launch': 'Не вдалося відкрити',
    'ach_get_title': 'Досягнення здобуто!',
    'ach_first_visit_desc': 'Дослідник Портфоліо!',
    'ach_play_game_desc': 'Час для гри!',
    'ach_view_about_desc': 'Знайомство відбулося!',
    'ach_view_projects_desc': 'Майстер Проєктів',
    'ach_view_contacts_desc': 'На Зв\'язку!',
    'ach_open_github_repo_desc': 'Дослідник Коду!',
    'ach_switch_theme_desc': 'Володар Світла і Темряви!',
    'ach_switch_language_desc': 'Поліглот!',
    'ach_survived_creeper_desc': 'Та ти везунчик!',
    'ach_nether_portal_opened_desc': 'Ворота Відкрито!',
    
    'you_died_text': 'ВИ ЗАГИНУЛИ!',
    'respawn_button_text': 'ВІДРОДИТИСЯ',
    'title_screen_button_text': 'ГОЛОВНЕ МЕНЮ',
    'score_text': 'Рахунок: ',
    'xp_label': 'Досвід:',
  },
  'en': {
    'portfolioTitle': 'Nazariy Luchkiv Portfolio',
    'playerName': 'Nazariy Luchkiv',
    'nav_about': 'About Me',
    'nav_about_nether': 'About Nether', // For changing "About Me" title in Nether
    'nav_projects': 'Projects',
    'nav_contacts': 'Contacts',
    'nav_nether_details': 'About Nether', // For the nav item leading to Nether details
    'nav_settings': 'Settings',
    'nav_wiki': 'Minecraft Wiki', // For new Wiki nav item

    'play_button': 'PLAY (Classic)',
    'about_title': 'ABOUT ME:',
    'about_text_p1': 'Hi! I\'m Nazariy Luchkiv, I\'m 15 years old. I\'m studying to become an Information Processing and Software Operator.',
    'about_text_p2': 'I love playing games and watching series. My favorite games are Red Dead Redemption 2, The Witcher 3: Wild Hunt, and The Last of Us. Among the series, I can highlight Breaking Bad, Better Call Saul, and The Sopranos.',
    'about_text_p3': 'In the future, I plan to study programming.',

    'nether_about_title': 'ABOUT THE NETHER (from Minecraft Wiki):', // Title for AboutScreen in Nether
    'nether_about_p1': 'The Nether is a dangerous, hell-like dimension in Minecraft, filled with oceans of lava, fire, unique blocks, and hostile mobs.',
    'nether_about_p2': 'Here you can find Nether Fortresses with valuable loot, Piglin Bastions, and resources such as Nether Quartz, Nether Gold Ore, Netherrack, and Ancient Debris for crafting Netherite gear.',
    'nether_about_p3': 'Traveling to the Nether is always risky, but the rewards can be well worth the challenge!',

    'nether_details_title': 'The Nether Realm', // Title for NetherDetailsScreen

    'projects_title': 'MY PROJECTS:',
    'projects_wip_title': 'PLANNED:',
    'projects_wip_tag': '(IN PROGRESS)',
    'project_portfolio_title': 'Pixel Portfolio [Minecraft Style]',
    'project_portfolio_desc': 'My portfolio. This site was built with Flutter and inspired by the Minecraft style.',
    'project_portfolio_tech': 'Technologies: Flutter Web, Dart',
    'projects_insta_title': 'Instagram UI Clone',
    'projects_insta_desc': 'A clone of the popular social network Instagram\'s interface, created to practice UI/UX skills in Flutter.',
    'projects_insta_tech': 'Technologies: Flutter, Dart',
    'github_button': 'GitHub',
    'site_button': 'Website',
    'projects_alpha_title': 'Project "Alpha"',
    'projects_alpha_desc': 'I am currently actively working on this idea. More details will appear soon!',
    'projects_beta_title': 'Project "Beta"',
    'projects_beta_desc': 'Another project in development. Follow updates on my GitHub!',

    'contacts_title': 'CONTACTS:',
    'contacts_subtitle': 'ALWAYS OPEN TO COMMUNICATION AND NEW IDEAS! CONTACT ME:',
    'contact_github': 'GitHub',
    'contact_telegram': 'Telegram',
    'contact_instagram': 'Instagram',
    'contact_email': 'Email',

    'settings_title': 'SETTINGS',
    'theme_action_activate_night': 'Night Mode', 
    'theme_action_activate_day': 'Day Mode',   
    'theme_action_exit_nether': 'Leave Nether', 
    'settings_action_enter_nether': 'Nether Portal', // For the Nether portal button
    'settings_lang_switch': 'Switch to Ukrainian',
    'settings_lang_current': 'Current language:',

    'wiki_title': 'Minecraft Wiki Search',
    'wiki_search_hint': 'Enter block, item, mob name...',
    'wiki_search_button': 'Search',
    'wiki_no_results': 'Nothing found',
    'wiki_enter_query': 'Enter something to search!',
    'wiki_loading': 'Searching...',

    'error_launch': 'Could not launch',
    'ach_get_title': 'Achievement get!',
    'ach_first_visit_desc': 'Portfolio Explorer!',
    'ach_play_game_desc': 'Time to Play!',
    'ach_view_about_desc': 'Met the Creator!',
    'ach_view_projects_desc': 'Project Artisan',
    'ach_view_contacts_desc': 'Made Contact!',
    'ach_open_github_repo_desc': 'Code Explorer!',
    'ach_switch_theme_desc': 'Master of Light & Shadow!',
    'ach_switch_language_desc': 'Polyglot!',
    'ach_survived_creeper_desc': 'Lucky You!',
    'ach_nether_portal_opened_desc': 'The Gates are Open!',

    'you_died_text': 'YOU DIED!',
    'respawn_button_text': 'RESPAWN',
    'title_screen_button_text': 'TITLE SCREEN',
    'score_text': 'Score: ',
    'xp_label': 'Experience:',
  },
};

String tr(BuildContext context, String key) {
  final locale = languageNotifier.value;
  // print('[DEBUG tr_function] Current language code: ${locale.languageCode}, For Key: "$key" -> Result: "${localizedStrings[locale.languageCode]?[key] ?? "KEY_NOT_FOUND"}"');
  return localizedStrings[locale.languageCode]?[key] ?? key;
}