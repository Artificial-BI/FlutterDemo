import 'dart:math';

import 'package:flutter/material.dart';

import 'demo_pages.dart';

enum TurnDirection { forward, backward }

class BookExperienceScreen extends StatefulWidget {
  const BookExperienceScreen({super.key});

  @override
  State<BookExperienceScreen> createState() => _BookExperienceScreenState();
}

class _BookExperienceScreenState extends State<BookExperienceScreen>
    with TickerProviderStateMixin {
  late final AnimationController _coverOpen = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  late final AnimationController _turn = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 560),
  );

  late final List<Widget> _pages = buildDemoPages(onRestartBook: _restartBook);

  int _index = 0;
  bool _coverHover = false;
  bool _coverPressed = false;
  TurnDirection? _activeTurn;
  TurnDirection? _dragDirection;
  bool _dragInProgress = false;

  bool get _bookUnlocked => _coverOpen.value > 0.995;

  @override
  void dispose() {
    _coverOpen.dispose();
    _turn.dispose();
    super.dispose();
  }

  void _openCover() {
    _coverOpen.animateTo(1, curve: Curves.easeOutCubic);
  }

  void _closeCover() {
    _coverOpen.animateBack(0, curve: Curves.easeInOutCubic);
  }

  void _restartBook() {
    if (!mounted) {
      return;
    }
    setState(() {
      _index = 0;
      _activeTurn = null;
      _dragDirection = null;
      _turn.value = 0;
      _dragInProgress = false;
    });
    _coverOpen.animateBack(0, curve: Curves.easeInOutCubic);
  }

  void _startButtonTurn(TurnDirection direction) {
    if (_activeTurn != null || _turn.isAnimating || !_bookUnlocked) {
      return;
    }
    if (direction == TurnDirection.forward && _index >= _pages.length - 1) {
      return;
    }
    if (direction == TurnDirection.backward && _index <= 0) {
      return;
    }

    setState(() {
      _activeTurn = direction;
    });

    _turn.forward(from: 0).then((_) {
      if (!mounted) {
        return;
      }
      _finishTurn(direction);
    });
  }

  void _finishTurn(TurnDirection direction) {
    setState(() {
      _index += direction == TurnDirection.forward ? 1 : -1;
      _turn.value = 0;
      _activeTurn = null;
      _dragDirection = null;
      _dragInProgress = false;
    });
  }

  void _cancelTurn() {
    setState(() {
      _turn.value = 0;
      _activeTurn = null;
      _dragDirection = null;
      _dragInProgress = false;
    });
  }

  void _handlePageDragStart(DragStartDetails details) {
    if (_turn.isAnimating || !_bookUnlocked || _activeTurn != null) {
      return;
    }
    _dragInProgress = true;
    _dragDirection = null;
    _turn.value = 0;
  }

  void _handlePageDragUpdate(DragUpdateDetails details, double pageWidth) {
    if (!_dragInProgress || _turn.isAnimating || pageWidth <= 0) {
      return;
    }

    if (_dragDirection == null) {
      if (details.delta.dx < -1.2 && _index < _pages.length - 1) {
        _dragDirection = TurnDirection.forward;
      } else if (details.delta.dx > 1.2 && _index > 0) {
        _dragDirection = TurnDirection.backward;
      }
      if (_dragDirection != null) {
        setState(() {
          _activeTurn = _dragDirection;
        });
      }
    }

    if (_dragDirection == null) {
      return;
    }

    final delta = _dragDirection == TurnDirection.forward
        ? -details.delta.dx / pageWidth
        : details.delta.dx / pageWidth;

    _turn.value = (_turn.value + delta).clamp(0.0, 1.0);
  }

  void _handlePageDragEnd(DragEndDetails details) {
    if (!_dragInProgress || _dragDirection == null || _activeTurn == null) {
      _dragInProgress = false;
      return;
    }

    final direction = _dragDirection!;
    final shouldFinish = _turn.value > 0.35;

    if (shouldFinish) {
      _turn.animateTo(1, curve: Curves.easeOutCubic).then((_) {
        if (!mounted) {
          return;
        }
        _finishTurn(direction);
      });
      return;
    }

    _turn.animateBack(0, curve: Curves.easeOutQuad).then((_) {
      if (!mounted) {
        return;
      }
      _cancelTurn();
    });
  }

  void _handleCoverDragUpdate(DragUpdateDetails details, double width) {
    if (width <= 0 || _coverOpen.value >= 1) {
      return;
    }
    final delta = (-details.delta.dx / width).clamp(-0.08, 0.08);
    _coverOpen.value = (_coverOpen.value + delta).clamp(0.0, 1.0);
  }

  void _handleCoverDragEnd(DragEndDetails details) {
    if (_coverOpen.value > 0.28) {
      _openCover();
    } else {
      _closeCover();
    }
  }

  @override
  Widget build(BuildContext context) {
    final merged = Listenable.merge([_coverOpen, _turn]);

    return AnimatedBuilder(
      animation: merged,
      builder: (context, _) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.15, -0.45),
                radius: 1.45,
                colors: [
                  Color(0xFF13213E),
                  Color(0xFF0B1020),
                  Color(0xFF04060F),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _GridPainter(progress: _coverOpen.value),
                    ),
                  ),
                ),
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                    final phone = constraints.maxWidth < 520;
                    final narrow = constraints.maxWidth < 700;
                    final short = constraints.maxHeight < 780;

                    final width = min(
                      constraints.maxWidth * (phone ? 0.97 : (narrow ? 0.96 : 0.92)),
                      1000.0,
                    );

                    final height = min(
                      constraints.maxHeight *
                          (phone ? 0.82 : (short ? 0.72 : (narrow ? 0.74 : 0.76))),
                      phone ? 720.0 : (narrow ? 640.0 : 690.0),
                    );

                      return Column(
                        children: [
                          SizedBox(height: narrow ? 4 : 8),
                          Text(
                            'Cinematic Click Book',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  fontSize: narrow ? 30 : 38,
                                  letterSpacing: narrow ? 1.0 : 1.4,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: phone ? 2 : (narrow ? 4 : 8)),
                          Text(
                            'Cinematic Click Book',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontSize: phone ? 24 : (narrow ? 30 : 38),
                              letterSpacing: phone ? 0.6 : (narrow ? 1.0 : 1.4),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: phone ? 4 : (narrow ? 8 : 10)),
                          Text(
                            _bookUnlocked
                                ? 'Drag or click to turn pages'
                                : 'Tap or drag the cover to open',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.72),
                              fontSize: phone ? 12 : (narrow ? 14 : 16),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: phone ? 8 : (narrow ? 12 : 18)),
                          Expanded(
                            child: Center(
                              child: SizedBox(
                                width: width,
                                height: height,
                                child: Stack(
                                  children: [
                                    _buildBookBase(width, height),
                                    if (_coverOpen.value < 0.998)
                                      _buildCoverLayer(width, height),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: narrow ? 10 : 16),
                          _buildNavigation(compact: phone || constraints.maxHeight < 720),
                          SizedBox(height: narrow ? 8 : 14),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookBase(double width, double height) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A223B), Color(0xFF0F1529), Color(0xFF090D1A)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 42,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 22,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.16),
                      Colors.black.withValues(alpha: 0.22),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragStart: _bookUnlocked
                          ? _handlePageDragStart
                          : null,
                      onHorizontalDragUpdate: _bookUnlocked
                          ? (details) =>
                                _handlePageDragUpdate(details, width - 28)
                          : null,
                      onHorizontalDragEnd: _bookUnlocked
                          ? _handlePageDragEnd
                          : null,
                      child: _buildPageLayers(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageLayers() {
    final direction = _activeTurn;
    if (direction == null) {
      return RepaintBoundary(child: _pages[_index]);
    }

    final incomingIndex = direction == TurnDirection.forward
        ? _index + 1
        : _index - 1;
    if (incomingIndex < 0 || incomingIndex >= _pages.length) {
      return RepaintBoundary(child: _pages[_index]);
    }

    final progress = Curves.easeInOut.transform(_turn.value);
    final angle =
        (direction == TurnDirection.forward ? -1 : 1) * progress * (pi / 1.9);
    final pivot = direction == TurnDirection.forward
        ? Alignment.centerLeft
        : Alignment.centerRight;
    final translate =
        (direction == TurnDirection.forward ? 1 : -1) * progress * 24;

    final shadowBegin = direction == TurnDirection.forward
        ? Alignment.centerLeft
        : Alignment.centerRight;
    final shadowEnd = direction == TurnDirection.forward
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.scale(
          scale: 0.975 + (0.025 * progress),
          child: RepaintBoundary(child: _pages[incomingIndex]),
        ),
        Transform(
          alignment: pivot,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0018)
            ..translateByDouble(translate, 0, 0, 1)
            ..rotateY(angle),
          child: Stack(
            fit: StackFit.expand,
            children: [
              RepaintBoundary(child: _pages[_index]),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: shadowBegin,
                      end: shadowEnd,
                      colors: [
                        Colors.black.withValues(alpha: 0.45 * progress),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoverLayer(double width, double height) {
    final progress = Curves.easeOutCubic.transform(_coverOpen.value);
    final hoverLift = _coverHover ? -12.0 : 0.0;
    final pressScale = _coverPressed ? 0.985 : 1.0;
    final compact = width < 560;

    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: MouseRegion(
          onEnter: (_) {
            if (_coverOpen.value >= 1) {
              return;
            }
            setState(() => _coverHover = true);
          },
          onExit: (_) => setState(() => _coverHover = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _openCover,
            onTapDown: (_) => setState(() => _coverPressed = true),
            onTapUp: (_) => setState(() => _coverPressed = false),
            onTapCancel: () => setState(() => _coverPressed = false),
            onPanStart: (_) => setState(() => _coverPressed = true),
            onPanUpdate: (details) => _handleCoverDragUpdate(details, width),
            onPanEnd: (details) {
              setState(() => _coverPressed = false);
              _handleCoverDragEnd(details);
            },
            child: Transform(
              alignment: Alignment.centerLeft,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0019)
                ..translateByDouble(0.0, hoverLift * (1 - progress), 0.0, 1)
                ..scaleByDouble(pressScale, pressScale, 1.0, 1)
                ..rotateZ((_coverHover ? -0.012 : 0.0) * (1 - progress))
                ..rotateY(-progress * pi * 0.93),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2A4B66),
                      Color(0xFF172745),
                      Color(0xFF0D162B),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.55),
                      blurRadius: 36 + (progress * 8),
                      offset: const Offset(0, 20),
                    ),
                    BoxShadow(
                      color: const Color(
                        0xFF6EE4FF,
                      ).withValues(alpha: 0.18 * (1 - progress)),
                      blurRadius: 22,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.24),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        compact ? 20 : 34,
                        compact ? 20 : 30,
                        compact ? 20 : 34,
                        compact ? 20 : 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NEON ATLAS',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontSize: compact ? 20 : 24,
                                  letterSpacing: compact ? 0.8 : 1.0,
                                ),
                          ),
                          SizedBox(height: compact ? 8 : 10),
                          Text(
                            'An interactive click-demo book',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.78),
                                  fontSize: compact ? 14 : 16,
                                ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: compact ? 12 : 14,
                              vertical: compact ? 8 : 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white.withValues(alpha: 0.12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.24),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.touch_app, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Click or drag left to open',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontSize: compact ? 12 : 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation({required bool compact}) {
    final atStart = _index == 0;
    final atEnd = _index == _pages.length - 1;
    final locked = !_bookUnlocked;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Page ${_index + 1} / ${_pages.length}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.76),
            fontSize: compact ? 14 : 16,
          ),
        ),
        SizedBox(height: compact ? 8 : 10),
        Wrap(
          spacing: compact ? 8 : 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            HoverPressSurface(
              onTap: locked || atStart
                  ? null
                  : () => _startButtonTurn(TurnDirection.backward),
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 14 : 16,
                vertical: compact ? 10 : 11,
              ),
              background: Colors.white.withValues(alpha: 0.10),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chevron_left),
                  SizedBox(width: 4),
                  Text('Prev'),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_pages.length, (dotIndex) {
                final active = dotIndex == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: EdgeInsets.symmetric(horizontal: compact ? 2 : 3),
                  width: active ? (compact ? 16 : 20) : (compact ? 6 : 8),
                  height: compact ? 6 : 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: active
                        ? const Color(0xFF62F2D8)
                        : Colors.white.withValues(alpha: 0.22),
                  ),
                );
              }),
            ),
            HoverPressSurface(
              onTap: locked || atEnd
                  ? null
                  : () => _startButtonTurn(TurnDirection.forward),
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 14 : 16,
                vertical: compact ? 10 : 11,
              ),
              background: Colors.white.withValues(alpha: 0.10),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Next'),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08 + (0.05 * progress))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const spacing = 48.0;
    for (double x = 0; x <= size.width; x += spacing) {
      path.moveTo(x, 0);
      path.lineTo(x, size.height);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      path.moveTo(0, y);
      path.lineTo(size.width, y);
    }

    canvas.drawPath(path, paint);

    final glow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFF4EE6FF).withValues(alpha: 0.09 + 0.16 * progress),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.5, size.height * 0.22),
              radius: size.shortestSide * 0.65,
            ),
          );

    canvas.drawRect(Offset.zero & size, glow);
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
