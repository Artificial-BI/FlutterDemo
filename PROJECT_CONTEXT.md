# Project Context

## Scope

This project is a premium animated Flutter digital-book demo for Android and Windows. The core goal is tactile, satisfying click/drag interaction quality with a cinematic visual style.

## Current Feature Summary

- Interactive cover with hinge open animation (hover + press + drag/tap open).
- Custom page-turn transition preserving live page interactivity.
- 10 page interaction flow:
  - expandable control deck
  - rotary volume knob
  - reactive brightness dimmer
  - premium mode toggle
  - 3D flip reveal card
  - mechanical lever
  - notification bell micro-interaction
  - radial action wheel
  - charge-and-hold ring
  - multi-step finale CTA
- Shared reusable interaction widget with hover, press, and keyboard activation support.
- Clear previous/next navigation and page indicators.

## Main File Ownership

- `lib/main.dart`
  - Entrypoint; launches `ClickBookDemoApp`.

- `lib/book_demo_app.dart`
  - App-level theme and typography.

- `lib/book_experience.dart`
  - Book container experience:
    - cover open interaction
    - page turn state/transitions
    - drag handling
    - nav controls and background painter

- `lib/demo_pages.dart`
  - Interaction page content and reusable page widgets:
    - `ShowcasePageShell`
    - `HoverPressSurface`
    - page widgets 1-10

- `test/widget_test.dart`
  - Smoke test for app startup and cover UI.

## Dependency Notes

- `google_fonts` is used for premium typography.
- Page-turn remains custom `Transform/Matrix4` for stable live interactions.

## Architecture Notes

- Intentionally minimal, feature-oriented structure.
- No BLoC/Redux/global complex state layers.
- Local widget state + focused animation controllers.

## Build/Run Notes (2026-03-24)

- `flutter pub get`: passed
- `flutter analyze`: passed
- `flutter build windows`: passed
- `flutter build apk`: passed
- `flutter run -d windows --no-resident`: passed
- `flutter run -d emulator-5554 --no-resident`: passed on emulator `Medium_Phone_API_36.1`
- `adb devices`: confirmed Android runtime target as `emulator-5554`
