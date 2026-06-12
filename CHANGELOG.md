# Changelog

All notable changes to Ultimate are documented here. Versions follow
[Semantic Versioning](https://semver.org).

## [0.7.1] — 2026-06-12

### Fixed

- **Sheet body controls were intermittently un-tappable / laggy.** The 0.7.0
  swipe-to-dismiss `DragGesture` covered the whole sheet card, so buttons,
  sliders and chips inside had to lose a gesture-disambiguation race on every
  tap. The drag now lives only on the grabber handle at the top — body controls
  respond instantly again.

[0.7.1]: https://github.com/devmobileuae/Ultimate/releases/tag/0.7.1

## [0.7.0] — 2026-06-12

### Added

- **Swipe-to-dismiss bottom sheet**: `.uBottomSheet` now has a drag grabber and
  follows a downward drag, dismissing past a threshold (or a flick) and springing
  back otherwise. Internal behavior only — no API change. Applies to `.card`
  and `.glass` styles.

[0.7.0]: https://github.com/devmobileuae/Ultimate/releases/tag/0.7.0

## [0.6.0] — 2026-06-12

### Added

- **Glass top bar + edge fade**: `UTopBar(…, style: .glass)` backs the bar
  with a faded frosted strip reaching up through the status bar — pin it and
  scrolling content dissolves under it. The underlying treatment is exposed as
  `.uEdgeFade(_:height:)` / `UGlassEdgeFade` for shells that want the fade on
  a bare screen edge (top or bottom) without a bar. Gallery: glass-bar
  specimen on the Navigation page.

[0.6.0]: https://github.com/devmobileuae/Ultimate/releases/tag/0.6.0

## [0.5.0] — 2026-06-12

### Added

- **Glass bottom nav**: `UBottomNav(selection:items:style:)` with `.ink`
  (default, unchanged) and `.glass` — a frosted pill the scrolling content
  shimmers through; active item becomes a `surfaceInverse` circle, no shadow.
  Gallery: glass nav specimen on the Navigation page.

[0.5.0]: https://github.com/devmobileuae/Ultimate/releases/tag/0.5.0

## [0.4.0] — 2026-06-12

### Added

- **Glass modal chrome**: `UModalStyle` (`.card` default / `.glass`) on
  `.uBottomSheet` and `.uDialog`. Glass modals render frosted over the scrim —
  the content behind shimmers through — and carry no shadow. Gallery: glass
  sheet and glass dialog presenters on the Sheets page.

[0.4.0]: https://github.com/devmobileuae/Ultimate/releases/tag/0.4.0

## [0.3.0] — 2026-06-12

### Added

- **Haptics layer** — every tappable component gives feedback out of the box,
  ON by default. A light press haptic fires on touch-down (`UButton`,
  `UIconButton`, `UChip`, `UNavCircle`, `USheetAction`, `UCell`, dropdown
  trigger, and all pressables); state-changing controls fire a `.selection`
  tick (`USwitch`, `UCheckbox`, `URadio`, `USegmentedControl`, `UStepper`,
  `UTabs`, `UDateStrip`, `UBottomNav`, `UCalendarDay`, dropdown row), and
  destructive actions fire a `.warning` (destructive dropdown row, destructive
  `USheetAction`). Clamped/no-op taps stay silent.
  - `UHaptic` enum (impact / selection / notification styles, plus `.none`).
  - `UltimateHaptics.configure(default:)` to set or disable the global press
    feel app-wide.
  - `.uHaptic(_:)` view modifier to override haptics per subtree.
  - Generators respect the user's system-level haptics setting; no-op on
    devices without a Taptic Engine.
- **Glass effect** — a frosted surface (ultra-thin material + faint tint +
  hairline rim + top highlight) for content over colorful or photographic
  backdrops, with no shadow (it floats by contrast).
  - `.uGlass(radius:)` view modifier (default radius matches cards).
  - `UCardFill.glass`, `UButtonVariant.glass`, and a `.glass` `UIconButton`
    variant.
  - Gallery: glass specimens on the Buttons and Cards pages (over a gradient
    backdrop) and a Haptics specimen on the Controls page.

[0.3.0]: https://github.com/devmobileuae/Ultimate/releases/tag/0.3.0

## [0.2.1] — 2026-06-12

### Fixed

- **Onest weights rendered as SF.** The bundled variable `Onest[wght].ttf`
  exposes no PostScript names for its named instances on iOS, so
  `Onest-Medium`/`Onest-SemiBold`/`Onest-Bold` silently fell back to the
  system font — only Regular was real Onest. Static per-weight font files are
  now bundled and registered alongside the variable file, restoring the full
  type ramp (labels, headlines, titles, display).

[0.2.1]: https://github.com/devmobileuae/Ultimate/releases/tag/0.2.1

## [0.2.0] — 2026-06-11

### Added

- **Configurable theming**: `UTheme` + `UltimateTheme.configure(_:)`. Install
  a theme once at app start to rebrand the entire system — every semantic
  color token (accents, selection fills, surfaces, text, status, nav, washes)
  is overridable as a light/dark pair via `UThemeColor`. Anything not set
  keeps the stock Ultimate value; existing 0.1 code is unaffected.
- `UltimateTheme.reset()` restores the stock look.
- Runtime theme switching: re-apply `configure(_:)` and rebuild the themed
  hierarchy (e.g. `.id(themeToken)`); colors resolve the active theme at draw
  time.
- Gallery: new **Theming** page with live presets (Stock / Garnet / Ocean /
  Forest).

[0.2.0]: https://github.com/devmobileuae/Ultimate/releases/tag/0.2.0

## [0.1.0] — 2026-06-11

Initial release.

### Added

- **33 components** across 12 groups:
  - Core: `UIcon` (Lucide thin-line)
  - Buttons: `UButton` (primary/accent/soft/white/outline/ghost × sm/md/lg,
    icon slots, block), `UIconButton`
  - Controls: `USwitch`, `UCheckbox`, `URadio`, `USegmentedControl`,
    `UStepper` (horizontal + compact vertical), `USlider`
  - Inputs: `UInput`, `USearchBar`
  - Cells: `UCell`, `UCellGroup`, `UAgendaRow`
  - Badges: `UBadge`, `UChip`, `UAvatar`, `UAvatarStack`
  - Navigation: `UBottomNav`, `UTopBar`, `UTabs`, `UDateStrip`, `UNavCircle`,
    `UNavCircleRow`
  - Menus: `UDropdown`
  - Calendar: `UCalendar`, `UCalendarDay` (tones, dot/icon/count markers)
  - Cards: `UCard`, `UEventCard`, `UStatTile`
  - Sheets: `.uBottomSheet` (floating, inset from all edges), `USheetAction`,
    `.uDialog`, `.uToast`
  - Progress: `UProgressBar`, `UProgressRing`
- **Semantic token layer**: `UColor` (+ 9 candy tones via `UTone`), `UFont` /
  `UTextStyle` (Onest type ramp, Dynamic Type), `USpacing`, `URadius`, `USize`,
  `UShadow`, `UMotion`. All colors are dynamic — light/dark resolves
  automatically, including subtree scoping via
  `.environment(\.colorScheme, .dark)`.
- **Dark theme**: primary surfaces invert to white, lime replaces coral as the
  accent and selection color.
- **`UltimateGallery`** product: full catalog of every component in every
  variant and state, with a per-page light/dark toggle.
- Bundled Onest variable font (OFL) with automatic registration.
- CI: package build on every push/PR.

### Known limitations

- `UDropdown`'s floating menu can be clipped by a scrolling ancestor.
- `UDropdown` custom triggers should be non-interactive views.

[0.1.0]: https://github.com/devmobileuae/Ultimate/releases/tag/0.1.0
