ROUND_TIME = 0
FREEZE_TIME = 0
VOTE_TIME = 0

setTimer(
	function()
		if(FREEZE_TIME > 0) then
			FREEZE_TIME = FREEZE_TIME - 1
			
			-- Starting round sound
			if(FREEZE_TIME <= 3) then
				playSoundFrontEnd(5)
			end
			if(FREEZE_TIME == 1) then
				setTimer(playSoundFrontEnd, 1000, 1, 45)
			end
			return
		end
		
		if(ROUND_TIME > 0) then
			ROUND_TIME = ROUND_TIME - 1
			return
		end
		
		if(VOTE_TIME > 0) then
			VOTE_TIME = VOTE_TIME - 1
			return
		end
	end,
	1000, 0
)

addEvent('onRoundTimeSync', true)
addEventHandler('onRoundTimeSync', getRootElement(),
	function(serverclock, freezeclock, voteclock)
		ROUND_TIME = tonumber(serverclock) or 0
		FREEZE_TIME = tonumber(freezeclock) or 0
		VOTE_TIME = tonumber(voteclock) or 0
	end
)

addEvent('onRoundMapnameUpdate', true)
addEventHandler('onRoundMapnameUpdate', getRootElement(),
	function(mapname)
		MAP_NAME = tostring(mapname) or ''
	end
)