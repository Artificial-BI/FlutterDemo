import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<Widget> buildDemoPages({required VoidCallback onRestartBook}) {
  return [
    const IntroPulsePage(),
    const VolumeControlPage(),
    const BrightnessDimmerPage(),
    const MorphTogglePage(),
    const FlipRevealPage(),
    const MechanicalLeverPage(),
    const DialControlPage(),
    const ExpandablePanelPage(),
    const CinematicButtonsPage(),
    FinalWowPage(onRestartBook: onRestartBook),
  ];
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

class _ShowcasePageShellState extends State<ShowcasePageShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ambient = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ambient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _ambient,
      builder: (context, _) {
        final t = _ambient.value;

        return LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 430;
            final short = constraints.maxHeight < 470;
            final veryShort = constraints.maxHeight < 360;
            final horizontalPadding = compact ? 14.0 : 24.0;
            final topPadding = veryShort
                ? 10.0
                : (short ? 12.0 : (compact ? 16.0 : 22.0));
            final bottomPadding = veryShort ? 10.0 : (compact ? 12.0 : 24.0);
            final sectionGap = veryShort ? 8.0 : (short ? 10.0 : 16.0);
            final textGap = veryShort ? 4.0 : (short ? 6.0 : 8.0);
            final iconSize = compact ? 34.0 : 42.0;

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
                  _orb(
                    size: compact ? 220 : 260,
                    color: widget.gradient.last.withValues(alpha: 0.34),
                    left:
                        -28 + sin((t + widget.pageNumber * 0.07) * pi * 2) * 24,
                    top:
                        -56 + cos((t + widget.pageNumber * 0.03) * pi * 2) * 20,
                  ),
                  _orb(
                    size: compact ? 190 : 220,
                    color: widget.gradient.first.withValues(alpha: 0.28),
                    right:
                        -40 + cos((t + widget.pageNumber * 0.11) * pi * 2) * 24,
                    bottom:
                        -66 + sin((t + widget.pageNumber * 0.06) * pi * 2) * 22,
                  ),
                  _orb(
                    size: compact ? 120 : 140,
                    color: Colors.white.withValues(alpha: 0.14),
                    right:
                        72 + sin((t + widget.pageNumber * 0.05) * pi * 2) * 20,
                    top: 70 + cos((t + widget.pageNumber * 0.09) * pi * 2) * 20,
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.12),
                            Colors.black.withValues(alpha: 0.52),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        topPadding,
                        horizontalPadding,
                        bottomPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: iconSize,
                                height: iconSize,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    compact ? 12 : 14,
                                  ),
                                  color: Colors.white.withValues(alpha: 0.12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Icon(
                                  widget.icon,
                                  size: compact ? 18 : 20,
                                ),
                              ),
                              SizedBox(width: compact ? 10 : 12),
                              Text(
                                'PAGE ${widget.pageNumber}',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.68),
                                  letterSpacing: 1.2,
                                  fontSize: compact ? 12 : 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: sectionGap),
                          Text(
                            widget.title,
                            maxLines: compact ? 3 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: veryShort ? 18 : (compact ? 20 : 24),
                              letterSpacing: compact ? 0.5 : 1.0,
                              height: compact ? 1.05 : 1.1,
                            ),
                          ),
                          SizedBox(height: textGap),
                          Text(
                            widget.subtitle,
                            maxLines: compact ? 3 : 4,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.78),
                              fontSize: veryShort ? 12.5 : (compact ? 13.5 : 16),
                              height: compact ? 1.2 : 1.35,
                            ),
                          ),
                          SizedBox(height: sectionGap),
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
                          SizedBox(height: veryShort ? 4 : (short ? 6 : 10)),
                          Text(
                            widget.hint,
                            maxLines: compact ? 2 : 3,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.68),
                              letterSpacing: 0.2,
                              fontSize: veryShort ? 11 : (compact ? 12 : 14),
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
        child: Container(
          width: size,
          height: size,
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
    );
  }
}

