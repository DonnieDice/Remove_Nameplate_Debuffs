# v3.3.0 - 2026-04-25

## Changes
- Migrated to RGX-Framework: minimap button now uses `RGXMinimap:Create()` — drag, angle persistence, tooltip, and show/hide handled by the framework.
- Migrated events and periodic timer to `RGX:RegisterEvent()` and `RGX:Every()`.
- Fixed: Minimap tooltip status now updates in real-time after left-clicking to toggle.
- Fixed: Disabling the addon (`/rnd off` or minimap click to disable) now correctly restores all previously hidden nameplate debuff/buff/aura frames. Previously frames stayed hidden permanently until a nameplate was refreshed.
- Added `## RequiredDeps: RGX-Framework` to TOC.
