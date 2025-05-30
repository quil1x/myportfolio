import 'dart:math';
import 'package:flutter/material.dart';
import '../theme_notifier.dart'; 

class _FaunaParticle {
  double x;
  double y;
  double speedX;
  double ySpeed; 
  String imagePath;
  Size size;
  bool moveRight; 
  final Random _random = Random();

  _FaunaParticle({
    required this.x,
    required this.y,
    required this.speedX,
    required this.ySpeed, 
    required this.imagePath,
    required this.size,
  }) : moveRight = Random().nextBool();

  void update(Size areaSize) {
    if (moveRight) {
      x += speedX;
      if (x + size.width >= areaSize.width) { 
        x = areaSize.width - size.width;      
        moveRight = false;                    
      }
    } else { 
      x -= speedX;
      if (x <= 0) { 
        x = 0;                                
        moveRight = true;                     
      }
    }
    
    if (_random.nextDouble() < 0.003) { 
      moveRight = !moveRight;
    }
    
    y += ySpeed;
    double maxVertSpeedForBounce = (speedX * 0.6).clamp(0.15, 0.8); 
    if (y <= 0) { 
      y = 0;                   
      ySpeed = _random.nextDouble().abs() * maxVertSpeedForBounce; 
    } else if (y + size.height >= areaSize.height) { 
      y = areaSize.height - size.height;
      ySpeed = -(_random.nextDouble().abs() * maxVertSpeedForBounce); 
    }

    if (_random.nextDouble() < 0.035) { 
      ySpeed += (_random.nextDouble() - 0.5) * 0.35; 
      double maxVerticalSpeedOverall = (speedX * 0.8).clamp(0.2, 1.2); 
      ySpeed = ySpeed.clamp(-maxVerticalSpeedOverall, maxVerticalSpeedOverall);
    }
    
    y = y.clamp(0.0, (areaSize.height - size.height).clamp(0.0, double.infinity));
  }

  static double _randomOffset() => Random().nextDouble() * 15.0;
}

class ThemeAnimatedFauna extends StatefulWidget {
  final AppThemeMode currentThemeMode;
  final double areaHeight; 

  const ThemeAnimatedFauna({
    super.key,
    required this.currentThemeMode,
    this.areaHeight = 84.0, 
  });

  @override
  State<ThemeAnimatedFauna> createState() => _ThemeAnimatedFaunaState();
}

class _ThemeAnimatedFaunaState extends State<ThemeAnimatedFauna> with SingleTickerProviderStateMixin {
  final List<_FaunaParticle> _particles = []; // ВИПРАВЛЕНО: зроблено final
  late AnimationController _controller;
  final Random _random = Random();
  Size? _areaSize; 

