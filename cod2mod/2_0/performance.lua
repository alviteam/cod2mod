local FRAMES = nil
local RATE = nil

FPS = 0
PING = 0

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function()
		for i, player in ipairs(getElementsByType("player")) do
			if(player == getLocalPlayer()) then
				FRAMES = 0
				RATE = 0
			end
		end
		setTimer(monitorClientPerformance, 1000, 1, getLocalPlayer())
	end
)

addEventHandler("onClientPlayerJoin", getRootElement(),
	function()
		if(source == getLocalPlayer()) then
			FRAMES = 0
			RATE = 0
			setTimer(monitorClientPerformance, 1000, 1, source)
		end
	end
)

addEventHandler("onClientRender", getRootElement(),
	function()
		FRAMES = FRAMES + 1
	end
)

function monitorClientPerformance(player)
	if(player) then
		PING = getPlayerPing(player)
		if(FRAMES < FPS_LIMIT or PING > PING_LIMIT) then
			RATE = RATE + 1
			if(RATE >= 12) then
				-- display info
			end
			if(RATE >= 20) then
				--triggerServerEvent("lib_kickPlayer", player, player, "Anti-lag system xD")
			end
		else
			if(RATE > 0) then RATE = RATE - 1 end
		end
		FPS = FRAMES
		FRAMES = 0
		setElementData(player, "Ping", PING)
		setElementData(player, "FPS", FPS)
		setTimer(monitorClientPerformance, 1000, 1, player)
	end
end