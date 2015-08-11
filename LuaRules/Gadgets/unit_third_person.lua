if not gadgetHandler:IsSyncedCode() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name 	= "Third Person Movement",
		desc	= "Implements direct movement control of a unit",
		author	= "Google Frog",
		date	= "11 August 2015",
		license	= "GNU GPL, v2 or later",
		layer	= 10,
		enabled = true
	}
end

-------------------------------------------------------------------
-------------------------------------------------------------------

local sqrt = math.sqrt

-------------------------------------------------------------------
-------------------------------------------------------------------

local function explode(div,str)
	if (div=='') then return 
		false 
	end
	local pos,arr = 0,{}
	-- for each divider found
	for st,sp in function() return string.find(str,div,pos,true) end do
		table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
		pos = sp + 1 -- Jump past current divider
	end
	table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
	return arr
end

-------------------------------------------------------------------
-------------------------------------------------------------------

local rollerUnitDefID = UnitDefNames["roller"].id
local rollerID
local lastMessagee

local speed, turnPenalty

-------------------------------------------------------------------
-------------------------------------------------------------------
-- 2D Vector Functions

local function DistSq(x1,z1,x2,z2)
	return (x1 - x2)*(x1 - x2) + (z1 - z2)*(z1 - z2)
end

local function Mult(b, v)
	return {b*v[1], b*v[2]}
end

local function AbsVal(v)
	return sqrt(v[1]*v[1] + v[2]*v[2])
end

local function Unit(v)
	local mag = AbsVal(v)
	if mag > 0 then
		return {v[1]/mag, v[2]/mag}
	else
		return v
	end
end

local function Norm(b, v)
	local mag = AbsVal(v)
	if mag > 0 then
		return {b*v[1]/mag, b*v[2]/mag}
	else
		return v
	end
end

local function AngleManual(v) -- in case Angle stops working
	if v[1] == 0 and v[2] == 0 then
		return 0
	end
	local mult = 1/AbsVal(v)
	local x, z = v[1]*mult, v[2]*mult
	Spring.Echo(x, z)
	if z > 0 then
		return math.acos(x)
	elseif z < 0 then
		return 2*math.pi - math.acos(x)
	elseif x < 0 then
		return math.pi
	end
	-- x < 0
	return 0
end

local function Angle(v)
	return -Spring.GetHeadingFromVector(v[1], v[2])/2^15*math.pi + math.pi/2
end

local function Dot(v1, v2)
	return v1[1]*v2[1] + v1[2]*v2[2]
end

local function PolarToCart(mag, dir)
	return {mag*math.cos(dir), mag*math.sin(dir)}
end

local function Add(v1, v2)
	return {v1[1] + v2[1], v1[2] + v2[2]}
end

-------------------------------------------------------------------
-------------------------------------------------------------------
-- Movement Functions

local mapWidth = Game.mapSizeX
local mapHeight = Game.mapSizeZ
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local CMD_INSERT = CMD.INSERT

function IsValidPosition(x, z)
	return x and z and x >= 1 and z >= 1 and x <= mapWidth-1 and z <= mapHeight-1
end

function ClampPosition(x, z)
	if x and z then
		if IsValidPosition(x, z) then
			return x, z
		else
			if x < 1 then
				x = 1
			elseif x > mapWidth-1 then
				x = mapWidth-1
			end
			if z < 1 then
				z = 1
			elseif z > mapHeight-1 then
				z = mapHeight-1
			end
			return x, z
		end
	end
end

function GiveClampedMoveGoal(unitID, x, z)
	local cx, cz = ClampPosition(x, z)
	local cy = Spring.GetGroundHeight(cx, cz)
	--Spring.MarkerAddPoint(cx, cy, cz)
	Spring.SetUnitMoveGoal(unitID, cx, cy, cz, 16, nil, true) -- The last argument is whether the goal is raw
	return true
end

-------------------------------------------------------------------
-------------------------------------------------------------------

local function RollerMovement(unitID, dirInput, accelInput)
	if not (unitID and Spring.ValidUnitID(unitID)) then
		return
	end
	
	local ux, uy, uz = Spring.GetUnitPosition(unitID)
	local dx, dy, dz = Spring.GetUnitDirection(unitID)
	local dir = {dx, dz}
	
	dirInput = math.max(-1, math.min(1, dirInput))
	local dirInputAngle = dirInput*math.pi/2
	
	turnPenalty = math.max(0.1, math.min(1, turnPenalty*(1 + 0.4*(math.abs(dirInput) - 0.5))))
	
	local moveVec = PolarToCart(500, Angle(dir) + dirInputAngle)
	
	GiveClampedMoveGoal(unitID, moveVec[1] + ux, moveVec[2] + uz)
	
	if accelInput < 0 then
		accelInput = accelInput*0.1
	end
	
	speed = (speed + accelInput*0.5)*(0.985 - turnPenalty*0.2)
	
	--Spring.Echo("speed", speed)
	--Spring.Echo("turnPenalty", turnPenalty)
	
	Spring.SetUnitRulesParam(unitID, "selfMoveSpeedChange", speed)
	Spring.SetUnitRulesParam(unitID, "selfMaxAccelerationChange", 1)
	Spring.SetUnitRulesParam(unitID, "selfTurnSpeedChange", 0.5*20/(10 + speed))
	GG.UpdateUnitAttributes(unitID)
end


-------------------------------------------------------------------
-------------------------------------------------------------------

function gadget:UnitCreated(unitID, unitDefID)
	if rollerUnitDefID == unitDefID then
		rollerID = unitID
		speed = 0
		turnPenalty = 0
	end
end

function gadget:GameFrame(frame)
	if rollerID then
		if not lastMessagee or lastMessagee + 1 < frame then
			RollerMovement(rollerID, 0, 0)
		end
	else
		Spring.CreateUnit(rollerUnitDefID, 3000, 300, 3000, 0, 0)
	end
end

function gadget:Initialize()
	
end

-------------------------------------------------------------------
-------------------------------------------------------------------
-- Handling messages

function HandleLuaMessage(msg)
	local msg_table = explode('|', msg)
	if msg_table[1] == 'movement' then
		local dir = tonumber(msg_table[2])
		local accel = tonumber(msg_table[3])
		
		lastMessagee = Spring.GetGameFrame()
		
		RollerMovement(rollerID, dir, accel)
	end
end

function gadget:RecvLuaMsg(msg)
	HandleLuaMessage(msg)
end

