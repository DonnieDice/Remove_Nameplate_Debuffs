--=====================================================================================
-- RND | Remove Nameplate Debuffs - locales.lua
-- Version: 3.0.0
-- Author: DonnieDice
-- Description: Multi-language localization system for RND
--=====================================================================================

-- Ensure global addon namespace exists
RND = RND or {}

-- Initialize localization table
RND.L = RND.L or {}

-- Get current WoW client locale
local locale = GetLocale()

-- Default English strings (always loaded as fallback)
local L = {
    -- Status Messages
    ["ADDON_ENABLED"] = "Addon |cff00ff00enabled|r",
    ["ADDON_DISABLED"] = "Addon |cffff0000disabled|r",
    ["DEBUFFS_HIDDEN"] = "Nameplate debuffs are now |cffff0000hidden|r",
    ["DEBUFFS_SHOWN"] = "Nameplate debuffs are now |cff00ff00visible|r",
    ["WELCOME_MESSAGE"] = "Welcome to RND! Type |cffffffff/rnd help|r for commands",
    
    -- Error Messages
    ["ERROR_PREFIX"] = "|cffff0000RND Error:|r",
    ["ERROR_UNKNOWN_COMMAND"] = "Unknown command. Type |cffffffff/rnd help|r for available commands",
    ["ERROR_NAMEPLATE_FORBIDDEN"] = "Cannot modify nameplate (forbidden by Blizzard)",
    
    -- Help System
    ["HELP_HEADER"] = "|cffff7d00=== RND Commands ===|r",
    ["HELP_TEST"] = "|cffffffff/rnd test|r - Toggle nameplates to test",
    ["HELP_ENABLE"] = "|cffffffff/rnd enable|r - Enable addon",
    ["HELP_DISABLE"] = "|cffffffff/rnd disable|r - Disable addon",
    ["HELP_STATUS"] = "|cffffffff/rnd status|r - Show current settings",
    
    -- Status Display
    ["STATUS_HEADER"] = "|cffff7d00=== RND Status ===|r",
    ["STATUS_STATUS"] = "Status:",
    ["STATUS_VERSION"] = "Version: |cffffffff%s|r",
    
    -- General Status
    ["ENABLED_STATUS"] = "|cff00ff00Enabled|r",
    ["DISABLED_STATUS"] = "|cffff0000Disabled|r",
    ["TYPE_HELP"] = "Type |cffffffff/rnd help|r for commands",
    
    -- Test Messages
    ["TEST_TOGGLING"] = "Toggling nameplates for testing...",
    ["TEST_COMPLETE"] = "Test complete! Debuffs should be hidden on enemy nameplates",
    
    -- RGX Mods Branding
    ["RGX_MODS_PREFIX"] = "|cffff7d00RGX Mods|r",
    ["COMMUNITY_MESSAGE"] = "Part of the RealmGX Community - join us at discord.gg/N7kdKAHVVF",
    
    -- Welcome Message Settings
    ["WELCOME_ENABLED"] = "Welcome message |cff00ff00enabled|r",
    ["WELCOME_DISABLED"] = "Welcome message |cffff0000disabled|r",
    ["HELP_WELCOME_ON"] = "Enable welcome message on login",
    ["HELP_WELCOME_OFF"] = "Disable welcome message on login",
    ["STATUS_WELCOME"] = "Welcome message:"
}

-- Russian localization by ZamestoTV (Hubbotu)
if locale == "ruRU" then
    L["ADDON_ENABLED"] = "Аддон |cff00ff00включен|r"
    L["ADDON_DISABLED"] = "Аддон |cffff0000отключен|r"
    L["DEBUFFS_HIDDEN"] = "Дебаффы на индикаторах здоровья теперь |cffff0000скрыты|r"
    L["DEBUFFS_SHOWN"] = "Дебаффы на индикаторах здоровья теперь |cff00ff00видны|r"
    L["WELCOME_MESSAGE"] = "Добро пожаловать в RND! Введите |cffffffff/rnd help|r для команд"
    
    L["ERROR_PREFIX"] = "|cffff0000Ошибка RND:|r"
    L["ERROR_UNKNOWN_COMMAND"] = "Неизвестная команда. Введите |cffffffff/rnd help|r для доступных команд"
    L["ERROR_NAMEPLATE_FORBIDDEN"] = "Невозможно изменить индикатор здоровья (запрещено Blizzard)"
    
    L["HELP_HEADER"] = "|cffff7d00=== Команды RND ===|r"
    L["HELP_TEST"] = "|cffffffff/rnd test|r - Переключить индикаторы для теста"
    L["HELP_ENABLE"] = "|cffffffff/rnd enable|r - Включить аддон"
    L["HELP_DISABLE"] = "|cffffffff/rnd disable|r - Отключить аддон"
    L["HELP_STATUS"] = "|cffffffff/rnd status|r - Показать текущие настройки"
    
    L["STATUS_HEADER"] = "|cffff7d00=== Статус RND ===|r"
    L["STATUS_STATUS"] = "Статус:"
    L["STATUS_VERSION"] = "Версия: |cffffffff%s|r"
    
    L["ENABLED_STATUS"] = "|cff00ff00Включен|r"
    L["DISABLED_STATUS"] = "|cffff0000Отключен|r"
    L["TYPE_HELP"] = "Введите |cffffffff/rnd help|r для команд"
    
    L["TEST_TOGGLING"] = "Переключение индикаторов для тестирования..."
    L["TEST_COMPLETE"] = "Тест завершен! Дебаффы должны быть скрыты на вражеских индикаторах"
    
    L["COMMUNITY_MESSAGE"] = "Часть сообщества RealmGX - присоединяйтесь к нам на discord.gg/N7kdKAHVVF"
    
    L["WELCOME_ENABLED"] = "Приветственное сообщение |cff00ff00включено|r"
    L["WELCOME_DISABLED"] = "Приветственное сообщение |cffff0000отключено|r"
    L["HELP_WELCOME_ON"] = "Включить приветственное сообщение при входе"
    L["HELP_WELCOME_OFF"] = "Отключить приветственное сообщение при входе"
    L["STATUS_WELCOME"] = "Приветственное сообщение:"