class HoverPressSurface extends StatefulWidget {
  const HoverPressSurface({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.width,
    this.height,
    this.alignment,
    this.borderRadius = 18,
    this.background,
    this.border,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final double borderRadius;
  final Color? background;
  final Border? border;

  @override
  State<HoverPressSurface> createState() => _HoverPressSurfaceState();
}

class _HoverPressSurfaceState extends State<HoverPressSurface> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final canTap = widget.onTap != null;

    return FocusableActionDetector(
      enabled: canTap,
      mouseCursor: canTap ? SystemMouseCursors.click : MouseCursor.defer,
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap?.call();
            return null;
          },
        ),
      },
      onShowFocusHighlight: (focused) => setState(() => _focused = focused),
      child: MouseRegion(
        onEnter: canTap ? (_) => setState(() => _hovered = true) : null,
        onExit: canTap ? (_) => setState(() => _hovered = false) : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          onTapDown: canTap ? (_) => setState(() => _pressed = true) : null,
          onTapUp: canTap ? (_) => setState(() => _pressed = false) : null,
          onTapCancel: canTap ? () => setState(() => _pressed = false) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            width: widget.width,
            height: widget.height,
            alignment: widget.alignment,
            padding: widget.padding,
            transform: Matrix4.identity()
              ..translateByDouble(0.0, _hovered ? -5.0 : 0.0, 0.0, 1)
              ..scaleByDouble(
                _pressed ? 0.97 : 1.0,
                _pressed ? 0.97 : 1.0,
                1.0,
                1,
              ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: widget.background ?? Colors.white.withValues(alpha: 0.1),
              border:
                  widget.border ??
                  Border.all(
                    color: Colors.white.withValues(
                      alpha: _focused ? 0.68 : 0.20,
                    ),
                  ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _hovered ? 0.45 : 0.28),
                  blurRadius: _hovered ? 20 : 12,
                  offset: Offset(0, _hovered ? 12 : 8),
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class IntroPulsePage extends StatefulWidget {
  const IntroPulsePage({super.key});

  @override
  State<IntroPulsePage> createState() => _IntroPulsePageState();
}

class _IntroPulsePageState extends State<IntroPulsePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _expand = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 560),
    value: 0,
  );

  bool _expanded = false;
  double _throttle = 0.56;
  final List<bool> _modules = <bool>[true, false, true];

  @override
  void dispose() {
    _expand.dispose();
    super.dispose();
  }

  void _toggleDeck() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _expand.forward();
      } else {
        _expand.reverse();
      }
    });
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
          final compact = constraints.maxWidth < 500 || constraints.maxHeight < 320;
          final panelWidth = min(540.0, constraints.maxWidth);
          final panelPadding = compact ? 10.0 : 18.0;
          final revealHeight = compact
              ? min(108.0, constraints.maxHeight * 0.44)
              : max(120.0, constraints.maxHeight - 122);

          return SizedBox(
            width: panelWidth,
            child: AnimatedBuilder(
              animation: _expand,
              builder: (context, _) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.all(panelPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(compact ? 20 : 24),
                    color: Colors.white.withValues(alpha: 0.10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF57DEFF,
                        ).withValues(alpha: 0.18 + (0.2 * _expand.value)),
                        blurRadius: 26 + (18 * _expand.value),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (compact)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white.withValues(alpha: 0.14),
                                  ),
                                  child: const Icon(Icons.memory, size: 20),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _expanded
                                        ? 'Control Deck Expanded'
                                        : 'Control Deck Compact',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontSize: compact ? 14 : 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: HoverPressSurface(
                                onTap: _toggleDeck,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 9,
                                ),
                                borderRadius: 12,
                                background: const Color(
                                  0xFF5BDFFF,
                                ).withValues(alpha: 0.22),
                                child: Text(_expanded ? 'Collapse' : 'Expand'),
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white.withValues(alpha: 0.14),
                              ),
                              child: const Icon(Icons.memory),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _expanded
                                    ? 'Control Deck Expanded'
                                    : 'Control Deck Compact',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            HoverPressSurface(
                              onTap: _toggleDeck,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              borderRadius: 14,
                              background: const Color(
                                0xFF5BDFFF,
                              ).withValues(alpha: 0.22),
                              child: Text(_expanded ? 'Collapse' : 'Expand'),
                            ),
                          ],
                        ),
                      SizedBox(height: compact ? 10 : 14),
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
                                  ...List.generate(3, (index) {
                                    final animation = CurvedAnimation(
                                      parent: _expand,
                                      curve: Interval(
                                        0.08 * index,
                                        0.86,
                                        curve: Curves.easeOut,
                                      ),
                                    );

                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.14),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: compact ? 8 : 10,
                                          ),
                                          child: HoverPressSurface(
                                            onTap: () => setState(
                                              () => _modules[index] =
                                                  !_modules[index],
                                            ),
                                            borderRadius: compact ? 14 : 16,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: compact ? 12 : 14,
                                              vertical: compact ? 10 : 12,
                                            ),
                                            background: Colors.white.withValues(
                                              alpha: 0.07,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  [
                                                    Icons.bolt,
                                                    Icons.blur_circular,
                                                    Icons.shield,
                                                  ][index],
                                                  size: compact ? 17 : 18,
                                                ),
                                                SizedBox(
                                                  width: compact ? 8 : 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    [
                                                      'Power Routing',
                                                      'Scene Diffusion',
                                                      'Defense Mesh',
                                                    ][index],
                                                  ),
                                                ),
                                                AnimatedContainer(
                                                  duration: const Duration(
                                                    milliseconds: 220,
                                                  ),
                                                  width: compact ? 42 : 46,
                                                  height: compact ? 26 : 28,
                                                  padding: const EdgeInsets.all(
                                                    3,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    color: _modules[index]
                                                        ? const Color(
                                                            0xFF66FFE0,
                                                          ).withValues(
                                                            alpha: 0.32,
                                                          )
                                                        : Colors.white
                                                              .withValues(
                                                                alpha: 0.16,
                                                              ),
                                                  ),
                                                  child: AnimatedAlign(
                                                    duration: const Duration(
                                                      milliseconds: 220,
                                                    ),
                                                    alignment: _modules[index]
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                    child: Container(
                                                      width: compact ? 18 : 22,
                                                      height: compact ? 18 : 22,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: _modules[index]
                                                            ? const Color(
                                                                0xFF70FFDF,
                                                              )
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  SizedBox(height: compact ? 2 : 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.speed,
                                        size: compact ? 17 : 18,
                                      ),
                                      SizedBox(width: compact ? 8 : 10),
                                      Text(
                                        'Response Throttle',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontSize: compact ? 13 : 14,
                                            ),
                                      ),
                                      SizedBox(width: compact ? 8 : 12),
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

class VolumeControlPage extends StatefulWidget {
  const VolumeControlPage({super.key});

  @override
  State<VolumeControlPage> createState() => _VolumeControlPageState();
}

class _VolumeControlPageState extends State<VolumeControlPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );

  double _value = 0.64;
  bool _pressed = false;

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  static const double _startAngle = -pi * 0.75;
  static const double _sweepAngle = pi * 1.5;

  double _valueFromAngle(double angle) {
    var normalized = angle;
    if (normalized < _startAngle) {
      normalized += pi * 2;
    }

    final clamped = normalized.clamp(
      _startAngle,
      _startAngle + _sweepAngle,
    ).toDouble();

    return ((clamped - _startAngle) / _sweepAngle).clamp(0.0, 1.0);
  }

  double _angleFromValue(double value) {
    return _startAngle + (_sweepAngle * value) + (pi / 2);
  }

  void _updateFromLocal(Offset local, Size size) {
    final center = size.center(Offset.zero);
    final raw = atan2(local.dy - center.dy, local.dx - center.dx);
    final newValue = _valueFromAngle(raw);

    if ((newValue - _value).abs() > 0.003) {
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
          final compact = constraints.maxWidth < 450 || constraints.maxHeight < 320;
          final availableForDial = max(
            130.0,
            constraints.maxHeight - (compact ? 18 : 56),
          );
          final dialSize = min(
            compact ? 220.0 : 300.0,
            min(
              constraints.maxWidth * (compact ? 0.72 : 0.72),
              availableForDial,
            ),
          );
          final scale = dialSize / 300;

          return SizedBox(
            width: min(520.0, constraints.maxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Output ${(100 * _value).round()}%',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: compact ? 16 : 20),
                ),
                SizedBox(height: compact ? 6 : 14),
                SizedBox(
                  width: dialSize,
                  height: dialSize,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
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
                                    strokeWidth: max(8, 12 * scale),
                                  ),
                                ),
                                Container(
                                  width: (218 + (pulse * 18)) * scale,
                                  height: (218 + (pulse * 18)) * scale,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFFFA96C).withValues(
                                        alpha: (0.4 * (1 - pulse)).clamp(
                                          0.0,
                                          1.0,
                                        ),
                                      ),
                                      width: 2.2,
                                    ),
                                  ),
                                ),
                                AnimatedScale(
                                  scale: _pressed ? 0.94 : 1,
                                  duration: const Duration(milliseconds: 120),
                                  curve: Curves.easeOut,
                                  child: Container(
                                    width: 210 * scale,
                                    height: 210 * scale,
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
                                          alpha: 0.2,
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.42,
                                          ),
                                          blurRadius: 24 * scale,
                                          offset: Offset(0, 12 * scale),
                                        ),
                                      ],
                                    ),
                                    child: Transform.rotate(
                                      angle: dialAngle,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            top: 16 * scale,
                                          ),
                                          width: max(9, 12 * scale),
                                          height: 70 * scale,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
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
    final radius = size.shortestSide * 0.42;
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.16);

    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFB86E), Color(0xFFFF6A4F), Color(0xFF7D5BFF)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    const start = -pi * 0.75;
    const sweep = pi * 1.5;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      basePaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep * value,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.strokeWidth != strokeWidth;
  }
}

