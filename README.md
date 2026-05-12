# Cinematic Click Book Demo

A premium Flutter showcase built as an interactive digital book for Android, Windows, and Chrome/Web.

## Architecture Status (2026-04-01)

A full architectural refactor was completed to address code-review findings around monolithic page structure, eager widget creation, animation lifecycle, duplicated responsive rules, and avoidable rebuild patterns.

Verified after refactor:

- `dart format lib test`: passed
- `flutter analyze`: passed with no issues
- `flutter test`: passed
- `flutter build windows`: passed
- `flutter build apk`: passed
- `flutter run -d windows --no-resident`: launched successfully
- `flutter run -d chrome`: launched successfully
- `flutter build web`: passed

## What This Project Contains

- Interactive book cover with hinge open animation (click/tap/drag), hover lift on Windows, and press compression.
- Custom live page-turn system using `Transform/Matrix4` while keeping page content interactive.
- 10 themed interaction pages with distinct click/drag feedback.
- Reusable hover/press/focus interaction surface with desktop keyboard activation support.
- Dark cinematic theme with glow, layered depth, and ambient motion.
- Final CTA page with multi-step progression and restart flow.

## Experience Structure

- Cover: `NEON ATLAS` interactive cover.
- Page 1: Intro control deck with expandable panel and staggered controls.
- Page 2: Rotary volume knob with drag rotation, press-in feel, radial pulse.
- Page 3: Vertical brightness dimmer with reactive ambient glow.
- Page 4: Premium mode toggle with ambience shift.
- Page 5: 3D flip card with moving sheen.
- Page 6: Mechanical lever with spring settle and base compression.
- Page 7: Notification bell with wiggle, ring wave, badge pop.
- Page 8: Radial command menu with staggered fan-out and hover-aware reactions.
- Page 9: Charge-and-hold interaction with fill ring and burst payoff.
- Page 10: Finale cinematic CTA (prime -> execute -> success), plus book restart.

## File Structure And Ownership

- `lib/main.dart`
  - App entrypoint.

- `lib/book_demo_app.dart`
  - App shell, theme, typography.

- `lib/book_experience.dart`
  - Book container, cover interaction, page turn state, navigation, and scene composition.

- `lib/book/book_experience_constants.dart`
  - Named constants for unlock thresholds, turn thresholds, cover motion, and book-scene decoration values.

- `lib/design/`
  - Shared lightweight design tokens for common app colors, spacing, radii, and motion values.

- `lib/demo/demo_page_catalog.dart`
  - Lazy page registry. Builds the active page by index instead of eagerly creating all 10 pages at startup.

- `lib/demo/animation/demo_animation.dart`
  - Shared animation lifecycle abstractions.
  - Centralized `AnimationController` creation/disposal helpers.
  - Shared staggered animation builder.

- `lib/demo/responsive/demo_responsive.dart`
  - Single source of truth for breakpoints and page/book layout rules.
  - Shared `BookLayout`, `DemoPageLayout`, and `DemoPageShellLayout` models.

- `lib/demo/shared/hover_press_surface.dart`
  - Reusable hover/press/focus interaction surface.

- `lib/demo/shared/showcase_page_shell.dart`
  - Shared visual shell and ambient backdrop for all demo pages.

- `lib/demo/pages/`
  - `intro_control_deck_page.dart`
  - `volume_control_page.dart`
  - `brightness_dimmer_page.dart`
  - `morph_toggle_page.dart`
  - `flip_reveal_page.dart`
  - `mechanical_lever_page.dart`
  - `notification_bell_page.dart`
  - `radial_command_wheel_page.dart`
  - `charge_and_hold_page.dart`
  - `final_cinematic_cta_page.dart`

- `lib/demo_pages.dart`
  - Compatibility barrel export for shared demo modules.
  - No longer owns all pages or builds them eagerly.

- `test/widget_test.dart`
  - Smoke tests for app launch, cover visibility, and page navigation.

- `PROJECT_CONTEXT.md`
  - Architecture and ownership notes.

## Architectural Rules

### Pages

- One page per file.
- Shared page chrome lives in `ShowcasePageShell`.
- Shared interaction surfaces live in `HoverPressSurface`.
- Page lookup goes through `buildDemoPage(index, ...)` so only the active page and in-flight turn target are built.

### Animation Lifecycle

- `AnimationController` instances are created in `initState`, never as inline field initializers.
- Controller disposal is centralized through `ManagedSingleTickerState` / `ManagedTickerState`.
- Derived animations such as intervals and curves are created once in lifecycle-safe helpers, not recreated inside `build()` every frame.
- Animation completion logic uses `AnimationStatus` listeners instead of timer guesses.

### Responsive Rules

- Breakpoints are centralized in `demo_responsive.dart`.
- Book-level layout uses `BookLayout`.
- Page-level compact/short decisions use `DemoPageLayout` and `DemoPageShellLayout`.
- New pages should extend the shared layout models instead of introducing ad-hoc width/height thresholds.

### Rebuild And Repaint Rules

- `Scaffold` stays static; animation-driven rebuilds are localized to the grid backdrop and book scene.
- `RepaintBoundary` is applied only around page content layers that benefit from isolation during page turns.
- Avoid wrapping unrelated ancestors in animation listeners.

## Run

```bash
flutter pub get
```

Windows:

```bash
flutter run -d windows
```

Android:

```bash
flutter devices
flutter run -d <android-device-id>
```

Chrome/Web:

```bash
flutter run -d chrome
```

## Build

Windows:

```bash
flutter build windows
```

Android APK:

```bash
flutter build apk
```

Web:

```bash
flutter build web
```

## Verification Commands

```bash
dart format lib test
flutter analyze
flutter test
flutter build windows
flutter build apk
flutter run -d windows --no-resident
```

## Notes

- `google_fonts` provides the premium typography (`Orbitron`, `Exo 2`).
- The page-turn implementation remains custom `Transform/Matrix4` to preserve live interactivity on the active pages.
- Page-turn drag state is handled through a small dedicated gesture helper with explicit `idle / warming / active / committing` phases.
- `HoverPressSurface` was intentionally preserved and reused as the base interaction primitive.
