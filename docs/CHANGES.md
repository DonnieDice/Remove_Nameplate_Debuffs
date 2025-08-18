## v3.1.2 - GameTooltip Fix & Welcome Message Toggle

- Fixed - GameTooltip hook issue by changing from invalid OnTooltipSetUnit to OnShow handler [core.lua]
- Added - Ability to toggle welcome message with /rnd welcome on/off commands [core.lua]
- Added - Localization strings for welcome message toggle in all supported languages [locales.lua]
- Updated - Help command now shows welcome message toggle options [core.lua]
- Updated - Status command now displays welcome message setting [core.lua]

## v3.0.0 - Major Overhaul & RGX Mods Integration

- Added - Complete code rewrite with professional architecture [core.lua]
- Added - Multi-language localization system (English, Russian, German, French, Spanish) [locales.lua]
- Added - Russian localization by ZamestoTV (Hubbotu) [locales.lua]
- Added - Support for all WoW versions (BCC, Wrath, MoP) [new TOC files]
- Added - CLAUDE.md documentation for AI assistance [CLAUDE.md]
- Added - SavedVariables system for persistent settings [RNDSettings]
- Updated - Simplified command structure (/rnd on, off, test, status) [core.lua]
- Updated - Complete RGX Mods branding and community integration [README.md]
- Updated - Professional error handling with pcall protection [core.lua]
- Updated - Performance optimizations throughout codebase [core.lua]
- Updated - All TOC files with consistent formatting and metadata [All TOC files]
- Fixed - Forbidden nameplate handling with proper error suppression [core.lua]
- Fixed - Initialization timing issues with proper event ordering [core.lua]
- Fixed - Memory efficiency through cached constants [core.lua]
- Removed - Legacy code and unnecessary complexity [core.lua]

## v2.1.4 - Previous Release

- Updated - TOC version bump for Retail, Vanilla, and Cata [Remove_Nameplate_Debuffs.toc, Remove_Nameplate_Debuffs_Vanilla.toc, Remove_Nameplate_Debuffs_Cata.toc]
- Updated - Email address updated in TOC files for Retail, Vanilla, and Cata [Remove_Nameplate_Debuffs.toc, Remove_Nameplate_Debuffs_Vanilla.toc, Remove_Nameplate_Debuffs_Cata.toc]