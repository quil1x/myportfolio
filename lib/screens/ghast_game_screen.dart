import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui'; // Потрібен для ImageFilter.blur
import '../localization/strings.dart';
import '../language_notifier.dart'; 

// Стани Гаста
enum GhastState { flying, shootingPrep, shootingFire, hit, dying } // Додано 'hit' назад, якщо він потрібен для логіки

class Fireball {
  double x; 
  double y; 
  double currentSize;
  final double initialSize;
  final double maxSize;
  final double growthFactor;
  double speedY; 
  double speedX; 
  bool isActive;
  bool isReflected;
  double targetX; 
  double targetY; 

  Rect get rect => Rect.fromLTWH(x - currentSize / 2, y - currentSize / 2, currentSize, currentSize);

  Fireball({
    required this.x,
    required this.y,
    this.initialSize = 15.0, 
    this.maxSize = 45.0,     
    this.growthFactor = 0.6, 
    this.speedY = 4.5,     
    this.speedX = 0.0, 
    this.isActive = true,
    this.isReflected = false,
    this.targetX = 0.0, 
    this.targetY = 0.0, 
  }) : currentSize = initialSize;

  void update(Size screenSize) { 
    if (isActive) {
      if (!isReflected) { 
        y += speedY;
        if (currentSize < maxSize) {
          currentSize += growthFactor;
          if (currentSize > maxSize) currentSize = maxSize;
        }
      } else { 
        y -= speedY; 
        if (targetX != 0 || targetY != 0) { 
             double dx = targetX - x; 
             if (dx.abs() > 1.0) {
                speedX = dx * 0.08; 
             } else {
                speedX = dx; 
             }
             x += speedX;
        }
      }
      if (y > screenSize.height + currentSize || y < -currentSize) {
        isActive = false; 
      }
    }
  }
}

class GhastGameScreen extends StatefulWidget {
  const GhastGameScreen({super.key});

  @override
  State<GhastGameScreen> createState() => _GhastGameScreenState();
}

class _GhastGameScreenState extends State<GhastGameScreen> with TickerProviderStateMixin {
  double _ghastCurrentX = 0.0; 
  final double _ghastYFraction = 0.15; 
  final double _ghastSize = 200.0; 
  AnimationController? _ghastMoveController;
  GhastState _ghastState = GhastState.flying;
  Timer? _shootStateTimer; 
  Timer? _shootCooldownTimer;  
  Timer? _dyingTimer; 
  bool _ghastMovesRight = true; 

  Fireball? _fireball;
  final String _ghastFlyingAsset = 'assets/images/ghast.png';
  final String _ghastShootingAsset = 'assets/images/ghast_shoot.png';
  final String _ghastRipAsset = 'assets/images/ghast-rip.png'; 
  final String _fireballAsset = 'assets/images/fireball.png';
  final String _netherGameBackgroundAsset = 'assets/images/minecraft_nether_bg.png'; 

