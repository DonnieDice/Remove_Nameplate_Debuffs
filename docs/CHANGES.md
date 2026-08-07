# v3.3.3 - 2026-08-07

## Changes
- TOC bump: Updated universal interface versions to 11509 (Classic Era), 20506 (TBC Anniversary), 50504 (MoP Classic), 120007 (Retail). Removed Cata (40402) and legacy Retail eras (110207, 120000, 120001).

# v3.3.2 - 2026-06-30

## Changes

- Updated for WoW Retail 12.0.7 (Interface 120007).

# v3.3.1 - 2026-04-29

## Documentation
- Added the v3.3.0 per-release changelog entry.
- Synced addon version metadata for the v3.3.1 documentation release.

# v3.3.0 - 2026-04-25

## Changes
- Migrated to RGX-Framework: minimap button now uses `RGXMinimap:Create()` â€” drag, angle persistence, tooltip, and show/hide handled by the framework.
- Migrated events and periodic timer to `RGX:RegisterEvent()` and `RGX:Every()`.
- Fixed: Minimap tooltip status now updates in real-time after left-clicking to toggle.
- Fixed: Disabling the addon (`/rnd off` or minimap click to disable) now correctly restores all previously hidden nameplate debuff/buff/aura frames. Previously frames stayed hidden permanently until a nameplate was refreshed.
- Added `## RequiredDeps: RGX-Framework` to TOC.
