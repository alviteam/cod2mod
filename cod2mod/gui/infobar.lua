Infobar = {}
Infobar.color = tocolor(0, 0, 0, 180)
Infobar.height = math.ceil(sY/20)
Infobar.offset = math.floor(Infobar.height/3)
Infobar.top = math.floor(sY - Infobar.height - Infobar.offset)
Infobar.bottom = Infobar.top + Infobar.height
Infobar.font = Font.Calibri

Infobar.teaminfo = {}
Infobar.teaminfo.size = Infobar.height + Infobar.offset*2
Infobar.teaminfo.top = Infobar.top - Infobar.offset
Infobar.teaminfo.text1 = {}
Infobar.teaminfo.text1.top = Infobar.top - math.ceil(Infobar.height * 0.1)
Infobar.teaminfo.text1.bottom = Infobar.top + math.ceil(Infobar.height * 0.8)
Infobar.teaminfo.text1.sample = 'XX'
Infobar.teaminfo.text1.font = dxCreateFont('fonts/Calibri.ttf', 36)
Infobar.teaminfo.text1.fontsize = Font.adjustSize(Infobar.teaminfo.text1.font, Infobar.teaminfo.text1.bottom - Infobar.teaminfo.text1.top)
Infobar.teaminfo.text2 = {}
Infobar.teaminfo.text2.top = Infobar.top + math.floor(Infobar.height * 0.6)
Infobar.teaminfo.text2.bottom = Infobar.bottom
Infobar.teaminfo.text2.sample = 'XX Alive'
Infobar.teaminfo.text2.font = dxCreateFont('fonts/Calibri.ttf', 16)
Infobar.teaminfo.text2.fontsize = Font.adjustSize(Infobar.teaminfo.text2.font, Infobar.teaminfo.text2.bottom - Infobar.teaminfo.text2.top)

Infobar.teaminfo[1] = {}
Infobar.teaminfo[1].left = Infobar.teaminfo.size / 2
Infobar.teaminfo[1].text = {}
Infobar.teaminfo[1].text.left = Infobar.teaminfo[1].left + Infobar.teaminfo.size + Infobar.offset
Infobar.teaminfo[2] = {}
Infobar.teaminfo[2].left = Infobar.teaminfo[1].text.left + (dxGetTextWidth(tostring(Infobar.teaminfo.text2.sample), Infobar.teaminfo.text2.fontsize, Infobar.teaminfo.text2.font) * 2.5)
Infobar.teaminfo[2].text = {}
Infobar.teaminfo[2].text.left = Infobar.teaminfo[2].left + Infobar.teaminfo.size + Infobar.offset

Infobar.fps = {}
Infobar.fps.color = tocolor(255, 255, 255, 180)
Infobar.fps.top = Infobar.top
Infobar.fps.bottom = Infobar.top + math.ceil(Infobar.height * 0.55)
Infobar.fps.font = dxCreateFont('fonts/Calibri.ttf', 20)
Infobar.fps.fontsize = Font.adjustSize(Infobar.fps.font, Infobar.fps.bottom - Infobar.fps.top)
Infobar.fps.sample = 'FPS: XXXXXX'
Infobar.fps.width = math.ceil(dxGetTextWidth(tostring(Infobar.fps.sample), Infobar.fps.fontsize, Infobar.fps.font))
Infobar.fps.left = sX - Infobar.fps.width - (Infobar.offset / 2)

Infobar.ping = {}
Infobar.ping.color = tocolor(255, 255, 255, 180)
Infobar.ping.top = Infobar.top + math.ceil(Infobar.height * 0.45)
Infobar.ping.bottom = Infobar.bottom
Infobar.ping.font = dxCreateFont('fonts/Calibri.ttf', 20)
Infobar.ping.fontsize = Font.adjustSize(Infobar.ping.font, Infobar.ping.bottom - Infobar.ping.top)
Infobar.ping.sample = 'Ping: XXXXXX'
Infobar.ping.left = sX - math.floor(dxGetTextWidth(tostring(Infobar.ping.sample), Infobar.ping.fontsize, Infobar.ping.font)) - math.floor(Infobar.offset / 2)

Infobar.logo = {}
Infobar.logo.ratio = 2.7
Infobar.logo.height = Infobar.height + (Infobar.offset * 1.5)
Infobar.logo.top = Infobar.top - math.floor(Infobar.offset * 0.4)
Infobar.logo.width = math.ceil(Infobar.logo.height * Infobar.logo.ratio)
Infobar.logo.left = math.ceil(sX / 2) - math.floor(Infobar.logo.width / 2)

Infobar.time = {}
Infobar.time.color = tocolor(255, 255, 255, 180)
Infobar.time.height = math.ceil(Infobar.height / 2)
Infobar.time.sample = 'XXXXXXXXXXXXXXX'
Infobar.time.font = dxCreateFont('fonts/Calibri.ttf', 20)
Infobar.time.fontsize = Font.adjustSize(Infobar.time.font, Infobar.time.height)
Infobar.time.width = math.ceil(dxGetTextWidth(tostring(Infobar.time.sample), Infobar.time.fontsize, Infobar.time.font))
Infobar.time.right = sX - (Infobar.fps.width * 2)
Infobar.time.left = Infobar.time.right - Infobar.time.width
Infobar.time.text1 = {}
Infobar.time.text1.top = Infobar.top
Infobar.time.text1.bottom = Infobar.top + Infobar.time.height + 2
Infobar.time.text2 = {}
Infobar.time.text2.top = Infobar.time.text1.bottom - 2
Infobar.time.text2.bottom = Infobar.bottom

