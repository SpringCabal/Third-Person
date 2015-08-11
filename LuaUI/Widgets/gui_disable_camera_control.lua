--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "Disable camera control",
		desc      = "Disables camera zooming and panning",
		author    = "gajop",
		date      = "WIP",
		license   = "GPLv2",
		version   = "0.1",
		layer     = -1000,
		enabled   = true,  --  loaded by default?
		handler   = true,
		api       = true,
		hidden    = true,
	}
end

-------------------------------------------------------------------
-------------------------------------------------------------------

local rollerUnitDefID = UnitDefNames["roller"].id
local rollerID

-------------------------------------------------------------------
-------------------------------------------------------------------

function widget:Initialize()
    for k, v in pairs(Spring.GetCameraState()) do
        Spring.Echo(k .. " = " .. tostring(v) .. ",")
    end
--     local devMode = (tonumber(Spring.GetModOptions().play_mode) or 0) == 0
--     if devMode then
--         widgetHandler:RemoveWidget(widget)
--         return
--     end
    s = {
        px = 3150,
        py = 102.34146118164,
        pz = 3480,
        mode = 1,
        flipped = -1,
        dy = -0.90149933099747,
        dz = -0.43356931209564,
        fov = 45,
        height = 3300,
        angle = 0.46399998664856,
        dx = 0,
    }
    Spring.SetCameraState(s, 0)
end

function widget:Shutdown()
end

function widget:UnitCreated(unitID, unitDefID)
	if rollerUnitDefID == unitDefID then
		rollerID = unitID
	end
end

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
	return math.sqrt(v[1]*v[1] + v[2]*v[2])
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

function widget:GameFrame()
	if not rollerID then
		return
	end
	
	local ux, uy, uz = Spring.GetUnitPosition(rollerID)
	local dx, dy, dz = Spring.GetUnitDirection(rollerID)
	
	local dir = Norm(1, {dx, dz})
	local angle = Angle(dir)
	
	s = {
		mode = 4,
        px = ux-1000*dir[1],
        py = uy,
        pz = uz-1000*dir[2],
        rx = -0.8,
        ry = -angle + 0.5*math.pi,
        rz = 0,
        dx = 0.1,
        dy = 0.1,
        dz = 0.1,
        fov = 45,
		name = "free",
		gndOffset = 1000,
    }
    Spring.SetCameraState(s, 0.01)
end