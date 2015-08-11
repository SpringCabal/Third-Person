local mineexplode = Weapon:New{
				alwaysVisible = true,
				areaofeffect = 200,
				avoidfeature = false,
				burst = 3,
				burstrate = 0.1,
				craterboost = 0,
				cratermult = 0,
				collidefriendly = false,
				collidefeature = false,
				collideneutral = false,
				collideground = true,
				explosiongenerator = "custom:flashnuke",
				firestarter = 100,
				impulseboost = 0.123,
				impulsefactor = 0.123,
				intensity = 0.7,
				noselfdamage = true,
				projectiles = 10,
				range = 180,
				reloadtime = 0.31000000238419,
				rgbcolor = "1 0.95 0.4",
				size = 1.75,
				sprayangle = 1180,
				tolerance = 5000,
				turret = true,
				weapontimer = 0.1,
				weapontype = "Cannon",
				weaponvelocity = 2000,
				customparams = {
					nofriendlyfire = true
				},
				damage = {
					default = 150000,
				},
}

return lowerkeys{
	mineexplode = mineexplode
}