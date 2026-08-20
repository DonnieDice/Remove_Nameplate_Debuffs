# RemoveNameplateDebuffs

RemoveNameplateDebuffs hides debuff and aura widgets on enemy nameplates. The single `RemoveNameplateDebuffs.toc` supports Classic Era (`11509`), Burning Crusade Classic (`20506`), Mists of Pandaria Classic (`50504`), and Retail (`120007`), and requires `RGX-Framework`.

## Layout And Runtime

- The TOC loads `data/locales.lua` before `data/core.lua`; preserve that order.
- `data/core.lua` owns settings, nameplate filtering, RGX events/timers, minimap integration, and `/rnd` commands.
- `media/` contains branding assets; `docs/CHANGES.md` and `docs/changelogs/` contain release notes.

## Development Rules

- Use the existing RGX event, timer, minimap, and slash-command APIs. Do not add parallel lifecycle plumbing.
- Preserve defensive checks around forbidden or missing nameplate frames and restore hidden widgets when the addon is disabled.
- Keep localization fallbacks and SavedVariables compatibility intact.
- Keep `RemoveNameplateDebuffs.toc` and `ADDON_VERSION` in `data/core.lua` synchronized when changing versions.

## Testing And Release

- There is no build step or automated test suite. Install the addon and `RGX-Framework` in each supported client flavor being changed. Verify `/rnd help`, `/rnd test`, enable/disable, settings persistence, minimap behavior, nameplate add/aura updates, and compatibility with available nameplate replacements.
- Stable releases use `vX.Y.Z` tags. `.github/workflows/release.yml` validates the tag against the TOC version and packages with BigWigsMods/packager; pushes to `dev` and `alpha` use those release channels. Update `docs/CHANGES.md` and the matching `docs/changelogs/<version>.md` entry for a release.
