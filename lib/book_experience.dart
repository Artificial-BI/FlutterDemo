import 'dart:math';

import 'package:flutter/material.dart';

import 'book/book_experience_constants.dart';
import 'demo/animation/demo_animation.dart';
import 'demo/demo_page_catalog.dart';
import 'demo/responsive/demo_responsive.dart';
import 'demo/shared/hover_press_surface.dart';

enum TurnDirection { forward, backward }

enum _TurnAnimationOutcome { complete, cancel }

class BookExperienceScreen extends StatefulWidget {
  const BookExperienceScreen({super.key});

  @override
  State<BookExperienceScreen> createState() => _BookExperienceScreenState();
}

class _BookExperienceScreenState
    extends ManagedTickerState<BookExperienceScreen> {
  late final AnimationController _coverOpen;
  late final AnimationController _turn;

  int _index = 0;
  bool _bookUnlocked = false;
  bool _coverHover = false;
  bool _coverPressed = false;
  TurnDirection? _activeTurn;
  TurnDirection? _dragDirection;
  bool _dragInProgress = false;
  _TurnAnimationOutcome? _pendingTurnOutcome;
  double? _pendingWarmupTurnDelta;

  @override
  void initState() {
    super.initState();
    _coverOpen = createAnimationController(duration: BookDurations.coverOpen)
      ..addListener(_syncBookUnlockState);
    _turn = createAnimationController(duration: BookDurations.pageTurn)
      ..addStatusListener(_handleTurnStatus);
  }

  void _syncBookUnlockState() {
    final unlocked = _coverOpen.value > BookThresholds.unlockProgress;
    if (mounted && unlocked != _bookUnlocked) {
      setState(() => _bookUnlocked = unlocked);
    }
  }

  void _handleTurnStatus(AnimationStatus status) {
    if (!mounted || _activeTurn == null || _pendingTurnOutcome == null) {
      return;
    }

    if (status == AnimationStatus.completed &&
        _pendingTurnOutcome == _TurnAnimationOutcome.complete) {
      _finishTurn(_activeTurn!);
      return;
    }

    if (status == AnimationStatus.dismissed &&
        _pendingTurnOutcome == _TurnAnimationOutcome.cancel) {
      _cancelTurn();
    }
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
      _bookUnlocked = false;
      _activeTurn = null;
      _dragDirection = null;
      _dragInProgress = false;
      _pendingTurnOutcome = null;
      _pendingWarmupTurnDelta = null;
      _turn.value = 0;
    });
    _coverOpen.animateBack(0, curve: Curves.easeInOutCubic);
  }

  void _scheduleTurnWarmup(VoidCallback action) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      action();
    });
  }

  void _flushPendingWarmupTurnDelta() {
    final delta = _pendingWarmupTurnDelta;
    if (delta == null ||
        !_dragInProgress ||
        _turn.isAnimating ||
        _activeTurn == null) {
      _pendingWarmupTurnDelta = null;
      return;
    }
    _pendingWarmupTurnDelta = null;
    _turn.value = (_turn.value + delta).clamp(0.0, 1.0);
  }

  void _startButtonTurn(TurnDirection direction) {
    if (_activeTurn != null || _turn.isAnimating || !_bookUnlocked) {
      return;
    }
    if (direction == TurnDirection.forward && _index >= demoPageCount - 1) {
      return;
    }
    if (direction == TurnDirection.backward && _index <= 0) {
      return;
    }

    setState(() {
      _activeTurn = direction;
      _dragDirection = null;
      _dragInProgress = false;
      _pendingTurnOutcome = _TurnAnimationOutcome.complete;
      _pendingWarmupTurnDelta = null;
      _turn.value = 0;
    });

    _scheduleTurnWarmup(() {
      if (_activeTurn != direction ||
          _pendingTurnOutcome != _TurnAnimationOutcome.complete ||
          _turn.isAnimating) {
        return;
      }
      _turn.animateTo(1, curve: Curves.easeOutCubic);
    });
  }

  void _finishTurn(TurnDirection direction) {
    setState(() {
      _index += direction == TurnDirection.forward ? 1 : -1;
      _pendingTurnOutcome = null;
      _pendingWarmupTurnDelta = null;
      _turn.value = 0;
      _activeTurn = null;
      _dragDirection = null;
      _dragInProgress = false;
    });
  }

  void _cancelTurn() {
    setState(() {
      _pendingTurnOutcome = null;
      _pendingWarmupTurnDelta = null;
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
    _pendingTurnOutcome = null;
    _pendingWarmupTurnDelta = null;
    _turn.value = 0;
  }

  void _handlePageDragUpdate(DragUpdateDetails details, double pageWidth) {
    if (!_dragInProgress || _turn.isAnimating || pageWidth <= 0) {
      return;
    }

    if (_dragDirection == null) {
      if (details.delta.dx < -BookThresholds.coverDragDirectionDelta &&
          _index < demoPageCount - 1) {
        _dragDirection = TurnDirection.forward;
      } else if (details.delta.dx > BookThresholds.coverDragDirectionDelta &&
          _index > 0) {
        _dragDirection = TurnDirection.backward;
      }
      if (_dragDirection != null) {
        final initialDelta = _dragDirection == TurnDirection.forward
            ? -details.delta.dx / pageWidth
            : details.delta.dx / pageWidth;
        setState(() => _activeTurn = _dragDirection);
        _pendingWarmupTurnDelta = initialDelta;
        _scheduleTurnWarmup(_flushPendingWarmupTurnDelta);
        return;
      }
    }

    if (_dragDirection == null) {
      return;
    }

    final delta = _dragDirection == TurnDirection.forward
        ? -details.delta.dx / pageWidth
        : details.delta.dx / pageWidth;

    if (_pendingWarmupTurnDelta != null) {
      _pendingWarmupTurnDelta = _pendingWarmupTurnDelta! + delta;
      return;
    }

    _turn.value = (_turn.value + delta).clamp(0.0, 1.0);
  }

  void _handlePageDragEnd(DragEndDetails details) {
    if (!_dragInProgress || _dragDirection == null || _activeTurn == null) {
      _dragInProgress = false;
      _pendingWarmupTurnDelta = null;
      return;
    }

    _flushPendingWarmupTurnDelta();
    final shouldFinish = _turn.value > BookThresholds.pageTurnCommitProgress;
    _pendingTurnOutcome = shouldFinish
        ? _TurnAnimationOutcome.complete
        : _TurnAnimationOutcome.cancel;

    if (shouldFinish) {
      _turn.animateTo(1, curve: Curves.easeOutCubic);
      return;
    }

    _turn.animateBack(0, curve: Curves.easeOutQuad);
  }

  void _handleCoverDragUpdate(DragUpdateDetails details, double width) {
    if (width <= 0 || _coverOpen.value >= 1) {
      return;
    }
    final delta = (-details.delta.dx / width).clamp(
      -BookMotion.coverDragDeltaClamp,
      BookMotion.coverDragDeltaClamp,
    );
    _coverOpen.value = (_coverOpen.value + delta).clamp(0.0, 1.0);
  }

  void _handleCoverDragEnd(DragEndDetails details) {
    if (_coverOpen.value > BookThresholds.coverOpenSnapProgress) {
      _openCover();
      return;
    }
    _closeCover();
  }

  Widget _buildPage(int index) {
    return buildDemoPage(index, onRestartBook: _restartBook);
  }

  Widget? _buildIncomingPage() {
    if (_activeTurn == null) {
      return null;
    }

    final incomingIndex = _activeTurn == TurnDirection.forward
        ? _index + 1
        : _index - 1;
    if (incomingIndex < 0 || incomingIndex >= demoPageCount) {
      return null;
    }
    return _buildPage(incomingIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.15, -0.45),
            radius: 1.45,
            colors: [Color(0xFF13213E), Color(0xFF0B1020), Color(0xFF04060F)],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: _AnimatedGridBackdrop(progress: _coverOpen)),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final layout = BookLayout.fromConstraints(constraints);
                  final currentPage = _buildPage(_index);
                  final incomingPage = _buildIncomingPage();

                  return Column(
                    children: [
                      SizedBox(height: layout.narrow ? 4 : 8),
                      Text(
                        'Cinematic Click Book',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontSize: layout.phone
                                  ? 24
                                  : (layout.narrow ? 30 : 38),
                              letterSpacing: layout.phone
                                  ? 0.6
                                  : (layout.narrow ? 1.0 : 1.4),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: layout.phone ? 4 : (layout.narrow ? 8 : 10),
                      ),
                      Text(
                        _bookUnlocked
                            ? 'Drag or click to turn pages'
                            : 'Tap or drag the cover to open',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.72),
                          fontSize: layout.phone
                              ? 12
                              : (layout.narrow ? 14 : 16),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: layout.phone ? 8 : (layout.narrow ? 12 : 18),
                      ),
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            width: layout.bookWidth,
                            height: layout.bookHeight,
                            child: _BookScene(
                              coverOpen: _coverOpen,
                              turn: _turn,
                              currentPage: currentPage,
                              incomingPage: incomingPage,
                              activeTurn: _activeTurn,
                              bookUnlocked: _bookUnlocked,
                              coverHover: _coverHover,
                              coverPressed: _coverPressed,
                              coverCompact: layout.coverCompact,
                              onPageDragStart: _bookUnlocked
                                  ? _handlePageDragStart
                                  : null,
                              onPageDragUpdate: _bookUnlocked
                                  ? (details) => _handlePageDragUpdate(
                                      details,
                                      layout.bookWidth - 28,
                                    )
                                  : null,
                              onPageDragEnd: _bookUnlocked
                                  ? _handlePageDragEnd
                                  : null,
                              onCoverEnter: () {
                                if (_coverOpen.value >= 1) {
                                  return;
                                }
                                setState(() => _coverHover = true);
                              },
                              onCoverExit: () =>
                                  setState(() => _coverHover = false),
                              onCoverTap: _openCover,
                              onCoverTapDown: () =>
                                  setState(() => _coverPressed = true),
                              onCoverTapUp: () =>
                                  setState(() => _coverPressed = false),
                              onCoverTapCancel: () =>
                                  setState(() => _coverPressed = false),
                              onCoverPanStart: () =>
                                  setState(() => _coverPressed = true),
                              onCoverPanUpdate: (details) =>
                                  _handleCoverDragUpdate(
                                    details,
                                    layout.bookWidth,
                                  ),
                              onCoverPanEnd: (details) {
                                setState(() => _coverPressed = false);
                                _handleCoverDragEnd(details);
                              },
                              onCoverPanCancel: () =>
                                  setState(() => _coverPressed = false),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: layout.narrow ? 10 : 16),
                      _BookNavigation(
                        pageIndex: _index,
                        pageCount: demoPageCount,
                        compact: layout.compactNavigation,
                        locked: !_bookUnlocked,
                        onPrevious: () =>
                            _startButtonTurn(TurnDirection.backward),
                        onNext: () => _startButtonTurn(TurnDirection.forward),
                      ),
                      SizedBox(height: layout.narrow ? 8 : 14),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedGridBackdrop extends StatelessWidget {
  const _AnimatedGridBackdrop({required this.progress});

  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: progress,
        builder: (context, _) {
          return RepaintBoundary(
            child: CustomPaint(painter: _GridPainter(progress: progress.value)),
          );
        },
      ),
    );
  }
}