class BrightnessDimmerPage extends StatefulWidget {
  const BrightnessDimmerPage({super.key});

  @override
  State<BrightnessDimmerPage> createState() => _BrightnessDimmerPageState();
}

class _BrightnessDimmerPageState extends State<BrightnessDimmerPage> {
  double _brightness = 0.66;

  void _updateFromLocal(Offset local, Size size) {
    if (size.height <= 0) {
      return;
    }
    final ratio = (1 - (local.dy / size.height)).clamp(0.0, 1.0);
    setState(() => _brightness = ratio);
  }

  @override
  Widget build(BuildContext context) {
    final glowSize = lerpDouble(120, 250, _brightness) ?? 180;
    final topTone = Color.lerp(
      const Color(0xFF102138),
      const Color(0xFF355C8C),
      _brightness,
    )!;

    return ShowcasePageShell(
      pageNumber: 3,
      title: 'Reactive Brightness Orb',
      subtitle: 'Vertical drag changes light intensity and scene ambience.',
      hint: 'Drag up and down the dimmer rail to sculpt the room glow.',
      icon: Icons.wb_sunny,
      gradient: [topTone, const Color(0xFF16263C), const Color(0xFF080D17)],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 430 || constraints.maxHeight < 300;
          final railHeight = min(
            compact ? 170.0 : 300.0,
            constraints.maxHeight * (compact ? 0.82 : 0.86),
          );

          final orbSize = min(
            compact ? 140.0 : glowSize,
            min(
              constraints.maxWidth * (compact ? 0.48 : 0.56),
              constraints.maxHeight * (compact ? 0.72 : 0.84),
            ),
          );

          final orb = AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            width: orbSize,
            height: orbSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(
                0xFFFFF3B0,
              ).withValues(alpha: 0.18 + _brightness * 0.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFFFFE582,
                  ).withValues(alpha: 0.28 + (_brightness * 0.4)),
                  blurRadius: 30 + (90 * _brightness),
                  spreadRadius: 2,
                ),
              ],
            ),
          );

          final rail = SizedBox(
            width: compact ? 62 : 82,
            height: railHeight,
            child: LayoutBuilder(
              builder: (context, railConstraints) {
                final size = Size(
                  railConstraints.maxWidth,
                  railConstraints.maxHeight,
                );
                final trackHeight = max(0.0, railConstraints.maxHeight - 24);

                return GestureDetector(
                  onTapDown: (details) =>
                      _updateFromLocal(details.localPosition, size),
                  onVerticalDragUpdate: (details) =>
                      _updateFromLocal(details.localPosition, size),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 10 : 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white.withValues(alpha: 0.11),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: compact ? 18 : 22,
                            height: trackHeight * _brightness,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Color(0xFFFFC876), Color(0xFFFFFFA0)],
                              ),
                            ),
                          ),
                        ),
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 160),
                          alignment: Alignment(0, 1 - (_brightness * 2)),
                          child: Container(
                            width: compact ? 36 : 44,
                            height: compact ? 36 : 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF141F32),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Icon(
                              Icons.brightness_6,
                              size: compact ? 16 : 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );

          return SizedBox(
            width: min(420.0, constraints.maxWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Center(child: orb)),
                SizedBox(width: compact ? 16 : 28),
                rail,
              ],
            ),
          );
        },
      ),
    );
  }
}

