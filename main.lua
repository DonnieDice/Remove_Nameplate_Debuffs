--v1.0.2
local a = CreateFrame("Frame")
local events = {}

function events:NAME_PLATE_UNIT_ADDED(plate)
	local unitId = plate
	local nameplate = C_NamePlate.GetNamePlateForUnit(unitId)
	local frame = nameplate.UnitFrame
	if not nameplate or frame:IsForbidden() then return end
	frame.BuffFrame:ClearAllPoints()
	frame.BuffFrame:SetAlpha(0)
end

for b, u in pairs(events) do
	a:RegisterEvent(b)
end

a:SetScript("OnEvent", function(self, event, ...) events[event](self, ...) end)
