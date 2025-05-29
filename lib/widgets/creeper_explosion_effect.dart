import 'dart:async';
import 'dart:math';
import 'dart:ui'; 
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:web/web.dart' as web; 
import '../localization/strings.dart';
import '../achievement_manager.dart';
import '../xp_notifier.dart'; 
import 'package:google_fonts/google_fonts.dart';

enum ExplosionStage { idling, hissing, exploding, youDied }

class CreeperExplosionEffect extends StatefulWidget {
  final VoidCallback onEffectComplete;

  const CreeperExplosionEffect({super.key, required this.onEffectComplete});

  @override
  State<CreeperExplosionEffect> createState() => _CreeperExplosionEffectState();
}

class _Particle { // Залишається без змін
  double x;
  double y;
  double endY;
  double size;
  Color color;
  double initialOpacity;
  double currentOpacity = 0.0;
  double ySpeed;
  double xDrift;
  Duration delay;
  bool startedFalling = false;

  _Particle({
    required this.x,
    required this.y,
    required this.endY,
    required this.size,
    required this.color,
    required this.initialOpacity,
    required this.ySpeed,
    required this.xDrift,
    required this.delay,
  });
}

class _CreeperExplosionEffectState extends State<CreeperExplosionEffect> with TickerProviderStateMixin {
  final AudioPlayer _hissPlayer = AudioPlayer();
  final AudioPlayer _explosionPlayer = AudioPlayer();
  
  ExplosionStage _stage = ExplosionStage.idling;
  List<_Particle> _particles = [];
  final Random _random = Random();

  late AnimationController _greenFlashController;
  late Animation<double> _greenFlashAnimation;

  Timer? _particleAnimationTimer;