  @override
  void initState() {
    super.initState();
    // print('[FaunaDebug] initState FaunaWidget. Theme: ${widget.currentThemeMode}');
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16), 
    )..addListener(_updateFauna);
    _controller.repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // print('[FaunaDebug] initState - addPostFrameCallback');
      if (mounted) {
        _updateAreaSizeAndGenerateFauna();
      }
    });
  }

  @override
  void didUpdateWidget(ThemeAnimatedFauna oldWidget) {
    super.didUpdateWidget(oldWidget);
    // print('[FaunaDebug] didUpdateWidget FaunaWidget. New Theme: ${widget.currentThemeMode}, Old Theme: ${oldWidget.currentThemeMode}, New Height: ${widget.areaHeight}, Old Height: ${oldWidget.areaHeight}');
    bool areaHeightChanged = oldWidget.areaHeight != widget.areaHeight;
    bool themeChanged = oldWidget.currentThemeMode != widget.currentThemeMode;

    if ((areaHeightChanged || themeChanged) && mounted) {
       _updateAreaSizeAndGenerateFauna();
    }
  }
  
  void _updateAreaSizeAndGenerateFauna() {
    // print('[FaunaDebug] Attempting to update area size and generate fauna. Current widget.areaHeight: ${widget.areaHeight}');
    final renderObject = context.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize && mounted) {
        _areaSize = Size(MediaQuery.of(context).size.width, widget.areaHeight);
        // print('[FaunaDebug] Area size successfully updated: $_areaSize');
        _generateFauna();
    } else {
        // print('[FaunaDebug] RenderObject not ready or not RenderBox in _updateAreaSizeAndGenerateFauna. Scheduling post frame.');
        WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
                final postFrameRenderObject = context.findRenderObject();
                if (postFrameRenderObject is RenderBox && postFrameRenderObject.hasSize) {
                     _areaSize = Size(MediaQuery.of(context).size.width, widget.areaHeight);
                     // print('[FaunaDebug] Area size updated in post frame: $_areaSize');
                     _generateFauna();
                } else {
                     // print("[FaunaDebug] ERROR: Could not determine area size even after post frame callback for generation.");
                }
            }
        });
    }
  }

  void _generateFauna() {
    if (!mounted || _areaSize == null || _areaSize!.height <= 0 || _areaSize!.width <= 0) {
      // print('[FaunaDebug] _generateFauna SKIPPED: mounted: $mounted, _areaSize: $_areaSize');
      if (_particles.isNotEmpty) {
        setState(() {
          _particles.clear();
        });
      }
      return;
    }

    _particles.clear(); 
    String imagePath;
    Size faunaSize;
    int count;
    double minSpeedX, maxSpeedX; 
    double minSpeedY, maxSpeedY;

    // print('[FaunaDebug] Generating fauna for theme: ${widget.currentThemeMode} with areaHeight: ${_areaSize!.height}');

    switch (widget.currentThemeMode) {
      case AppThemeMode.light: 
        imagePath = 'assets/images/bee.png'; 
        faunaSize = const Size(52, 52);   
        count = 10;                     
        minSpeedX = 0.25; maxSpeedX = 0.65; 
        minSpeedY = 0.1; maxSpeedY = 0.35; 
        break;
      case AppThemeMode.dark: 
        imagePath = 'assets/images/bat.png'; 
        faunaSize = const Size(78, 39);   
        count = 10;                       
        minSpeedX = 0.4; maxSpeedX = 1.0;
        minSpeedY = 0.2; maxSpeedY = 0.6;
        break;
      case AppThemeMode.nether: 
        imagePath = 'assets/images/ghast.png'; 
        faunaSize = const Size(65, 65);   
        count = 6;                        
        minSpeedX = 0.1; maxSpeedX = 0.3;  
        minSpeedY = 0.05; maxSpeedY = 0.25;          
        break;
    }
    // print('[FaunaDebug] Fauna params: path=$imagePath, size=$faunaSize, count=$count');

    double maxCreatureVerticalSpace = (_areaSize!.height - faunaSize.height).clamp(0.0, double.infinity);
    // print('[FaunaDebug] Calculated maxCreatureVerticalSpace: $maxCreatureVerticalSpace for faunaHeight: ${faunaSize.height}');


    if (faunaSize.height > _areaSize!.height || maxCreatureVerticalSpace < 1.0 && faunaSize.height > 0) { 
        // print("[FaunaDebug] Fauna ${faunaSize.height} too tall for area ${_areaSize!.height}. Not generating particles.");
        if(mounted) setState(() {});
        return; 
    }

    for (int i = 0; i < count; i++) {
      bool startsFromLeft = _random.nextBool();
      _particles.add(_FaunaParticle(
        x: startsFromLeft 
            ? -faunaSize.width - (_FaunaParticle._randomOffset()) 
            : _areaSize!.width + (_FaunaParticle._randomOffset()), 
        y: _random.nextDouble() * maxCreatureVerticalSpace,
        speedX: minSpeedX + _random.nextDouble() * (maxSpeedX - minSpeedX),
        ySpeed: (minSpeedY + _random.nextDouble() * (maxSpeedY - minSpeedY)) * (_random.nextBool() ? 1 : -1), 
        imagePath: imagePath,
        size: faunaSize,
      )..moveRight = startsFromLeft); 
    }
    // print('[FaunaDebug] Generated ${_particles.length} particles.');
    if(mounted) setState(() {});
  }
  
  void _updateFauna() {
    if (!mounted || _areaSize == null) return;
    for (var particle in _particles) {
      particle.update(_areaSize!);
    }
    if(mounted) setState(() {}); 
  }

  @override
  void dispose() {
    // print('[FaunaDebug] dispose FaunaWidget');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('[FaunaDebug] build FaunaWidget. Particles: ${_particles.length}, AreaHeight: ${widget.areaHeight}, _areaSize: $_areaSize');
    
    if (_areaSize == null || _particles.isEmpty) {
      // print('[FaunaDebug] Build: Returning empty SizedBox. Particles empty: ${_particles.isEmpty}, areaSize null: ${_areaSize == null}');
      return SizedBox(height: widget.areaHeight); 
    }
    
    return SizedBox(
      width: double.infinity,
      height: widget.areaHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge, 
        children: _particles.map((particle) {
          Widget imageWidget = Image.asset(
            particle.imagePath,
            width: particle.size.width,
            height: particle.size.height,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // print('[FaunaDebug] ERROR loading image: ${particle.imagePath} - $error');
              return Container( 
                width: particle.size.width, 
                height: particle.size.height, 
                color: Colors.blue.withAlpha(150)); 
            },
          );

          imageWidget = Transform.flip(
            flipX: particle.moveRight, 
            child: imageWidget,
          );
          
          return Positioned(
            left: particle.x,
            top: particle.y,
            child: Opacity( 
              opacity: 1.0, 
              child: imageWidget,
            ),
          );
        }).toList(),
      ),
    );
  }
}