local BODYPART_TORSO = 3
local BODYPART_ASS = 4
local BODYPART_LARM = 5
local BODYPART_RARM = 6
local BODYPART_LLEG = 7
local BODYPART_RLEG = 8
local BODYPART_HEAD = 9

addEventHandler('onPlayerDamage', root,
	function (attacker, weapon, bodypart, loss)
		if (getElementData(source, 'spawnprotected') == 'true') then
			return
		end

		if (bodypart == BODYPART_HEAD) then
			setElementHealth(source, 0)
		end
	end
)