import 'dart:math';

import 'package:flutter/material.dart';

import '../animation/demo_animation.dart';
import '../responsive/demo_responsive.dart';
import '../shared/showcase_page_shell.dart';

abstract final class _VolumeDialTokens {
  static const double startAngle = -pi * 0.75;
  static const double sweepAngle = pi * 1.5;
  static const double updateEpsilon = 0.003;
  static const double initialValue = 0.64;
  static const double compactMaxDialSize = 220.0;
  static const double regularMaxDialSize = 300.0;
  static const double minDialHeight = 130.0;
  static const double dialWidthFactor = 0.72;
  static const double maxContentWidth = 520.0;
  static const double compactTitleFontSize = 16.0;
  static const double regularTitleFontSize = 20.0;
  static const double compactTitleGap = 6.0;
  static const double regularTitleGap = 14.0;
  static const double pulseRingBaseSize = 218.0;
  static const double pulseRingSizeRange = 18.0;
  static const double pulseRingAlpha = 0.4;
  static const double pulseRingStrokeWidth = 2.2;
  static const double minArcStrokeWidth = 8.0;
  static const double regularArcStrokeWidth = 12.0;
  static const double knobSize = 210.0;
  static const double pressScale = 0.94;
  static const double knobBorderAlpha = 0.2;
  static const double knobShadowAlpha = 0.42;
  static const double knobShadowBlur = 24.0;
  static const double knobShadowOffset = 12.0;
  static const double indicatorTopInset = 16.0;
  static const double minIndicatorWidth = 9.0;
  static const double regularIndicatorWidth = 12.0;
  static const double indicatorHeight = 70.0;
  static const double indicatorRadius = 10.0;
  static const double arcBaseAlpha = 0.16;
  static const double arcRadiusFactor = 0.42;
  static const double compactHeaderReserve = 30.0;
  static const double regularHeaderReserve = 42.0;
  static const Duration knobPressDuration = Duration(milliseconds: 120);
}

class VolumeControlPage extends StatefulWidget {
  const VolumeControlPage({super.key});

  @override
  State<VolumeControlPage> createState() => _VolumeControlPageState();
}

