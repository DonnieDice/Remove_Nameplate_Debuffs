# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RND (Remove Nameplate Debuffs) is a professional World of Warcraft addon that removes debuff icons from enemy nameplates for a cleaner interface. As of v3.0.0, it features a simplified command structure, persistent settings, multi-language support, and extensive error handling as part of the RGX Mods collection.

## Project Structure

- **data/core.lua**: Main addon functionality with advanced features
- **data/locales.lua**: Multi-language support (English, Russian, German, French, Spanish)
- **Images/icon.tga**: Addon icon displayed in all output
- **Remove_Nameplate_Debuffs.toc**: TOC file for retail WoW (Interface: 110105)
- **Remove_Nameplate_Debuffs_Cata.toc**: TOC file for Classic Cataclysm (Interface: 40402)
- **Remove_Nameplate_Debuffs_Vanilla.toc**: TOC file for Classic WoW (Interface: 11507)
- **Remove_Nameplate_Debuffs_Mists.toc**: TOC file for Mists of Pandaria (Interface: 50500)

## Commands

Use `/rnd` followed by various commands for full functionality:

- `/rnd help` - Show all available commands
- `/rnd enable/disable` - Control addon state
- `/rnd test` - Test functionality by toggling nameplates
- `/rnd status` - Show current settings

## Settings Architecture

**SavedVariables**: `RNDSettings` automatically managed with fallback defaults

The addon uses an optimized, professional architecture:

1. **Constants Management**: Performance-optimized with cached local constants
2. **Global Namespace**: `RND` table with proper initialization and namespacing
3. **Settings System**: Complete configuration management with type validation
4. **Event System**: Optimized event handling with early returns
5. **Slash Commands**: Complete `/rnd` interface with comprehensive validation
6. **Error Handling**: Enterprise-grade protection with `pcall` protection
7. **Localization**: Multi-language support with automatic locale detection

## RGX Mods Standards

This addon follows RGX Mods community standards with Discord integration and professional error handling.

## Key Features

- **Multi-Version Support**: Four TOC files for all WoW versions
- **Settings Validation**: All user inputs are type-checked and validated
- **Error Resilience**: Addon continues functioning even with errors
- **Performance**: Optimized for minimal memory and CPU usage
- **Maintainability**: Clean, documented code with clear separation of concerns
- **User Experience**: Consistent RGX Mods branding with icons and professional messaging
- **Community Integration**: RealmGX Discord integration throughout the addon

## Development Notes

- Version centralized in `ADDON_VERSION` constant in `core.lua`
- All four TOC files must be updated simultaneously
- Version appears in welcome message and status display
- Settings persist automatically via SavedVariables
- Multi-language support with automatic locale detection
- Professional error handling with pcall protection