Infobar.status = {}
Infobar.status.color = tocolor(255, 255, 255, 180)
Infobar.status.height = math.ceil(Infobar.height / 2)
Infobar.status.width = sX - 20
Infobar.status.left = 10
Infobar.status.right = sX - 10
Infobar.status.bottom = Infobar.top
Infobar.status.top = Infobar.status.bottom - Infobar.status.height
Infobar.status.font = dxCreateFont('fonts/Calibri.ttf', 20)
Infobar.status.fontsize = Font.adjustSize(Infobar.status.font, Infobar.status.bottom - Infobar.status.top)

Infobar.grenades = {}
Infobar.grenades.grenade_icon = "images/grenade.png"
Infobar.grenades.smoke_icon = "images/smoke.png"
Infobar.grenades.height = Infobar.height * 1.2
Infobar.grenades.font = dxCreateFont('fonts/Calibri.ttf', 20)
Infobar.grenades.fontsize = Font.adjustSize(Infobar.grenades.font, math.floor(Infobar.grenades.height / 2))
Infobar.grenades.top = {}
Infobar.grenades.top[1] = Infobar.status.top - Infobar.grenades.height * 1 - 10 * 1
Infobar.grenades.top[2] = Infobar.status.top - Infobar.grenades.height * 2 - 10 * 2
Infobar.grenades.label = {}
Infobar.grenades.label.sample = 'XX'
Infobar.grenades.label.width = math.ceil(dxGetTextWidth(tostring(Infobar.grenades.sample), Infobar.grenades.fontsize, Infobar.grenades.font)) + 10
Infobar.grenades.label.left = sX - Infobar.grenades.label.width
Infobar.grenades.label.bottom = {}
Infobar.grenades.label.bottom[1] = Infobar.grenades.top[1] + Infobar.grenades.height
Infobar.grenades.label.bottom[2] = Infobar.grenades.top[2] + Infobar.grenades.height
Infobar.grenades.left = Infobar.grenades.label.left - Infobar.grenades.height

IMG_LOGO = 'images/cod2mod_logo.png'
IMG_WHITE = 'images/country-ussr.png'
IMG_BLACK = 'images/country-axis.png'

-- addEventHandler('onResourceStart', getRootElement(),
	-- function()
		-- IMG_WHITE = call(getResourceFromName( "resource" ), "exportedFunction", 1, "2", "three" )
		-- IMG_BLACK = 
	-- end
-- )
	
