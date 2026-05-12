# Context

## Current Refactor Status (2026-04-01)

This project has completed a structural refactor focused on architecture rather than cosmetics.

## What Changed

- Split the former monolithic `lib/demo_pages.dart` into dedicated page files under `lib/demo/pages/`.
- Replaced eager page construction with a lazy page catalog in `lib/demo/demo_page_catalog.dart`.
- Introduced a shared animation lifecycle layer in `lib/demo/animation/demo_animation.dart`.
- Centralized breakpoint and layout rules in `lib/demo/responsive/demo_responsive.dart`.
- Moved book-scene motion thresholds and constants into `lib/book/book_experience_constants.dart`.
- Localized animation rebuilds in `lib/book_experience.dart` so the entire `Scaffold` is no longer rebuilt every tick.
- Removed timer-based animation completion from the final CTA page and switched to `AnimationStatus` handling.
- Added a navigation smoke test in `test/widget_test.dart`.

## Verified Commands And Results

- `dart format lib test` -> passed
- `flutter analyze` -> passed (no issues)
- `flutter test` -> passed
- `flutter build windows` -> passed
- `flutter build apk` -> passed
- `flutter run -d windows --no-resident` -> passed

## Quick Ownership Map

- `lib/book_experience.dart`
  - Book container, cover interaction, page turn orchestration, navigation UI.
  - Includes a small page-turn gesture handler with explicit `idle / warming / active / committing` states.

- `lib/demo/demo_page_catalog.dart`
  - Lazy page creation by index.

- `lib/demo/animation/demo_animation.dart`
  - Shared controller lifecycle and stagger helpers.

- `lib/demo/responsive/demo_responsive.dart`
  - Shared breakpoint and layout rules.

- `lib/demo/shared/`
  - Common page shell and interaction surface.

- `lib/demo/pages/`
  - Individual page implementations.

## Notes

- Main project context remains in `PROJECT_CONTEXT.md`.
- The current working tree intentionally includes user-approved deletions of `_android_page3*.png` and `build.zip`.
