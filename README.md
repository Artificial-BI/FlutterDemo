# Cinematic Click Book Demo

A premium Flutter showcase built as an interactive digital book for Android, Windows, and Chrome/Web.

## Build/Run Compatibility Status (2026-03-24)

A targeted platform compatibility pass was completed with no code-level blockers found.

- `flutter pub get`: passed
- `flutter analyze`: passed with no issues
- `flutter build windows`: passed
- `flutter build apk`: passed
- `flutter run -d windows --no-resident`: launched successfully
- `flutter run -d emulator-5554 --no-resident`: launched successfully on Android emulator (`Medium_Phone_API_36.1`)

Current verified result:
- Windows build + launch path is working.
- Android build + runtime launch path is working.

Chrome/Web support:
- The project is intended to support Chrome/Web as a target.
- To run in Chrome, the local environment must have Flutter web support enabled and Chrome detected by `flutter devices`.
- If the `web/` folder is missing, add web platform support before running in Chrome.

Android runtime verification details:
- Emulator name/id: `Medium_Phone_API_36.1`
- Runtime device id used: `emulator-5554`
- Note: an initial transient service-protocol attach error was resolved by restarting `adb` and rerunning `flutter run`.

## What Was Added

- Animated book cover with hinge-style open (click/tap/drag), hover lift on Windows, and press compression.
- Custom live page-turn system (3D transform + edge shadows + drag-based turning).
- 10 themed interactive pages with distinct click/drag feedback.
- Reusable hover/press/focus interaction surface with desktop keyboard activation support.
- Dark cinematic theme with glow, layered depth, and ambient motion.
- Final CTA page with multi-step progression and success mood shift.

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
  - App shell, dark theme, typography setup.

- `lib/book_experience.dart`
  - Cover animation, book container, page-turn logic, navigation controls.

- `lib/demo_pages.dart`
  - Shared page shell (`ShowcasePageShell`), reusable interactive surface (`HoverPressSurface`), and all page interactions (1-10).

- `test/widget_test.dart`
  - Smoke test confirming app launch and cover visibility.

- `PROJECT_CONTEXT.md`
  - Context summary and feature ownership notes.

## Packages Added

- `google_fonts: ^8.0.2`
  - Used for premium typography (`Orbitron`, `Exo 2`) to avoid generic default styling.

Notes on page-turn package strategy:
- The book turn uses custom `Transform/Matrix4` animation to keep pages fully live/interactive and stable on desktop/mobile/web.
- A package-based page-turn was intentionally not integrated to avoid risking interactive-page limitations.

## Run

1. Install dependencies:

```bash
flutter pub get
Run on Windows:
flutter run -d windows
Run on Android (device/emulator required):
flutter devices
flutter run -d <android-device-id>

If your device id is literally android, you can use:

flutter run -d android
Run on Chrome/Web:

If web support already exists in the project:

flutter run -d chrome

If the project does not yet include web support, add it first:

flutter create . --platforms web
flutter run -d chrome

To confirm Chrome is available as a Flutter target:

flutter devices
Build
Windows release
flutter build windows
Android APK
flutter build apk
Chrome/Web build
flutter build web

Built web output will be generated in:

build/web
Verification Commands
flutter pub get
flutter analyze
flutter test
flutter run -d windows
flutter run -d emulator-5554
flutter run -d chrome

When Android hardware/emulator is unavailable, use build verification:

flutter build apk --debug

When Chrome/Web runtime cannot be launched locally, use build verification:

flutter build web
Notes
Windows requires the Windows desktop Flutter toolchain to be installed.
Android requires a connected device or emulator.
Chrome/Web requires Flutter web support and a detected Chrome browser target.
If Chrome does not appear in flutter devices, enable web support and verify the local Flutter setup before running.

