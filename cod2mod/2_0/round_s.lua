ROUND_TIME = 0
FREEZE_TIME = 0
VOTE_TIME = 0

local roundStarted = false
local roundTimeUpdate = false

setTimer(
	function()
		--REMOVE ME
		if((modulo(TIME_LIMIT, 5) == 0 and TIME_LIMIT == 0) or roundTimeUpdate) then
			triggerEvent('onRoundSync', getRootElement())
			roundTimeUpdate = false
		end
		--/REMOVE ME
		
		if((modulo(ROUND_TIME, 5) == 0 and FREEZE_TIME == 0) or roundTimeUpdate) then
			triggerEvent('onRoundSync', getRootElement())
			roundTimeUpdate = false
		end
		
		if(FREEZE_TIME == 0 and ROUND_TIME ~= 0 and not roundStarted) then
			roundStarted = true
			triggerEvent('onRoundStart', getRootElement())
		elseif(ROUND_TIME == 0 and roundStarted) then
			roundStarted = false
			triggerEvent('onRoundEnd', getRootElement())
		elseif(VOTE_TIME == 0) then
			triggerEvent('onVoteEnd', getRootElement())
		end
		
		
		if(FREEZE_TIME > 0) then
			FREEZE_TIME = FREEZE_TIME - 1
		elseif(ROUND_TIME > 0) then
			ROUND_TIME = ROUND_TIME - 1
		else
			VOTE_TIME = VOTE_TIME - 1
		end
	end,
	1000, 0
)

addEvent('onRoundStart', true)
addEventHandler('onRoundStart', getRootElement(),
	function()
		roundTimeUpdate = true
	end
)

addEvent('onRoundEnd', true)
addEventHandler('onRoundEnd', getRootElement(),
	function()
		triggerEvent('onVoteMap', getRootElement())
	end
)

addEvent('onRoundSync', true)
addEventHandler('onRoundSync', getRootElement(),
	function()
		--REMOVE ME
		ROUND_TIME = TIME_LIMIT
		--/REMOVE ME
		
		triggerClientEvent(getRootElement(), 'onRoundTimeSync', getRootElement(), ROUND_TIME, FREEZE_TIME, VOTE_TIME)
		
		local map = call(getResourceFromName('mapmanager'), 'getRunningGamemodeMap')
		if(map) then
			local mapname = getResourceName(map) or ''
			triggerClientEvent(getRootElement(), 'onRoundMapnameUpdate', getRootElement(), mapname)
		end
	end
)

-- *
-- * Useful functions
-- *
function modulo(a, b)
	return (a - math.floor(a/b)*b)
end