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
  double currentOpacity = 0.0; // Ініціалізуємо тут, а не через конструктор
  Duration animationDelay;
  bool isVisible = false; // Ініціалізуємо тут, а не через конструктор

  _PortalPixel({
    required this.rect,
    required this.color,
    required this.initialOpacity,
    // currentOpacity та isVisible прибрані з параметрів
    required this.animationDelay,
  });
}

class _PortalAnimationOverlayState extends State<PortalAnimationOverlay> with TickerProviderStateMixin {
  final AudioPlayer _portalSoundPlayer = AudioPlayer();
  List<_PortalPixel> _pixels = [];
  final Random _random = Random();
  bool _animationStarted = false;

  late AnimationController _pixelAnimationController;

  @override
  void initState() {
    super.initState();

    _pixelAnimationController = AnimationController(
      duration: const Duration(seconds: 2, milliseconds: 500),
      vsync: this,
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _generatePixels(MediaQuery.of(context).size);
        _startPortalSequence();
      }
    });
  }

  void _generatePixels(Size screenSize) {
    const int pixelGridSize = 20;
    final double pixelWidth = screenSize.width / pixelGridSize;
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
            pixelWidth + 0.5,
            pixelWidth + 0.5,
          ),
          color: portalColors[_random.nextInt(portalColors.length)],
          initialOpacity: 0.1 + _random.nextDouble() * 0.5,
          animationDelay: Duration(milliseconds: _random.nextInt(1000)),
        ));
      }
    }
  }
  
  Future<void> _startPortalSequence() async {
    if (!mounted) return;
    _portalSoundPlayer.play(AssetSource('audio/portal_travel.mp3'));
    
    setState(() { _animationStarted = true; });
    _pixelAnimationController.forward();

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
          color: Colors.black.withAlpha((0.3 * 255).round()), // ВИПРАВЛЕНО: withOpacity
          child: AnimatedBuilder(
            animation: _pixelAnimationController,
            builder: (context, child) {
              return Stack(
                children: _pixels.map((pixel) {
                  double currentOpacityValue = 0.0; // Перейменовано, щоб уникнути конфлікту з полем
                  if (_animationStarted && _pixelAnimationController.value * _pixelAnimationController.duration!.inMilliseconds > pixel.animationDelay.inMilliseconds) {
                    double lifeProgress = (_pixelAnimationController.value * _pixelAnimationController.duration!.inMilliseconds - pixel.animationDelay.inMilliseconds) / 
                                          (_pixelAnimationController.duration!.inMilliseconds - pixel.animationDelay.inMilliseconds - 500);
                    lifeProgress = lifeProgress.clamp(0.0, 1.0);

                    if (lifeProgress < 0.7) {
                      currentOpacityValue = pixel.initialOpacity * (lifeProgress / 0.7) ;
                    } else {
                      currentOpacityValue = pixel.initialOpacity * (1 - (lifeProgress - 0.7) / 0.3);
                    }
                    currentOpacityValue = currentOpacityValue.clamp(0.0, pixel.initialOpacity);
                  }
                  pixel.currentOpacity = currentOpacityValue; // Оновлюємо поле, якщо потрібно десь ще
                  
                  return Positioned.fromRect(
                    rect: pixel.rect,
                    child: Opacity(
                      opacity: currentOpacityValue,
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