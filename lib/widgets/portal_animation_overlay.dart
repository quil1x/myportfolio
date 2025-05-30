import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../theme_notifier.dart';
import '../achievement_manager.dart';

class PortalAnimationOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const PortalAnimationOverlay({super.key, required this.onComplete});

  @override
  State<PortalAnimationOverlay> createState() => _PortalAnimationOverlayState();
}

class _PortalPixel {
  Rect rect; // Позиція та розмір
  Color color;
  double initialOpacity;
  double currentOpacity;
  Duration animationDelay;
  bool isVisible;

  _PortalPixel({
    required this.rect,
    required this.color,
    required this.initialOpacity,
    this.currentOpacity = 0.0,
    required this.animationDelay,
    this.isVisible = false,
  });
}

class _PortalAnimationOverlayState extends State<PortalAnimationOverlay> with TickerProviderStateMixin {
  final AudioPlayer _portalSoundPlayer = AudioPlayer();
  List<_PortalPixel> _pixels = [];
  final Random _random = Random();
  bool _animationStarted = false;

  // Контролер для загальної анімації появи/зникнення пікселів
  late AnimationController _pixelAnimationController;

  @override
  void initState() {
    super.initState();

    _pixelAnimationController = AnimationController(
      duration: const Duration(seconds: 2, milliseconds: 500), // Тривалість ефекту
      vsync: this,
    );
    
    // Генеруємо пікселі один раз
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _generatePixels(MediaQuery.of(context).size);
        _startPortalSequence();
      }
    });
  }

  void _generatePixels(Size screenSize) {
    const int pixelGridSize = 20; // Розмір сітки (20xN пікселів)
    final double pixelWidth = screenSize.width / pixelGridSize;
    // Вираховуємо кількість пікселів по висоті, щоб зберегти пропорції
    final int verticalPixelCount = (screenSize.height / pixelWidth).ceil();

    const List<Color> portalColors = [
      Color(0xFF4B0082), // Indigo
      Color(0xFF8A2BE2), // BlueViolet
      Color(0xFF9400D3), // DarkViolet
      Color(0xFFDA70D6), // Orchid
      Color(0xFF580058), // Глибокий фіолетовий
      Color(0xFF8C008C), // Яскравіший фіолетовий
      Color(0xFFD200D2), // Пурпурний/малиновий
    ];

    _pixels = [];
    for (int i = 0; i < pixelGridSize; i++) {
      for (int j = 0; j < verticalPixelCount; j++) {
        _pixels.add(_PortalPixel(
          rect: Rect.fromLTWH(
            i * pixelWidth, 
            j * pixelWidth, 
            pixelWidth + 0.5, // +0.5 щоб уникнути проміжків через округлення
            pixelWidth + 0.5,
          ),
          color: portalColors[_random.nextInt(portalColors.length)],
          initialOpacity: 0.1 + _random.nextDouble() * 0.5, // Різна максимальна прозорість
          animationDelay: Duration(milliseconds: _random.nextInt(1000)), // Затримка появи
        ));
      }
    }
  }
  
  Future<void> _startPortalSequence() async {
    if (!mounted) return;
    _portalSoundPlayer.play(AssetSource('audio/portal_travel.mp3'));
    
    setState(() { _animationStarted = true; });
    _pixelAnimationController.forward();


    // Загальний час ефекту перед зміною теми
    await Future.delayed(_pixelAnimationController.duration! + const Duration(milliseconds: 300)); 
    if (!mounted) return;

    themeNotifier.switchToNether();
    AchievementManager.show(context, 'nether_portal_opened');
    
    widget.onComplete();
  }

  @override
  void dispose() {
    _portalSoundPlayer.dispose();
    _pixelAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          color: Colors.black.withAlpha((0.3 * 255).round()), // Легке затемнення фону
          child: AnimatedBuilder(
            animation: _pixelAnimationController,
            builder: (context, child) {
              return Stack(
                children: _pixels.map((pixel) {
                  // Анімація появи та зникнення кожного пікселя
                  // Проста логіка: з'являється після затримки, тримається, зникає
                  double currentOpacity = 0.0;
                  if (_animationStarted && _pixelAnimationController.value * _pixelAnimationController.duration!.inMilliseconds > pixel.animationDelay.inMilliseconds) {
                    // Прогрес життя пікселя після його затримки
                    double lifeProgress = (_pixelAnimationController.value * _pixelAnimationController.duration!.inMilliseconds - pixel.animationDelay.inMilliseconds) / 
                                          (_pixelAnimationController.duration!.inMilliseconds - pixel.animationDelay.inMilliseconds - 500); // 500ms на зникнення
                    lifeProgress = lifeProgress.clamp(0.0, 1.0);

                    if (lifeProgress < 0.7) { // З'являється і тримається
                      currentOpacity = pixel.initialOpacity * (lifeProgress / 0.7) ;
                    } else { // Зникає
                      currentOpacity = pixel.initialOpacity * (1 - (lifeProgress - 0.7) / 0.3);
                    }
                    currentOpacity = currentOpacity.clamp(0.0, pixel.initialOpacity);
                  }
                  
                  return Positioned.fromRect(
                    rect: pixel.rect,
                    child: Opacity(
                      opacity: currentOpacity,
                      child: Container(color: pixel.color),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}