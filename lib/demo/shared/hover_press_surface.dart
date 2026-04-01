import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../animation/demo_animation.dart';

abstract final class HoverPressSurfaceTokens {
  static const double hoverLift = -5.0;
  static const double pressedScale = 0.97;
  static const double defaultBackgroundAlpha = 0.10;
  static const double focusedBorderAlpha = 0.68;
  static const double idleBorderAlpha = 0.20;
  static const double hoverShadowAlpha = 0.45;
  static const double idleShadowAlpha = 0.28;
  static const double hoverShadowBlur = 20.0;
  static const double idleShadowBlur = 12.0;
  static const double hoverShadowOffset = 12.0;
  static const double idleShadowOffset = 8.0;
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
            duration: DemoDurations.hoverSurface,
            curve: Curves.easeOut,
            width: widget.width,
            height: widget.height,
            alignment: widget.alignment,
            padding: widget.padding,
            transform: Matrix4.identity()
              ..translateByDouble(
                0.0,
                _hovered ? HoverPressSurfaceTokens.hoverLift : 0.0,
                0.0,
                1,
              )
              ..scaleByDouble(
                _pressed ? HoverPressSurfaceTokens.pressedScale : 1.0,
                _pressed ? HoverPressSurfaceTokens.pressedScale : 1.0,
                1.0,
                1,
              ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color:
                  widget.background ??
                  Colors.white.withValues(
                    alpha: HoverPressSurfaceTokens.defaultBackgroundAlpha,
                  ),
              border:
                  widget.border ??
                  Border.all(
                    color: Colors.white.withValues(
                      alpha: _focused
                          ? HoverPressSurfaceTokens.focusedBorderAlpha
                          : HoverPressSurfaceTokens.idleBorderAlpha,
                    ),
                  ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: _hovered
                        ? HoverPressSurfaceTokens.hoverShadowAlpha
                        : HoverPressSurfaceTokens.idleShadowAlpha,
                  ),
                  blurRadius: _hovered
                      ? HoverPressSurfaceTokens.hoverShadowBlur
                      : HoverPressSurfaceTokens.idleShadowBlur,
                  offset: Offset(
                    0,
                    _hovered
                        ? HoverPressSurfaceTokens.hoverShadowOffset
                        : HoverPressSurfaceTokens.idleShadowOffset,
                  ),
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
