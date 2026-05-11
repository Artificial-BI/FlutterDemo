import 'dart:math';

import 'package:flutter/material.dart';

import '../animation/demo_animation.dart';
import '../responsive/demo_responsive.dart';
import '../shared/hover_press_surface.dart';
import '../shared/showcase_page_shell.dart';

abstract final class _ChargeHoldTokens {
  static const double compactAreaSize = 220.0;
  static const double regularAreaSize = 500.0;
  static const double compactAreaWidthFactor = 0.76;
  static const double regularAreaWidthFactor = 1.0;
  static const double compactAreaHeightFactor = 0.72;
  static const double regularAreaHeightFactor = 0.96;
  static const double compactRingSize = 150.0;
  static const double regularRingSize = 250.0;
  static const double ringAreaFactor = 0.72;
  static const double compactCoreSize = 92.0;
  static const double regularCoreSize = 140.0;
  static const double coreAreaFactor = 0.40;
  static const double coreGrowthAreaFactor = 0.08;
  static const int burstParticleCount = 16;
  static const double burstBaseDistanceFactor = 0.18;
  static const double burstTravelAreaFactor = 0.48;
  static const double burstOpacityBase = 0.9;
  static const double compactParticleSize = 6.0;
  static const double regularParticleSize = 7.0;
  static const double completedCoreAlpha = 0.34;
  static const double idleCoreAlpha = 0.9;
  static const double idleBorderAlpha = 0.6;
  static const double coreGlowAlpha = 0.42;
  static const double coreGlowBlur = 30.0;
  static const double coreGlowSpread = 2.0;
  static const double hintMinBottomInset = 8.0;
  static const double hintBottomFactor = 0.04;
  static const double compactHintFontSize = 12.5;
  static const double regularHintFontSize = 16.0;
  static const double compactFooterHeight = 42.0;
  static const double regularFooterHeight = 48.0;
  static const double compactRingFooterGap = 14.0;
  static const double regularRingFooterGap = 18.0;
  static const double ringRadiusFactor = 0.42;
  static const double ringStrokeWidth = 12.0;
  static const double ringBaseAlpha = 0.14;
  static const double restartSurfaceAlpha = 0.14;
}

class ChargeAndHoldPage extends StatefulWidget {
  const ChargeAndHoldPage({super.key});

  @override
  State<ChargeAndHoldPage> createState() => _ChargeAndHoldPageState();
}

