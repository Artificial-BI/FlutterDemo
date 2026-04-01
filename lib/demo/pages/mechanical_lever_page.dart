import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../animation/demo_animation.dart';
import '../responsive/demo_responsive.dart';
import '../shared/showcase_page_shell.dart';

abstract final class _MechanicalLeverTokens {
  static const double initialLeverValue = 0.18;
  static const double toggleThreshold = 0.5;
  static const double engagedThreshold = 0.55;
  static const double compactControlWidth = 210.0;
  static const double regularControlWidth = 270.0;
  static const double compactControlWidthFactor = 0.72;
  static const double regularControlWidthFactor = 0.84;
  static const double compactControlHeight = 220.0;
  static const double regularControlHeight = 320.0;
  static const double compactControlHeightFactor = 0.82;
  static const double regularControlHeightFactor = 0.95;
  static const double referenceControlWidth = 270.0;
  static const double referenceControlHeight = 320.0;
  static const double dragRangeMin = 120.0;
  static const double dragRangeBase = 190.0;
  static const double leverStartAngle = 0.72;
  static const double leverEndAngle = -0.72;
  static const double baseBottomOffset = 26.0;
  static const double pressedBaseScale = 0.95;
  static const double baseWidth = 224.0;
  static const double baseHeight = 30.0;
  static const double baseCornerRadius = 15.0;
  static const double baseShadowAlpha = 0.38;
  static const double baseShadowBlur = 20.0;
  static const double baseShadowOffset = 12.0;
  static const double pivotBottomOffset = 56.0;
  static const double pivotWidth = 38.0;
  static const double pivotHeight = 174.0;
  static const double pivotCornerRadius = 18.0;
  static const double leverBottomOffset = 92.0;
  static const double leverWidth = 34.0;
  static const double leverHeight = 142.0;
  static const double handleCornerRadius = 18.0;
  static const double knobSize = 60.0;
  static const double knobGlowAlpha = 0.45;
  static const double knobGlowBlur = 28.0;
  static const double statusTopOffset = 16.0;
  static const double compactStatusFontSize = 16.0;
  static const double regularStatusFontSize = 18.0;
  static const Duration basePressDuration = Duration(milliseconds: 120);
}

class MechanicalLeverPage extends StatefulWidget {
  const MechanicalLeverPage({super.key});

  @override
  State<MechanicalLeverPage> createState() => _MechanicalLeverPageState();
}

