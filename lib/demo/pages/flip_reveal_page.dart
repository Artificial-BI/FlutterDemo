import 'dart:math';

import 'package:flutter/material.dart';

import '../animation/demo_animation.dart';
import '../responsive/demo_responsive.dart';
import '../shared/showcase_page_shell.dart';

abstract final class _FlipRevealTokens {
  static const double cardPerspective = 0.0018;
  static const double compactCardHeight = 210.0;
  static const double regularCardHeight = 360.0;
  static const double compactCardHeightFactor = 0.74;
  static const double regularCardHeightFactor = 0.92;
  static const double compactCardWidth = 230.0;
  static const double regularCardWidth = 290.0;
  static const double cardWidthFactor = 0.78;
  static const double cardAspectRatio = 0.86;
  static const double sheenAlphaCap = 0.35;
  static const double surfaceBorderAlpha = 0.26;
  static const double surfaceFillAlpha = 0.11;
  static const double surfaceShadowAlpha = 0.34;
  static const double surfaceShadowBlur = 28.0;
  static const double surfaceShadowOffsetY = 16.0;
}

class FlipRevealPage extends StatefulWidget {
  const FlipRevealPage({super.key});

  @override
  State<FlipRevealPage> createState() => _FlipRevealPageState();
}

class _FlipRevealPageState extends ManagedSingleTickerState<FlipRevealPage> {
  late final AnimationController _flip;

  bool _front = true;

  @override
  void initState() {
    super.initState();
    _flip = createAnimationController(duration: DemoDurations.flipCard);
  }

  void _toggle() {
    setState(() => _front = !_front);
    if (_front) {
      _flip.reverse();
      return;
    }
    _flip.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ShowcasePageShell(
      pageNumber: 5,
      title: '3D Flip Reveal',
      subtitle: 'A perspective card turns with a moving glass sheen highlight.',
      hint: 'Tap the card to flip between front and back faces.',
      icon: Icons.flip,
      gradient: const [Color(0xFF1C1F38), Color(0xFF1B1732), Color(0xFF090C17)],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = DemoPageLayout.fromConstraints(constraints);
          final cardHeight = min(
            layout.compact
                ? _FlipRevealTokens.compactCardHeight
                : _FlipRevealTokens.regularCardHeight,
            constraints.maxHeight *
                (layout.compact
                    ? _FlipRevealTokens.compactCardHeightFactor
                    : _FlipRevealTokens.regularCardHeightFactor),
          );
          final cardWidth = min(
            layout.compact
                ? _FlipRevealTokens.compactCardWidth
                : _FlipRevealTokens.regularCardWidth,
            min(
              constraints.maxWidth * _FlipRevealTokens.cardWidthFactor,
              cardHeight * _FlipRevealTokens.cardAspectRatio,
            ),
          );

          return GestureDetector(
            onTap: _toggle,
            child: AnimatedBuilder(
              animation: _flip,
              builder: (context, _) {
                final angle = _flip.value * pi;
                final showingFront = angle <= pi / 2;
                final sheen =
                    (sin(angle).abs() * _FlipRevealTokens.sheenAlphaCap).clamp(
                      0.0,
                      _FlipRevealTokens.sheenAlphaCap,
                    );

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, _FlipRevealTokens.cardPerspective)
                    ..rotateY(angle),
                  child: SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          layout.compact ? 20 : 24,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: _FlipRevealTokens.surfaceBorderAlpha,
                          ),
                        ),
                        color: Colors.white.withValues(
                          alpha: _FlipRevealTokens.surfaceFillAlpha,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: _FlipRevealTokens.surfaceShadowAlpha,
                            ),
                            blurRadius: _FlipRevealTokens.surfaceShadowBlur,
                            offset: const Offset(
                              0,
                              _FlipRevealTokens.surfaceShadowOffsetY,
                            ),
                          ),
                        ],
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Transform(
                            alignment: Alignment.center,
                            transform: showingFront
                                ? Matrix4.identity()
                                : Matrix4.rotationY(pi),
                            child: _FlipFace(
                              compact: layout.compact,
                              icon: showingFront
                                  ? Icons.layers
                                  : Icons.auto_fix_high,
                              title: showingFront
                                  ? 'Front Layer'
                                  : 'Back Layer',
                              description: showingFront
                                  ? 'Tap to rotate the card in depth and reveal hidden data.'
                                  : 'Reveal complete. Tap again to snap back to the front.',
                            ),
                          ),
                          Positioned.fill(
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    layout.compact ? 20 : 24,
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment(
                                      -1 + (_flip.value * 2),
                                      -1,
                                    ),
                                    end: Alignment(1 + (_flip.value * 2), 1),
                                    colors: [
                                      Colors.white.withValues(
                                        alpha: sheen.toDouble(),
                                      ),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _FlipFace extends StatelessWidget {
  const _FlipFace({
    required this.compact,
    required this.icon,
    required this.title,
    required this.description,
  });

  final bool compact;
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(compact ? 12 : 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: compact ? 30 : 36),
          SizedBox(height: compact ? 8 : 18),
          Text(
            title,
            style: TextStyle(
              fontSize: compact ? 18 : 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: compact ? 10 : 12),
          Text(description, style: TextStyle(fontSize: compact ? 14 : 16)),
        ],
      ),
    );
  }
}
