import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../localization/strings.dart';
import '../language_notifier.dart'; 

// Стани Гаста
enum GhastState { flying, shooting }

// Клас для Фаєрбола
class Fireball {
  double x; 
  double y; 
  final double size;
  final double speedY;
  bool isActive; 
  Rect get rect => Rect.fromLTWH(x - size / 2, y - size / 2, size, size);

  Fireball({
    required this.x,
    required this.y,
    this.size = 39.0, // <--- РОЗМІР ФАЄРБОЛА ЗБІЛЬШЕНО (було 30.0)
    this.speedY = 4.0, // Можна трохи зменшити швидкість фаєрбола, якщо він став більшим
    this.isActive = true,
  });

  void update() {
    if (isActive) {
      y += speedY;
    }
  }
}

class GhastGameScreen extends StatefulWidget {
  const GhastGameScreen({super.key});

  @override
  State<GhastGameScreen> createState() => _GhastGameScreenState();
}

class _GhastGameScreenState extends State<GhastGameScreen> with TickerProviderStateMixin {
  // Гаст
  double _ghastXFraction = 0.5; 
  final double _ghastYFraction = 0.2; // Трохи опустимо Гаста, бо він став більшим (0.0 = верх)
  final double _ghastSize = 250.0; // <--- РОЗМІР ГАСТА ЗБІЛЬШЕНО (було 100.0)
  AnimationController? _ghastMoveController;
  Animation<double>? _ghastMoveAnimation;
  GhastState _ghastState = GhastState.flying;
  Timer? _shootTimer; 

  // Фаєрбол
  Fireball? _fireball;
  final String _ghastFlyingAsset = 'assets/images/ghast.png'; //
  final String _ghastShootingAsset = 'assets/images/ghast_shoot.png'; //
  final String _fireballAsset = 'assets/images/fireball.png'; //

  Timer? _gameLoopTimer;

  @override
  void initState() {
    super.initState();

    _ghastMoveController = AnimationController(
      duration: const Duration(seconds: 6), // <--- ШВИДКІСТЬ ГАСТА ЗМЕНШЕНА (було 4 сек)
      vsync: this,
    )..repeat(reverse: true); 

    _ghastMoveAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _ghastMoveController!, curve: Curves.easeInOut),
    );

    _startShootingTimer();
    _gameLoopTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _updateGame();
    });
  }

  void _startShootingTimer() {
    _shootTimer?.cancel(); 
    final randomShootInterval = Duration(seconds: 3 + Random().nextInt(4)); 
    _shootTimer = Timer.periodic(randomShootInterval, (timer) {
      if (mounted && _ghastState == GhastState.flying && _fireball == null) {
        _shootFireball();
      }
    });
  }

  void _shootFireball() {
    if (!mounted) return;
    final screenSize = MediaQuery.of(context).size;

    // Визначаємо позицію центру Гаста
    double ghastCenterX = (screenSize.width - _ghastSize) * _ghastXFraction + (_ghastSize / 2);
    double ghastCenterY = screenSize.height * _ghastYFraction; // Тепер _ghastYFraction для верхнього краю

    setState(() {
      _ghastState = GhastState.shooting;
      _fireball = Fireball(
        x: ghastCenterX,
        y: ghastCenterY + (_ghastSize * 0.6), // Позиція фаєрбола відносно "рота" Гаста
      );
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _ghastState = GhastState.flying;
        });
      }
    });
  }

  void _updateGame() {
    if (!mounted) return;
    if (_fireball != null && _fireball!.isActive) {
      setState(() {
        _fireball!.update();
        if (_fireball!.y > MediaQuery.of(context).size.height + _fireball!.size) {
          _fireball = null; 
        }
      });
    }
  }

  void _handleFireballTap() {
    if (_fireball != null && _fireball!.isActive) {
      // print("Фаєрбол відбито! (поки що просто лог)");
      // TODO: Реалізувати логіку відбиття фаєрбола назад у Гаста
      if (mounted) {
        setState(() {
          _fireball = null; 
        });
      }
    }
  }

  @override
  void dispose() {
    _ghastMoveController?.dispose();
    _shootTimer?.cancel();
    _gameLoopTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return ValueListenableBuilder<Locale>(
      valueListenable: languageNotifier,
      builder: (context, currentLocale, child) {
        return Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _ghastMoveAnimation!,
                builder: (context, child) {
                  double centerGhastXFraction = (_ghastMoveAnimation!.value + 1) / 2; 
                  double minCenterFraction = (_ghastSize / 2) / screenSize.width;
                  double maxCenterFraction = 1.0 - (_ghastSize / 2) / screenSize.width;
                  _ghastXFraction = minCenterFraction + centerGhastXFraction * (maxCenterFraction - minCenterFraction);
                  _ghastXFraction = _ghastXFraction.clamp(minCenterFraction, maxCenterFraction);

                  return Positioned(
                    // Позиціонуємо по верхньому краю Гаста, _ghastYFraction тепер для верху
                    top: screenSize.height * _ghastYFraction, 
                    left: screenSize.width * _ghastXFraction - (_ghastSize / 2),
                    child: Image.asset(
                      _ghastState == GhastState.shooting ? _ghastShootingAsset : _ghastFlyingAsset,
                      width: _ghastSize,
                      height: _ghastSize,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: _ghastSize,
                          height: _ghastSize,
                          color: Colors.grey.withOpacity(0.5),
                          child: const Icon(Icons.broken_image, color: Colors.red, size: 40),
                        );
                      },
                    ),
                  );
                },
              ),

              if (_fireball != null && _fireball!.isActive)
                Positioned(
                  left: _fireball!.x - _fireball!.size / 2,
                  top: _fireball!.y - _fireball!.size / 2,
                  child: GestureDetector(
                    onTap: _handleFireballTap,
                    child: Image.asset(
                      _fireballAsset,
                      width: _fireball!.size,
                      height: _fireball!.size,
                       errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: _fireball!.size,
                          height: _fireball!.size,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle
                          ),
                          child: const Icon(Icons.whatshot, color: Colors.red, size: 20,),
                        );
                      },
                    ),
                  ),
                ),

              Positioned(
                top: MediaQuery.of(context).padding.top + 20,
                left: 0,
                right: 0,
                child: Text(
                  tr(context, 'ghast_game_title'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                        color: theme.brightness == Brightness.dark 
                               ? Colors.white.withOpacity(0.9) 
                               : Colors.black.withOpacity(0.9),
                        fontSize: 16,
                        shadows: [
                           Shadow(
                              offset: const Offset(1.0, 1.0),
                              blurRadius: 2.0,
                              color: Colors.black.withOpacity(0.5),
                           ),
                        ]
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}