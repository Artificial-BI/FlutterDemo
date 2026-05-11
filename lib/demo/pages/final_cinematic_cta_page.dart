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
  static const double ringAlphaBase = 0.16;
  static const double ringBorderWidth = 2.0;
  static const double ringVisibleThreshold = 0.02;
  static const double pulseVerticalRangeFactor = 0.35;
  static const double pulseRadiusRange = 10.0;
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
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  void _restartEntireBook() {
    setState(() => _stage = 0);
    _mood.stop();
    _mood.value = 0;
    _pulse.stop();
    _pulse.value = 0;
    widget.onRestartBook();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mood,
      builder: (context, _) {
        final safeMood = _mood.value.clamp(0.0, 1.0);
        const gradientAStart = Color(0xFF17243A);
        const gradientBStart = Color(0xFF1E1632);
        final gradientA =
            Color.lerp(gradientAStart, const Color(0xFF27476E), safeMood) ??
            gradientAStart;
        final gradientB =
            Color.lerp(gradientBStart, const Color(0xFF2F1D3E), safeMood) ??
            gradientBStart;

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
                child: _FinalRestartButton(
                  compact: layout.compact,
                  onTap: _restartEntireBook,
                ),
                builder: (context, restartButton) {
                  final pulse = Curves.easeOut.transform(_pulse.value);
                  final ringRange = layout.compact
                      ? _FinalCtaTokens.compactRingRange
                      : _FinalCtaTokens.regularRingRange;
                  final buttonHeight = layout.compact
                      ? _FinalCtaTokens.compactButtonHeight
                      : _FinalCtaTokens.regularButtonHeight;

                  return SizedBox(
                    width: panelWidth,
                    child: _FinalCtaPanel(
                      buttonWidth: buttonWidth,
                      compact: layout.compact,
                      moodValue: _mood.value,
                      onAdvance: _advance,
                      pulse: pulse,
                      restartButton: restartButton!,
                      ringRange: ringRange,
                      stage: _stage,
                      buttonHeight: buttonHeight,
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

class _FinalCtaPanel extends StatelessWidget {
  const _FinalCtaPanel({
    required this.buttonWidth,
    required this.buttonHeight,
    required this.compact,
    required this.moodValue,
    required this.onAdvance,
    required this.pulse,
    required this.restartButton,
    required this.ringRange,
    required this.stage,
  });

  final double buttonWidth;
  final double buttonHeight;
  final bool compact;
  final double moodValue;
  final VoidCallback onAdvance;
  final double pulse;
  final Widget restartButton;
  final double ringRange;
  final int stage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(
            compact
                ? _FinalCtaTokens.compactPanelPadding
                : _FinalCtaTokens.regularPanelPadding,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              compact
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
                  alpha:
                      _FinalCtaTokens.panelGlowAlphaBase +
                      (_FinalCtaTokens.panelGlowAlphaRange * moodValue),
                ),
                blurRadius:
                    _FinalCtaTokens.panelGlowBlurBase +
                    (_FinalCtaTokens.panelGlowBlurRange * moodValue),
              ),
            ],
          ),
          child: Column(
            children: [
              _FinalCtaStatus(compact: compact, stage: stage),
              SizedBox(
                height: compact
                    ? _FinalCtaTokens.compactActionGap
                    : _FinalCtaTokens.regularActionGap,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  _FinalPulseRing(
                    buttonHeight: buttonHeight,
                    buttonWidth: buttonWidth,
                    pulse: pulse,
                    ringRange: ringRange,
                    stage: stage,
                  ),
                  _FinalCtaButton(
                    buttonWidth: buttonWidth,
                    compact: compact,
                    onAdvance: onAdvance,
                    stage: stage,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: compact
              ? _FinalCtaTokens.compactFooterGap
              : _FinalCtaTokens.regularFooterGap,
        ),
        restartButton,
      ],
    );
  }
}

class _FinalCtaStatus extends StatelessWidget {
  const _FinalCtaStatus({required this.compact, required this.stage});

  final bool compact;
  final int stage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          [
            'Stage 1: Prime Sequence',
            'Stage 2: Confirm Execution',
            'Processing...',
            'Success: Sequence Complete',
          ][stage],
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: compact
                ? _FinalCtaTokens.compactTitleFontSize
                : _FinalCtaTokens.regularTitleFontSize,
          ),
        ),
        SizedBox(
          height: compact
              ? _FinalCtaTokens.compactTitleGap
              : _FinalCtaTokens.regularTitleGap,
        ),
        Text(
          stage == 3
              ? 'Cinematic mode reached. You can reset or restart the full book.'
              : 'This is a multi-step CTA with deliberate progression.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: compact
                ? _FinalCtaTokens.compactBodyFontSize
                : _FinalCtaTokens.regularBodyFontSize,
          ),
        ),
      ],
    );
  }
}

