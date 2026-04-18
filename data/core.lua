--=====================================================================================
-- RND | Remove Nameplate Debuffs! - core.lua
-- Version: 3.2.0
-- Author: DonnieDice
-- Description: Professional World of Warcraft addon that removes debuff icons from nameplates
-- RGX Mods Collection - RealmGX Community Project
--=====================================================================================

-- Global addon namespace and version info
RND = RND or {}

-- Constants (cached for performance)
local ADDON_VERSION = "3.2.0"
local ADDON_NAME = "RemoveNameplateDebuffs"
local ICON_PATH = "|Tinterface/addons/RemoveNameplateDebuffs/images/icon:16:16|t"
local MINIMAP_ICON_TEXTURE = "Interface\\AddOns\\RemoveNameplateDebuffs\\images\\icon"

-- Chat prefix matching RGX Mods standard (matches BLU format)
local CHAT_PREFIX = ICON_PATH .. " - |cffffffff[|r|cff05dffaRND|r|cffffffff]|r"

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

-- Test functionality by toggling nameplates
function RND:TestFunctionality()
	if not self.L then
		print(CHAT_PREFIX .. " |cffff0000Error:|r Localization not loaded")
		return
	end

	print(CHAT_PREFIX .. " " .. self.L["TEST_TOGGLING"])

	-- Toggle nameplates off and on to force refresh
	SetCVar("nameplateShowEnemies", 0)
	C_Timer.After(0.5, function()
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

	print(CHAT_PREFIX .. " " .. self.L["TYPE_HELP"])
end

-- =====================================================================================
-- Minimap Button
-- =====================================================================================

function RND:UpdateMinimapButtonPosition()
    if not self.minimapButton or not Minimap then return end

    local angle = math.rad((RNDSettings and RNDSettings.minimapAngle) or self.defaultMinimapAngle)
    local minimapRadius = math.max(Minimap:GetWidth() or 140, Minimap:GetHeight() or 140) / 2 + 10
    local x = math.cos(angle) * minimapRadius
    local y = math.sin(angle) * minimapRadius
    self.minimapButton:ClearAllPoints()
    self.minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

function RND:UpdateMinimapPositionFromCursor()
    if not self.minimapButton or not RNDSettings or not Minimap then return end

    local mx, my = Minimap:GetCenter()
    local scale = Minimap:GetEffectiveScale()
    local cx, cy = GetCursorPosition()
    cx = cx / scale
    cy = cy / scale

    if not mx or not my then
        return
    end

    local dy = cy - my
    local dx = cx - mx
    local angle = math.deg((math.atan2 and math.atan2(dy, dx)) or math.atan(dy, dx))
    if angle < 0 then
        angle = angle + 360
    end

    RNDSettings.minimapAngle = angle
    self:UpdateMinimapButtonPosition()
end

function RND:CreateMinimapButton()
    if self.minimapButton or not Minimap then return end

    local button = CreateFrame("Button", "RND_MinimapButton", Minimap)
    self.minimapButton = button
    button:SetSize(32, 32)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(Minimap:GetFrameLevel() + 8)
    button:SetMovable(true)
    button:EnableMouse(true)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:RegisterForDrag("LeftButton")

    local backdrop = button:CreateTexture(nil, "BACKGROUND")
    backdrop:SetSize(24, 24)
    backdrop:SetPoint("CENTER", button, "CENTER", 1, 0)
    backdrop:SetTexture("Interface\\Buttons\\WHITE8X8")
    if backdrop.SetMask then
        backdrop:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMaskSmall")
    end
    backdrop:SetVertexColor(0.03, 0.03, 0.03, 0.98)
    button.backdrop = backdrop

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(19, 19)
    icon:SetPoint("CENTER", button, "CENTER", 0, -1)
    icon:SetTexture(MINIMAP_ICON_TEXTURE)
    icon:SetTexCoord(0.02, 0.98, 0.02, 0.98)
    button.icon = icon

    local overlay = button:CreateTexture(nil, "OVERLAY")
    overlay:SetSize(54, 54)
    overlay:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
    overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    button.overlay = overlay

    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    button:SetScript("OnClick", function(self, mouseButton)
        if self.isDragging then return end
        if mouseButton == "LeftButton" then
            RND:HandleMinimapClick()
        end
    end)

    button:SetScript("OnDragStart", function(self)
        self.isDragging = true
        if GameTooltip then GameTooltip:Hide() end
        self:SetScript("OnUpdate", function()
            RND:UpdateMinimapPositionFromCursor()
        end)
    end)
    button:SetScript("OnDragStop", function(self)
        self.isDragging = false
        self:SetScript("OnUpdate", nil)
        RND:UpdateMinimapButtonPosition()
    end)

    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:ClearLines()
        local title = "|cffff7d00R|r|cffffffffemove|r |cffff7d00N|r|cffffffffameplate|r |cffff7d00D|r|cffffffffebuffs|r|cffff7d00!|r"
        GameTooltip:AddLine(ICON_PATH .. " " .. title)
        GameTooltip:AddLine(" ")
        local enabled = RND:GetSetting("enabled")
        local statusText = enabled and "|cff00ff00Enabled|r" or "|cffff0000Disabled|r"
        GameTooltip:AddDoubleLine("|cffffffffStatus|r", statusText)
        GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine("|cffff7d00Left-Click|r", "|cffffffffToggle debuff removal|r", 1, 1, 1, 1, 1, 1)
        GameTooltip:AddDoubleLine("|cff4ecdc4Left-Drag|r", "|cffffffffMove around minimap|r", 1, 1, 1, 1, 1, 1)
        GameTooltip:AddDoubleLine("|cffe74c3cCtrl+Right-Click|r", "|cffffffffHide minimap icon|r", 1, 1, 1, 1, 1, 1)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- Handle Ctrl+Right-click to hide the minimap icon
    button:SetScript("OnMouseDown", function(self, mouseButton)
        if mouseButton == "RightButton" and IsControlKeyDown() then
            self.isCtrlRightClick = true
        end
    end)

    button:SetScript("OnMouseUp", function(self, mouseButton)
        if mouseButton == "RightButton" and self.isCtrlRightClick and IsControlKeyDown() then
            self.isCtrlRightClick = false
            GameTooltip:Hide()
            RND:ToggleMinimapIcon(false)
        end
    end)
end

function RND:HandleMinimapClick()
-- Toggle enabled state on left-click
	local current = self:GetSetting("enabled")
	self:SetSetting("enabled", not current)
	if self.L then
		local msg = (not current) and self.L["ADDON_ENABLED"] or self.L["ADDON_DISABLED"]
		print(CHAT_PREFIX .. " " .. msg)
	end
end

function RND:ToggleMinimapIcon(show)
	self:SetSetting("minimapIconEnabled", show and true or false)
	if show then
		if not self.minimapButton then
			self:CreateMinimapButton()
		end
		if self.minimapButton then
			self.minimapButton:Show()
			self:UpdateMinimapButtonPosition()
		end
		if self.L then
			print(CHAT_PREFIX .. " " .. (self.L["MINIMAP_ICON_SHOWN"] or "Minimap icon |cff00ff00shown|r"))
		end
	else
		if self.minimapButton then
			self.minimapButton:Hide()
		end
		if self.L then
			print(CHAT_PREFIX .. " " .. (self.L["MINIMAP_ICON_HIDDEN"] or "Minimap icon |cffff0000hidden|r. Use |cffffffff/rnd icon on|r to show it again."))
		end
	end
end

function RND:ApplyMinimapVisibility()
    local shouldShow = self:GetSetting("minimapIconEnabled")
    if shouldShow then
        if not self.minimapButton then
            self:CreateMinimapButton()
        end
        if self.minimapButton then
            self.minimapButton:Show()
            self:UpdateMinimapButtonPosition()
        end
    else
        if self.minimapButton then
            self.minimapButton:Hide()
        end
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
            self:CreateMinimapButton()
            self:ApplyMinimapVisibility()
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
        self:ApplyMinimapVisibility()
        self:DisplayWelcomeMessage()
        HookTooltips()
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
