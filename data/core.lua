--=====================================================================================
-- RND | Remove Nameplate Debuffs! - core.lua
-- Version: 3.3.0
-- Author: DonnieDice
-- Description: Professional World of Warcraft addon that removes debuff icons from nameplates
-- RGX Mods Collection - RealmGX Community Project
--=====================================================================================

-- Global addon namespace and version info
RND = RND or {}

-- Constants (cached for performance)
local ADDON_VERSION = "3.3.0"
local ADDON_NAME = "RemoveNameplateDebuffs"
local ICON_PATH = "|Tinterface/addons/RemoveNameplateDebuffs/media/icon:16:16|t"
local MINIMAP_ICON_TEXTURE = "Interface\\AddOns\\RemoveNameplateDebuffs\\media\\icon"

-- Chat prefix with orange R, N, D in [RND]
local CHAT_PREFIX = ICON_PATH .. " - |cffffffff[|r|cffff7d00RND|r|cffffffff]|r"

local RGX = assert(_G.RGXFramework, "RND: RGX-Framework not loaded")
local MM  = RGX:GetMinimap()

-- Set addon properties
RND.version = ADDON_VERSION
RND.addonName = ADDON_NAME

-- Default configuration
RND.defaults = {
    enabled = true,
    showWelcome = true,
    firstRun = true,
    minimapIconEnabled = true,
    minimapAngle = 220
}

-- Minimap button state
RND.minimapButton = nil
RND.defaultMinimapAngle = 220

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

-- Restore debuffs on a specific nameplate (inverse of HideNameplateDebuffs)
function RND:RestoreNameplateDebuffs(unitId)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitId)
    if not nameplate or not nameplate.UnitFrame then return end
    pcall(function()
        if nameplate.UnitFrame:IsForbidden() then return end
        local unitFrame = nameplate.UnitFrame
        local frames = {
            unitFrame.BuffFrame, unitFrame.ExtraIconFrame, unitFrame.AuraWidget,
            unitFrame.Auras, unitFrame.Debuffs, unitFrame.Buffs, unitFrame.AuraIconRegion,
            unitFrame.auras,
        }
        for _, frame in ipairs(frames) do
            if frame then
                frame:SetAlpha(1)
                frame:Show()
            end
        end
        for key, frame in pairs(unitFrame) do
            if type(key) == "string" and type(frame) == "table" then
                local lowerKey = string.lower(key)
                if string.find(lowerKey, "debuff") or string.find(lowerKey, "buff") or string.find(lowerKey, "aura") then
                    if frame.SetAlpha then frame:SetAlpha(1) end
                    if frame.Show then frame:Show() end
                end
            end
        end
    end)
end

-- Restore debuffs on all currently visible nameplates
function RND:RestoreAllNameplateDebuffs()
    for _, nameplate in pairs(C_NamePlate.GetNamePlates()) do
        if nameplate and nameplate.UnitFrame then
            local unitId = nameplate.UnitFrame.unit
            if unitId then self:RestoreNameplateDebuffs(unitId) end
        end
    end
end

-- Test functionality by toggling nameplates
function RND:TestFunctionality()
	if not self.L then
		print(CHAT_PREFIX .. " |cffff0000Error:|r Localization not loaded")
		return
	end

	print(CHAT_PREFIX .. " " .. self.L["TEST_TOGGLING"])

	-- Toggle nameplates off and on to force refresh
	SetCVar("nameplateShowEnemies", 0)
	RGX:After(0.5, function()
		SetCVar("nameplateShowEnemies", 1)
		print(CHAT_PREFIX .. " " .. self.L["TEST_COMPLETE"])
	end)
end

-- Display welcome message on player login
function RND:DisplayWelcomeMessage()
	if not self:GetSetting("showWelcome") then
		return
	end

	-- Ensure localization exists
	if not self.L then
		print(CHAT_PREFIX .. " |cffff0000Error:|r Localization not loaded")
		return
	end

	-- Welcome messages matching RGX Mods standard (same format as BLU)
	print(CHAT_PREFIX .. " Welcome. " .. self.L["TYPE_HELP"])
	print(CHAT_PREFIX .. " |cffffff00Version:|r |cff8080ff" .. ADDON_VERSION .. "|r")

	-- Show community message on first run
	if self:GetSetting("firstRun") then
		print(CHAT_PREFIX .. " " .. self.L["COMMUNITY_MESSAGE"])
		self:SetSetting("firstRun", false)
	end
end

-- =====================================================================================
-- Minimap Button
-- =====================================================================================

