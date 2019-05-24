local sX, sY = guiGetScreenSize()

local youkilledText = ''
local killedbyText = ''
local youkilledColor = tocolor(255, 255, 255, 255)
local killedbyColor = tocolor(255, 255, 255, 255)
local selfkillColor = tocolor(255, 0, 0, 255)
local killmessageColor = tocolor(255, 255, 255, 255)
local drawYouKilledMessage = false
local drawKilledByMessage = false
local youkilledTimer = nil
local killedbyTimer = nil
local youkilledCounter = 0
local killedbyCounter = 0

local fontsize = Font.adjustSize(Font.Segoe, sY*0.04)

function drawKillMessages()
	if(drawYouKilledMessage) then
		dxDrawText(youkilledText, 0, sY*0.75, sX, sY*0.75, youkilledColor, fontsize, Font.Segoe, "center", "center", false, false, false, true, true)
	end
	if(drawKilledByMessage) then
		dxDrawText(killedbyText, 0, sY*0.8, sX, sY*0.8, killedbyColor, fontsize, Font.Segoe, "center", "center", false, false, false, true, true)
	end
end
addEventHandler('onClientRender', getRootElement(), drawKillMessages)

function killmessage(killer)
	youkilledColor = killmessageColor
	
	if(getLocalPlayer() == source and not killer) then
		youkilledText = 'You killed yourself'
		drawYouKilledMessage = true
		youkilledColor = selfkillColor
		
		if(youkilledTimer and isTimer(youkilledTimer)) then
			killTimer(youkilledTimer)
		end
		
		youkilledTimer = setTimer(
			function()
				drawYouKilledMessage = false
				youkilledColor = killmessageColor
			end,
			5000, 1
		)
		return
	end
	
	if(getLocalPlayer() == source and killer and getElementType(killer) == 'player') then
		killedbyText = 'Killed by '..getPlayerName(killer)
		drawKilledByMessage = true
		
		if(killedbyTimer and isTimer(killedbyTimer)) then
			killTimer(killedbyTimer)
		end
		
		killedbyTimer = setTimer(
			function()
				drawKilledByMessage = false
			end,
			5000, 1
		)
	elseif(getLocalPlayer() == killer and source and getElementType(source) == 'player') then
		youkilledText = 'You killed '..getPlayerName(source)
		drawYouKilledMessage = true
		
		if(youkilledTimer and isTimer(youkilledTimer)) then
			killTimer(youkilledTimer)
		end
		
		youkilledTimer = setTimer(
			function()
				drawYouKilledMessage = false
			end,
			5000, 1
		)
	end
end
addEvent('onClientKillmessage', true)
addEventHandler('onClientKillmessage', getRootElement(), killmessage)