  @override
  void initState() { // Залишається майже без змін
    super.initState();
    AchievementManager.setCreeperEffectStatus(true);

    _greenFlashController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _greenFlashAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.35), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.35, end: 0.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.25), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.25, end: 0.0), weight: 1),
    ]).animate(_greenFlashController);

    _startHissSequence();
  }

  Future<void> _startHissSequence() async { // Залишається без змін
    if (!mounted) return;
    setState(() { _stage = ExplosionStage.hissing; });
    _greenFlashController.repeat(period: const Duration(milliseconds: 700));
    _hissPlayer.play(AssetSource('audio/creeper.mp3'));
    
    await Future.delayed(const Duration(milliseconds: 1500)); 
    if (!mounted) return;

    _greenFlashController.stop();
    _greenFlashController.reset();
    
    _startExplosionSequence();
  }

  Future<void> _startExplosionSequence() async { // Залишається без змін
    if (!mounted) return;
    AchievementManager.show(context, 'survived_creeper');
    _explosionPlayer.play(AssetSource('audio/creeper-explosion.mp3'));
    
    xpNotifier.resetXp(); 

    setState(() { _stage = ExplosionStage.exploding; });
    _generateParticles(MediaQuery.of(context).size);
    _animateParticles(MediaQuery.of(context).size);
    
    await Future.delayed(const Duration(seconds: 2, milliseconds: 500)); 
    if (!mounted) return;

    if (_stage == ExplosionStage.exploding) {
      _showYouDiedScreen();
    }
  }

  void _showYouDiedScreen() { // Залишається без змін
    if (!mounted) return;
    _particleAnimationTimer?.cancel();
    setState(() {
      _stage = ExplosionStage.youDied;
      _particles.clear(); 
    });
  }

  void _generateParticles(Size screenSize) { // Залишається без змін
    const particleCount = 450; 
    _particles = []; 
    for (int i = 0; i < particleCount; i++) {
      final greyShade = 50 + _random.nextInt(130); 
      _particles.add(_Particle(
        x: _random.nextDouble() * screenSize.width,
        y: _random.nextDouble() * screenSize.height * 0.8, 
        endY: screenSize.height + 20.0 + (_random.nextDouble() * 40.0),
        size: 4.0 + _random.nextDouble() * 8.0, 
        color: Color.fromARGB(255, greyShade, greyShade, greyShade),
        initialOpacity: 0.7 + _random.nextDouble() * 0.3, 
        ySpeed: 2.0 + _random.nextDouble() * 4.5, 
        xDrift: (_random.nextDouble() - 0.5) * 3.0, 
        delay: Duration(milliseconds: _random.nextInt(350)),
      ));
    }
  }

  void _animateParticles(Size screenSize) { // Залишається без змін
    _particleAnimationTimer?.cancel(); 
    _particleAnimationTimer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      if (!mounted || _stage != ExplosionStage.exploding) {
        timer.cancel();
        return;
      }
      bool particlesStillActive = false;
      if (mounted) {
        setState(() {
          for (int i = 0; i < _particles.length; i++) {
            var p = _particles[i];
            if (!p.startedFalling) {
               p.delay = p.delay - const Duration(milliseconds: 25);
               if (p.delay.isNegative) {
                 p.startedFalling = true;
                 p.currentOpacity = p.initialOpacity; 
               }
            }

            if (p.startedFalling) {
              p.y += p.ySpeed;
              p.x += p.xDrift;
              p.currentOpacity -= 0.018; 
              p.ySpeed += 0.1; 
            }
            if (p.y < p.endY && p.currentOpacity > 0) {
              particlesStillActive = true;
            }
          }
          _particles.removeWhere((p) => p.currentOpacity <= 0 || p.y >= p.endY);
        });
      }

      if (!particlesStillActive && _particles.isEmpty) {
          timer.cancel();
          if (mounted && _stage == ExplosionStage.exploding) {
             _showYouDiedScreen();
          }
      }
    });
  }

  void _handleRespawn() { // Залишається без змін
    if (!mounted) return;
    widget.onEffectComplete(); 
    web.window.location.reload(); 
  }

  @override
  void dispose() { // Залишається без змін
    _hissPlayer.dispose();
    _explosionPlayer.dispose();
    _greenFlashController.dispose();
    _particleAnimationTimer?.cancel();
    AchievementManager.setCreeperEffectStatus(false);
    super.dispose();
  }

  // Оновлений стиль для кнопок "Respawn" та "Title Screen"
  ButtonStyle _minecraftButtonStyle(BuildContext context) {
    // Кольори як на скріншоті Disabled-Death-Screen.png
    const buttonBackgroundColor = Color(0xFF707070); // Основний сірий
    const buttonBorderColorLight = Color(0xFFABABAB); // Світла частина рамки (зверху/зліва)
    const buttonBorderColorDark = Color(0xFF373737);  // Темна частина рамки (знизу/справа)
    const textColor = Colors.white;

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(buttonBackgroundColor),
      foregroundColor: WidgetStateProperty.all(textColor),
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
      textStyle: WidgetStateProperty.all(
        GoogleFonts.pressStart2p(fontSize: 10, color: textColor), // Менший шрифт
      ),
      elevation: WidgetStateProperty.all(0), // Прибираємо стандартну тінь Flutter
      shape: WidgetStateProperty.all(
        // Створюємо "псевдо-3D" рамку за допомогою StackedBorders
        // або просто BeveledRectangleBorder з одним кольором рамки
        // Для простоти використаємо Beveled з легким заокругленням
         BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(1.5), // ⬅️ Дуже легке заокруглення
        )
      ),
      // Для більш точного ефекту Minecraft кнопок потрібен CustomPainter або Stack з Container'ами
      // Ми зробимо простіший варіант з рамкою і фоном
      side: WidgetStateProperty.resolveWith<BorderSide>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return const BorderSide(color: buttonBorderColorDark, width: 2.0); // Темніша при натисканні
          }
          return const BorderSide(color: buttonBorderColorLight, width: 1.0); // Світліша в спокої
        },
      ),
       overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return Colors.white.withOpacity(0.1);
          }
          if (states.contains(WidgetState.pressed)) {
            return Colors.black.withOpacity(0.1);
          }
          return null; 
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: IgnorePointer( // Клікати можна тільки на кнопки Respawn/Title Screen
        ignoring: _stage != ExplosionStage.youDied,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Розмиття фону ТІЛЬКИ під час вибуху та екрану "You Died"
            if (_stage == ExplosionStage.exploding || _stage == ExplosionStage.youDied)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Сила розмиття
                  child: Container(
                    // Затемнення + ледь помітний червонуватий відтінок для "You Died"
                    color: _stage == ExplosionStage.youDied 
                           ? const Color(0xFF520000).withOpacity(0.45) // Червонуватий під час "You Died"
                           : Colors.black.withOpacity(0.65), // Просто затемнення під час вибуху
                  ), 
                ),
              ),

            if (_stage == ExplosionStage.hissing) // Залишається без змін
              AnimatedBuilder(
                animation: _greenFlashAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _greenFlashAnimation.value,
                    child: Container(color: Colors.green.withOpacity(0.7)),
                  );
                }
              ),

            if (_stage == ExplosionStage.exploding) // Залишається без змін
              ..._particles.map((p) { 
                return Positioned(
                  left: p.x,
                  top: p.y,
                  child: Opacity(
                    opacity: p.currentOpacity.clamp(0.0, 1.0),
                    child: Container(
                      width: p.size,
                      height: p.size,
                      decoration: BoxDecoration(
                        color: p.color,
                        border: Border.all(color: Colors.black.withOpacity(0.2), width: 0.5)
                      ),
                    ),
                  ),
                );
              }),
            
            // Екран "YOU DIED" - тепер стилізований точно як у Minecraft
            if (_stage == ExplosionStage.youDied)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You Died!', 
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont( // Використовуємо GoogleFonts для гнучкості
                        'Press Start 2P', // Або інший піксельний шрифт, якщо цей не підходить
                        fontSize: 32, // Розмір як на скріншоті
                        color: const Color(0xFFFC5555), // Червоний колір
                        shadows: [ // Тінь для тексту
                          const Shadow(color: Color(0xFF3E0000), offset: Offset(2.5, 2.5), blurRadius: 0),
                        ]
                      ),
                    ),
                    const SizedBox(height: 20), // Відступ між текстами
                    Text(
                      "${tr(context, 'score_text')}0", // Використовуємо ключ, але рахунок завжди 0
                      style: GoogleFonts.getFont(
                        'Press Start 2P',
                        fontSize: 16,
                        color: Colors.white,
                         shadows: [
                          const Shadow(color: Colors.black54, offset: Offset(2,2), blurRadius: 0),
                        ]
                      ),
                    ),
                    const SizedBox(height: 35), 
                    // Кнопки
                    SizedBox( // Обмежуємо ширину кнопок
                      width: 220, // Ширина кнопок як у Minecraft
                      child: ElevatedButton(
                        onPressed: _handleRespawn,
                        style: _minecraftButtonStyle(context), 
                        child: Text(tr(context, 'respawn_button_text')),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 220,
                      child: ElevatedButton(
                        onPressed: _handleRespawn, // Поки що теж перезавантажує, можна змінити на повернення на головну
                        style: _minecraftButtonStyle(context),
                        child: Text(tr(context, 'title_screen_button_text')),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}