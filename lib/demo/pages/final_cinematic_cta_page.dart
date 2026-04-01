import 'dart:math';

import 'package:flutter/material.dart';

import '../animation/demo_animation.dart';
import '../responsive/demo_responsive.dart';
import '../shared/hover_press_surface.dart';
import '../shared/showcase_page_shell.dart';

abstract final class _FinalCtaTokens {
  static const double primedMoodProgress = 0.35;
  static const double maxPanelWidth = 560.0;
  static const double compactButtonWidth = 180.0;
  static const double regularButtonWidth = 220.0;
  static const double minButtonWidth = 150.0;
  static const double compactButtonInset = 28.0;
  static const double regularButtonInset = 120.0;
  static const double compactRingBase = 96.0;
  static const double regularRingBase = 180.0;
  static const double compactRingRange = 52.0;
  static const double regularRingRange = 120.0;
  static const double compactPanelPadding = 16.0;
  static const double regularPanelPadding = 22.0;
  static const double compactPanelRadius = 20.0;
  static const double regularPanelRadius = 24.0;
  static const double panelFillAlpha = 0.11;
  static const double panelBorderAlpha = 0.24;
  static const double panelGlowAlphaBase = 0.14;
  static const double panelGlowAlphaRange = 0.34;
  static const double panelGlowBlurBase = 30.0;
  static const double panelGlowBlurRange = 24.0;
  static const double compactTitleFontSize = 18.0;
  static const double regularTitleFontSize = 20.0;
  static const double compactBodyFontSize = 14.0;
  static const double regularBodyFontSize = 16.0;
  static const double compactTitleGap = 10.0;
  static const double regularTitleGap = 12.0;
  static const double compactActionGap = 16.0;
  static const double regularActionGap = 20.0;
  static const double ringAlphaBase = 0.32;
  static const double ringBorderWidth = 2.0;
  static const double compactButtonHeight = 58.0;
  static const double regularButtonHeight = 86.0;
  static const double buttonRadius = 18.0;
  static const double successButtonAlpha = 0.28;
  static const double idleButtonAlpha = 0.24;
  static const double compactButtonFontSize = 15.0;
  static const double regularButtonFontSize = 20.0;
  static const double compactFooterGap = 10.0;
  static const double regularFooterGap = 14.0;
  static const double restartSurfaceAlpha = 0.14;
}

class FinalCinematicCtaPage extends StatefulWidget {
  const FinalCinematicCtaPage({super.key, required this.onRestartBook});

  final VoidCallback onRestartBook;

  @override
  State<FinalCinematicCtaPage> createState() => _FinalCinematicCtaPageState();
}

