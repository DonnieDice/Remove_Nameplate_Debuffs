--=====================================================================================
-- RND | Remove Nameplate Debuffs - core.lua
-- Version: 3.0.0
-- Author: DonnieDice
-- Description: Professional World of Warcraft addon that removes debuff icons from nameplates
-- RGX Mods Collection - RealmGX Community Project
--=====================================================================================

-- Global addon namespace and version info
RND = RND or {}

-- Constants (cached for performance)
local ADDON_VERSION = "3.1.0"
local ADDON_NAME = "Remove_Nameplate_Debuffs"
local ICON_PATH = "|Tinterface/addons/Remove_Nameplate_Debuffs/images/icon:16:16|t"

-- Set addon properties
RND.version = ADDON_VERSION
RND.addonName = ADDON_NAME

-- Default configuration
RND.defaults = {
    enabled = true,
    showWelcome = true,
    firstRun = true
}

-- Saved variables will be loaded by WoW after ADDON_LOADED event
-- Do not initialize here as it will override saved settings

-- Initialize addon settings
function RND:InitializeSettings()
    -- Ensure SavedVariables table exists
    RNDSettings = RNDSettings or {}
    
    -- Set defaults for any missing values
    for key, value in pairs(self.defaults) do
        if RNDSettings[key] == nil then
            RNDSettings[key] = value
        end
    end
end

-- Get current settings with fallback to defaults (with type validation)
function RND:GetSetting(key)
    if not key or type(key) ~= "string" then
        return nil
    end
    
    -- Return default if SavedVariables not loaded yet
    if not RNDSettings then
        return self.defaults[key]
    end
    
    local value = RNDSettings[key]
    if value ~= nil then
        return value
    end
    
    return self.defaults[key]
end

-- Set a setting value (with validation)
function RND:SetSetting(key, value)
    if not key or type(key) ~= "string" or self.defaults[key] == nil then
        return false
    end
    
    -- Ensure SavedVariables table exists
    if not RNDSettings then
        RNDSettings = {}
    end
    
    -- Type validation based on default values
    local defaultType = type(self.defaults[key])
    if type(value) ~= defaultType then
        return false
    end
    
    RNDSettings[key] = value
    return true
end

-- Hide debuffs on a specific nameplate
function RND:HideNameplateDebuffs(unitId)
    if not self:GetSetting("enabled") then
        return
    end
    
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitId)
    
    -- Ensure nameplate and UnitFrame are valid and not forbidden
    if not nameplate or not nameplate.UnitFrame then
        return
    end
    
    -- Use pcall to handle forbidden nameplates gracefully
    local success, err = pcall(function()
        if nameplate.UnitFrame:IsForbidden() then
            return
        end
        
        local unitFrame = nameplate.UnitFrame
        
        -- Standard Blizzard BuffFrame
        if unitFrame.BuffFrame then
            unitFrame.BuffFrame:ClearAllPoints()
            unitFrame.BuffFrame:SetAlpha(0)
            unitFrame.BuffFrame:Hide()
        end
        
        -- Plater compatibility
        if unitFrame.ExtraIconFrame then
            unitFrame.ExtraIconFrame:SetAlpha(0)
            unitFrame.ExtraIconFrame:Hide()
        end
        
        -- TidyPlates/Threat Plates compatibility
        if unitFrame.AuraWidget then
            unitFrame.AuraWidget:SetAlpha(0)
            unitFrame.AuraWidget:Hide()
        end
        
        -- KuiNameplates compatibility
        if unitFrame.Auras then
            unitFrame.Auras:SetAlpha(0)
            unitFrame.Auras:Hide()
        end
        
        -- ElvUI compatibility
        if unitFrame.Debuffs then
            unitFrame.Debuffs:SetAlpha(0)
            unitFrame.Debuffs:Hide()
        end
        if unitFrame.Buffs then
            unitFrame.Buffs:SetAlpha(0)
            unitFrame.Buffs:Hide()
        end
        
        -- NeatPlates compatibility
        if unitFrame.AuraIconRegion then
            unitFrame.AuraIconRegion:SetAlpha(0)
            unitFrame.AuraIconRegion:Hide()
        end
        
        -- Additional generic frames that might contain debuffs
        if unitFrame.auras then
            unitFrame.auras:SetAlpha(0)
            unitFrame.auras:Hide()
        end
        
        -- Check for any frame with "debuff" or "buff" in the name (case insensitive)
        for key, frame in pairs(unitFrame) do
            if type(key) == "string" and type(frame) == "table" then
                local lowerKey = string.lower(key)
                if (string.find(lowerKey, "debuff") or string.find(lowerKey, "buff") or string.find(lowerKey, "aura")) then
                    if frame.SetAlpha then
                        frame:SetAlpha(0)
                    end
                    if frame.Hide then
                        frame:Hide()
                    end
                end
            end
        end
    end)
    
    if not success and self.L then
        -- Silent fail - nameplates can be forbidden in certain situations
    end
