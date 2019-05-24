addEventHandler('onClientPlayerDamage', getLocalPlayer(),
	function ()
		if (getElementData(source, 'spawnprotected') == 'true') then
			cancelEvent()
		end
	end
)

addEventHandler('onClientPlayerWeaponFire', getLocalPlayer(),
	function ()
		setElementData(source, 'spawnprotected', 'false')
	end
)