class _MechanicalLeverPageState
    extends ManagedSingleTickerState<MechanicalLeverPage> {
  late final AnimationController _lever;

  bool _pressedBase = false;

  @override
  void initState() {
    super.initState();
    _lever = createAnimationController(
      duration: DemoDurations.leverSettle,
      value: _MechanicalLeverTokens.initialLeverValue,
    );
  }

  void _toggle() {
    final target = _lever.value > _MechanicalLeverTokens.toggleThreshold
        ? 0.0
        : 1.0;
    _lever.animateTo(target, curve: Curves.easeOutBack);
  }

  @override
  Widget build(BuildContext context) {
    return ShowcasePageShell(
      pageNumber: 6,
      title: 'Mechanical Lever',
      subtitle: 'A weighted lever with spring settle and base compression.',
      hint: 'Drag vertically or click to engage and disengage the switch.',
      icon: Icons.settings_input_component,
      gradient: const [Color(0xFF2B1F17), Color(0xFF221A25), Color(0xFF0D0A12)],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = DemoPageLayout.fromConstraints(constraints);
          final controlWidth = min(
            layout.compact
                ? _MechanicalLeverTokens.compactControlWidth
                : _MechanicalLeverTokens.regularControlWidth,
            constraints.maxWidth *
                (layout.compact
                    ? _MechanicalLeverTokens.compactControlWidthFactor
                    : _MechanicalLeverTokens.regularControlWidthFactor),
          );
          final controlHeight = min(
            layout.compact
                ? _MechanicalLeverTokens.compactControlHeight
                : _MechanicalLeverTokens.regularControlHeight,
            constraints.maxHeight *
                (layout.compact
                    ? _MechanicalLeverTokens.compactControlHeightFactor
                    : _MechanicalLeverTokens.regularControlHeightFactor),
          );
          final scale = min(
            controlWidth / _MechanicalLeverTokens.referenceControlWidth,
            controlHeight / _MechanicalLeverTokens.referenceControlHeight,
          );
          final dragRange = max(
            _MechanicalLeverTokens.dragRangeMin,
            _MechanicalLeverTokens.dragRangeBase * scale,
          );

          return GestureDetector(
            onTapDown: (_) => setState(() => _pressedBase = true),
            onTapUp: (_) => setState(() => _pressedBase = false),
            onTapCancel: () => setState(() => _pressedBase = false),
            onTap: _toggle,
            onVerticalDragUpdate: (details) {
              _lever.value = (_lever.value - details.delta.dy / dragRange)
                  .clamp(0.0, 1.0);
            },
            onVerticalDragEnd: (_) {
              _lever.animateTo(
                _lever.value > _MechanicalLeverTokens.toggleThreshold ? 1 : 0,
                curve: Curves.easeOutBack,
              );
            },
            child: AnimatedBuilder(
              animation: _lever,
              builder: (context, _) {
                final angle = lerpDouble(
                      _MechanicalLeverTokens.leverStartAngle,
                      _MechanicalLeverTokens.leverEndAngle,
                      _lever.value,
                    ) ??
                    0;
                final engaged =
                    _lever.value > _MechanicalLeverTokens.engagedThreshold;

                return SizedBox(
                  width: controlWidth,
                  height: controlHeight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: _MechanicalLeverTokens.baseBottomOffset * scale,
                        child: AnimatedScale(
                          duration: _MechanicalLeverTokens.basePressDuration,
                          scale: _pressedBase
                              ? _MechanicalLeverTokens.pressedBaseScale
                              : 1,
                          child: Container(
                            width: _MechanicalLeverTokens.baseWidth * scale,
                            height: _MechanicalLeverTokens.baseHeight * scale,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                _MechanicalLeverTokens.baseCornerRadius * scale,
                              ),
                              color: const Color(0xFF483C36),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: _MechanicalLeverTokens.baseShadowAlpha,
                                  ),
                                  blurRadius:
                                      _MechanicalLeverTokens.baseShadowBlur *
                                      scale,
                                  offset: Offset(
                                    0,
                                    _MechanicalLeverTokens.baseShadowOffset *
                                        scale,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: _MechanicalLeverTokens.pivotBottomOffset * scale,
                        child: Container(
                          width: _MechanicalLeverTokens.pivotWidth * scale,
                          height: _MechanicalLeverTokens.pivotHeight * scale,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              _MechanicalLeverTokens.pivotCornerRadius * scale,
                            ),
                            color: const Color(0xFF1E2738),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: _MechanicalLeverTokens.leverBottomOffset * scale,
                        child: Transform.rotate(
                          angle: angle,
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Container(
                                width: _MechanicalLeverTokens.leverWidth * scale,
                                height:
                                    _MechanicalLeverTokens.leverHeight * scale,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    _MechanicalLeverTokens.handleCornerRadius *
                                        scale,
                                  ),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFC5CED8),
                                      Color(0xFF5D6670),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: _MechanicalLeverTokens.knobSize * scale,
                                height: _MechanicalLeverTokens.knobSize * scale,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: engaged
                                      ? const Color(0xFF7AFFB1)
                                      : const Color(0xFFE88B6A),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          (engaged
                                                  ? const Color(0xFF7AFFB1)
                                                  : const Color(0xFFE88B6A))
                                              .withValues(
                                                alpha: _MechanicalLeverTokens
                                                    .knobGlowAlpha,
                                              ),
                                      blurRadius:
                                          _MechanicalLeverTokens.knobGlowBlur *
                                          scale,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: _MechanicalLeverTokens.statusTopOffset * scale,
                        child: Text(
                          engaged ? 'ENGAGED' : 'STANDBY',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontSize:
                                    scale < 0.9
                                        ? _MechanicalLeverTokens
                                            .compactStatusFontSize
                                        : _MechanicalLeverTokens
                                            .regularStatusFontSize,
                              ),
                        ),
                      ),
                    ],
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
