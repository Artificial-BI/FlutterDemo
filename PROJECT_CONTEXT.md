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

## Current Architecture

The project now uses a small feature-oriented structure with explicit shared layers instead of one giant page file.

### Core Files

- `lib/main.dart`
  - Entrypoint; launches `ClickBookDemoApp`.

- `lib/book_demo_app.dart`
  - App theme and typography.

- `lib/book_experience.dart`
  - Book scene composition.
  - Cover open interaction.
  - Page turn state/transitions.
  - Navigation controls.
  - Scoped animated rebuilds for the scene.

- `lib/book/book_experience_constants.dart`
  - Named constants for book unlock thresholds, turn thresholds, motion ratios, and decoration tokens.

### Demo Layer

- `lib/demo/demo_page_catalog.dart`
  - Lazy page builder by index.
  - Only the active page and the incoming page during a turn are built.

- `lib/demo/shared/showcase_page_shell.dart`
  - Shared page shell and ambient backdrop.

- `lib/demo/shared/hover_press_surface.dart`
  - Shared hover/press/focus interaction primitive.

- `lib/demo/responsive/demo_responsive.dart`
  - Shared breakpoint constants.
  - `BookLayout`, `DemoPageLayout`, `DemoPageShellLayout`.

- `lib/demo/animation/demo_animation.dart`
  - Shared animation controller lifecycle helpers.
  - Staggered animation utilities.

- `lib/demo/pages/`
  - One page per file for all 10 demo pages.

## Architectural Rules

- Do not reintroduce eager page lists for the full book. Use the page catalog.
- Do not create `AnimationController` instances as inline field initializers. Create them in `initState`.
- Do not create `CurvedAnimation`/interval objects in `build()` unless the object is purely local and not rebuild-sensitive; prefer lifecycle-owned fields or shared helpers.
- Do not use `Future.delayed` to guess animation completion. Use `AnimationStatus` listeners.
- Do not add new breakpoint thresholds ad hoc inside pages. Extend `demo_responsive.dart` instead.
- Reuse `HoverPressSurface` and `ShowcasePageShell` before adding new wrappers.
- Keep rebuild scopes local to the subtree that actually depends on an animation.

## Build/Run Notes (2026-04-01)

- `dart format lib test`: passed
- `flutter analyze`: passed
- `flutter test`: passed
- `flutter build windows`: passed
- `flutter build apk`: passed
- `flutter run -d windows --no-resident`: passed

## Dependency Notes

- `google_fonts` is used for premium typography.
- Page-turn remains custom `Transform/Matrix4` for stable live interactions.