class _FinalPulseRing extends StatelessWidget {
  const _FinalPulseRing({
    required this.buttonHeight,
    required this.buttonWidth,
    required this.pulse,
    required this.ringRange,
    required this.stage,
  });

  final double buttonHeight;
  final double buttonWidth;
  final double pulse;
  final double ringRange;
  final int stage;

  @override
  Widget build(BuildContext context) {
    if (stage != 2 || pulse <= _FinalCtaTokens.ringVisibleThreshold) {
      return SizedBox(width: buttonWidth, height: buttonHeight);
    }

    final alpha = (_FinalCtaTokens.ringAlphaBase * (1 - pulse)).clamp(0.0, 1.0);
    final verticalRange = ringRange * _FinalCtaTokens.pulseVerticalRangeFactor;

    return Container(
      width: buttonWidth + (pulse * ringRange),
      height: buttonHeight + (pulse * verticalRange),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          _FinalCtaTokens.buttonRadius +
              (pulse * _FinalCtaTokens.pulseRadiusRange),
        ),
        border: Border.all(
          color: const Color(0xFF7DE8FF).withValues(alpha: alpha),
          width: _FinalCtaTokens.ringBorderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7DE8FF).withValues(alpha: alpha * 0.55),
            blurRadius: 18,
          ),
        ],
      ),
    );
  }
}

class _FinalCtaButton extends StatelessWidget {
  const _FinalCtaButton({
    required this.buttonWidth,
    required this.compact,
    required this.onAdvance,
    required this.stage,
  });

  final double buttonWidth;
  final bool compact;
  final VoidCallback onAdvance;
  final int stage;

  @override
  Widget build(BuildContext context) {
    return HoverPressSurface(
      onTap: stage == 2 ? null : onAdvance,
      width: buttonWidth,
      height: compact
          ? _FinalCtaTokens.compactButtonHeight
          : _FinalCtaTokens.regularButtonHeight,
      borderRadius: _FinalCtaTokens.buttonRadius,
      alignment: Alignment.center,
      background: stage == 3
          ? const Color(
              0xFF7DFFBF,
            ).withValues(alpha: _FinalCtaTokens.successButtonAlpha)
          : const Color(
              0xFF5BA2FF,
            ).withValues(alpha: _FinalCtaTokens.idleButtonAlpha),
      border: Border.all(
        color: stage == 3 ? const Color(0xFFA0FFD3) : const Color(0xFF8CC7FF),
      ),
      child: Text(
        stage == 0
            ? 'Prime CTA'
            : stage == 1
            ? 'Execute CTA'
            : stage == 2
            ? 'Executing...'
            : 'Reset CTA',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: compact
              ? _FinalCtaTokens.compactButtonFontSize
              : _FinalCtaTokens.regularButtonFontSize,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _FinalRestartButton extends StatelessWidget {
  const _FinalRestartButton({required this.compact, required this.onTap});

  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverPressSurface(
      onTap: onTap,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 14 : 18,
        vertical: compact ? 10 : 12,
      ),
      borderRadius: 14,
      background: Colors.white.withValues(
        alpha: _FinalCtaTokens.restartSurfaceAlpha,
      ),
      child: const Text('Restart Entire Book'),
    );
  }
}