class _BookScene extends StatelessWidget {
  const _BookScene({
    required this.coverOpen,
    required this.turn,
    required this.currentPage,
    required this.incomingPage,
    required this.activeTurn,
    required this.bookUnlocked,
    required this.coverHover,
    required this.coverPressed,
    required this.coverCompact,
    required this.onPageDragStart,
    required this.onPageDragUpdate,
    required this.onPageDragEnd,
    required this.onCoverEnter,
    required this.onCoverExit,
    required this.onCoverTap,
    required this.onCoverTapDown,
    required this.onCoverTapUp,
    required this.onCoverTapCancel,
    required this.onCoverPanStart,
    required this.onCoverPanUpdate,
    required this.onCoverPanEnd,
    required this.onCoverPanCancel,
  });

  final Animation<double> coverOpen;
  final Animation<double> turn;
  final Widget currentPage;
  final Widget? incomingPage;
  final TurnDirection? activeTurn;
  final bool bookUnlocked;
  final bool coverHover;
  final bool coverPressed;
  final bool coverCompact;
  final GestureDragStartCallback? onPageDragStart;
  final GestureDragUpdateCallback? onPageDragUpdate;
  final GestureDragEndCallback? onPageDragEnd;
  final VoidCallback onCoverEnter;
  final VoidCallback onCoverExit;
  final VoidCallback onCoverTap;
  final VoidCallback onCoverTapDown;
  final VoidCallback onCoverTapUp;
  final VoidCallback onCoverTapCancel;
  final VoidCallback onCoverPanStart;
  final GestureDragUpdateCallback onCoverPanUpdate;
  final GestureDragEndCallback onCoverPanEnd;
  final VoidCallback onCoverPanCancel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _BookBase(
          bookUnlocked: bookUnlocked,
          onPageDragStart: onPageDragStart,
          onPageDragUpdate: onPageDragUpdate,
          onPageDragEnd: onPageDragEnd,
          child: _AnimatedBookPageLayers(
            turn: turn,
            currentPage: currentPage,
            incomingPage: incomingPage,
            activeTurn: activeTurn,
          ),
        ),
        _AnimatedCoverLayer(
          coverOpen: coverOpen,
          compact: coverCompact,
          hover: coverHover,
          pressed: coverPressed,
          onEnter: onCoverEnter,
          onExit: onCoverExit,
          onTap: onCoverTap,
          onTapDown: onCoverTapDown,
          onTapUp: onCoverTapUp,
          onTapCancel: onCoverTapCancel,
          onPanStart: onCoverPanStart,
          onPanUpdate: onCoverPanUpdate,
          onPanEnd: onCoverPanEnd,
          onPanCancel: onCoverPanCancel,
        ),
      ],
    );
  }
}