class _VolumeControlPageState
    extends ManagedSingleTickerState<VolumeControlPage> {
  late final AnimationController _pulse;

  double _value = _VolumeDialTokens.initialValue;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _pulse = createAnimationController(duration: DemoDurations.volumePulse);
  }

  double _valueFromAngle(double angle) {
    var normalized = angle;
    if (normalized < _VolumeDialTokens.startAngle) {
      normalized += pi * 2;
    }

    final clamped = normalized
        .clamp(
          _VolumeDialTokens.startAngle,
          _VolumeDialTokens.startAngle + _VolumeDialTokens.sweepAngle,
        )
        .toDouble();

    return ((clamped - _VolumeDialTokens.startAngle) /
            _VolumeDialTokens.sweepAngle)
        .clamp(0.0, 1.0);
  }

  double _angleFromValue(double value) {
    return _VolumeDialTokens.startAngle +
        (_VolumeDialTokens.sweepAngle * value) +
        (pi / 2);
  }

  void _updateFromLocal(Offset local, Size size) {
    final center = size.center(Offset.zero);
    final raw = atan2(local.dy - center.dy, local.dx - center.dx);
    final newValue = _valueFromAngle(raw);

    if ((newValue - _value).abs() > _VolumeDialTokens.updateEpsilon) {
      _pulse.forward(from: 0);
      setState(() => _value = newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dialAngle = _angleFromValue(_value);

    return ShowcasePageShell(
      pageNumber: 2,
      title: 'Rotary Volume Knob',
      subtitle: 'Drag to rotate the hardware dial with tactile press feedback.',
      hint: 'Drag around the knob edge. Click presses the cap before release.',
      icon: Icons.surround_sound,
      gradient: const [Color(0xFF2A1637), Color(0xFF1B1B34), Color(0xFF0D0F1F)],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = DemoPageLayout.fromConstraints(constraints);
          final headerReserve = layout.compact
              ? _VolumeDialTokens.compactHeaderReserve
              : _VolumeDialTokens.regularHeaderReserve;
          final availableForDial = max(
            _VolumeDialTokens.minDialHeight,
            constraints.maxHeight - headerReserve,
          );
          final dialSize = min(
            layout.compact
                ? _VolumeDialTokens.compactMaxDialSize
                : _VolumeDialTokens.regularMaxDialSize,
            min(
              constraints.maxWidth * _VolumeDialTokens.dialWidthFactor,
              availableForDial,
            ),
          );
          final scale = dialSize / _VolumeDialTokens.regularMaxDialSize;

          return SizedBox(
            width: min(_VolumeDialTokens.maxContentWidth, constraints.maxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Output ${(100 * _value).round()}%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: layout.compact
                        ? _VolumeDialTokens.compactTitleFontSize
                        : _VolumeDialTokens.regularTitleFontSize,
                  ),
                ),
                SizedBox(
                  height: layout.compact
                      ? _VolumeDialTokens.compactTitleGap
                      : _VolumeDialTokens.regularTitleGap,
                ),
                SizedBox(
                  width: dialSize,
                  height: dialSize,
                  child: LayoutBuilder(
                    builder: (context, dialConstraints) {
                      final size = Size(
                        dialConstraints.maxWidth,
                        dialConstraints.maxHeight,
                      );

                      return GestureDetector(
                        onTapDown: (_) {
                          setState(() => _pressed = true);
                          _pulse.forward(from: 0);
                        },
                        onTapUp: (_) => setState(() => _pressed = false),
                        onTapCancel: () => setState(() => _pressed = false),
                        onPanStart: (details) {
                          setState(() => _pressed = true);
                          _updateFromLocal(details.localPosition, size);
                        },
                        onPanUpdate: (details) {
                          _updateFromLocal(details.localPosition, size);
                        },
                        onPanEnd: (_) => setState(() => _pressed = false),
                        child: AnimatedBuilder(
                          animation: _pulse,
                          builder: (context, _) {
                            final pulse = Curves.easeOut.transform(
                              _pulse.value,
                            );
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: size,
                                  painter: _ArcPainter(
                                    value: _value,
                                    strokeWidth: max(
                                      _VolumeDialTokens.minArcStrokeWidth,
                                      _VolumeDialTokens.regularArcStrokeWidth *
                                          scale,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      (_VolumeDialTokens.pulseRingBaseSize +
                                          (pulse *
                                              _VolumeDialTokens
                                                  .pulseRingSizeRange)) *
                                      scale,
                                  height:
                                      (_VolumeDialTokens.pulseRingBaseSize +
                                          (pulse *
                                              _VolumeDialTokens
                                                  .pulseRingSizeRange)) *
                                      scale,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFFFA96C).withValues(
                                        alpha: (_VolumeDialTokens.pulseRingAlpha *
                                                (1 - pulse))
                                            .clamp(
                                          0.0,
                                          1.0,
                                        ),
                                      ),
                                      width:
                                          _VolumeDialTokens.pulseRingStrokeWidth,
                                    ),
                                  ),
                                ),
                                AnimatedScale(
                                  scale: _pressed
                                      ? _VolumeDialTokens.pressScale
                                      : 1,
                                  duration: _VolumeDialTokens.knobPressDuration,
                                  curve: Curves.easeOut,
                                  child: Container(
                                    width: _VolumeDialTokens.knobSize * scale,
                                    height: _VolumeDialTokens.knobSize * scale,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF37475E),
                                          Color(0xFF182232),
                                          Color(0xFF111721),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha:
                                              _VolumeDialTokens.knobBorderAlpha,
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha:
                                                _VolumeDialTokens.knobShadowAlpha,
                                          ),
                                          blurRadius:
                                              _VolumeDialTokens.knobShadowBlur *
                                              scale,
                                          offset: Offset(
                                            0,
                                            _VolumeDialTokens.knobShadowOffset *
                                                scale,
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: Transform.rotate(
                                      angle: dialAngle,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            top: _VolumeDialTokens
                                                .indicatorTopInset *
                                                scale,
                                          ),
                                          width: max(
                                            _VolumeDialTokens.minIndicatorWidth,
                                            _VolumeDialTokens
                                                    .regularIndicatorWidth *
                                                scale,
                                          ),
                                          height:
                                              _VolumeDialTokens.indicatorHeight *
                                              scale,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              _VolumeDialTokens.indicatorRadius,
                                            ),
                                            gradient: const LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xFFFFB86E),
                                                Color(0xFFFF7147),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({required this.value, this.strokeWidth = 12});

  final double value;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * _VolumeDialTokens.arcRadiusFactor;
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: _VolumeDialTokens.arcBaseAlpha);

    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFB86E), Color(0xFFFF6A4F), Color(0xFF7D5BFF)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _VolumeDialTokens.startAngle,
      _VolumeDialTokens.sweepAngle,
      false,
      basePaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _VolumeDialTokens.startAngle,
      _VolumeDialTokens.sweepAngle * value,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.strokeWidth != strokeWidth;
  }
}
