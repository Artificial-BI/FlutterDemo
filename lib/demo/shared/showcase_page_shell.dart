import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../animation/demo_animation.dart';
import '../responsive/demo_responsive.dart';

abstract final class ShowcasePageShellTokens {
  static const double primaryOrbAlpha = 0.34;
  static const double secondaryOrbAlpha = 0.28;
  static const double accentOrbAlpha = 0.14;
  static const double overlayStartAlpha = 0.12;
  static const double overlayEndAlpha = 0.52;
  static const double panelFillAlpha = 0.12;
  static const double panelBorderAlpha = 0.25;
  static const double pageLabelAlpha = 0.68;
  static const double subtitleAlpha = 0.78;
  static const double hintAlpha = 0.68;
  static const double blurSigma = 10.0;
}

class ShowcasePageShell extends StatefulWidget {
  const ShowcasePageShell({
    super.key,
    required this.pageNumber,
    required this.title,
    required this.subtitle,
    required this.hint,
    required this.icon,
    required this.gradient,
    required this.child,
  });

  final int pageNumber;
  final String title;
  final String subtitle;
  final String hint;
  final IconData icon;
  final List<Color> gradient;
  final Widget child;

  @override
  State<ShowcasePageShell> createState() => _ShowcasePageShellState();
}

class _ShowcasePageShellState
    extends ManagedSingleTickerState<ShowcasePageShell> {
  late final AnimationController _ambient;

  @override
  void initState() {
    super.initState();
    _ambient = createAnimationController(duration: DemoDurations.ambientLoop)
      ..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduceTurnEffects = !TickerMode.valuesOf(context).enabled;

    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = DemoPageShellLayout.fromConstraints(constraints);

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradient,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: RepaintBoundary(
                  child: _AmbientBackdrop(
                    animation: _ambient,
                    layout: layout,
                    pageNumber: widget.pageNumber,
                    gradient: widget.gradient,
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(
                          alpha: ShowcasePageShellTokens.overlayStartAlpha,
                        ),
                        Colors.black.withValues(
                          alpha: ShowcasePageShellTokens.overlayEndAlpha,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!reduceTurnEffects)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: ShowcasePageShellTokens.blurSigma,
                      sigmaY: ShowcasePageShellTokens.blurSigma,
                    ),
                    child: const ColoredBox(color: Colors.transparent),
                  ),
                ),
              Positioned.fill(
                child: RepaintBoundary(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      layout.horizontalPadding,
                      layout.topPadding,
                      layout.horizontalPadding,
                      layout.bottomPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: layout.iconSize,
                              height: layout.iconSize,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  layout.compact ? 12 : 14,
                                ),
                                color: Colors.white.withValues(
                                  alpha: ShowcasePageShellTokens.panelFillAlpha,
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(
                                    alpha: ShowcasePageShellTokens
                                        .panelBorderAlpha,
                                  ),
                                ),
                              ),
                              child: Icon(
                                widget.icon,
                                size: layout.compact ? 18 : 20,
                              ),
                            ),
                            SizedBox(width: layout.pageLabelSpacing),
                            Text(
                              'PAGE ${widget.pageNumber}',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white.withValues(
                                  alpha: ShowcasePageShellTokens.pageLabelAlpha,
                                ),
                                letterSpacing: 1.2,
                                fontSize: layout.compact ? 12 : 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: layout.sectionGap),
                        Text(
                          widget.title,
                          maxLines: layout.compact ? 3 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: layout.titleFontSize,
                            letterSpacing: layout.titleLetterSpacing,
                            height: layout.titleHeight,
                          ),
                        ),
                        SizedBox(height: layout.textGap),
                        Text(
                          widget.subtitle,
                          maxLines: layout.compact ? 3 : 4,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(
                              alpha: ShowcasePageShellTokens.subtitleAlpha,
                            ),
                            fontSize: layout.subtitleFontSize,
                            height: layout.subtitleHeight,
                          ),
                        ),
                        SizedBox(height: layout.sectionGap),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, area) {
                              return Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: area.maxWidth,
                                    maxHeight: area.maxHeight,
                                  ),
                                  child: widget.child,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: layout.veryShort
                              ? 4
                              : (layout.short ? 6 : 10),
                        ),
                        Text(
                          widget.hint,
                          maxLines: layout.compact ? 2 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(
                              alpha: ShowcasePageShellTokens.hintAlpha,
                            ),
                            letterSpacing: 0.2,
                            fontSize: layout.hintFontSize,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AmbientBackdrop extends StatelessWidget {
  const _AmbientBackdrop({
    required this.animation,
    required this.layout,
    required this.pageNumber,
    required this.gradient,
  });

  final Animation<double> animation;
  final DemoPageShellLayout layout;
  final int pageNumber;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = animation.value;

        return Stack(
          children: [
            _orb(
              size: layout.primaryOrbSize,
              color: gradient.last.withValues(
                alpha: ShowcasePageShellTokens.primaryOrbAlpha,
              ),
              left: -28 + sin((t + pageNumber * 0.07) * pi * 2) * 24,
              top: -56 + cos((t + pageNumber * 0.03) * pi * 2) * 20,
            ),
            _orb(
              size: layout.secondaryOrbSize,
              color: gradient.first.withValues(
                alpha: ShowcasePageShellTokens.secondaryOrbAlpha,
              ),
              right: -40 + cos((t + pageNumber * 0.11) * pi * 2) * 24,
              bottom: -66 + sin((t + pageNumber * 0.06) * pi * 2) * 22,
            ),
            _orb(
              size: layout.accentOrbSize,
              color: Colors.white.withValues(
                alpha: ShowcasePageShellTokens.accentOrbAlpha,
              ),
              right: 72 + sin((t + pageNumber * 0.05) * pi * 2) * 20,
              top: 70 + cos((t + pageNumber * 0.09) * pi * 2) * 20,
            ),
          ],
        );
      },
    );
  }

  Widget _orb({
    double? left,
    double? top,
    double? right,
    double? bottom,
    required double size,
    required Color color,
  }) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        child: SizedBox(
          width: size,
          height: size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color,
                  blurRadius: size * 0.42,
                  spreadRadius: size * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
