--v1.0.11

-- This script creates a frame for event handling and defines a function to handle the NAME_PLATE_UNIT_ADDED event.
-- When this event occurs, the function clears the points of the BuffFrame and sets its alpha to 0.
-- The defined events are registered with the frame and a script is set to handle events when they occur.

-- Create a frame for event handling
local a = CreateFrame("Frame")

-- Create a table for events
local events = {}

-- Define a function to handle the NAME_PLATE_UNIT_ADDED event
function events:NAME_PLATE_UNIT_ADDED(plate)
	-- Get the unit ID from the event
	local unitId = plate
	-- Get the nameplate associated with the unit
	local nameplate = C_NamePlate.GetNamePlateForUnit(unitId)
	-- Get the unit frame from the nameplate
	local frame = nameplate.UnitFrame
	-- Check if the nameplate or frame is forbidden (likely due to security restrictions)
	if not nameplate or frame:IsForbidden() then
		return
	end
	-- Clear the points of the BuffFrame and set its alpha to 0
	frame.BuffFrame:ClearAllPoints()
	frame.BuffFrame:SetAlpha(0)
end

-- Register the defined events with the frame
for b, u in pairs(events) do
	a:RegisterEvent(b)
end

-- Set a script to handle events when they occur
a:SetScript("OnEvent", function(self, event, ...) events[event](self, ...) end)