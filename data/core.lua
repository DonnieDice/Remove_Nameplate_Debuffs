local frame = CreateFrame("Frame")
local events = {}

-- Handle the NAME_PLATE_UNIT_ADDED event
function events:NAME_PLATE_UNIT_ADDED(unitId)
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
    print("[|cffff7d00RND|r] |cffff7d00R|r|cffffffffemove |cffff7d00N|r|cffffffffameplate |cffff7d00D|r|cffffffffebuffs|r Loaded!")
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