end

-- Test functionality by toggling nameplates
function RND:TestFunctionality()
    if not self.L then
        print(ICON_PATH .. " |cffff0000RND Error:|r Localization not loaded")
        return
    end
    
    print(ICON_PATH .. " |cffff7d00RND:|r " .. self.L["TEST_TOGGLING"])
    
    -- Toggle nameplates off and on to force refresh
    SetCVar("nameplateShowEnemies", 0)
    C_Timer.After(0.5, function()
        SetCVar("nameplateShowEnemies", 1)
        print(ICON_PATH .. " |cffff7d00RND:|r " .. self.L["TEST_COMPLETE"])
    end)
end

-- Display welcome message on player login
function RND:DisplayWelcomeMessage()
    if not self:GetSetting("showWelcome") then
        return
    end
    
    -- Ensure localization exists
    if not self.L then
        print(ICON_PATH .. " |cffff0000RND Error:|r Localization not loaded")
        return
    end
    
    -- Cached strings for performance
    local title = "[|cffff7d00R|r|cffffffffemove|r |cffff7d00N|r|cffffffffameplate|r |cffff7d00D|r|cffffffffebuffs|r]"
    local version = "|cff8080ff(v" .. ADDON_VERSION .. ")|r"
    local rgxMods = "|cffff7d00RGX Mods|r"
    local status = self:GetSetting("enabled") and self.L["ENABLED_STATUS"] or self.L["DISABLED_STATUS"]
    
    print(ICON_PATH .. " - " .. title .. " " .. status .. " " .. version .. " - " .. rgxMods)
    
    -- Show community message on first run
    if self:GetSetting("firstRun") then
        print(ICON_PATH .. " " .. self.L["COMMUNITY_MESSAGE"])
        self:SetSetting("firstRun", false)
    end
    
    print(ICON_PATH .. " " .. self.L["TYPE_HELP"])
end

-- Slash command handler
function RND:HandleSlashCommand(args)
    -- Ensure localization exists
    if not self.L then
        print(ICON_PATH .. " |cffff0000RND Error:|r Localization not loaded")
        return
    end
    
    -- Use cached icon path
    local iconPrefix = ICON_PATH
    
    local command = string.lower(args or "")
    
    if command == "" or command == "help" then
        self:ShowHelp()
    elseif command == "on" or command == "enable" then
        self:SetSetting("enabled", true)
        print(iconPrefix .. " |cffff7d00RND:|r " .. self.L["ADDON_ENABLED"])
    elseif command == "off" or command == "disable" then
        self:SetSetting("enabled", false)
        print(iconPrefix .. " |cffff7d00RND:|r " .. self.L["ADDON_DISABLED"])
    elseif command == "test" then
        self:TestFunctionality()
    elseif command == "status" then
        self:ShowStatus()
    else
        print(iconPrefix .. " " .. self.L["ERROR_PREFIX"] .. " " .. self.L["ERROR_UNKNOWN_COMMAND"])
    end