class _FinalCinematicCtaPageState
    extends ManagedTickerState<FinalCinematicCtaPage> {
  late final AnimationController _mood;
  late final AnimationController _pulse;
  late final Listenable _effects;

  int _stage = 0;

  @override
  void initState() {
    super.initState();
    _mood = createAnimationController(duration: DemoDurations.finalMoodShift);
    _pulse = createAnimationController(duration: DemoDurations.finalPulse)
      ..addStatusListener(_handlePulseStatus);
    _effects = Listenable.merge(<Listenable>[_mood, _pulse]);
  }

  void _handlePulseStatus(AnimationStatus status) {
    if (!mounted || status != AnimationStatus.completed || _stage != 2) {
      return;
    }
    setState(() => _stage = 3);
    _mood.forward(from: _mood.value);
  }

  void _advance() {
    if (_stage == 0) {
      setState(() => _stage = 1);
      _mood.animateTo(
        _FinalCtaTokens.primedMoodProgress,
        curve: Curves.easeOut,
      );
      return;
    }

    if (_stage == 1) {
      setState(() => _stage = 2);
      _pulse.forward(from: 0);
      return;
    }

    if (_stage == 3) {
      setState(() => _stage = 0);
      _mood.animateBack(0, curve: Curves.easeInOut);
      _pulse.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mood,
      builder: (context, _) {
        final gradientA = Color.lerp(
          const Color(0xFF17243A),
          const Color(0xFF27476E),
          _mood.value,
        )!;
        final gradientB = Color.lerp(
          const Color(0xFF1E1632),
          const Color(0xFF2F1D3E),
          _mood.value,
        )!;

        return ShowcasePageShell(
          pageNumber: 10,
          title: 'Final Cinematic CTA',
          subtitle:
              'Hover, press, and multi-step success for the closing payoff.',
          hint: 'Prime, execute, then complete the finale sequence.',
          icon: Icons.stars,
          gradient: [gradientA, gradientB, const Color(0xFF090B16)],
          child: LayoutBuilder(
            builder: (context, constraints) {
              final layout = DemoPageLayout.fromConstraints(constraints);
              final panelWidth = min(
                _FinalCtaTokens.maxPanelWidth,
                constraints.maxWidth,
              );
              final buttonWidth = min(
                layout.compact
                    ? _FinalCtaTokens.compactButtonWidth
                    : _FinalCtaTokens.regularButtonWidth,
                max(
                  _FinalCtaTokens.minButtonWidth,
                  panelWidth -
                      (layout.compact
                          ? _FinalCtaTokens.compactButtonInset
                          : _FinalCtaTokens.regularButtonInset),
                ),
              );

              return AnimatedBuilder(
                animation: _effects,
                builder: (context, _) {
                  final pulse = Curves.easeOut.transform(_pulse.value);
                  final ringBase = layout.compact
                      ? _FinalCtaTokens.compactRingBase
                      : _FinalCtaTokens.regularRingBase;
                  final ringRange = layout.compact
                      ? _FinalCtaTokens.compactRingRange
                      : _FinalCtaTokens.regularRingRange;

                  return SizedBox(
                    width: panelWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                            layout.compact
                                ? _FinalCtaTokens.compactPanelPadding
                                : _FinalCtaTokens.regularPanelPadding,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              layout.compact
                                  ? _FinalCtaTokens.compactPanelRadius
                                  : _FinalCtaTokens.regularPanelRadius,
                            ),
                            color: Colors.white.withValues(
                              alpha: _FinalCtaTokens.panelFillAlpha,
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: _FinalCtaTokens.panelBorderAlpha,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6AE5FF).withValues(
                                  alpha: _FinalCtaTokens.panelGlowAlphaBase +
                                      (_FinalCtaTokens.panelGlowAlphaRange *
                                          _mood.value),
                                ),
                                blurRadius:
                                    _FinalCtaTokens.panelGlowBlurBase +
                                    (_FinalCtaTokens.panelGlowBlurRange *
                                        _mood.value),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                [
                                  'Stage 1: Prime Sequence',
                                  'Stage 2: Confirm Execution',
                                  'Processing...',
                                  'Success: Sequence Complete',
                                ][_stage],
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontSize: layout.compact
                                          ? _FinalCtaTokens.compactTitleFontSize
                                          : _FinalCtaTokens.regularTitleFontSize,
                                    ),
                              ),
                              SizedBox(
                                height: layout.compact
                                    ? _FinalCtaTokens.compactTitleGap
                                    : _FinalCtaTokens.regularTitleGap,
                              ),
                              Text(
                                _stage == 3
                                    ? 'Cinematic mode reached. You can reset or restart the full book.'
                                    : 'This is a multi-step CTA with deliberate progression.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontSize: layout.compact
                                          ? _FinalCtaTokens.compactBodyFontSize
                                          : _FinalCtaTokens.regularBodyFontSize,
                                    ),
                              ),
                              SizedBox(
                                height: layout.compact
                                    ? _FinalCtaTokens.compactActionGap
                                    : _FinalCtaTokens.regularActionGap,
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: ringBase + (pulse * ringRange),
                                    height: ringBase + (pulse * ringRange),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF7DE8FF)
                                            .withValues(
                                              alpha: (_FinalCtaTokens
                                                          .ringAlphaBase *
                                                      (1 - pulse))
                                                  .clamp(0.0, 1.0),
                                            ),
                                        width: _FinalCtaTokens.ringBorderWidth,
                                      ),
                                    ),
                                  ),
                                  HoverPressSurface(
                                    onTap: _stage == 2 ? null : _advance,
                                    width: buttonWidth,
                                    height: layout.compact
                                        ? _FinalCtaTokens.compactButtonHeight
                                        : _FinalCtaTokens.regularButtonHeight,
                                    borderRadius: _FinalCtaTokens.buttonRadius,
                                    alignment: Alignment.center,
                                    background: _stage == 3
                                        ? const Color(
                                            0xFF7DFFBF,
                                          ).withValues(
                                            alpha:
                                                _FinalCtaTokens.successButtonAlpha,
                                          )
                                        : const Color(
                                            0xFF5BA2FF,
                                          ).withValues(
                                            alpha:
                                                _FinalCtaTokens.idleButtonAlpha,
                                          ),
                                    border: Border.all(
                                      color: _stage == 3
                                          ? const Color(0xFFA0FFD3)
                                          : const Color(0xFF8CC7FF),
                                    ),
                                    child: Text(
                                      _stage == 0
                                          ? 'Prime CTA'
                                          : _stage == 1
                                          ? 'Execute CTA'
                                          : _stage == 2
                                          ? 'Executing...'
                                          : 'Reset CTA',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontSize: layout.compact
                                                ? _FinalCtaTokens
                                                    .compactButtonFontSize
                                                : _FinalCtaTokens
                                                    .regularButtonFontSize,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: layout.compact
                              ? _FinalCtaTokens.compactFooterGap
                              : _FinalCtaTokens.regularFooterGap,
                        ),
                        HoverPressSurface(
                          onTap: widget.onRestartBook,
                          padding: EdgeInsets.symmetric(
                            horizontal: layout.compact ? 14 : 18,
                            vertical: layout.compact ? 10 : 12,
                          ),
                          borderRadius: 14,
                          background: Colors.white.withValues(
                            alpha: _FinalCtaTokens.restartSurfaceAlpha,
                          ),
                          child: const Text('Restart Entire Book'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
