Killstreaks = {}

addEventHandler('onPlayerSpawn', root,
	function ()
		Killstreaks[source] = 0
	end
)

addEventHandler('onPlayerWasted', root,
	function (ammo, killer, killerWeapon, bodypart, stealth)
		Stats.saveKillstreak(source, Killstreaks[source])
		
		outputChatBox('Your killstreak: '..Killstreaks[source], source)
		if (Killstreaks[source] >= 5) then
			outputChatBox(getPlayerName(source)..'\'s killstreak: '..Killstreaks[source]..' kills', getRootElement(), 0, 255, 0)
		end

		Killstreaks[source] = 0
		if (killer and Killstreaks[killer]) then
			Killstreaks[killer] = Killstreaks[killer] + 1
		end
	end
)