end

-- Show help information
function RND:ShowHelp()
    -- Ensure localization exists
    if not self.L then
        print(ICON_PATH .. " |cffff0000RND Error:|r Localization not loaded")
        return
    end
    
    local iconPrefix = ICON_PATH
    print(iconPrefix .. " " .. self.L["HELP_HEADER"])
    print(iconPrefix .. " " .. self.L["HELP_TEST"])
    print(iconPrefix .. " |cffffffff/rnd on|r - Enable addon")
    print(iconPrefix .. " |cffffffff/rnd off|r - Disable addon")
    print(iconPrefix .. " " .. self.L["HELP_STATUS"])
end

-- Show current status
function RND:ShowStatus()
    -- Ensure localization exists
    if not self.L then
        print(ICON_PATH .. " |cffff0000RND Error:|r Localization not loaded")
        return
    end
    
    local iconPrefix = ICON_PATH
    print(iconPrefix .. " " .. self.L["STATUS_HEADER"])
    print(iconPrefix .. " " .. self.L["STATUS_STATUS"] .. " " .. 
        (self:GetSetting("enabled") and self.L["ENABLED_STATUS"] or self.L["DISABLED_STATUS"]))
    print(iconPrefix .. " " .. string.format(self.L["STATUS_VERSION"], ADDON_VERSION))
end

-- Track initialization state
RND.initialized = false

-- Event handler function (optimized with early returns)
function RND:OnEvent(event, ...)
    if event == "NAME_PLATE_UNIT_ADDED" then
        -- Only process if addon is fully initialized and enabled
        if self.initialized and self:GetSetting("enabled") then
            local unitId = ...
            self:HideNameplateDebuffs(unitId)
        end
        return
    end
    
    if event == "NAME_PLATE_UNIT_REMOVED" then
        -- Could be used for cleanup if needed
        return
    end
    
    if event == "UNIT_AURA" then
        -- Handle aura updates to re-hide debuffs when they're added
        if self.initialized and self:GetSetting("enabled") then
            local unitId = ...
            if unitId and string.match(unitId, "nameplate") then
                self:HideNameplateDebuffs(unitId)
            end
        end
        return
    end
    
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == ADDON_NAME then
            self:InitializeSettings()
            self.initialized = true
        end
        return
    end
    
    if event == "PLAYER_LOGIN" then
        -- Ensure we're initialized before showing welcome
        if not self.initialized then
            self:InitializeSettings()
            self.initialized = true
        end
        self:DisplayWelcomeMessage()
    end
end

-- Register slash commands with error handling
SLASH_RND1 = "/rnd"
SlashCmdList["RND"] = function(args)
    local success, errorMsg = pcall(RND.HandleSlashCommand, RND, args)
    if not success then
        print(ICON_PATH .. " |cffff0000RND Error:|r " .. tostring(errorMsg))
    end
end

-- Event frame setup with error handling
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
eventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
eventFrame:RegisterEvent("UNIT_AURA")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    local success, errorMsg = pcall(RND.OnEvent, RND, event, ...)
    if not success then
        print(ICON_PATH .. " |cffff0000RND Error:|r Event handler failed: " .. tostring(errorMsg))
    end
end)

-- Add a periodic update to continuously enforce debuff removal
-- This handles addons that recreate their frames dynamically
local updateTimer = 0
eventFrame:SetScript("OnUpdate", function(self, elapsed)
    updateTimer = updateTimer + elapsed
    if updateTimer > 0.5 then -- Check every 0.5 seconds
        updateTimer = 0
        if RND.initialized and RND:GetSetting("enabled") then
            -- Refresh all visible nameplates
            for _, nameplate in pairs(C_NamePlate.GetNamePlates()) do
                if nameplate and nameplate.UnitFrame then
                    local unitId = nameplate.UnitFrame.unit
                    if unitId then
                        RND:HideNameplateDebuffs(unitId)
                    end
                end
            end
        end
    end
end)