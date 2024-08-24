local frame = CreateFrame("Frame")
local events = {}

-- Persistent settings using a saved variable
RNDDB = RNDDB or { showWelcomeMessage = true, addonEnabled = true }

-- Localization table
local L = {
    ["ADDON_LOADED"] = "Loaded!",
    ["WELCOME_MESSAGE_ENABLED"] = "|cff00ff00enabled|r",
    ["WELCOME_MESSAGE_DISABLED"] = "|cffff0000disabled|r",
    ["ADDON_ENABLED"] = "|cff00ff00enabled|r",
    ["ADDON_DISABLED"] = "|cffff0000disabled|r",
    ["AVAILABLE_COMMANDS"] = "Available commands:",
    ["TOGGLE_WELCOME"] = "/rnd welcome - Toggle the welcome message",
    ["TOGGLE_ADDON"] = "/rnd - Toggle the addon on/off",
}

-- Addon prefix
local PREFIX = "[|cffff7d00RND|r] "

-- Handle the NAME_PLATE_UNIT_ADDED event
function events:NAME_PLATE_UNIT_ADDED(unitId)
    if not RNDDB.addonEnabled then return end  -- Skip processing if the addon is disabled

    local nameplate = C_NamePlate.GetNamePlateForUnit(unitId)
    
    -- Ensure nameplate and UnitFrame are valid and not forbidden
    if not nameplate or nameplate.UnitFrame:IsForbidden() then
        return
    end

    local unitFrame = nameplate.UnitFrame
    unitFrame.BuffFrame:ClearAllPoints()
    unitFrame.BuffFrame:SetAlpha(0)
end

-- Display a message on player login
local function DisplayOnLoginMessage()
    if RNDDB.showWelcomeMessage then
        print(PREFIX .. L["ADDON_LOADED"])
    end
end

-- Slash command to toggle the addon on/off and show help
SLASH_RND1 = "/rnd"
SlashCmdList["RND"] = function(input)
    if input == "" then
        -- Toggle the addon on/off
        RNDDB.addonEnabled = not RNDDB.addonEnabled
        local status = RNDDB.addonEnabled and L["ADDON_ENABLED"] or L["ADDON_DISABLED"]
        print(PREFIX .. "Addon " .. status)
    elseif input == "welcome" then
        -- Toggle the welcome message
        RNDDB.showWelcomeMessage = not RNDDB.showWelcomeMessage
        local status = RNDDB.showWelcomeMessage and L["WELCOME_MESSAGE_ENABLED"] or L["WELCOME_MESSAGE_DISABLED"]
        print(PREFIX .. "Welcome message " .. status)
    elseif input == "help" then
        -- Display help information
        print(PREFIX .. L["AVAILABLE_COMMANDS"])
        print(PREFIX .. L["TOGGLE_ADDON"])
        print(PREFIX .. L["TOGGLE_WELCOME"])
    else
        print(PREFIX .. L["AVAILABLE_COMMANDS"] .. " /rnd help")
    end
end

-- Event handler function
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        DisplayOnLoginMessage()
    else
        events[event](self, ...)
    end
end)

-- Register relevant events
frame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
frame:RegisterEvent("PLAYER_LOGIN")

-- Register the event handler
for event in pairs(events) do
    frame:RegisterEvent(event)
end