class _ChargeAndHoldPageState extends ManagedTickerState<ChargeAndHoldPage> {
  late final AnimationController _hold;
  late final AnimationController _burst;
  late final Listenable _effects;

  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _hold = createAnimationController(duration: DemoDurations.holdCharge)
      ..addStatusListener(_handleHoldStatus);
    _burst = createAnimationController(duration: DemoDurations.holdBurst);
    _effects = Listenable.merge(<Listenable>[_hold, _burst]);
  }

  void _handleHoldStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_completed && mounted) {
      setState(() => _completed = true);
      _burst.forward(from: 0);
    }
  }

  void _startHold() {
    if (_completed) {
      return;
    }
    _hold.forward();
  }

  void _releaseHold() {
    if (_completed) {
      return;
    }
    _hold.animateBack(
      0,
      duration: DemoDurations.holdRelease,
      curve: Curves.easeOut,
    );
  }

  void _reset() {
    setState(() {
      _completed = false;
      _hold.stop();
      _hold.value = 0;
      _burst.stop();
      _burst.value = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowcasePageShell(
      pageNumber: 9,
      title: 'Charge And Hold',
      subtitle:
          'Press and hold to fill the ring and trigger a cinematic burst.',
      hint: 'Hold to charge. Releasing early drains the ring back down.',
      icon: Icons.bolt,
      gradient: const [Color(0xFF231B3C), Color(0xFF1A142B), Color(0xFF0A0915)],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = DemoPageLayout.fromConstraints(constraints);
          final areaSize = min(
            layout.compact
                ? _ChargeHoldTokens.compactAreaSize
                : _ChargeHoldTokens.regularAreaSize,
            min(
              constraints.maxWidth *
                  (layout.compact
                      ? _ChargeHoldTokens.compactAreaWidthFactor
                      : _ChargeHoldTokens.regularAreaWidthFactor),
              constraints.maxHeight *
                  (layout.compact
                      ? _ChargeHoldTokens.compactAreaHeightFactor
                      : _ChargeHoldTokens.regularAreaHeightFactor),
            ),
          );

          return AnimatedBuilder(
            animation: _effects,
            child: _ChargeFooter(
              compact: layout.compact,
              completed: _completed,
              onReset: _reset,
            ),
            builder: (context, footer) {
              final progress = Curves.easeOut.transform(_hold.value);
              final burst = Curves.easeOut.transform(_burst.value);
              final ringSize = min(
                layout.compact
                    ? _ChargeHoldTokens.compactRingSize
                    : _ChargeHoldTokens.regularRingSize,
                areaSize * _ChargeHoldTokens.ringAreaFactor,
              );
              final coreBase = min(
                layout.compact
                    ? _ChargeHoldTokens.compactCoreSize
                    : _ChargeHoldTokens.regularCoreSize,
                areaSize * _ChargeHoldTokens.coreAreaFactor,
              );
              final coreSize =
                  coreBase +
                  (progress *
                      (areaSize * _ChargeHoldTokens.coreGrowthAreaFactor));
              final footerHeight = layout.compact
                  ? _ChargeHoldTokens.compactFooterHeight
                  : _ChargeHoldTokens.regularFooterHeight;
              final ringFooterGap = layout.compact
                  ? _ChargeHoldTokens.compactRingFooterGap
                  : _ChargeHoldTokens.regularRingFooterGap;
              final footerBottom = max(
                _ChargeHoldTokens.hintMinBottomInset,
                areaSize * _ChargeHoldTokens.hintBottomFactor,
              );
              final ringBottom = (areaSize + ringSize) / 2;
              final footerTop = areaSize - footerBottom - footerHeight;
              final overlap = ringBottom + ringFooterGap - footerTop;
              final ringOffsetY = _completed && overlap > 0 ? -overlap : 0.0;

              return SizedBox(
                width: areaSize,
                height: areaSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, ringOffsetY),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _BurstParticles(
                            areaSize: areaSize,
                            burst: burst,
                            compact: layout.compact,
                            completed: _completed,
                            ringSize: ringSize,
                          ),
                          _ChargeRing(ringSize: ringSize, progress: progress),
                          _ChargeCore(
                            compact: layout.compact,
                            completed: _completed,
                            coreSize: coreSize,
                            onRelease: _releaseHold,
                            onStart: _startHold,
                            progress: progress,
                          ),
                        ],
                      ),
                    ),
                    Positioned(bottom: footerBottom, child: footer!),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _BurstParticles extends StatelessWidget {
  const _BurstParticles({
    required this.areaSize,
    required this.burst,
    required this.compact,
    required this.completed,
    required this.ringSize,
  });

  final double areaSize;
  final double burst;
  final bool compact;
  final bool completed;
  final double ringSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(_ChargeHoldTokens.burstParticleCount, (index) {
          final angle =
              index * ((2 * pi) / _ChargeHoldTokens.burstParticleCount);
          final distance =
              (ringSize * _ChargeHoldTokens.burstBaseDistanceFactor) +
              (burst * (areaSize * _ChargeHoldTokens.burstTravelAreaFactor));
          final opacity = (_ChargeHoldTokens.burstOpacityBase - burst).clamp(
            0.0,
            1.0,
          );

          return Transform.translate(
            offset: Offset(cos(angle) * distance, sin(angle) * distance),
            child: Opacity(
              opacity: completed ? opacity.toDouble() : 0,
              child: Container(
                width: compact
                    ? _ChargeHoldTokens.compactParticleSize
                    : _ChargeHoldTokens.regularParticleSize,
                height: compact
                    ? _ChargeHoldTokens.compactParticleSize
                    : _ChargeHoldTokens.regularParticleSize,
                decoration: const BoxDecoration(
                  color: Color(0xFF92E9FF),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ChargeRing extends StatelessWidget {
  const _ChargeRing({required this.ringSize, required this.progress});

  final double ringSize;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(ringSize),
      painter: _HoldRingPainter(value: progress),
    );
  }
}

class _ChargeCore extends StatelessWidget {
  const _ChargeCore({
    required this.compact,
    required this.completed,
    required this.coreSize,
    required this.onRelease,
    required this.onStart,
    required this.progress,
  });

  final bool compact;
  final bool completed;
  final double coreSize;
  final VoidCallback onRelease;
  final VoidCallback onStart;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onStart(),
      onTapUp: (_) => onRelease(),
      onTapCancel: onRelease,
      onLongPressStart: (_) => onStart(),
      onLongPressEnd: (_) => onRelease(),
      child: AnimatedContainer(
        duration: DemoDurations.hoverSurface,
        width: coreSize,
        height: coreSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: completed
              ? const Color(
                  0xFF79FFD3,
                ).withValues(alpha: _ChargeHoldTokens.completedCoreAlpha)
              : const Color(
                  0xFF27344C,
                ).withValues(alpha: _ChargeHoldTokens.idleCoreAlpha),
          border: Border.all(
            color: completed
                ? const Color(0xFF90FFE0)
                : const Color(
                    0xFF7EDFFF,
                  ).withValues(alpha: _ChargeHoldTokens.idleBorderAlpha),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  (completed
                          ? const Color(0xFF79FFD3)
                          : const Color(0xFF7EDFFF))
                      .withValues(alpha: _ChargeHoldTokens.coreGlowAlpha),
              blurRadius: _ChargeHoldTokens.coreGlowBlur,
              spreadRadius: _ChargeHoldTokens.coreGlowSpread,
            ),
          ],
        ),
        child: Text(
          completed ? 'CHARGED' : '${(progress * 100).round()}%',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontSize: compact ? 17 : 20),
        ),
      ),
    );
  }
}

class _ChargeFooter extends StatelessWidget {
  const _ChargeFooter({
    required this.compact,
    required this.completed,
    required this.onReset,
  });

  final bool compact;
  final bool completed;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    if (completed) {
      return HoverPressSurface(
        onTap: onReset,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 14 : 18,
          vertical: compact ? 10 : 12,
        ),
        borderRadius: 14,
        background: Colors.white.withValues(
          alpha: _ChargeHoldTokens.restartSurfaceAlpha,
        ),
        child: const Text('Rearm Charge'),
      );
    }

    return Text(
      'Press and hold the core',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontSize: compact
            ? _ChargeHoldTokens.compactHintFontSize
            : _ChargeHoldTokens.regularHintFontSize,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _HoldRingPainter extends CustomPainter {
  _HoldRingPainter({required this.value});

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * _ChargeHoldTokens.ringRadiusFactor;
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _ChargeHoldTokens.ringStrokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: _ChargeHoldTokens.ringBaseAlpha);

    final fill = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _ChargeHoldTokens.ringStrokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        startAngle: -pi / 2,
        endAngle: pi * 1.5,
        colors: [
          Color(0xFF52E8FF),
          Color(0xFF80FFCF),
          Color(0xFFFFC27B),
          Color(0xFF52E8FF),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, base);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      pi * 2 * value,
      false,
      fill,
    );
  }

  @override
  bool shouldRepaint(covariant _HoldRingPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
