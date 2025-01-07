import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen that displays a lootbox opening animation with a magical fantasy theme
/// Uses kebab-style rotation (exponential ease-out) and sparkle effects
class OpenLootboxScreen extends ConsumerStatefulWidget {
  const OpenLootboxScreen({super.key});

  @override
  ConsumerState<OpenLootboxScreen> createState() => _OpenLootboxScreenState();
}

class _OpenLootboxScreenState extends ConsumerState<OpenLootboxScreen>
    with TickerProviderStateMixin {
  static const String _lootboxImage =
      'https://cdn.midjourney.com/26f913ca-2e33-4d60-97af-56f5622092a7/0_1.png';

  late AnimationController _chestController;
  late AnimationController _buttonController;
  late AnimationController _sparkleController;
  late Animation<Offset> _slideAnimation;

  bool _isOpened = false;
  bool _showCollectButton = false;

  /// Kebab rotation parameters
  final double _angleFinal = 12 * math.pi; // 6 full rotations
  final double _k = 3.0; // exponential coefficient

  /// θ(t) = AngleFinal * (1 - e^(-k·t)) / (1 - e^(-k))
  double _kebabAngle(double t) =>
      _angleFinal * (1 - math.exp(-_k * t)) / (1 - math.exp(-_k));

  @override
  void initState() {
    super.initState();

    _chestController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _chestController,
        curve: Curves.easeOut,
      ),
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.0,
      upperBound: 1.0,
    )..repeat(reverse: true);

    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat();
  }

  @override
  void dispose() {
    _chestController.dispose();
    _buttonController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  /// Triggers the chest opening animation sequence
  void _startOpening() {
    if (_isOpened) return;

    setState(() => _isOpened = true);

    _chestController.forward(from: 0.0).then((_) {
      setState(() => _showCollectButton = true);
    });
    _buttonController.stop();
  }

  void _collectAndClose() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              _lootboxImage,
              fit: BoxFit.cover,
            ),
          ),
          if (!_isOpened)
            Center(
              child: AnimatedBuilder(
                animation: _buttonController,
                builder: (context, child) {
                  final double scale = 1.0 + 0.1 * _buttonController.value;
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: GlowingFantasyButton(
                  text: 'Ouvrir le Coffre',
                  onTap: _startOpening,
                ),
              ),
            ),
          SlideTransition(
            position: _slideAnimation,
            child: AnimatedBuilder(
              animation: _chestController,
              builder: (context, child) {
                final double angle = _kebabAngle(_chestController.value);
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(angle),
                  child: child,
                );
              },
              child: Center(
                child: SparklingFantasyContainer(animation: _sparkleController),
              ),
            ),
          ),
          if (_showCollectButton)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: GlowingFantasyButton(
                  text: 'Récupérer le lot',
                  onTap: _collectAndClose,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A fantasy-themed button with gradient background and glow effect
class GlowingFantasyButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const GlowingFantasyButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF743DA),
              Color(0xFF8E2DE2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.amberAccent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFF66FF).withAlpha(179),
              blurRadius: 25,
              spreadRadius: 2,
            )
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.amberAccent,
                blurRadius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A decorative container with a moving shimmer effect
class SparklingFantasyContainer extends StatelessWidget {
  final AnimationController animation;

  const SparklingFantasyContainer({
    super.key,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final double t = animation.value;
        final double shimmerOffset = -4.0 + 13.0 * t;

        return Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF743DA),
                Color(0xFF8E2DE2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.amberAccent,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFF66FF).withAlpha(179),
                blurRadius: 25,
                spreadRadius: 2,
              )
            ],
          ),
          child: ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment(shimmerOffset - 0.2, 0.1),
                end: Alignment(shimmerOffset + 0.2, -0.1),
                colors: [
                  Colors.white.withAlpha(0),
                  Colors.white.withAlpha(102),
                  Colors.white.withAlpha(0),
                ],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(rect);
            },
            blendMode: BlendMode.screen,
            child: const Center(
              child: Text(
                'Contenu Magique',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.amberAccent,
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