class MorphTogglePage extends StatefulWidget {
  const MorphTogglePage({super.key});

  @override
  State<MorphTogglePage> createState() => _MorphTogglePageState();
}

class _MorphTogglePageState extends State<MorphTogglePage> {
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    final onColor = const Color(0xFF8E9CFF);
    final offColor = const Color(0xFF3A4B63);

    return ShowcasePageShell(
      pageNumber: 4,
      title: 'Mode Toggle Chamber',
      subtitle:
          'Flip between two cinematic ambience states with morphing form.',
      hint:
          'Click the switch for hover lift, press compression, and mode shift.',
      icon: Icons.toggle_on,
      gradient: [
        _enabled ? const Color(0xFF251E48) : const Color(0xFF162233),
        _enabled ? const Color(0xFF1B1F42) : const Color(0xFF152530),
        const Color(0xFF090C16),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 430 || constraints.maxHeight < 300;
          final maxSwitchWidth = min(
            300.0,
            constraints.maxWidth - (compact ? 8 : 0),
          );
          final offWidth = compact ? min(maxSwitchWidth, 220.0) : 224.0;
          final onWidth = compact ? maxSwitchWidth : 300.0;
          final switchHeight = compact ? 86.0 : 128.0;
          final knobSize = compact ? 62.0 : 102.0;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 420),
                curve: Curves.easeOutBack,
                width: _enabled ? onWidth : offWidth,
                height: switchHeight,
                padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_enabled ? 64 : 30),
                  color: (_enabled ? onColor : offColor).withValues(
                    alpha: 0.24,
                  ),
                  border: Border.all(
                    color: (_enabled ? onColor : offColor).withValues(
                      alpha: 0.72,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (_enabled ? onColor : offColor).withValues(
                        alpha: 0.35,
                      ),
                      blurRadius: _enabled ? (compact ? 32 : 42) : 20,
                      spreadRadius: _enabled ? 3 : 1,
                    ),
                  ],
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 360),
                  curve: Curves.easeOutBack,
                  alignment: _enabled
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 360),
                    curve: Curves.easeOutBack,
                    width: knobSize,
                    height: knobSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_enabled ? 50 : 24),
                      color: _enabled
                          ? const Color(0xFFCEC5FF)
                          : const Color(0xFF9AA8B8),
                    ),
                    child: Icon(
                      _enabled ? Icons.nightlight_round : Icons.light_mode,
                      color: const Color(0xFF121A2A),
                      size: compact ? 34 : 40,
                    ),
                  ),
                ),
              ),
              SizedBox(height: compact ? 14 : 18),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: HoverPressSurface(
                  onTap: () => setState(() => _enabled = !_enabled),
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 14 : 18,
                    vertical: compact ? 10 : 12,
                  ),
                  borderRadius: 14,
                  background: _enabled
                      ? const Color(0xFF8E9CFF).withValues(alpha: 0.32)
                      : Colors.white.withValues(alpha: 0.1),
                  child: Text(
                    _enabled
                        ? 'Switch To Day Protocol'
                        : 'Switch To Night Protocol',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FlipRevealPage extends StatefulWidget {
  const FlipRevealPage({super.key});

  @override
  State<FlipRevealPage> createState() => _FlipRevealPageState();
}

class _FlipRevealPageState extends State<FlipRevealPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flip = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 640),
  );

  bool _front = true;

  void _toggle() {
    setState(() {
      _front = !_front;
    });
    if (_front) {
      _flip.reverse();
    } else {
      _flip.forward();
    }
  }

  @override
  void dispose() {
    _flip.dispose();
    super.dispose();
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
          final compact = constraints.maxWidth < 430 || constraints.maxHeight < 300;
          final cardHeight = min(
            compact ? 210.0 : 360.0,
            constraints.maxHeight * (compact ? 0.74 : 0.92),
          );
          final cardWidth = min(
            compact ? 230.0 : 290.0,
            min(constraints.maxWidth * 0.78, cardHeight * 0.86),
          );

          return GestureDetector(
            onTap: _toggle,
            child: AnimatedBuilder(
              animation: _flip,
              builder: (context, _) {
                final angle = _flip.value * pi;
                final showingFront = angle <= pi / 2;
                final content = showingFront
                    ? _frontFace(compact: compact)
                    : _backFace(compact: compact);
                final sheen = (sin(angle).abs() * 0.35).clamp(0.0, 0.35);

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0018)
                    ..rotateY(angle),
                  child: SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(compact ? 20 : 24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.26),
                        ),
                        color: Colors.white.withValues(alpha: 0.11),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.34),
                            blurRadius: 28,
                            offset: const Offset(0, 16),
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
                            child: content,
                          ),
                          Positioned.fill(
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    compact ? 20 : 24,
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

  Widget _frontFace({required bool compact}) {
    return Padding(
      padding: EdgeInsets.all(compact ? 12 : 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.layers, size: compact ? 30 : 36),
          SizedBox(height: compact ? 8 : 18),
          Text(
            'Front Layer',
            style: TextStyle(
              fontSize: compact ? 18 : 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: compact ? 10 : 12),
          Text(
            'Tap to rotate the card in depth and reveal hidden data.',
            style: TextStyle(fontSize: compact ? 14 : 16),
          ),
        ],
      ),
    );
  }

  Widget _backFace({required bool compact}) {
    return Padding(
      padding: EdgeInsets.all(compact ? 12 : 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_fix_high, size: compact ? 30 : 36),
          SizedBox(height: compact ? 8 : 18),
          Text(
            'Back Layer',
            style: TextStyle(
              fontSize: compact ? 18 : 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: compact ? 10 : 12),
          Text(
            'Reveal complete. Tap again to snap back to the front.',
            style: TextStyle(fontSize: compact ? 14 : 16),
          ),
        ],
      ),
    );
  }
}