addEventHandler('onClientRender', getRootElement(),
	function()
		SCORE_WHITE = tonumber(getElementData(WHITE, "Score") or 0) or 0
		SCORE_BLACK = tonumber(getElementData(BLACK, "Score") or 0) or 0
		
		ALIVE_WHITE = #(Team.getAlivePlayers(WHITE))
		ALIVE_BLACK = #(Team.getAlivePlayers(BLACK))
		if(ALIVE_WHITE < 10) then ALIVE_WHITE = '0'..ALIVE_WHITE end
		if(ALIVE_BLACK < 10) then ALIVE_BLACK = '0'..ALIVE_BLACK end
		
		if(FPS < FPS_LIMIT) then
			Infobar.fps.color = tocolor(255, 50, 50, 255)
		else
			Infobar.fps.color = tocolor(255, 255, 255, 180)
		end
		
		if(PING > PING_LIMIT) then
			Infobar.ping.color = tocolor(255, 50, 50, 255)
		else
			Infobar.ping.color = tocolor(255, 255, 255, 180)
		end
		
		if(FREEZE_TIME > 0) then
			GAME_STATUS = 'Starting round'
			ROUND_STATUS = 'Round starts in:'
		elseif(ROUND_TIME > 0) then
			if(MAP_NAME ~= '') then
				GAME_STATUS = 'Playing '..MAP_NAME
			end
			ROUND_STATUS = 'Round time:'
		else
			GAME_STATUS = 'Vote on a new map'
			ROUND_STATUS = 'Vote time:'
		end
		
		local minutes
		local seconds
		if(FREEZE_TIME > 0) then
			minutes = '0'
			seconds = FREEZE_TIME
		elseif(ROUND_TIME > 0) then
			if(ROUND_TIME >= 60) then
				minutes = math.floor(ROUND_TIME / 60)
				seconds = ROUND_TIME - (minutes * 60)
			else
				minutes = '0'
				seconds = ROUND_TIME
			end
		else
			minutes = '0'
			seconds = VOTE_TIME
		end
		if(seconds < 10) then
			seconds = '0'..seconds
		end
		Infobar.time.text = minutes..':'..seconds

		local grenadeCount = tonumber(getElementData(getLocalPlayer(), "frag") or 0) or nil
		local smokeCount = tonumber(getElementData(getLocalPlayer(), "smoke") or 0) or nil
		
		-- DRAWING
		dxDrawRectangle(0, Infobar.top, sX, Infobar.height, Infobar.color)
		dxDrawLine(0, Infobar.top, sX, Infobar.top, tocolor(255, 255, 255, 180))
		dxDrawLine(0, Infobar.bottom, sX, Infobar.bottom, tocolor(255, 255, 255, 180))
		
		dxDrawImage(Infobar.teaminfo[1].left, Infobar.teaminfo.top, Infobar.teaminfo.size, Infobar.teaminfo.size, IMG_WHITE)
		dxDrawText(SCORE_WHITE, Infobar.teaminfo[1].text.left, Infobar.teaminfo.text1.top, Infobar.teaminfo[1].text.left, Infobar.teaminfo.text1.bottom, tocolor(255, 255, 255, 180), Infobar.teaminfo.text1.fontsize, Infobar.teaminfo.text1.font, 'left', 'center')
		dxDrawText(ALIVE_WHITE..' Alive', Infobar.teaminfo[1].text.left + 1, Infobar.teaminfo.text2.top, Infobar.teaminfo[1].text.left, Infobar.teaminfo.text2.bottom, tocolor(190, 255, 190, 200), Infobar.teaminfo.text2.fontsize, Infobar.teaminfo.text2.font, 'left', 'center')
		
		dxDrawImage(Infobar.teaminfo[2].left, Infobar.teaminfo.top, Infobar.teaminfo.size, Infobar.teaminfo.size, IMG_BLACK)
		dxDrawText(SCORE_BLACK, Infobar.teaminfo[2].text.left, Infobar.teaminfo.text1.top, Infobar.teaminfo[2].text.left, Infobar.teaminfo.text1.bottom, tocolor(255, 255, 255, 180), Infobar.teaminfo.text1.fontsize, Infobar.teaminfo.text1.font, 'left', 'center')
		dxDrawText(ALIVE_BLACK..' Alive', Infobar.teaminfo[2].text.left + 1, Infobar.teaminfo.text2.top, Infobar.teaminfo[2].text.left, Infobar.teaminfo.text2.bottom, tocolor(190, 255, 190, 200), Infobar.teaminfo.text2.fontsize, Infobar.teaminfo.text2.font, 'left', 'center')
		
		dxDrawText('FPS: '..FPS, Infobar.fps.left, Infobar.fps.top, Infobar.fps.left, Infobar.fps.bottom, Infobar.fps.color, Infobar.fps.fontsize, Infobar.fps.font)
		dxDrawText('Ping: '..PING, Infobar.ping.left, Infobar.ping.top, Infobar.ping.left, Infobar.ping.bottom, Infobar.ping.color, Infobar.ping.fontsize, Infobar.ping.font)
		
		dxDrawImage(Infobar.logo.left, Infobar.logo.top, Infobar.logo.width, Infobar.logo.height, IMG_LOGO)

		dxDrawText(ROUND_STATUS, Infobar.time.left, Infobar.time.text1.top, Infobar.time.right, Infobar.time.text1.bottom, Infobar.time.color, Infobar.time.fontsize, Infobar.time.font, 'center', 'center')
		dxDrawText(Infobar.time.text, Infobar.time.left, Infobar.time.text2.top, Infobar.time.right, Infobar.time.text2.bottom, Infobar.time.color, Infobar.time.fontsize, Infobar.time.font, 'center', 'center')
		
		dxDrawText(GAME_STATUS, Infobar.status.left, Infobar.status.top, Infobar.status.right, Infobar.status.bottom, Infobar.status.color, Infobar.status.fontsize, Infobar.status.font, 'right', 'center')

		if (smokeCount ~= nil) then
			dxDrawImage(Infobar.grenades.left, Infobar.grenades.top[1], Infobar.grenades.height, Infobar.grenades.height, Infobar.grenades.smoke_icon)
			dxDrawText(smokeCount, Infobar.grenades.label.left, Infobar.grenades.top[1], sX, Infobar.grenades.label.bottom[1], Infobar.status.color, Infobar.grenades.fontsize, Infobar.grenades.font, 'left', 'center')
		end
		if (grenadeCount ~= nil) then
			dxDrawImage(Infobar.grenades.left, Infobar.grenades.top[2], Infobar.grenades.height, Infobar.grenades.height, Infobar.grenades.grenade_icon)
			dxDrawText(grenadeCount, Infobar.grenades.label.left, Infobar.grenades.top[2], sX, Infobar.grenades.label.bottom[2], Infobar.status.color, Infobar.grenades.fontsize, Infobar.grenades.font, 'left', 'center')
		end

		-- RESET
		Infobar.color = tocolor(0, 0, 0, 180)
	end
)

--TODO move to vars file
WEAPON_TEARGAS = 17

addEventHandler('onClientPlayerDamage', getRootElement(),
	function (attacker, weapon, bodypart, loss)
		if(source == getLocalPlayer() and weapon ~= WEAPON_TEARGAS) then
			Infobar.color = tocolor(255, 0, 0, 210)
		end
	end
)