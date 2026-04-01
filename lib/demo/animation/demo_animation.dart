import 'package:flutter/material.dart';

abstract final class DemoDurations {
  static const Duration ambientLoop = Duration(seconds: 12);
  static const Duration hoverSurface = Duration(milliseconds: 140);
  static const Duration introDeckExpand = Duration(milliseconds: 560);
  static const Duration volumePulse = Duration(milliseconds: 520);
  static const Duration flipCard = Duration(milliseconds: 640);
  static const Duration leverSettle = Duration(milliseconds: 420);
  static const Duration notificationWiggle = Duration(milliseconds: 760);
  static const Duration notificationRing = Duration(milliseconds: 980);
  static const Duration radialMenu = Duration(milliseconds: 620);
  static const Duration holdCharge = Duration(milliseconds: 1700);
  static const Duration holdRelease = Duration(milliseconds: 240);
  static const Duration holdBurst = Duration(milliseconds: 860);
  static const Duration finalMoodShift = Duration(milliseconds: 900);
  static const Duration finalPulse = Duration(milliseconds: 1000);
}

mixin _AnimationControllerRegistry<T extends StatefulWidget> on State<T> {
  final List<AnimationController> _managedControllers = <AnimationController>[];

  @protected
  void registerController(AnimationController controller) {
    _managedControllers.add(controller);
  }

  @protected
  @override
  @mustCallSuper
  void dispose() {
    for (final controller in _managedControllers.reversed) {
      controller.dispose();
    }
    super.dispose();
  }
}

abstract class ManagedSingleTickerState<T extends StatefulWidget>
    extends State<T>
    with SingleTickerProviderStateMixin<T>, _AnimationControllerRegistry<T> {
  @protected
  AnimationController createAnimationController({
    required Duration duration,
    Duration? reverseDuration,
    double? value,
  }) {
    final controller = AnimationController(
      vsync: this,
      duration: duration,
      reverseDuration: reverseDuration,
      value: value,
    );
    registerController(controller);
    return controller;
  }
}

abstract class ManagedTickerState<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin<T>, _AnimationControllerRegistry<T> {
  @protected
  AnimationController createAnimationController({
    required Duration duration,
    Duration? reverseDuration,
    double? value,
  }) {
    final controller = AnimationController(
      vsync: this,
      duration: duration,
      reverseDuration: reverseDuration,
      value: value,
    );
    registerController(controller);
    return controller;
  }
}

List<Animation<double>> buildStaggeredAnimations({
  required Animation<double> parent,
  required int count,
  required double step,
  Curve curve = Curves.easeOut,
  double end = 1.0,
}) {
  return List<Animation<double>>.generate(
    count,
    (index) => CurvedAnimation(
      parent: parent,
      curve: Interval(step * index, end, curve: curve),
    ),
  );
}
