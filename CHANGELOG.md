# Changelog

All notable changes to Ultimate are documented here. Versions follow
[Semantic Versioning](https://semver.org).

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