class _BookBase extends StatelessWidget {
  const _BookBase({
    required this.bookUnlocked,
    required this.onPageDragStart,
    required this.onPageDragUpdate,
    required this.onPageDragEnd,
    required this.child,
  });

  final bool bookUnlocked;
  final GestureDragStartCallback? onPageDragStart;
  final GestureDragUpdateCallback? onPageDragUpdate;
  final GestureDragEndCallback? onPageDragEnd;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A223B), Color(0xFF0F1529), Color(0xFF090D1A)],
        ),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: BookDecorationTokens.bookFrameBorderAlpha,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: BookDecorationTokens.bookShadowAlpha,
            ),
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
                padding: const EdgeInsets.all(14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragStart: bookUnlocked
                          ? onPageDragStart
                          : null,
                      onHorizontalDragUpdate: bookUnlocked
                          ? onPageDragUpdate
                          : null,
                      onHorizontalDragEnd: bookUnlocked ? onPageDragEnd : null,
                      child: child,
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
}

class _BookPageLayers extends StatelessWidget {
  const _BookPageLayers({
    required this.currentPage,
    required this.incomingPage,
    required this.activeTurn,
    required this.turnValue,
  });

  final Widget currentPage;
  final Widget? incomingPage;
  final TurnDirection? activeTurn;
  final double turnValue;

