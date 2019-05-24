GameTypes['TDM'] = {}

GameTypes['TDM'].scorelimit = tonumber(get('tdm_scorelimit') or 0)

GameTypes['TDM'].init = function()
	GameTypes['TDM'].setClock()
end

GameTypes['TDM'].setClock = function()
	ROUND_TIME = tonumber(get('tdm_roundtime') or 0)
	FREEZE_TIME = tonumber(get('tdm_freezetime') or 0)
	VOTE_TIME = tonumber(get('votetime') or 0)
end