function RND:CreateMinimapButton()
    if self.minimapButton then return end
    self.minimapButton = MM:Create({
        name         = "RND_MinimapButton",
        icon         = MINIMAP_ICON_TEXTURE,
        defaultAngle = self.defaultMinimapAngle,
        storage      = RNDSettings,
        angleKey     = "minimapAngle",
        enabledKey   = "minimapIconEnabled",
        tooltip = {
            title    = "|cffff7d00R|r|cffffffffemove|r |cffff7d00N|r|cffffffffameplate|r |cffff7d00D|r|cffffffffebuffs|r|cffff7d00!|r",
            getLines = function()
                local enabled = RND:GetSetting("enabled")
                return {
                    { left = "|cffffffffStatus|r",           right = enabled and "|cff00ff00Enabled|r" or "|cffff0000Disabled|r" },
                    { left = "|cffff7d00Left-Click|r",       right = "|cffffffffToggle debuff removal|r" },
                    { left = "|cff4ecdc4Left-Drag|r",        right = "|cffffffffMove around minimap|r" },
                    { left = "|cffe74c3cCtrl+Right-Click|r", right = "|cffffffffHide minimap icon|r" },
                }
            end,
        },
        onLeftClick = function() RND:HandleMinimapClick() end,
        onCtrlRight = function(btn)
            btn:SetVisible(false)
            if RND.L then
                print(CHAT_PREFIX .. " " .. (RND.L["MINIMAP_ICON_HIDDEN"] or "Minimap icon |cffff0000hidden|r. Use |cffffffff/rnd icon on|r to show it again."))
            end
        end,
    })
end

function RND:HandleMinimapClick()
	local current = self:GetSetting("enabled")
	self:SetSetting("enabled", not current)
	if current then
		self:RestoreAllNameplateDebuffs()
	end
	if self.L then
		local msg = (not current) and self.L["ADDON_ENABLED"] or self.L["ADDON_DISABLED"]
		print(CHAT_PREFIX .. " " .. msg)
	end
	if self.minimapButton then
		local frame = self.minimapButton.frame
		if GameTooltip:IsShown() and GameTooltip:GetOwner() == frame then
			frame:GetScript("OnEnter")()
		end
	end
end

function RND:ToggleMinimapIcon(show)
	if not self.minimapButton and show then
		self:CreateMinimapButton()
	end
	if self.minimapButton then
		self.minimapButton:SetVisible(show and true or false)
	end
	if self.L then
		if show then
			print(CHAT_PREFIX .. " " .. (self.L["MINIMAP_ICON_SHOWN"] or "Minimap icon |cff00ff00shown|r"))
		else
			print(CHAT_PREFIX .. " " .. (self.L["MINIMAP_ICON_HIDDEN"] or "Minimap icon |cffff0000hidden|r. Use |cffffffff/rnd icon on|r to show it again."))
		end
	end
end

function RND:ApplyMinimapVisibility()
    local shouldShow = self:GetSetting("minimapIconEnabled")
    if shouldShow and not self.minimapButton then
        self:CreateMinimapButton()
    end
    if self.minimapButton then
        self.minimapButton:SetVisible(shouldShow and true or false)
    end
end

-- Slash command handler
function RND:HandleSlashCommand(args)
	-- Ensure localization exists
	if not self.L then
		print(CHAT_PREFIX .. " |cffff0000Error:|r Localization not loaded")
		return
	end

	local command = string.lower(args or "")

	if command == "" or command == "help" then
		self:ShowHelp()
	elseif command == "on" or command == "enable" then
		self:SetSetting("enabled", true)
		print(CHAT_PREFIX .. " " .. self.L["ADDON_ENABLED"])
	elseif command == "off" or command == "disable" then
		self:SetSetting("enabled", false)
		self:RestoreAllNameplateDebuffs()
		print(CHAT_PREFIX .. " " .. self.L["ADDON_DISABLED"])
	elseif command == "test" then
		self:TestFunctionality()
	elseif command == "status" then
		self:ShowStatus()
	elseif command == "welcome on" then
		self:SetSetting("showWelcome", true)
		print(CHAT_PREFIX .. " " .. (self.L["WELCOME_ENABLED"] or "Welcome message |cff00ff00enabled|r"))
	elseif command == "welcome off" then
		self:SetSetting("showWelcome", false)
		print(CHAT_PREFIX .. " " .. (self.L["WELCOME_DISABLED"] or "Welcome message |cffff0000disabled|r"))
	elseif command == "icon" then
		self:ShowHelp()
	elseif command == "icon on" then
		self:ToggleMinimapIcon(true)
	elseif command == "icon off" then
		self:ToggleMinimapIcon(false)
	else
		print(CHAT_PREFIX .. " " .. self.L["ERROR_PREFIX"] .. " " .. self.L["ERROR_UNKNOWN_COMMAND"])
	end
end

