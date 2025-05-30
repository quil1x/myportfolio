import 'package:flutter/material.dart';
import '../localization/strings.dart';
import '../language_notifier.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Для TimeoutException

class MinecraftWikiScreen extends StatefulWidget {
  const MinecraftWikiScreen({super.key});

  @override
  State<MinecraftWikiScreen> createState() => _MinecraftWikiScreenState();
}

class _MinecraftWikiScreenState extends State<MinecraftWikiScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchResultText = "";
  bool _isLoading = false;
  String _lastQuery = "";

  Future<String> _fetchWikiExtract(String pageTitle) async {
    if (!mounted) {
      print("[WIKI DEBUG] _fetchWikiExtract: Віджет не примонтовано на старті.");
      return "";
    }

    final trimmedPageTitle = pageTitle.trim();
    if (trimmedPageTitle.isEmpty) {
      print("[WIKI DEBUG] _fetchWikiExtract: Порожній запит після trim.");
      return "";
    }

    final encodedPageTitle = Uri.encodeComponent(trimmedPageTitle);
    final url = Uri.parse(
        'https://minecraft.wiki/w/api.php?action=query&prop=extracts&exintro&explaintext&titles=$encodedPageTitle&format=json&origin=*');
    
    print("[WIKI DEBUG] _fetchWikiExtract: Формуємо URL: $url");

    try {
      print("[WIKI DEBUG] _fetchWikiExtract: Починаю HTTP GET запит...");
      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          print("[WIKI DEBUG] _fetchWikiExtract: Таймаут запиту!");
          // Повертаємо null або кидаємо TimeoutException, щоб catch обробив це
          throw TimeoutException('Запит до Wiki API тривав занадто довго.');
        },
      );
      
      print("[WIKI DEBUG] _fetchWikiExtract: Отримано відповідь. Статус код: ${response.statusCode}");
      
      // Розкоментуй, щоб побачити повне тіло відповіді, якщо потрібно
      // print("[WIKI DEBUG] _fetchWikiExtract: Тіло відповіді: ${response.body}");

      if (!mounted) {
        print("[WIKI DEBUG] _fetchWikiExtract: Віджет не примонтовано після HTTP запиту.");
        return "";
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("[WIKI DEBUG] _fetchWikiExtract: JSON розкодовано успішно.");
        
        final queryData = data['query'];
        if (queryData == null) {
          print("[WIKI DEBUG] _fetchWikiExtract: У відповіді відсутній ключ 'query'.");
          return "";
        }

        final pages = queryData['pages'];
        if (pages != null && pages.isNotEmpty) {
          print("[WIKI DEBUG] _fetchWikiExtract: Знайдено 'pages' у відповіді.");
          
          final pageEntry = pages.entries.first; 
          final pageData = pageEntry.value;

          if (pageData != null) {
            if (pageData['missing'] != null) {
              print("[WIKI DEBUG] _fetchWikiExtract: Сторінку '$trimmedPageTitle' позначено API як 'missing'.");
              return ""; 
            }
            if (pageData['invalid'] != null) {
              print("[WIKI DEBUG] _fetchWikiExtract: Запит для '$trimmedPageTitle' позначено API як 'invalid'.");
              return "";
            }
            if (pageData['extract'] != null && pageData['extract'].isNotEmpty) {
              print("[WIKI DEBUG] _fetchWikiExtract: Екстракт знайдено для '$trimmedPageTitle'. Довжина: ${pageData['extract'].length}");
              return pageData['extract'];
            } else {
              print("[WIKI DEBUG] _fetchWikiExtract: Екстракт для '$trimmedPageTitle' порожній або відсутній у відповіді API.");
              return ""; 
            }
          } else {
             print("[WIKI DEBUG] _fetchWikiExtract: pageData (значення першої сторінки) є null для '$trimmedPageTitle'.");
             return "";
          }
        } else {
          print("[WIKI DEBUG] _fetchWikiExtract: Ключ 'pages' відсутній, порожній або має невірний формат у відповіді API для '$trimmedPageTitle'.");
        }
      } else {
        print("[WIKI DEBUG] _fetchWikiExtract: Помилка HTTP запиту. Статус код: ${response.statusCode} для '$trimmedPageTitle'.");
      }
    } on TimeoutException catch (e) {
      print("[WIKI DEBUG] _fetchWikiExtract: Таймаут запиту для '$trimmedPageTitle': $e");
      // Тут можна оновити UI, щоб показати помилку таймауту
      if (mounted) {
        // setState(() { _searchResultText = "Сервер не відповів вчасно. Спробуйте пізніше."; });
      }
    } catch (e, s) { 
      print("[WIKI DEBUG] _fetchWikiExtract: ВИНЯТОК під час запиту або обробки для '$trimmedPageTitle': $e");
      print("[WIKI DEBUG] _fetchWikiExtract: StackTrace: $s");
    }
    print("[WIKI DEBUG] _fetchWikiExtract: Функція завершилася, повертаючи порожній рядок для '$trimmedPageTitle'.");
    return ""; 
  }

  Future<void> _performSearch(String query) async {
    print("[WIKI DEBUG] _performSearch: Початок пошуку для '$query'");
    if (!mounted) {
      print("[WIKI DEBUG] _performSearch: Віджет не примонтовано на старті.");
      return;
    }

    final currentQuery = query.trim();
    _lastQuery = currentQuery; 

    if (currentQuery.isEmpty) {
      print("[WIKI DEBUG] _performSearch: Порожній запит.");
      if (!mounted) return;
      setState(() {
        _searchResultText = tr(context, 'wiki_enter_query');
        _isLoading = false;
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _searchResultText = "${tr(context, 'wiki_loading')} ('$currentQuery')";
    });
    print("[WIKI DEBUG] _performSearch: Встановлено isLoading=true, текст 'Завантаження...'");

    String foundText = await _fetchWikiExtract(currentQuery);
    
    // Обрізаємо для логу, якщо текст задовгий
    String logFoundText = foundText.length > 100 ? "${foundText.substring(0, 100)}..." : foundText;
    print("[WIKI DEBUG] _performSearch: _fetchWikiExtract повернув: '$logFoundText'");
    
    if (!mounted) {
      print("[WIKI DEBUG] _performSearch: Віджет не примонтовано після _fetchWikiExtract.");
      return;
    }

    setState(() {
      if (foundText.isNotEmpty) {
        _searchResultText = foundText;
        print("[WIKI DEBUG] _performSearch: Текст знайдено і встановлено в UI.");
      } else {
        _searchResultText = "${tr(context, 'wiki_no_results')} для запиту '$_lastQuery'";
        print("[WIKI DEBUG] _performSearch: Текст не знайдено, встановлено 'Нічого не знайдено' в UI.");
      }
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("[WIKI DEBUG] Build методі MinecraftWikiScreen");
    return ValueListenableBuilder<Locale>(
      valueListenable: languageNotifier,
      builder: (context, currentLocale, child) {
        // print("[WIKI DEBUG] ValueListenableBuilder для мови перебудовується, поточна локаль: $currentLocale");
        return Padding(
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(context, 'wiki_title'),
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: tr(context, 'wiki_search_hint'),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _isLoading ? null : () {
                          _performSearch(_searchController.text);
                        },
                      ),
                    ),
                    onSubmitted: _isLoading ? null : (value) {
                      _performSearch(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _performSearch(_searchController.text),
                    icon: _isLoading 
                        ? SizedBox(
                            width: 18, 
                            height: 18, 
                            child: CircularProgressIndicator(
                              strokeWidth: 2, 
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.onPrimary 
                              )
                            )
                          ) 
                        : const Icon(Icons.search, size: 18),
                    label: Text(tr(context, 'wiki_search_button')),
                    style: Theme.of(context).elevatedButtonTheme.style,
                  ),
                  const SizedBox(height: 30),
                  if (_lastQuery.isNotEmpty || _searchResultText == tr(context, 'wiki_enter_query'))
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(4.0),
                        color: Theme.of(context).cardColor.withAlpha(180),
                      ),
                      width: double.infinity,
                      child: _isLoading 
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 10),
                                  Text(_searchResultText), 
                                ],
                              ),
                            )
                          : Text(
                              _searchResultText.isEmpty && _lastQuery.isNotEmpty 
                                  ? "${tr(context, 'wiki_no_results')} для запиту '$_lastQuery'"
                                  : _searchResultText,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 11, height: 1.7),
                            ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}