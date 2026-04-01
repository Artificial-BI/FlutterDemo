import 'dart:math';

import 'package:flutter/material.dart';

import '../animation/demo_animation.dart';
import '../responsive/demo_responsive.dart';
import '../shared/hover_press_surface.dart';
import '../shared/showcase_page_shell.dart';

const List<IconData> _introModuleIcons = <IconData>[
  Icons.bolt,
  Icons.blur_circular,
  Icons.shield,
];

const List<String> _introModuleLabels = <String>[
  'Power Routing',
  'Scene Diffusion',
  'Defense Mesh',
];

abstract final class _IntroDeckTokens {
  static const double maxPanelWidth = 540.0;
  static const double compactRevealHeight = 108.0;
  static const double compactRevealHeightFactor = 0.44;
  static const double regularRevealMinHeight = 120.0;
  static const double regularRevealHeightOffset = 122.0;
  static const double compactPanelPadding = 10.0;
  static const double regularPanelPadding = 18.0;
  static const double panelFillAlpha = 0.10;
  static const double panelBorderAlpha = 0.22;
  static const double glowAlphaBase = 0.18;
  static const double glowAlphaRange = 0.20;
  static const double glowBlurBase = 26.0;
  static const double glowBlurRange = 18.0;
  static const double moduleStaggerStep = 0.08;
  static const double moduleStaggerEnd = 0.86;
  static const double initialThrottle = 0.56;
  static const double moduleSlideOffsetY = 0.14;
  static const double compactItemSpacing = 8.0;
  static const double regularItemSpacing = 10.0;
  static const double moduleCardAlpha = 0.07;
  static const double headerBadgeAlpha = 0.14;
  static const double actionButtonAlpha = 0.22;
  static const double enabledToggleAlpha = 0.32;
  static const double disabledToggleAlpha = 0.16;
  static const Duration panelExpandDuration = Duration(milliseconds: 260);
  static const Duration toggleSlideDuration = Duration(milliseconds: 220);
}

class IntroControlDeckPage extends StatefulWidget {
  const IntroControlDeckPage({super.key});

  @override
  State<IntroControlDeckPage> createState() => _IntroControlDeckPageState();
}

