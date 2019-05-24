addEventHandler('onPlayerWasted', getRootElement(),
	function(totalAmmo, killer, killerWeapon, bodypart, stealth)
		if(source ~= killer) then
			triggerClientEvent(getRootElement(), 'onClientKillmessage', source, killer)
		else
			triggerClientEvent(getRootElement(), 'onClientKillmessage', source)
		end
	end
)