  Timer? _gameLoopTimer;
  int _score = 0; // Буде використовуватися для відображення
  final Random _random = Random(); 

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted) {
        final screenSize = MediaQuery.of(context).size;
        setState(() { 
          _ghastCurrentX = (screenSize.width / 2) - (_ghastSize / 2);
        });
      }
    });

    _ghastMoveController = AnimationController(
      duration: const Duration(milliseconds: 40), 
      vsync: this,
    )..addListener(_moveGhast)
     ..repeat(); 

    _scheduleNextShot(); 
    _gameLoopTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) { 
      if (!mounted) { timer.cancel(); return; }
      _updateGame();
    });
  }

  void _moveGhast() {
    if (!mounted || 
        _ghastState == GhastState.dying || 
        _ghastState == GhastState.shootingPrep || 
        _ghastState == GhastState.shootingFire ||
        _ghastState == GhastState.hit ) { 
      return; 
    }
    
    if (MediaQuery.of(context).size.width == 0) return; 
    final screenSize = MediaQuery.of(context).size;
    const double ghastPixelSpeed = 1.2; 
    const double padding = 20.0; 

    setState(() {
      if (_ghastMovesRight) {
        _ghastCurrentX += ghastPixelSpeed;
        if (_ghastCurrentX + _ghastSize >= screenSize.width - padding) {
          _ghastCurrentX = screenSize.width - padding - _ghastSize;
          _ghastMovesRight = false;
        }
      } else {
        _ghastCurrentX -= ghastPixelSpeed;
        if (_ghastCurrentX <= padding) {
          _ghastCurrentX = padding;
          _ghastMovesRight = true;
        }
      }
      if (screenSize.width > _ghastSize + 2 * padding) {
         _ghastCurrentX = _ghastCurrentX.clamp(padding, screenSize.width - _ghastSize - padding);
      } else { 
         _ghastCurrentX = (screenSize.width - _ghastSize) / 2;
      }
    });
  }

  void _scheduleNextShot() {
    if (_ghastState == GhastState.dying || _ghastState == GhastState.hit) return; 

    _shootCooldownTimer?.cancel();
    final randomDelay = Duration(milliseconds: 1800 + _random.nextInt(2200)); 
    _shootCooldownTimer = Timer(randomDelay, () {
      if (mounted && _ghastState == GhastState.flying && _fireball == null) {
        _initiateShootingSequence();
      } else if (mounted){
        _scheduleNextShot(); 
      }
    });
  }

  void _initiateShootingSequence() {
    if (!mounted || _ghastState != GhastState.flying) return;

    setState(() {
      _ghastState = GhastState.shootingPrep; 
    });

    _shootStateTimer?.cancel();
    _shootStateTimer = Timer(const Duration(milliseconds: 300), () { 
      if (mounted && _ghastState == GhastState.shootingPrep) {
        _fireActualFireball();
      } else if (mounted && _ghastState != GhastState.dying && _ghastState != GhastState.hit) { 
         _resumeGhastFlying(); 
      }
    });
  }
  
  void _fireActualFireball(){
    if (!mounted || _ghastState == GhastState.dying || _ghastState == GhastState.hit) return;
    final screenSize = MediaQuery.of(context).size;
    
    double currentGhastCenterX = _ghastCurrentX + (_ghastSize / 2); 
    double currentGhastTopY = screenSize.height * _ghastYFraction;
    double mouthOffsetY = _ghastSize * 0.7; 

    setState(() {
      _fireball = Fireball(
        x: currentGhastCenterX,
        y: currentGhastTopY + mouthOffsetY,
      );
      _ghastState = GhastState.shootingFire; 
    });

    _shootStateTimer?.cancel(); 
    _shootStateTimer = Timer(const Duration(milliseconds: 1000), () { 
       if (mounted && _ghastState == GhastState.shootingFire && _fireball == null) { 
           _resumeGhastFlying();
       } else if (mounted && _ghastState == GhastState.shootingFire && _fireball != null) {
           // Якщо фаєрбол все ще активний, Гаст залишається в стані shootingFire
           // _updateGame має врешті-решт змінити стан Гаста через _resumeGhastFlying
       }
    });
  }
  
  void _resumeGhastFlying() { 
    if (mounted && 
        (_ghastState == GhastState.shootingFire || _ghastState == GhastState.shootingPrep) && 
        _ghastState != GhastState.dying && 
        _ghastState != GhastState.hit ) {
      setState(() {
        _ghastState = GhastState.flying;
      });
      _scheduleNextShot();
    }
  }

  Rect get _ghastRect { 
    final screenSize = MediaQuery.of(context).size;
    double ghastCurrentCenterY = screenSize.height * _ghastYFraction + _ghastSize / 2;
    return Rect.fromCenter(
        center: Offset(_ghastCurrentX + _ghastSize / 2, ghastCurrentCenterY),
        width: _ghastSize * 0.7, 
        height: _ghastSize * 0.7,
    );
  }

  void _updateGame() {
    if (!mounted) return; 
    final screenSize = MediaQuery.of(context).size;
    bool fireballVanishedThisTick = false;

    if (_fireball != null && _fireball!.isActive) {
      // double ghastCurrentTargetX = _ghastCurrentX + _ghastSize / 2; // ВИДАЛЕНО, бо невикористовується
      
      _fireball!.update(screenSize); 
      
      if (mounted) { 
        setState(() {
          if (_fireball!.isReflected && _ghastState != GhastState.dying && _ghastState != GhastState.hit) {
            if (_ghastRect.overlaps(_fireball!.rect)) {
              _ghastHit();
              _fireball = null; 
              fireballVanishedThisTick = true;
            }
            else if (_fireball!.y < (screenSize.height * _ghastYFraction) - _fireball!.currentSize) {
               _fireball = null; 
               fireballVanishedThisTick = true;
            }
          }
          
          if (!fireballVanishedThisTick && _fireball != null && !_fireball!.isReflected && _fireball!.y >= screenSize.height - _fireball!.currentSize / 2) { 
              _score = 0; 
              _fireball = null; 
              fireballVanishedThisTick = true;
          }

          if (_fireball != null && !_fireball!.isActive) { 
            _fireball = null; 
            fireballVanishedThisTick = true;
          }
        });
      }
    }

    if (fireballVanishedThisTick || _fireball == null) {
        if (_ghastState == GhastState.shootingFire) { 
           _resumeGhastFlying();
        }
    }
  }

  void _ghastHit() {
    // Тепер ми не використовуємо GhastState.hit як окремий стан перед dying,
    // а одразу переходимо в dying при влучанні.
    if (!mounted || _ghastState == GhastState.dying) return; 

    _shootCooldownTimer?.cancel(); 
    _shootStateTimer?.cancel();   

    setState(() {
      _ghastState = GhastState.dying; 
      _score++; 
    });

    _dyingTimer?.cancel();
    _dyingTimer = Timer(const Duration(milliseconds: 1500), () { 
      if (mounted) {
        setState(() {
          _ghastState = GhastState.flying; 
          _ghastCurrentX = (MediaQuery.of(context).size.width / 2) - (_ghastSize / 2);
          _ghastMovesRight = _random.nextBool(); 
          _scheduleNextShot(); 
        });
      }
    });
  }

  void _handleFireballTap() { // Тепер використовується
    if (_fireball != null && _fireball!.isActive && !_fireball!.isReflected) {
      if (mounted && _ghastState != GhastState.dying ) { // Прибираємо перевірку на hit, якщо його немає
        final screenSize = MediaQuery.of(context).size;
        _fireball!.targetX = _ghastCurrentX + _ghastSize / 2; 
        _fireball!.targetY = screenSize.height * _ghastYFraction + _ghastSize / 2; 

        setState(() {
          _fireball!.isReflected = true;
          _fireball!.speedY = 8.0; 
          _fireball!.currentSize = _fireball!.maxSize; 
        });
      }
    }
  }

  @override
  void dispose() {
    _ghastMoveController?.removeListener(_moveGhast);
    _ghastMoveController?.dispose();
    _shootStateTimer?.cancel();
    _shootCooldownTimer?.cancel();
    _gameLoopTimer?.cancel();
    _dyingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context); 

    String currentGhastAsset = _ghastFlyingAsset;
    // Якщо стан 'hit' більше не використовується, прибираємо його звідси
    if (_ghastState == GhastState.shootingPrep || _ghastState == GhastState.shootingFire) {
      currentGhastAsset = _ghastShootingAsset;
    } else if (_ghastState == GhastState.dying) { 
      currentGhastAsset = _ghastRipAsset; 
    }

    Widget ghastDisplayWidget = Image.asset(
      currentGhastAsset,
      width: _ghastSize,
      height: _ghastSize,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) { 
         return Container(
            width: _ghastSize,
            height: _ghastSize,
            color: Colors.grey.withAlpha(120),
            child: const Icon(Icons.broken_image, color: Colors.red, size: 40),
          );
      }, 
    );

    if (_ghastState == GhastState.dying) { // Повертаємо тільки коли 'dying'
      ghastDisplayWidget = Transform.rotate(
        angle: pi / 2, 
        child: ghastDisplayWidget,
      );
    }

    return ValueListenableBuilder<Locale>(
      valueListenable: languageNotifier,
      builder: (context, currentLocale, _) { // ВИПРАВЛЕНО: child на _
        return Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Stack( 
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      _netherGameBackgroundAsset, 
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors.grey[850]);
                      }
                    ),
                    ClipRect( 
                      child: BackdropFilter( 
                        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0), 
                        child: Container(
                          color: Colors.black.withAlpha((0.01 * 255).round()), 
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Умова для відображення Гаста
              if (!(_ghastState == GhastState.dying && !(_dyingTimer?.isActive ?? false)))
                Positioned(
                  top: screenSize.height * _ghastYFraction, 
                  left: _ghastCurrentX, 
                  child: ghastDisplayWidget,
                ),
              
              if (_fireball != null && _fireball!.isActive)
                Positioned( 
                  left: _fireball!.x - _fireball!.currentSize / 2,
                  top: _fireball!.y - _fireball!.currentSize / 2,
                  child: GestureDetector( 
                    onTap: _handleFireballTap, 
                    child: Image.asset(
                      _fireballAsset, 
                      width: _fireball!.currentSize,
                      height: _fireball!.currentSize,
                      fit: BoxFit.contain,
                       errorBuilder: (context, error, stackTrace) { 
                        return Container( 
                          width: _fireball!.currentSize,
                          height: _fireball!.currentSize,
                          decoration: const BoxDecoration(
                            color: Colors.orangeAccent,
                            shape: BoxShape.circle
                          ),
                          child: Icon(Icons.whatshot, color: Colors.redAccent, size: _fireball!.currentSize * 0.6,),
                        );
                       }, 
                    ),
                  ),
                ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 20,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tr(context, 'ghast_game_title'),
                      style: theme.textTheme.bodyLarge?.copyWith( 
                            color: Colors.white.withAlpha((0.9 * 255).round()), // Виправлено withOpacity
                            fontSize: 12, 
                            shadows: [ const Shadow( offset: Offset(1.0, 1.0), blurRadius: 1.0, color: Colors.black,) ]
                          ),
                    ),
                    Text(
                      "${tr(context, 'ghast_game_score')} $_score", // _score тепер використовується
                      style: theme.textTheme.bodyLarge?.copyWith( 
                            color: Colors.white, 
                            fontSize: 14, 
                            fontWeight: FontWeight.bold,
                            shadows: [ const Shadow( offset: Offset(1.0, 1.0), blurRadius: 1.0, color: Colors.black,) ]
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}