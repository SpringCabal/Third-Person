	--Wiki: http://springrts.com/wiki/Modrules.lua

local modRules = {
	movement = {
		allowPushingEnemyUnits    = true,
		allowCrushingAlliedUnits  = false,
		allowUnitCollisionDamage  = true,
		allowUnitCollisionOverlap = false,
		allowGroundUnitGravity    = true,
		allowDirectionalPathing   = true,
		allowHoverUnitStrafing    = false,
	},
	system = {
		pathFinderSystem = 1, -- 0 = legacy, 1 = QTPFS
	},
}

return modRules
