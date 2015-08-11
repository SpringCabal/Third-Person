function widget:GetInfo()
	return {
		name 	= "Movement Control",
		desc	= "Controlls vehicle movement.",
		author	= "Google Frog",
		date	= "8 August 2015",
		license	= "GNU GPL, v2 or later",
		layer	= 20, 
		enabled = true
	}
end

-------------------------------------------------------------------
-------------------------------------------------------------------

include('keysym.h.lua')
local W = KEYSYMS.W
local S = KEYSYMS.S
local A = KEYSYMS.A
local D = KEYSYMS.D

-------------------------------------------------------------------
-------------------------------------------------------------------
--[[
function widget:GameFrame(n)
	local mx, my = Spring.GetMouseState()
	local _, pos = Spring.TraceScreenRay(mx, my, true)
	if pos then
		local x, y, z = pos[1], pos[2], pos[3]
		if x ~= lastx or y ~= lasty or z ~= lastz then
			lastx, lasty, lastz = x, y, z
			Spring.SendLuaRulesMsg('movegun|' .. x .. '|' .. y .. '|' .. z )
		end
	end
end

function widget:MousePress(mx, my, button)
	local alt, ctrl, meta, shift = Spring.GetModKeyState()
	if button == 1 and not Spring.IsAboveMiniMap(mx, my) then
		local _, pos = Spring.TraceScreenRay(mx, my, true)
		if pos then
			local x, y, z = pos[1], pos[2], pos[3]
			Spring.SendLuaRulesMsg('shotgun|' .. x .. '|' .. y .. '|' .. z )
			return true
		end
	end	
end
--]]

function widget:GameFrame(frame)
	local dir = 0
	local accel = 0
	if Spring.GetKeyState(A) then
		dir = -1
    elseif Spring.GetKeyState(D) then
		dir = 1
    end
	
	if Spring.GetKeyState(W) then
		accel = 1
    elseif Spring.GetKeyState(S) then
		accel = -1
    end
	
	Spring.SendLuaRulesMsg('movement|' .. dir .. '|' .. accel)
end