class MechanicalLeverPage extends StatefulWidget {
  const MechanicalLeverPage({super.key});

  @override
  State<MechanicalLeverPage> createState() => _MechanicalLeverPageState();
}

class _MechanicalLeverPageState extends State<MechanicalLeverPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lever = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
    value: 0.18,
  );

  bool _pressedBase = false;

  @override
  void dispose() {
    _lever.dispose();
    super.dispose();
  }

  void _toggle() {
    final target = _lever.value > 0.5 ? 0.0 : 1.0;
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
          final compact = constraints.maxWidth < 430 || constraints.maxHeight < 300;
          final controlWidth = min(
            compact ? 210.0 : 270.0,
            constraints.maxWidth * (compact ? 0.72 : 0.84),
          );
          final controlHeight = min(
            compact ? 220.0 : 320.0,
            constraints.maxHeight * (compact ? 0.82 : 0.95),
          );
          final scale = min(controlWidth / 270, controlHeight / 320);
          final dragRange = max(120.0, 190 * scale);

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
                _lever.value > 0.5 ? 1 : 0,
                curve: Curves.easeOutBack,
              );
            },
            child: AnimatedBuilder(
              animation: _lever,
              builder: (context, _) {
                final angle = lerpDouble(0.72, -0.72, _lever.value) ?? 0;
                final engaged = _lever.value > 0.55;

                return SizedBox(
                  width: controlWidth,
                  height: controlHeight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 26 * scale,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 120),
                          scale: _pressedBase ? 0.95 : 1,
                          child: Container(
                            width: 224 * scale,
                            height: 30 * scale,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15 * scale),
                              color: const Color(0xFF483C36),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.38),
                                  blurRadius: 20 * scale,
                                  offset: Offset(0, 12 * scale),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 56 * scale,
                        child: Container(
                          width: 38 * scale,
                          height: 174 * scale,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18 * scale),
                            color: const Color(0xFF1E2738),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 92 * scale,
                        child: Transform.rotate(
                          angle: angle,
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Container(
                                width: 34 * scale,
                                height: 142 * scale,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    18 * scale,
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
                                width: 60 * scale,
                                height: 60 * scale,
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
                                              .withValues(alpha: 0.45),
                                      blurRadius: 28 * scale,
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
                        top: 16 * scale,
                        child: Text(
                          engaged ? 'ENGAGED' : 'STANDBY',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontSize: scale < 0.9 ? 16 : 18),
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

class DialControlPage extends StatefulWidget {
  const DialControlPage({super.key});

  @override
  State<DialControlPage> createState() => _DialControlPageState();
}

class _DialControlPageState extends State<DialControlPage>
    with TickerProviderStateMixin {
  late final AnimationController _wiggle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 760),
  );

  late final AnimationController _ring = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 980),
  );

  int _badge = 2;

  @override
  void dispose() {
    _wiggle.dispose();
    _ring.dispose();
    super.dispose();
  }

  void _triggerBell() {
    setState(() {
      _badge += 1;
    });
    _wiggle.forward(from: 0);
    _ring.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return ShowcasePageShell(
      pageNumber: 7,
      title: 'Notification Bell',
      subtitle:
          'Short wiggle, ripple rings, and badge pop for satisfying feedback.',
      hint: 'Tap the bell to trigger a compact alert animation and settle.',
      icon: Icons.notifications_active,
      gradient: const [Color(0xFF182337), Color(0xFF121A2D), Color(0xFF080D16)],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 430 || constraints.maxHeight < 300;
          final areaSize = min(
            compact ? 210.0 : 340.0,
            min(
              constraints.maxWidth * (compact ? 0.72 : 0.9),
              constraints.maxHeight * (compact ? 0.74 : 0.95),
            ),
          );
          final bellSize = min(170.0, areaSize * 0.52);
          final bellRadius = bellSize / 2;
          final badgeSize = min(42.0, max(32.0, areaSize * 0.13));

          return AnimatedBuilder(
            animation: Listenable.merge([_wiggle, _ring]),
            builder: (context, _) {
              final wiggle =
                  sin(_wiggle.value * pi * 8) * (1 - _wiggle.value) * 0.2;
              final ring = Curves.easeOut.transform(_ring.value);
              final badgeScale = 1 + (sin(_wiggle.value * pi * 6).abs() * 0.34);

              return SizedBox(
                width: areaSize,
                height: areaSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ...List.generate(2, (index) {
                      final local = ((ring - (index * 0.2)) / (1 - index * 0.2))
                          .clamp(0.0, 1.0);
                      final ringSize =
                          (bellSize * 0.78) + (local * areaSize * 0.72);
                      return IgnorePointer(
                        child: Container(
                          width: ringSize,
                          height: ringSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF66E7FF).withValues(
                                alpha: (0.4 * (1 - local)).clamp(0.0, 1.0),
                              ),
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }),
                    Transform.rotate(
                      angle: wiggle,
                      child: HoverPressSurface(
                        onTap: _triggerBell,
                        width: bellSize,
                        height: bellSize,
                        borderRadius: bellRadius,
                        alignment: Alignment.center,
                        background: const Color(
                          0xFF1A2A42,
                        ).withValues(alpha: 0.85),
                        border: Border.all(
                          color: const Color(
                            0xFF66E7FF,
                          ).withValues(alpha: 0.48),
                        ),
                        child: Icon(
                          Icons.notifications,
                          size: min(72.0, bellSize * 0.42),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: Offset(bellRadius * 0.72, -bellRadius * 0.72),
                        child: Transform.scale(
                          scale: badgeScale,
                          child: Container(
                            width: badgeSize,
                            height: badgeSize,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFF6B86),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFF6B86,
                                  ).withValues(alpha: 0.44),
                                  blurRadius: 18,
                                ),
                              ],
                            ),
                            child: Text(
                              '$_badge',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    fontSize: badgeSize < 38 ? 12 : 14,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
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

class ExpandablePanelPage extends StatefulWidget {
  const ExpandablePanelPage({super.key});

  @override
  State<ExpandablePanelPage> createState() => _ExpandablePanelPageState();
}

class _ExpandablePanelPageState extends State<ExpandablePanelPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _menu = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
    value: 0,
  );

  bool _open = false;
  int? _hovered;
  final List<Offset> _hoverOffsets = List<Offset>.filled(6, Offset.zero);

  final List<_RadialAction> _actions = const <_RadialAction>[
    _RadialAction(icon: Icons.flash_on, label: 'Boost'),
    _RadialAction(icon: Icons.shield, label: 'Guard'),
    _RadialAction(icon: Icons.route, label: 'Route'),
    _RadialAction(icon: Icons.waves, label: 'Pulse'),
    _RadialAction(icon: Icons.satellite_alt, label: 'Scan'),
    _RadialAction(icon: Icons.blur_on, label: 'Diffuse'),
  ];

  @override
  void dispose() {
    _menu.dispose();
    super.dispose();
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
          final compact = constraints.maxWidth < 460 || constraints.maxHeight < 320;
          final areaSize = min(
            compact ? 220.0 : 500.0,
            min(
              constraints.maxWidth * (compact ? 0.76 : 1.0),
              constraints.maxHeight * (compact ? 0.74 : 0.96),
            ),
          );
          final nodeSize = min(compact ? 52.0 : 72.0, max(42.0, areaSize * 0.18));
          final centerSize = min(compact ? 84.0 : 110.0, max(70.0, areaSize * 0.3));
          final radiusBase = min(compact ? 68.0 : 128.0, max(52.0, areaSize * 0.34));

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
                      final interval = CurvedAnimation(
                        parent: _menu,
                        curve: Interval(
                          0.06 * index,
                          1,
                          curve: Curves.easeOutBack,
                        ),
                      );
                      final value = interval.value;
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
                              final box = context.findRenderObject();
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
                                    normal * (compact ? 2.5 : 3);
                              });
                            },
                            child: HoverPressSurface(
                              onTap: () => _toggleMenu(),
                              width: nodeSize,
                              height: nodeSize,
                              borderRadius: nodeSize / 2,
                              alignment: Alignment.center,
                              background: _hovered == index
                                  ? const Color(
                                      0xFF5BE9FF,
                                    ).withValues(alpha: 0.34)
                                  : Colors.white.withValues(alpha: 0.11),
                              border: Border.all(
                                color: _hovered == index
                                    ? const Color(0xFF7BF0FF)
                                    : Colors.white.withValues(alpha: 0.24),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(item.icon, size: compact ? 22 : 24),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.label,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: compact ? 12 : 14),
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
                      ).withValues(alpha: 0.9),
                      border: Border.all(
                        color: const Color(0xFF67E5FF).withValues(alpha: 0.6),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _open ? Icons.close : Icons.adjust,
                            size: compact ? 28 : 30,
                          ),
                          const SizedBox(height: 4),
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

class _RadialAction {
  const _RadialAction({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class CinematicButtonsPage extends StatefulWidget {
  const CinematicButtonsPage({super.key});

  @override
  State<CinematicButtonsPage> createState() => _CinematicButtonsPageState();
}

class _CinematicButtonsPageState extends State<CinematicButtonsPage>
    with TickerProviderStateMixin {
  late final AnimationController _hold =
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1700),
      )..addStatusListener((status) {
        if (status == AnimationStatus.completed && !_completed) {
          setState(() => _completed = true);
          _burst.forward(from: 0);
        }
      });

  late final AnimationController _burst = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 860),
  );

  bool _completed = false;

  @override
  void dispose() {
    _hold.dispose();
    _burst.dispose();
    super.dispose();
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
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  void _reset() {
    setState(() {
      _completed = false;
      _hold.value = 0;
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
          final compact = constraints.maxWidth < 460 || constraints.maxHeight < 320;
          final areaSize = min(
            compact ? 220.0 : 500.0,
            min(
              constraints.maxWidth * (compact ? 0.76 : 1.0),
              constraints.maxHeight * (compact ? 0.72 : 0.96),
            ),
          );

          return AnimatedBuilder(
            animation: Listenable.merge([_hold, _burst]),
            builder: (context, _) {
              final progress = Curves.easeOut.transform(_hold.value);
              final burst = Curves.easeOut.transform(_burst.value);
              final ringSize = min(compact ? 150.0 : 250.0, areaSize * 0.72);
              final coreBase = min(compact ? 92.0 : 140.0, areaSize * 0.40);
              final coreSize = coreBase + (progress * (areaSize * 0.08));

              return SizedBox(
                width: areaSize,
                height: areaSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ...List.generate(16, (index) {
                      final angle = index * ((2 * pi) / 16);
                      final distance =
                          (ringSize * 0.18) + (burst * (areaSize * 0.48));
                      final opacity = (0.9 - burst).clamp(0.0, 1.0);
                      return Transform.translate(
                        offset: Offset(
                          cos(angle) * distance,
                          sin(angle) * distance,
                        ),
                        child: Opacity(
                          opacity: _completed ? opacity.toDouble() : 0,
                          child: Container(
                            width: compact ? 6 : 7,
                            height: compact ? 6 : 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF92E9FF),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }),
                    CustomPaint(
                      size: Size.square(ringSize),
                      painter: _HoldRingPainter(value: progress),
                    ),
                    GestureDetector(
                      onTapDown: (_) => _startHold(),
                      onTapUp: (_) => _releaseHold(),
                      onTapCancel: _releaseHold,
                      onLongPressStart: (_) => _startHold(),
                      onLongPressEnd: (_) => _releaseHold(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 140),
                        width: coreSize,
                        height: coreSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _completed
                              ? const Color(0xFF79FFD3).withValues(alpha: 0.34)
                              : const Color(0xFF27344C).withValues(alpha: 0.9),
                          border: Border.all(
                            color: _completed
                                ? const Color(0xFF90FFE0)
                                : const Color(
                                    0xFF7EDFFF,
                                  ).withValues(alpha: 0.6),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (_completed
                                          ? const Color(0xFF79FFD3)
                                          : const Color(0xFF7EDFFF))
                                      .withValues(alpha: 0.42),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          _completed
                              ? 'CHARGED'
                              : '${(progress * 100).round()}%',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontSize: compact ? 17 : 20),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: max(8.0, areaSize * 0.04),
                      child: _completed
                          ? HoverPressSurface(
                              onTap: _reset,
                              padding: EdgeInsets.symmetric(
                                horizontal: compact ? 14 : 18,
                                vertical: compact ? 10 : 12,
                              ),
                              borderRadius: 14,
                              background: Colors.white.withValues(alpha: 0.14),
                              child: const Text('Rearm Charge'),
                            )
                          : Text(
                              'Press and hold the core',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontSize: compact ? 12.5 : 16),
                            textAlign: TextAlign.center,
                          ),
                    ),
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

class _HoldRingPainter extends CustomPainter {
  _HoldRingPainter({required this.value});

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.42;
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.14);

    final fill = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
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

class FinalWowPage extends StatefulWidget {
  const FinalWowPage({super.key, required this.onRestartBook});

  final VoidCallback onRestartBook;

  @override
  State<FinalWowPage> createState() => _FinalWowPageState();
}

class _FinalWowPageState extends State<FinalWowPage>
    with TickerProviderStateMixin {
  late final AnimationController _mood = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  int _stage = 0;

  @override
  void dispose() {
    _mood.dispose();
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _advance() async {
    if (_stage == 0) {
      setState(() => _stage = 1);
      _mood.animateTo(0.35, curve: Curves.easeOut);
      return;
    }

    if (_stage == 1) {
      setState(() => _stage = 2);
      _pulse.forward(from: 0);
      await Future<void>.delayed(const Duration(milliseconds: 820));
      if (!mounted) {
        return;
      }
      setState(() => _stage = 3);
      _mood.forward(from: _mood.value);
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
      subtitle: 'Hover, press, and multi-step success for the closing payoff.',
      hint: 'Prime, execute, then complete the finale sequence.',
      icon: Icons.stars,
      gradient: [gradientA, gradientB, const Color(0xFF090B16)],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 500 || constraints.maxHeight < 320;
          final panelWidth = min(560.0, constraints.maxWidth);
          final buttonWidth = min(
            compact ? 180.0 : 220.0,
            max(150.0, panelWidth - (compact ? 28 : 120)),
          );

          return AnimatedBuilder(
            animation: Listenable.merge([_mood, _pulse]),
            builder: (context, _) {
              final pulse = Curves.easeOut.transform(_pulse.value);
              final ringBase = compact ? 96.0 : 180.0;
              final ringRange = compact ? 52.0 : 120.0;

              return SizedBox(
                width: panelWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(compact ? 16 : 22),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(compact ? 20 : 24),
                        color: Colors.white.withValues(alpha: 0.11),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF6AE5FF,
                            ).withValues(alpha: 0.14 + (0.34 * _mood.value)),
                            blurRadius: 30 + (24 * _mood.value),
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
                                ?.copyWith(fontSize: compact ? 18 : 20),
                          ),
                          SizedBox(height: compact ? 10 : 12),
                          Text(
                            _stage == 3
                                ? 'Cinematic mode reached. You can reset or restart the full book.'
                                : 'This is a multi-step CTA with deliberate progression.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontSize: compact ? 14 : 16),
                          ),
                          SizedBox(height: compact ? 16 : 20),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: ringBase + (pulse * ringRange),
                                height: ringBase + (pulse * ringRange),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF7DE8FF).withValues(
                                      alpha: (0.32 * (1 - pulse)).clamp(
                                        0.0,
                                        1.0,
                                      ),
                                    ),
                                    width: 2,
                                  ),
                                ),
                              ),
                              HoverPressSurface(
                                onTap: _stage == 2 ? null : _advance,
                                width: buttonWidth,
                                height: compact ? 58 : 86,
                                borderRadius: 18,
                                alignment: Alignment.center,
                                background: _stage == 3
                                    ? const Color(
                                        0xFF7DFFBF,
                                      ).withValues(alpha: 0.28)
                                    : const Color(
                                        0xFF5BA2FF,
                                      ).withValues(alpha: 0.24),
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
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontSize: compact ? 15 : 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: compact ? 10 : 14),
                    HoverPressSurface(
                      onTap: widget.onRestartBook,
                      padding: EdgeInsets.symmetric(
                        horizontal: compact ? 14 : 18,
                        vertical: compact ? 10 : 12,
                      ),
                      borderRadius: 14,
                      background: Colors.white.withValues(alpha: 0.14),
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
  }
}
