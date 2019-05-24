sX, sY = guiGetScreenSize()
GAME_STATUS = 'Warm up'
MAP_NAME = ''
ROUND_STATUS = ''
ROUND_TIME = 0
FPS_LIMIT = 25
PING_LIMIT = 150
FPS_COUNTER = 5
PING_COUNTER = 5

Team = {}
Team.getAlivePlayers = function(team)
	if(not team or getElementType(team) ~= 'team') then
		return {}
	end
	
	local players = {}
	for i, player in ipairs(getElementsByType('player')) do
		if(getPlayerTeam(player) == team and getElementHealth(player) > 0) then
			table.insert(players, player)
		end
	end
	
	return players
end

WHITE = getElementByID('TEAM_WHITE')
BLACK = getElementByID('TEAM_BLACK')

--addEventHandler("onClientPlayerJoin", getRootElement(),
	-- function()
		-- showPlayerHudComponent("all", false)
		-- showPlayerHudComponent("crosshair", true)
		-- showPlayerHudComponent("radar", true)
	-- end
-- )

-- addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	-- function()
		-- showPlayerHudComponent("all", false)
		-- showPlayerHudComponent("crosshair", true)
		-- showPlayerHudComponent("radar", true)
	-- end
-- )