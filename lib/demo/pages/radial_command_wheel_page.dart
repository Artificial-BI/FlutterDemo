import 'dart:math';

import 'package:flutter/material.dart';

import '../animation/demo_animation.dart';
import '../responsive/demo_responsive.dart';
import '../shared/hover_press_surface.dart';
import '../shared/showcase_page_shell.dart';

class _RadialAction {
  const _RadialAction({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

abstract final class _RadialWheelTokens {
  static const double compactAreaSize = 220.0;
  static const double regularAreaSize = 500.0;
  static const double compactAreaWidthFactor = 0.76;
  static const double regularAreaWidthFactor = 1.0;
  static const double compactAreaHeightFactor = 0.74;
  static const double regularAreaHeightFactor = 0.96;
  static const double compactNodeSize = 52.0;
  static const double regularNodeSize = 72.0;
  static const double minNodeSize = 42.0;
  static const double nodeAreaFactor = 0.18;
  static const double compactCenterSize = 84.0;
  static const double regularCenterSize = 110.0;
  static const double minCenterSize = 70.0;
  static const double centerAreaFactor = 0.3;
  static const double compactRadiusBase = 68.0;
  static const double regularRadiusBase = 128.0;
  static const double minRadiusBase = 52.0;
  static const double radiusAreaFactor = 0.34;
  static const double activeNodeAlpha = 0.34;
  static const double idleNodeAlpha = 0.11;
  static const double idleNodeBorderAlpha = 0.24;
  static const double centerFillAlpha = 0.9;
  static const double centerBorderAlpha = 0.6;
  static const double compactNodeIconSize = 22.0;
  static const double regularNodeIconSize = 24.0;
  static const double compactCenterIconSize = 28.0;
  static const double regularCenterIconSize = 30.0;
  static const double itemLabelGap = 4.0;
  static const double nodeHoverOffsetCompact = 2.5;
  static const double nodeHoverOffsetRegular = 3.0;
  static const double staggerStep = 0.06;
}

class RadialCommandWheelPage extends StatefulWidget {
  const RadialCommandWheelPage({super.key});

  @override
  State<RadialCommandWheelPage> createState() => _RadialCommandWheelPageState();
}

class _RadialCommandWheelPageState
    extends ManagedSingleTickerState<RadialCommandWheelPage> {
  late final AnimationController _menu;
  late final List<Animation<double>> _actionAnimations;

  bool _open = false;
  int? _hovered;
  final List<Offset> _hoverOffsets = List<Offset>.filled(6, Offset.zero);

  static const List<_RadialAction> _actions = <_RadialAction>[
    _RadialAction(icon: Icons.flash_on, label: 'Boost'),
    _RadialAction(icon: Icons.shield, label: 'Guard'),
    _RadialAction(icon: Icons.route, label: 'Route'),
    _RadialAction(icon: Icons.waves, label: 'Pulse'),
    _RadialAction(icon: Icons.satellite_alt, label: 'Scan'),
    _RadialAction(icon: Icons.blur_on, label: 'Diffuse'),
  ];

  @override
  void initState() {
    super.initState();
    _menu = createAnimationController(
      duration: DemoDurations.radialMenu,
      value: 0,
    );
    _actionAnimations = buildStaggeredAnimations(
      parent: _menu,
      count: _actions.length,
      step: _RadialWheelTokens.staggerStep,
      curve: Curves.easeOutBack,
    );
  }

  void _toggleMenu() {
    setState(() {
      _open = !_open;
      if (_open) {
        _menu.forward();
      } else {
        _menu.reverse();
        _hovered = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowcasePageShell(
      pageNumber: 8,
      title: 'Radial Command Wheel',
      subtitle: 'Open a futuristic radial menu with staggered fan-out actions.',
      hint:
          'Tap center to open. On Windows, move cursor across nodes for live response.',
      icon: Icons.radar,
      gradient: const [Color(0xFF1D1F43), Color(0xFF111E36), Color(0xFF080B18)],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = DemoPageLayout.fromConstraints(constraints);
          final areaSize = min(
            layout.compact
                ? _RadialWheelTokens.compactAreaSize
                : _RadialWheelTokens.regularAreaSize,
            min(
              constraints.maxWidth *
                  (layout.compact
                      ? _RadialWheelTokens.compactAreaWidthFactor
                      : _RadialWheelTokens.regularAreaWidthFactor),
              constraints.maxHeight *
                  (layout.compact
                      ? _RadialWheelTokens.compactAreaHeightFactor
                      : _RadialWheelTokens.regularAreaHeightFactor),
            ),
          );
          final nodeSize = min(
            layout.compact
                ? _RadialWheelTokens.compactNodeSize
                : _RadialWheelTokens.regularNodeSize,
            max(
              _RadialWheelTokens.minNodeSize,
              areaSize * _RadialWheelTokens.nodeAreaFactor,
            ),
          );
          final centerSize = min(
            layout.compact
                ? _RadialWheelTokens.compactCenterSize
                : _RadialWheelTokens.regularCenterSize,
            max(
              _RadialWheelTokens.minCenterSize,
              areaSize * _RadialWheelTokens.centerAreaFactor,
            ),
          );
          final radiusBase = min(
            layout.compact
                ? _RadialWheelTokens.compactRadiusBase
                : _RadialWheelTokens.regularRadiusBase,
            max(
              _RadialWheelTokens.minRadiusBase,
              areaSize * _RadialWheelTokens.radiusAreaFactor,
            ),
          );
          final areaContext = context;

          return SizedBox(
            width: areaSize,
            height: areaSize,
            child: AnimatedBuilder(
              animation: _menu,
              builder: (context, _) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    ...List.generate(_actions.length, (index) {
                      final item = _actions[index];
                      final value = _actionAnimations[index].value;
                      final angle =
                          (-pi / 2) + (index * (pi * 2 / _actions.length));
                      final radius = radiusBase * value;
                      final hover = _hoverOffsets[index];
                      final offset = Offset(
                        cos(angle) * radius + hover.dx,
                        sin(angle) * radius + hover.dy,
                      );

                      return Transform.translate(
                        offset: offset,
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: MouseRegion(
                            onEnter: (_) => setState(() => _hovered = index),
                            onExit: (_) {
                              setState(() {
                                _hovered = null;
                                _hoverOffsets[index] = Offset.zero;
                              });
                            },
                            onHover: (event) {
                              final box = areaContext.findRenderObject();
                              if (box is! RenderBox) {
                                return;
                              }
                              final local = box.globalToLocal(event.position);
                              final center = box.size.center(Offset.zero);
                              final vector = local - center;
                              final distance = vector.distance;
                              final normal = distance == 0
                                  ? Offset.zero
                                  : Offset(
                                      vector.dx / distance,
                                      vector.dy / distance,
                                    );
                              setState(() {
                                _hoverOffsets[index] =
                                    normal *
                                    (layout.compact
                                        ? _RadialWheelTokens
                                              .nodeHoverOffsetCompact
                                        : _RadialWheelTokens
                                              .nodeHoverOffsetRegular);
                              });
                            },
                            child: HoverPressSurface(
                              onTap: _toggleMenu,
                              width: nodeSize,
                              height: nodeSize,
                              borderRadius: nodeSize / 2,
                              alignment: Alignment.center,
                              background: _hovered == index
                                  ? const Color(
                                      0xFF5BE9FF,
                                    ).withValues(
                                      alpha: _RadialWheelTokens.activeNodeAlpha,
                                    )
                                  : Colors.white.withValues(
                                      alpha: _RadialWheelTokens.idleNodeAlpha,
                                    ),
                              border: Border.all(
                                color: _hovered == index
                                    ? const Color(0xFF7BF0FF)
                                    : Colors.white.withValues(
                                        alpha:
                                            _RadialWheelTokens.idleNodeBorderAlpha,
                                      ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    item.icon,
                                    size: layout.compact
                                        ? _RadialWheelTokens.compactNodeIconSize
                                        : _RadialWheelTokens.regularNodeIconSize,
                                  ),
                                  const SizedBox(
                                    height: _RadialWheelTokens.itemLabelGap,
                                  ),
                                  Text(
                                    item.label,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: layout.compact ? 12 : 14,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    HoverPressSurface(
                      onTap: _toggleMenu,
                      width: centerSize,
                      height: centerSize,
                      borderRadius: centerSize / 2,
                      alignment: Alignment.center,
                      background: const Color(
                        0xFF1B2D48,
                      ).withValues(alpha: _RadialWheelTokens.centerFillAlpha),
                      border: Border.all(
                        color: const Color(0xFF67E5FF).withValues(
                          alpha: _RadialWheelTokens.centerBorderAlpha,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _open ? Icons.close : Icons.adjust,
                            size: layout.compact
                                ? _RadialWheelTokens.compactCenterIconSize
                                : _RadialWheelTokens.regularCenterIconSize,
                          ),
                          const SizedBox(
                            height: _RadialWheelTokens.itemLabelGap,
                          ),
                          Text(_open ? 'Close' : 'Open'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