-- German localization
elseif locale == "deDE" then
    L["ADDON_ENABLED"] = "Addon |cff00ff00aktiviert|r"
    L["ADDON_DISABLED"] = "Addon |cffff0000deaktiviert|r"
    L["DEBUFFS_HIDDEN"] = "Namensplaketten-Debuffs sind jetzt |cffff0000verborgen|r"
    L["DEBUFFS_SHOWN"] = "Namensplaketten-Debuffs sind jetzt |cff00ff00sichtbar|r"
    L["WELCOME_MESSAGE"] = "Willkommen bei RND! Tippe |cffffffff/rnd help|r für Befehle"
    
    L["ERROR_PREFIX"] = "|cffff0000RND Fehler:|r"
    L["ERROR_UNKNOWN_COMMAND"] = "Unbekannter Befehl. Tippe |cffffffff/rnd help|r für verfügbare Befehle"
    L["ERROR_NAMEPLATE_FORBIDDEN"] = "Kann Namensplakette nicht ändern (von Blizzard verboten)"
    
    L["HELP_HEADER"] = "|cffff7d00=== RND Befehle ===|r"
    L["HELP_TEST"] = "|cffffffff/rnd test|r - Namensplaketten zum Testen umschalten"
    L["HELP_ENABLE"] = "|cffffffff/rnd enable|r - Addon aktivieren"
    L["HELP_DISABLE"] = "|cffffffff/rnd disable|r - Addon deaktivieren"
    L["HELP_STATUS"] = "|cffffffff/rnd status|r - Aktuelle Einstellungen anzeigen"
    
    L["STATUS_HEADER"] = "|cffff7d00=== RND Status ===|r"
    L["STATUS_STATUS"] = "Status:"
    L["STATUS_VERSION"] = "Version: |cffffffff%s|r"
    
    L["ENABLED_STATUS"] = "|cff00ff00Aktiviert|r"
    L["DISABLED_STATUS"] = "|cffff0000Deaktiviert|r"
    L["TYPE_HELP"] = "Tippe |cffffffff/rnd help|r für Befehle"
    
    L["TEST_TOGGLING"] = "Schalte Namensplaketten zum Testen um..."
    L["TEST_COMPLETE"] = "Test abgeschlossen! Debuffs sollten auf feindlichen Namensplaketten verborgen sein"
    
    L["COMMUNITY_MESSAGE"] = "Teil der RealmGX Community - tritt uns bei: discord.gg/N7kdKAHVVF"
    
    L["WELCOME_ENABLED"] = "Willkommensnachricht |cff00ff00aktiviert|r"
    L["WELCOME_DISABLED"] = "Willkommensnachricht |cffff0000deaktiviert|r"
    L["HELP_WELCOME_ON"] = "Willkommensnachricht beim Login aktivieren"
    L["HELP_WELCOME_OFF"] = "Willkommensnachricht beim Login deaktivieren"
    L["STATUS_WELCOME"] = "Willkommensnachricht:"

