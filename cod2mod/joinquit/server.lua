addEventHandler('onPlayerJoin', root,
	function ()
		outputChatBox('* '..trimColorCodes(getPlayerName(source))..' has joined the game', getRootElement(), 255, 100, 100, true)
	end
)

addEventHandler('onPlayerQuit', root,
	function (quitType, reason, responsibleElement)
		if(not reason) then reason = "" else reason = ": "..reason end

		outputChatBox('* '..trimColorCodes(getPlayerName(source))..' has left the game ['..quitType..reason..']', getRootElement(), 255, 100, 100, true)
	end
)