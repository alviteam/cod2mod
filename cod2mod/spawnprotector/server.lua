local Protectors = {}

addEventHandler('onPlayerSpawn', root,
	function ()
		setElementData(source, 'spawnprotected', 'true')
		Protectors[source] = setTimer(
			function (player)
				setElementData(player, 'spawnprotected', 'false')
			end, 5000, 1, source
		)
	end
)

addEventHandler('onPlayerWasted', root,
	function ()
		if(isTimer(Protectors[source])) then
			killTimer(Protectors[source])
		end
		--setElementData(source, 'spawnprotected', 'false')
	end
)

addEventHandler('onPlayerQuit', root,
	function ()
		if(isTimer(Protectors[source])) then
			killTimer(Protectors[source])
		end
	end
)