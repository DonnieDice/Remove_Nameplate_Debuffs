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
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        DisplayOnLoginMessage()
    else
        events[event](self, ...)
    end
end)