-- Show help information
function RND:ShowHelp()
	-- Ensure localization exists
	if not self.L then
		print(CHAT_PREFIX .. " |cffff0000Error:|r Localization not loaded")
		return
	end

	print(CHAT_PREFIX .. " " .. self.L["HELP_HEADER"])
	print(CHAT_PREFIX .. " " .. self.L["HELP_TEST"])
	print(CHAT_PREFIX .. " |cffffffff/rnd on|r - Enable addon")
	print(CHAT_PREFIX .. " |cffffffff/rnd off|r - Disable addon")
	print(CHAT_PREFIX .. " " .. self.L["HELP_STATUS"])
	print(CHAT_PREFIX .. " |cffffffff/rnd welcome on|r - " .. (self.L["HELP_WELCOME_ON"] or "Enable welcome message"))
	print(CHAT_PREFIX .. " |cffffffff/rnd welcome off|r - " .. (self.L["HELP_WELCOME_OFF"] or "Disable welcome message"))
	print(CHAT_PREFIX .. " |cffffffff/rnd icon on|r - " .. (self.L["HELP_ICON_ON"] or "Show minimap icon"))
	print(CHAT_PREFIX .. " |cffffffff/rnd icon off|r - " .. (self.L["HELP_ICON_OFF"] or "Hide minimap icon"))
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
    print(iconPrefix .. " " .. (self.L["STATUS_WELCOME"] or "Welcome message:") .. " " ..
        (self:GetSetting("showWelcome") and self.L["ENABLED_STATUS"] or self.L["DISABLED_STATUS"]))
    print(iconPrefix .. " " .. (self.L["STATUS_MINIMAP"] or "Minimap icon:") .. " " ..
        (self:GetSetting("minimapIconEnabled") and self.L["ENABLED_STATUS"] or self.L["DISABLED_STATUS"]))
    print(iconPrefix .. " " .. string.format(self.L["STATUS_VERSION"], ADDON_VERSION))
end

-- Track initialization state
RND.initialized = false

-- Hook tooltip to prevent showing debuff tooltips from nameplates
local function HookTooltips()
    -- Hook main GameTooltip using OnShow to check the unit
    if GameTooltip then
        GameTooltip:HookScript("OnShow", function(self)
            if RND:GetSetting("enabled") then
                -- Check if tooltip has a unit
                local _, unit = self:GetUnit()
                if unit and string.match(unit, "nameplate") then
                    self:Hide()
                    return
                end

                -- Check if owner is related to a nameplate
                local owner = self:GetOwner()
                if owner and owner:GetParent() then
                    local parent = owner:GetParent()
                    -- Check if the parent is a nameplate buff frame
                    if parent then
                        local parentName = parent:GetName()
                        if parentName and string.match(parentName, "NamePlate") then
                            self:Hide()
                            return
                        end
                        -- Also check if it's a unitframe from a nameplate
                        if parent.unit and string.match(parent.unit, "nameplate") then
                            self:Hide()
                            return
                        end
                    end
                end
            end
        end)
    end

    -- Hook NamePlateTooltip if it exists
    if NamePlateTooltip then
        NamePlateTooltip:HookScript("OnShow", function(self)
            if RND:GetSetting("enabled") then
                self:Hide()
            end
        end)
    end

    -- Hook BuffTooltip if it exists (some addons use this)
    if BuffTooltip then
        BuffTooltip:HookScript("OnShow", function(self)
            if RND:GetSetting("enabled") then
                local owner = self:GetOwner()
                if owner and owner:GetParent() then
                    local parent = owner:GetParent()
                    if parent and parent.unit and string.match(parent.unit, "nameplate") then
                        self:Hide()
                    end
                end
            end
        end)
    end
end

-- Register slash command via RGX-Framework
RGX:RegisterSlashCommand("/rnd", function(args)
    local success, errorMsg = pcall(RND.HandleSlashCommand, RND, args)
    if not success then
        print(ICON_PATH .. " |cffff0000RND Error:|r " .. tostring(errorMsg))
    end
end, "RND")

-- Event registration via RGX-Framework
RGX:RegisterEvent("NAME_PLATE_UNIT_ADDED", function(event, unitId)
    if RND.initialized and RND:GetSetting("enabled") then
        RND:HideNameplateDebuffs(unitId)
    end
end, "RND_NameplateAdded")

RGX:RegisterEvent("UNIT_AURA", function(event, unitId)
    if RND.initialized and RND:GetSetting("enabled") and unitId and string.match(unitId, "nameplate") then
        RND:HideNameplateDebuffs(unitId)
    end
end, "RND_UnitAura")

RGX:RegisterEvent("ADDON_LOADED", function(event, addonName)
    if addonName == ADDON_NAME then
        RND:InitializeSettings()
        RND:CreateMinimapButton()
        RND:ApplyMinimapVisibility()
        RND.initialized = true
    end
end, "RND_AddonLoaded")

RGX:RegisterEvent("PLAYER_LOGIN", function()
    if not RND.initialized then
        RND:InitializeSettings()
        RND.initialized = true
    end
    RND:ApplyMinimapVisibility()
    RND:DisplayWelcomeMessage()
    HookTooltips()
end, "RND_PlayerLogin")

-- Periodic update to continuously enforce debuff removal on dynamically created frames
RGX:Every(0.5, function()
    if RND.initialized and RND:GetSetting("enabled") then
        for _, nameplate in pairs(C_NamePlate.GetNamePlates()) do
            if nameplate and nameplate.UnitFrame then
                local unitId = nameplate.UnitFrame.unit
                if unitId then
                    RND:HideNameplateDebuffs(unitId)
                end
            end
        end
    end
end)