  Widget _pageLayer(Widget page, {required bool freezeTickers}) {
    return TickerMode(
      enabled: !freezeTickers,
      child: RepaintBoundary(child: page),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (activeTurn == null || incomingPage == null) {
      return RepaintBoundary(child: currentPage);
    }

    final incoming = incomingPage!;
    final progress = turnValue;
    final freezePageTickers = activeTurn != null;
    final angle =
        (activeTurn == TurnDirection.forward ? -1 : 1) * progress * (pi / 1.9);
    final pivot = activeTurn == TurnDirection.forward
        ? Alignment.centerLeft
        : Alignment.centerRight;
    final translate =
        (activeTurn == TurnDirection.forward ? 1 : -1) *
        progress *
        BookMotion.pageTurnTranslate;
    final shadowBegin = activeTurn == TurnDirection.forward
        ? Alignment.centerLeft
        : Alignment.centerRight;
    final shadowEnd = activeTurn == TurnDirection.forward
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.scale(
          scale:
              BookMotion.incomingPageBaseScale +
              (BookMotion.incomingPageScaleRange * progress),
          child: _pageLayer(
            incoming,
            freezeTickers: freezePageTickers,
          ),
        ),
        Transform(
          alignment: pivot,
          transform: Matrix4.identity()
            ..setEntry(3, 2, BookMotion.pageTurnPerspective)
            ..translateByDouble(translate, 0.0, 0.0, 1.0)
            ..rotateY(angle),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _pageLayer(currentPage, freezeTickers: freezePageTickers),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: shadowBegin,
                      end: shadowEnd,
                      colors: [
                        Colors.black.withValues(
                          alpha:
                              BookDecorationTokens.pageShadowAlpha * progress,
                        ),
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
}

class _AnimatedBookPageLayers extends StatelessWidget {
  const _AnimatedBookPageLayers({
    required this.turn,
    required this.currentPage,
    required this.incomingPage,
    required this.activeTurn,
  });

  final Animation<double> turn;
  final Widget currentPage;
  final Widget? incomingPage;
  final TurnDirection? activeTurn;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: turn,
      builder: (context, _) {
        return _BookPageLayers(
          currentPage: currentPage,
          incomingPage: incomingPage,
          activeTurn: activeTurn,
          turnValue: turn.value,
        );
      },
    );
  }
}

class _AnimatedCoverLayer extends StatelessWidget {
  const _AnimatedCoverLayer({
    required this.coverOpen,
    required this.compact,
    required this.hover,
    required this.pressed,
    required this.onEnter,
    required this.onExit,
    required this.onTap,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.onPanCancel,
  });

  final Animation<double> coverOpen;
  final bool compact;
  final bool hover;
  final bool pressed;
  final VoidCallback onEnter;
  final VoidCallback onExit;
  final VoidCallback onTap;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback onTapCancel;
  final VoidCallback onPanStart;
  final GestureDragUpdateCallback onPanUpdate;
  final GestureDragEndCallback onPanEnd;
  final VoidCallback onPanCancel;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: coverOpen,
      builder: (context, _) {
        if (coverOpen.value >= BookThresholds.coverHiddenProgress) {
          return const SizedBox.shrink();
        }
        return _CoverLayer(
          progressValue: coverOpen.value,
          compact: compact,
          hover: hover,
          pressed: pressed,
          onEnter: onEnter,
          onExit: onExit,
          onTap: onTap,
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onTapCancel: onTapCancel,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
          onPanCancel: onPanCancel,
        );
      },
    );
  }
}