-- French localization
elseif locale == "frFR" then
    L["ADDON_ENABLED"] = "Addon |cff00ff00activé|r"
    L["ADDON_DISABLED"] = "Addon |cffff0000désactivé|r"
    L["DEBUFFS_HIDDEN"] = "Les débuffs des barres de nom sont maintenant |cffff0000cachés|r"
    L["DEBUFFS_SHOWN"] = "Les débuffs des barres de nom sont maintenant |cff00ff00visibles|r"
    L["WELCOME_MESSAGE"] = "Bienvenue dans RND ! Tapez |cffffffff/rnd help|r pour les commandes"
    
    L["ERROR_PREFIX"] = "|cffff0000Erreur RND:|r"
    L["ERROR_UNKNOWN_COMMAND"] = "Commande inconnue. Tapez |cffffffff/rnd help|r pour les commandes disponibles"
    L["ERROR_NAMEPLATE_FORBIDDEN"] = "Impossible de modifier la barre de nom (interdit par Blizzard)"
    
    L["HELP_HEADER"] = "|cffff7d00=== Commandes RND ===|r"
    L["HELP_TEST"] = "|cffffffff/rnd test|r - Basculer les barres de nom pour tester"
    L["HELP_ENABLE"] = "|cffffffff/rnd enable|r - Activer l'addon"
    L["HELP_DISABLE"] = "|cffffffff/rnd disable|r - Désactiver l'addon"
    L["HELP_STATUS"] = "|cffffffff/rnd status|r - Afficher les paramètres actuels"
    
    L["STATUS_HEADER"] = "|cffff7d00=== Statut RND ===|r"
    L["STATUS_STATUS"] = "Statut :"
    L["STATUS_VERSION"] = "Version : |cffffffff%s|r"
    
    L["ENABLED_STATUS"] = "|cff00ff00Activé|r"
    L["DISABLED_STATUS"] = "|cffff0000Désactivé|r"
    L["TYPE_HELP"] = "Tapez |cffffffff/rnd help|r pour les commandes"
    
    L["TEST_TOGGLING"] = "Basculement des barres de nom pour le test..."
    L["TEST_COMPLETE"] = "Test terminé ! Les débuffs devraient être cachés sur les barres de nom ennemies"
    
    L["COMMUNITY_MESSAGE"] = "Partie de la communauté RealmGX - rejoignez-nous sur discord.gg/N7kdKAHVVF"
    
    L["WELCOME_ENABLED"] = "Message de bienvenue |cff00ff00activé|r"
    L["WELCOME_DISABLED"] = "Message de bienvenue |cffff0000désactivé|r"
    L["HELP_WELCOME_ON"] = "Activer le message de bienvenue à la connexion"
    L["HELP_WELCOME_OFF"] = "Désactiver le message de bienvenue à la connexion"
    L["STATUS_WELCOME"] = "Message de bienvenue :"

-- Spanish localization
elseif locale == "esES" or locale == "esMX" then
    L["ADDON_ENABLED"] = "Addon |cff00ff00habilitado|r"
    L["ADDON_DISABLED"] = "Addon |cffff0000deshabilitado|r"
    L["DEBUFFS_HIDDEN"] = "Los debuffs de placas de nombre ahora están |cffff0000ocultos|r"
    L["DEBUFFS_SHOWN"] = "Los debuffs de placas de nombre ahora están |cff00ff00visibles|r"
    L["WELCOME_MESSAGE"] = "¡Bienvenido a RND! Escribe |cffffffff/rnd help|r para comandos"
    
    L["ERROR_PREFIX"] = "|cffff0000Error RND:|r"
    L["ERROR_UNKNOWN_COMMAND"] = "Comando desconocido. Escribe |cffffffff/rnd help|r para comandos disponibles"
    L["ERROR_NAMEPLATE_FORBIDDEN"] = "No se puede modificar la placa de nombre (prohibido por Blizzard)"
    
    L["HELP_HEADER"] = "|cffff7d00=== Comandos RND ===|r"
    L["HELP_TEST"] = "|cffffffff/rnd test|r - Alternar placas de nombre para probar"
    L["HELP_ENABLE"] = "|cffffffff/rnd enable|r - Habilitar el addon"
    L["HELP_DISABLE"] = "|cffffffff/rnd disable|r - Deshabilitar el addon"
    L["HELP_STATUS"] = "|cffffffff/rnd status|r - Mostrar configuración actual"
    
    L["STATUS_HEADER"] = "|cffff7d00=== Estado RND ===|r"
    L["STATUS_STATUS"] = "Estado:"
    L["STATUS_VERSION"] = "Versión: |cffffffff%s|r"
    
    L["ENABLED_STATUS"] = "|cff00ff00Habilitado|r"
    L["DISABLED_STATUS"] = "|cffff0000Deshabilitado|r"
    L["TYPE_HELP"] = "Escribe |cffffffff/rnd help|r para comandos"
    
    L["TEST_TOGGLING"] = "Alternando placas de nombre para prueba..."
    L["TEST_COMPLETE"] = "¡Prueba completa! Los debuffs deberían estar ocultos en las placas de nombre enemigas"
    
    L["COMMUNITY_MESSAGE"] = "Parte de la comunidad RealmGX - únete a nosotros en discord.gg/N7kdKAHVVF"
    
    L["WELCOME_ENABLED"] = "Mensaje de bienvenida |cff00ff00habilitado|r"
    L["WELCOME_DISABLED"] = "Mensaje de bienvenida |cffff0000deshabilitado|r"
    L["HELP_WELCOME_ON"] = "Habilitar mensaje de bienvenida al iniciar sesión"
    L["HELP_WELCOME_OFF"] = "Deshabilitar mensaje de bienvenida al iniciar sesión"
    L["STATUS_WELCOME"] = "Mensaje de bienvenida:"
end

-- Assign localization table to global addon namespace
RND.L = L

-- Provide fallback function for missing translations
function RND:GetLocalizedString(key)
    if self.L and self.L[key] then
        return self.L[key]
    end
    
    -- Return the key itself if no translation found (for debugging)
    return key
end