import 'package:flutter/material.dart';

import 'pages/brightness_dimmer_page.dart';
import 'pages/charge_and_hold_page.dart';
import 'pages/final_cinematic_cta_page.dart';
import 'pages/flip_reveal_page.dart';
import 'pages/intro_control_deck_page.dart';
import 'pages/mechanical_lever_page.dart';
import 'pages/morph_toggle_page.dart';
import 'pages/notification_bell_page.dart';
import 'pages/radial_command_wheel_page.dart';
import 'pages/volume_control_page.dart';

const int demoPageCount = 10;

Widget buildDemoPage(int index, {required VoidCallback onRestartBook}) {
  return KeyedSubtree(
    key: ValueKey<String>('demo-page-$index'),
    child: switch (index) {
      0 => const IntroControlDeckPage(),
      1 => const VolumeControlPage(),
      2 => const BrightnessDimmerPage(),
      3 => const MorphTogglePage(),
      4 => const FlipRevealPage(),
      5 => const MechanicalLeverPage(),
      6 => const NotificationBellPage(),
      7 => const RadialCommandWheelPage(),
      8 => const ChargeAndHoldPage(),
      9 => FinalCinematicCtaPage(onRestartBook: onRestartBook),
      _ => throw RangeError.index(
        index,
        List<int>.generate(demoPageCount, (i) => i),
      ),
    },
  );
}