class _CoverLayer extends StatelessWidget {
  const _CoverLayer({
    required this.progressValue,
    required this.compact,
    required this.hover,
    required this.pressed,
    required this.onEnter,
    required this.onExit,
    required this.onTap,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.onPanCancel,
  });

  final double progressValue;
  final bool compact;
  final bool hover;
  final bool pressed;
  final VoidCallback onEnter;
  final VoidCallback onExit;
  final VoidCallback onTap;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback onTapCancel;
  final VoidCallback onPanStart;
  final GestureDragUpdateCallback onPanUpdate;
  final GestureDragEndCallback onPanEnd;
  final VoidCallback onPanCancel;

  @override
  Widget build(BuildContext context) {
    final progress = Curves.easeOutCubic.transform(progressValue);
    final hoverLift = hover ? BookMotion.coverHoverLift : 0.0;
    final pressScale = pressed ? BookMotion.coverPressedScale : 1.0;

    return Positioned.fill(
      child: MouseRegion(
        onEnter: (_) => onEnter(),
        onExit: (_) => onExit(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          onTapDown: (_) => onTapDown(),
          onTapUp: (_) => onTapUp(),
          onTapCancel: onTapCancel,
          onPanStart: (_) => onPanStart(),
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
          onPanCancel: onPanCancel,
          child: Transform(
            alignment: Alignment.centerLeft,
            transform: Matrix4.identity()
              ..setEntry(3, 2, BookMotion.coverPerspective)
              ..translateByDouble(0.0, hoverLift * (1 - progress), 0.0, 1.0)
              ..scaleByDouble(pressScale, pressScale, 1.0, 1.0)
              ..rotateZ(
                BookMotion.coverHoverRotation * (hover ? (1 - progress) : 0.0),
              )
              ..rotateY(-progress * pi * BookMotion.coverOpenRotationFactor),
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
                  color: Colors.white.withValues(
                    alpha: BookDecorationTokens.sharedBorderAlpha,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: BookDecorationTokens.coverShadowAlpha,
                    ),
                    blurRadius: 36 + (progress * 8),
                    offset: const Offset(0, 20),
                  ),
                  BoxShadow(
                    color: const Color(0xFF6EE4FF).withValues(
                      alpha:
                          BookDecorationTokens.coverGlowAlpha * (1 - progress),
                    ),
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
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.white.withValues(
                              alpha: BookDecorationTokens.sharedBorderAlpha,
                            ),
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
                            color: Colors.white.withValues(
                              alpha: BookDecorationTokens.coverHintFillAlpha,
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: BookDecorationTokens.sharedBorderAlpha,
                              ),
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
    );
  }
}

class _BookNavigation extends StatelessWidget {
  const _BookNavigation({
    required this.pageIndex,
    required this.pageCount,
    required this.compact,
    required this.locked,
    required this.onPrevious,
    required this.onNext,
  });

  final int pageIndex;
  final int pageCount;
  final bool compact;
  final bool locked;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final atStart = pageIndex == 0;
    final atEnd = pageIndex == pageCount - 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Page ${pageIndex + 1} / $pageCount',
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
              onTap: locked || atStart ? null : onPrevious,
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
              children: List<Widget>.generate(pageCount, (dotIndex) {
                final active = dotIndex == pageIndex;
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
              onTap: locked || atEnd ? null : onNext,
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
