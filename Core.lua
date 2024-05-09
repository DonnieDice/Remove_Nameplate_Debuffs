--v2.0.0
-- This script creates a frame for event handling and defines a function to handle the NAME_PLATE_UNIT_ADDED event.
-- When this event occurs, the function clears the points of the BuffFrame and sets its alpha to 0.
-- The defined events are registered with the frame and a script is set to handle events when they occur.
local frame = CreateFrame("Frame")
local events = {}
function events:NAME_PLATE_UNIT_ADDED(plate)
	local unitId = plate
	local nameplate = C_NamePlate.GetNamePlateForUnit(unitId)
	local frame = nameplate.UnitFrame
	if not nameplate or frame:IsForbidden() then
		return
	end
	frame.BuffFrame:ClearAllPoints()
	frame.BuffFrame:SetAlpha(0)
end
for event, handler in pairs(events) do
	frame:RegisterEvent(event)
end
local function DisplayOnLoginMessage()
    print("|cffff7d00R|r|cffffffffemove|r |cffff7d00N|r|cffffffffameplate|r |cffff7d00D|r|cffffffffebuffs|r is enabled")
end
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        DisplayOnLoginMessage()
    else
        events[event](self, ...)
    end
end)
