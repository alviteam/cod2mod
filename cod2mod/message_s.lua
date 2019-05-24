function sendGMMessage(thePlayer, commandName, ...)
	if(hasObjectPermissionTo(thePlayer, "command.kick", true)) then
		local info = {...}
		local finalinfo = table.concat(info, " ")
		local message = getAccountName(getPlayerAccount(thePlayer))..": "..finalinfo
		for i,player in ipairs(getElementsByType("player")) do
			callClientFunction(player, "receiveGMMessage", message)
		end
	end
end
addCommandHandler("send", sendGMMessage)