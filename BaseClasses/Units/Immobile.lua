local BaseImmobile = Unit:New {
    -- movement needs to be enabled so it can be pushed by gravity
	canMove				= true,
    maxVelocity         = 0.00001,
    movementClass		= "KBOT_Infantry", 
    canGuard            = false,
    canPatrol           = false,
    canRepeat           = false,
    category            = "INFANTRY",

    pushResistant       = true,
    collisionVolumeScales   = '37 40 37',
    collisionVolumeTest     = 1,
    collisionVolumeType     = 'cylY',
	-- corpse				= "",
	footprintX			= 1,
	footprintZ			= 1,
	mass				= 50,
	maxDamage			= 300, -- default only
	repairable			= false,
	sightDistance		= 0,


	stealth				= true,
	turnRate			= 0,
	upright				= true,
    customParams = {
        radius = 30,
    }
}

local BaseEffect = Unit:New {
    customParams        = {
        effect = true,
        -- invulnerable means that most instances are invulnerable through normal damage and effects (could still be manually destroyed)
        invulnerable = true, 
    },
    category            = "EFFECT",
    footprintX			= 1,
	footprintZ			= 1,
	mass				= 50,
    maxDamage           = 10000,
    collisionVolumeScales   = '0 0 0',
    collisionVolumeType     = 'cylY',
    pushResistant       = true,
    blocking            = false,
    canMove             = false, --effects cannot be moved (even by gravity)
    canGuard            = false,
    canPatrol           = false,
    canRepeat           = false,
    stealth				= true,
	turnRate			= 0,
	upright				= true,
    sightDistance		= 0,
--     canCloak            = true,
--     initCloaked         = true,
--     decloakOnFire       = false,
--     minCloakDistance    = 0,
}

local BaseWall = Unit:New {
    canMove             = false,
    canGuard            = false,
    canPatrol           = false,
    canRepeat           = false,
    maxVelocity         = 0,
    customParams = {
        wall = true,
        invulnerable = 1,
        nonparalyzable = 1,
    },
    mass                = 10e20,
    maxDamage           = 420,
    turnRate            = 0,
    sightDistance		= 0,
    upright             = true,
}

return {
    BaseImmobile = BaseImmobile,
    BaseEffect   = BaseEffect,
    BaseWall     = BaseWall,
}