class _IntroControlDeckPageState
    extends ManagedSingleTickerState<IntroControlDeckPage> {
  late final AnimationController _expand;
  late final List<Animation<double>> _moduleAnimations;
  late final List<Animation<Offset>> _moduleSlideAnimations;

  bool _expanded = false;
  double _throttle = _IntroDeckTokens.initialThrottle;
  final List<bool> _modules = <bool>[true, false, true];

  @override
  void initState() {
    super.initState();
    _expand = createAnimationController(
      duration: DemoDurations.introDeckExpand,
      value: 0,
    );
    _moduleAnimations = buildStaggeredAnimations(
      parent: _expand,
      count: _introModuleLabels.length,
      step: _IntroDeckTokens.moduleStaggerStep,
      end: _IntroDeckTokens.moduleStaggerEnd,
      curve: Curves.easeOut,
    );
    _moduleSlideAnimations = _moduleAnimations
        .map(
          (animation) => Tween<Offset>(
            begin: const Offset(0, _IntroDeckTokens.moduleSlideOffsetY),
            end: Offset.zero,
          ).animate(animation),
        )
        .toList(growable: false);
  }

  void _toggleDeck() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _expand.forward();
      return;
    }
    _expand.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ShowcasePageShell(
      pageNumber: 1,
      title: 'Intro Control Deck',
      subtitle: 'Expand a compact panel into a cinematic command dashboard.',
      hint: 'Tap the deck to reveal staggered modules and live controls.',
      icon: Icons.space_dashboard,
      gradient: const [Color(0xFF11253D), Color(0xFF131B2F), Color(0xFF070B16)],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = DemoPageLayout.fromConstraints(constraints);
          final panelWidth = min(
            _IntroDeckTokens.maxPanelWidth,
            constraints.maxWidth,
          );
          final panelPadding = layout.compact
              ? _IntroDeckTokens.compactPanelPadding
              : _IntroDeckTokens.regularPanelPadding;
          final revealHeight = layout.compact
              ? min(
                  _IntroDeckTokens.compactRevealHeight,
                  constraints.maxHeight *
                      _IntroDeckTokens.compactRevealHeightFactor,
                )
              : max(
                  _IntroDeckTokens.regularRevealMinHeight,
                  constraints.maxHeight -
                      _IntroDeckTokens.regularRevealHeightOffset,
                );

          return SizedBox(
            width: panelWidth,
            child: AnimatedBuilder(
              animation: _expand,
              builder: (context, _) {
                return AnimatedContainer(
                  duration: _IntroDeckTokens.panelExpandDuration,
                  curve: Curves.easeOut,
                  padding: EdgeInsets.all(panelPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      layout.compact ? 20 : 24,
                    ),
                    color: Colors.white.withValues(
                      alpha: _IntroDeckTokens.panelFillAlpha,
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: _IntroDeckTokens.panelBorderAlpha,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF57DEFF).withValues(
                          alpha:
                              _IntroDeckTokens.glowAlphaBase +
                              (_IntroDeckTokens.glowAlphaRange * _expand.value),
                        ),
                        blurRadius:
                            _IntroDeckTokens.glowBlurBase +
                            (_IntroDeckTokens.glowBlurRange * _expand.value),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _DeckHeader(
                        compact: layout.compact,
                        expanded: _expanded,
                        onToggle: _toggleDeck,
                      ),
                      SizedBox(height: layout.compact ? 10 : 14),
                      ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: _expand.value,
                          child: SizedBox(
                            height: revealHeight,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(top: 4, right: 2),
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  ...List.generate(_introModuleLabels.length, (
                                    index,
                                  ) {
                                    final animation = _moduleAnimations[index];
                                    final slideAnimation =
                                        _moduleSlideAnimations[index];

                                    return SlideTransition(
                                      position: slideAnimation,
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: layout.compact
                                                ? _IntroDeckTokens
                                                      .compactItemSpacing
                                                : _IntroDeckTokens
                                                      .regularItemSpacing,
                                          ),
                                          child: HoverPressSurface(
                                            onTap: () => setState(
                                              () => _modules[index] =
                                                  !_modules[index],
                                            ),
                                            borderRadius: layout.compact
                                                ? 14
                                                : 16,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: layout.compact
                                                  ? 12
                                                  : 14,
                                              vertical: layout.compact
                                                  ? 10
                                                  : 12,
                                            ),
                                            background: Colors.white.withValues(
                                              alpha: _IntroDeckTokens
                                                  .moduleCardAlpha,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  _introModuleIcons[index],
                                                  size: layout.compact
                                                      ? 17
                                                      : 18,
                                                ),
                                                SizedBox(
                                                  width: layout.compact
                                                      ? 8
                                                      : 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    _introModuleLabels[index],
                                                  ),
                                                ),
                                                _DeckToggle(
                                                  compact: layout.compact,
                                                  enabled: _modules[index],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  SizedBox(height: layout.compact ? 2 : 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.speed,
                                        size: layout.compact ? 17 : 18,
                                      ),
                                      SizedBox(width: layout.compact ? 8 : 10),
                                      Text(
                                        'Response Throttle',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontSize: layout.compact
                                                  ? 13
                                                  : 14,
                                            ),
                                      ),
                                      SizedBox(width: layout.compact ? 8 : 12),
                                      Expanded(
                                        child: SliderTheme(
                                          data: SliderTheme.of(context)
                                              .copyWith(
                                                trackHeight: 6,
                                                thumbShape:
                                                    const RoundSliderThumbShape(
                                                      enabledThumbRadius: 8,
                                                    ),
                                              ),
                                          child: Slider(
                                            value: _throttle,
                                            onChanged: (value) {
                                              setState(() => _throttle = value);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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

class _DeckHeader extends StatelessWidget {
  const _DeckHeader({
    required this.compact,
    required this.expanded,
    required this.onToggle,
  });

  final bool compact;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: compact ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: compact
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: compact ? 38 : 42,
              height: compact ? 38 : 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(compact ? 12 : 14),
                color: Colors.white.withValues(
                  alpha: _IntroDeckTokens.headerBadgeAlpha,
                ),
              ),
              child: Icon(Icons.memory, size: compact ? 20 : 24),
            ),
            SizedBox(width: compact ? 10 : 12),
            Expanded(
              child: Text(
                expanded ? 'Control Deck Expanded' : 'Control Deck Compact',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: compact ? 14 : 16),
              ),
            ),
          ],
        ),
        SizedBox(height: compact ? 10 : 0, width: compact ? 0 : 12),
        Align(
          alignment: compact ? Alignment.centerRight : Alignment.centerLeft,
          child: HoverPressSurface(
            onTap: onToggle,
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 12 : 14,
              vertical: compact ? 9 : 10,
            ),
            borderRadius: compact ? 12 : 14,
            background: const Color(0xFF5BDFFF).withValues(
              alpha: _IntroDeckTokens.actionButtonAlpha,
            ),
            child: Text(expanded ? 'Collapse' : 'Expand'),
          ),
        ),
      ],
    );
  }
}

class _DeckToggle extends StatelessWidget {
  const _DeckToggle({required this.compact, required this.enabled});

  final bool compact;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _IntroDeckTokens.toggleSlideDuration,
      width: compact ? 42 : 46,
      height: compact ? 26 : 28,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: enabled
            ? const Color(0xFF66FFE0).withValues(
                alpha: _IntroDeckTokens.enabledToggleAlpha,
              )
            : Colors.white.withValues(
                alpha: _IntroDeckTokens.disabledToggleAlpha,
              ),
      ),
      child: AnimatedAlign(
        duration: _IntroDeckTokens.toggleSlideDuration,
        alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: compact ? 18 : 22,
          height: compact ? 18 : 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled ? const Color(0xFF70FFDF) : Colors.white,
          ),
        ),
      ),
    );
  }
}
