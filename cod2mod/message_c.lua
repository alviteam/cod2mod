local screenWidth, screenHeight = guiGetScreenSize()
local GMMESSAGE = nil
local GMMheight = 0
local GMMdist = 0
local active = false

function receiveGMMessage(message)
	if(GMMESSAGE == nil) then
		GMMESSAGE = message
		active = true
		addEventHandler("onClientRender", getRootElement(), showGMMessage)
		return
	end
end

function showGMMessage()
	dxDrawRectangle(screenWidth/4, 0, screenWidth/2, GMMheight, tocolor(0, 0, 0, 100), true)
	if(GMMheight < 120 and active) then
		GMMheight = GMMheight + 10
	else
		if(GMMdist < 20) then
			GMMdist = GMMdist + 5
		else
			if(GMMESSAGE ~= nil and GMMheight >= 120) then
				dxDrawText(tostring(GMMESSAGE), screenWidth/4+5, GMMdist, screenWidth, screenHeight/GMMheight-10, tocolor(255, 255, 255, 255), 1.5, "verdana", "left", "top", false, true, true)
				setTimer(hideGMMessage, 5000, 1)
			end
		end
	end
end

function hideGMMessage()
	if(GMMheight > 0) then
		active = false
		GMMheight = GMMheight - 10
	else
		removeEventHandler("onClientRender", getRootElement(), showGMMessage)
		GMMESSAGE = nil
	end
end