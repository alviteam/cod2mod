ALLIES = getElementByID("TEAM_WHITE")
AXIS = getElementByID("TEAM_BLACK")
ALLIES_COUNTRY = nil
AXIS_COUNTRY = nil
PLANT_PROGRESS = 0
DEFUSE_PROGRESS = 0
SPAWN = false
SD = false
SD_CLOCK_ROT = 0
WEAPON_TYPE = 0
WEAPONS = {
{"Sten", "MP40"},
{"M1A1 Carbine", "Gewehr 43"},
{"Mosin-Nagant", "Kar98k"},
{"Springfield", "Scoped KAR98k"},
{"M1897 Trench Gun", "M1897 Trench Gun"},
{"Thompson", "MP44"},
{"AK-47", "M4"},
{"Engineer", "Engineer"},
{"Medic", "Medic"},
{"Signaller", "Signaller"}
}

addEventHandler('onClientResourceStart', getResourceRootElement(getThisResource()),
	function ()
		createMenu()
	end
)

local screenWidth, screenHeight = guiGetScreenSize()

chooseTeam = guiCreateWindow(0.2, 0.3, 0.6, 0.4, "Select your team", true)
guiSetVisible(chooseTeam, false)
logoTeam = guiCreateStaticImage(0, 0.05, 1, 1, "images/logo.png", true, chooseTeam)
icon = guiCreateStaticImage(0.47, 0.7, 0.06, 0.25, "images/icon.png", true, chooseTeam)
select_allies = guiCreateButton(0.1, 0.75, 0.3, 0.15, "Allies", true, chooseTeam)
select_axis = guiCreateButton(0.6, 0.75, 0.3, 0.15, "Axis", true, chooseTeam)
website = guiCreateLabel(0.02, 0.92, 0.5, 0.05, "http://cod2mod.bmat.pl", true, chooseTeam)
guiSetFont(website, "clear-normal")

chooseWeapon = guiCreateWindow(screenWidth/2-400, screenHeight/2-300, 800, 600, "Select your class", false)
guiSetVisible(chooseWeapon, false)
bgClass = guiCreateStaticImage(0, 0.05, 1, 1, "images/bg.png", true, chooseWeapon)
select_lightsmg = guiCreateButton(0.02, 0.07, 0.3, 0.1, "", true, chooseWeapon)
select_semi = guiCreateButton(0.02, 0.19, 0.3, 0.1, "", true, chooseWeapon)
select_bolt = guiCreateButton(0.02, 0.31, 0.3, 0.1, "", true, chooseWeapon)
select_sniper = guiCreateButton(0.02, 0.43, 0.3, 0.1, "", true, chooseWeapon)
select_shotgun = guiCreateButton(0.02, 0.55, 0.3, 0.1, "", true, chooseWeapon)
select_smg = guiCreateButton(0.02, 0.67, 0.3, 0.1, "", true, chooseWeapon)
select_modern = guiCreateButton(0.35, 0.07, 0.3, 0.1, "", true, chooseWeapon)
select_engineer = guiCreateButton(0.35, 0.19, 0.3, 0.1, "", true, chooseWeapon)
select_medic = guiCreateButton(0.35, 0.31, 0.3, 0.1, "", true, chooseWeapon)
select_signaller = guiCreateButton(0.35, 0.43, 0.3, 0.1, "", true, chooseWeapon)
cancel_button_weapons = guiCreateButton(0.775, 0.9, 0.2, 0.075, "Cancel", true, chooseWeapon)
website = guiCreateLabel(0.02, 0.95, 0.5, 0.05, "http://cod2mod.bmat.pl", true, chooseWeapon)
guiSetFont(website, "clear-normal")

voteWindow = guiCreateWindow(screenWidth-460, 0, 450, screenHeight*0.97, "Vote next map", false)
guiSetVisible(voteWindow, false)
mapsToVote = guiCreateGridList(0.05, 0.03, 0.42, 0.95, true, voteWindow)
gamesToVote = guiCreateGridList(0.525, 0.03, 0.42, 0.3, true, voteWindow)
mapsColumn = guiGridListAddColumn(mapsToVote, "Maps", 0.85)
gamesColumn = guiGridListAddColumn(gamesToVote, "Game types", 0.85)
tdmRow = guiGridListAddRow(gamesToVote)
sdRow = guiGridListAddRow(gamesToVote)
ctfRow = guiGridListAddRow(gamesToVote)
tdmVoteItem = guiGridListSetItemText(gamesToVote, tdmRow, gamesColumn, "Team Death Match", false, false)
ctfVoteItem = guiGridListSetItemText(gamesToVote, ctfRow, gamesColumn, "Capture The Flag", false, false)
timeRemainingItem = guiCreateButton(0.525, 0.9, 0.4, 0.05, tostring(20), true, voteWindow)

bomb_ticker_frame = guiCreateStaticImage(0.35, 0.5, 0.3, 0.025, "images/bomb_ticker_frame.png", true)
bomb_ticker = guiCreateStaticImage(0.351, 0.5, 0, 0.025, "images/bomb_ticker.png", true)
guiSetVisible(bomb_ticker_frame, false)
guiSetVisible(bomb_ticker, false)

function resizeVoteWindow( numMaps )
	local voteRect		= { screenWidth-450,	screenHeight-450,	400,				400 }
	local mapsRect		= { voteRect[3] * 0.05,	voteRect[4] * 0.1,	voteRect[3] * 0.42,	voteRect[4] * 0.7 }
	local gamesRect		= { voteRect[3] * 0.525,voteRect[4] * 0.1,	voteRect[3] * 0.42,	voteRect[4] * 0.7 }
	local buttonRect	= { voteRect[3] * 0.3,	voteRect[4] * 0.85,	voteRect[3] * 0.4,	voteRect[4] * 0.1 }
	local minHeight = numMaps * 14 + 40
	-- increase height
	local increase = minHeight - mapsRect[4]
	if increase > 0 then
		increase = math.min( increase, voteRect[2] )
		voteRect[2] = voteRect[2] - increase
		voteRect[4] = voteRect[4] + increase
		mapsRect[4] = mapsRect[4] + increase
		buttonRect[2] = buttonRect[2] + increase
	end
	-- increase width
	increase = 50
	if increase > 0 then
		increase = math.min( increase, voteRect[1] )
		voteRect[1] = voteRect[1] - increase
		voteRect[3] = voteRect[3] + increase
		mapsRect[3] = mapsRect[3] + increase
		gamesRect[1]= gamesRect[1] + increase
		buttonRect[1] = buttonRect[1] + increase / 2
	end
	guiSetPosition ( voteWindow, voteRect[1], voteRect[2], false )
	guiSetPosition ( mapsToVote, mapsRect[1], mapsRect[2], false )
	guiSetPosition ( gamesToVote, gamesRect[1], gamesRect[2], false )
	guiSetSize ( voteWindow, voteRect[3], voteRect[4], false )
	guiSetSize ( mapsToVote, mapsRect[3], mapsRect[4], false )
	guiSetSize ( gamesToVote, gamesRect[3], gamesRect[4], false )
end

function startVoting(maps,votingTime)
	if(isTimer(voteTimer)) then
		outputChatBox("* cod2mod voting system: Vote pending!", 255, 100, 100, true)
		return false
	end
	VOTE_TIME = votingTime
	guiSetText(timeRemainingItem, tostring(votingTime))
	while guiGridListGetRowCount(mapsToVote) > 0 do
		guiGridListRemoveRow(mapsToVote, 0)
	end
	for i=1, #maps do
		local row = guiGridListAddRow(mapsToVote)
		guiGridListSetItemText(mapsToVote, row, mapsColumn, tostring(maps[i]), false, false)
	end
	--resizeVoteWindow(#maps)
	guiSetVisible(voteWindow, true)
	showCursor(true)
	voteTimer = setTimer(votingCounter, 1000, 1)
end

function votingCounter()
	guiSetText(timeRemainingItem, tonumber(guiGetText(timeRemainingItem)) - 1)
	if(tonumber(guiGetText(timeRemainingItem)) >= 0) then
		voteTimer = setTimer(votingCounter, 1000, 1)
	else
		guiSetVisible(voteWindow, false)
		callServerFunction("voteEndedStartMap", getLocalPlayer())
	end
end

function chooseVoteOption()
	if(source == bgClass) then
		guiMoveToBack(bgClass)
	end
	if(source == logoTeam) then
		guiMoveToBack(logoTeam)
	end
	if(source == mapsToVote) then
		local item = guiGridListGetItemText(mapsToVote, guiGridListGetSelectedItem(mapsToVote), 1)
		setElementData(getLocalPlayer(), "vote", tostring(item))
	end
	if(source == gamesToVote) then
		local item = guiGridListGetItemText(gamesToVote, guiGridListGetSelectedItem(gamesToVote), 1)
		setElementData(getLocalPlayer(), "vote2", tostring(item))
	end
end
addEventHandler("onClientGUIClick", getRootElement(), chooseVoteOption)

function setCountries(allies, axis)
	ALLIES_COUNTRY = allies
	AXIS_COUNTRY = axis
end

function createMenu()
	guiSetVisible(chooseTeam, true)
	showCursor(true)
end

function createWeaponMenu()
	guiSetVisible(chooseWeapon, true)
	showCursor(true)
end

function chooseAllies(button, state)
	local allies = countPlayersInTeam(ALLIES)
	local axis = countPlayersInTeam(AXIS)
	if(allies <= axis) then
		outputChatBox("* "..getPlayerName(getLocalPlayer()).. " Joined Allies", 255, 100, 100, true)
		callServerFunction("setPlayerTeamServer", getLocalPlayer(), ALLIES)
		WEAPON_TYPE = 1
		guiSetVisible(chooseTeam, false)
		guiSetVisible(chooseWeapon, true)
	else
		outputChatBox("Too many players in Allies team!", getLocalPlayer())
	end

	unbindKey("g")
	unbindKey("4")
	bindKey("g", "up", throwGrenade, getLocalPlayer())
	bindKey("4", "up", throwSmoke, getLocalPlayer())
end
addEventHandler("onClientGUIClick", select_allies, chooseAllies, false)

function chooseAxis(button, state)
	local allies = countPlayersInTeam(ALLIES)
	local axis = countPlayersInTeam(AXIS)
	if(allies >= axis) then
		outputChatBox("* "..getPlayerName(getLocalPlayer()).. " Joined Axis", 255, 100, 100, true)
		callServerFunction("setPlayerTeamServer", getLocalPlayer(), AXIS)
		WEAPON_TYPE = 2
		guiSetVisible(chooseTeam, false)
		guiSetVisible(chooseWeapon, true)
	else
		outputChatBox("Too many players in Axis team!", getLocalPlayer())
	end

	unbindKey("g")
	unbindKey("4")
	bindKey("g", "up", throwGrenade, getLocalPlayer())
	bindKey("4", "up", throwSmoke, getLocalPlayer())
end
addEventHandler("onClientGUIClick", select_axis, chooseAxis, false)

function onClientGUIClick()
	if(source == select_lightsmg) then
		guiSetVisible(chooseWeapon, false)
		showCursor(false)
		setElementData(getLocalPlayer(), "type", "lightsmg")
		callServerFunction("onPlayerChangeTeamOrWeapon", getLocalPlayer())
	end
	if(source == select_semi) then
		guiSetVisible(chooseWeapon, false)
		showCursor(false)
		setElementData(getLocalPlayer(), "type", "semiauto")
		callServerFunction("onPlayerChangeTeamOrWeapon", getLocalPlayer())
	end
	if(source == select_bolt) then
		guiSetVisible(chooseWeapon, false)
		showCursor(false)
		setElementData(getLocalPlayer(), "type", "boltaction")
		callServerFunction("onPlayerChangeTeamOrWeapon", getLocalPlayer())
	end
	if(source == select_sniper) then
		guiSetVisible(chooseWeapon, false)
		showCursor(false)
		setElementData(getLocalPlayer(), "type", "sniper")
		callServerFunction("onPlayerChangeTeamOrWeapon", getLocalPlayer())
	end
	if(source == select_shotgun) then
		guiSetVisible(chooseWeapon, false)
		showCursor(false)
		setElementData(getLocalPlayer(), "type", "shotgun")
		callServerFunction("onPlayerChangeTeamOrWeapon", getLocalPlayer())
	end
	if(source == select_smg) then
		guiSetVisible(chooseWeapon, false)
		showCursor(false)
		setElementData(getLocalPlayer(), "type", "smg")
		callServerFunction("onPlayerChangeTeamOrWeapon", getLocalPlayer())
	end
	if(source == select_modern) then
		guiSetVisible(chooseWeapon, false)
		showCursor(false)
		setElementData(getLocalPlayer(), "type", "modern")
		callServerFunction("onPlayerChangeTeamOrWeapon", getLocalPlayer())
	end
	if(source == select_engineer) then
		guiSetVisible(chooseWeapon, false)
		showCursor(false)
		setElementData(getLocalPlayer(), "type", "engineer")
		callServerFunction("onPlayerChangeTeamOrWeapon", getLocalPlayer())
	end
	if(source == select_medic) then
		guiSetVisible(chooseWeapon, false)
		showCursor(false)
		setElementData(getLocalPlayer(), "type", "medic")
		callServerFunction("onPlayerChangeTeamOrWeapon", getLocalPlayer())
	end
	if(source == select_signaller) then
		guiSetVisible(chooseWeapon, false)
		showCursor(false)
		setElementData(getLocalPlayer(), "type", "signaller")
		callServerFunction("onPlayerChangeTeamOrWeapon", getLocalPlayer())
	end
	if(source == cancel_button_weapons) then
		guiSetVisible(chooseWeapon, false)
		showCursor(false)
	end
	
	guiSetText(select_lightsmg, tostring(WEAPONS[1][tonumber(WEAPON_TYPE)]))
	guiSetText(select_semi, tostring(WEAPONS[2][tonumber(WEAPON_TYPE)]))
	guiSetText(select_bolt, tostring(WEAPONS[3][tonumber(WEAPON_TYPE)]))
	guiSetText(select_sniper, tostring(WEAPONS[4][tonumber(WEAPON_TYPE)]))
	guiSetText(select_shotgun, tostring(WEAPONS[5][tonumber(WEAPON_TYPE)]))
	guiSetText(select_smg, tostring(WEAPONS[6][tonumber(WEAPON_TYPE)]))
	guiSetText(select_modern, tostring(WEAPONS[7][tonumber(WEAPON_TYPE)]))
	guiSetText(select_engineer, tostring(WEAPONS[8][tonumber(WEAPON_TYPE)]))
	guiSetText(select_medic, tostring(WEAPONS[9][tonumber(WEAPON_TYPE)]))
	guiSetText(select_signaller, tostring(WEAPONS[10][tonumber(WEAPON_TYPE)]))
end
addEventHandler("onClientGUIClick", getRootElement(), onClientGUIClick)

local lastShowTime = 0
function onClientPlayerWeaponFireFunc(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
    if(getElementType(source)=="player") then
		if(not isQuietWeapon(weapon)) then
			if getTickCount() - lastShowTime > 1000 then
				lastShowTime = getTickCount()
				callServerFunction("showPlayerOnMap", getLocalPlayer())
			end
		end
    end
end
addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(), onClientPlayerWeaponFireFunc)

function onClientPlayerWasted(killer, weapon, bodypart)
	for i,object in ipairs(getElementsByType("object")) do
		if(getElementModel(object) == 2985) then
			if(getElementData(getLocalPlayer(), "alreadyUseRKM") == "true") then
				detachElements(object, getLocalPlayer())
				setCameraTarget(getLocalPlayer(), getLocalPlayer())
				callServerFunction("takeWeaponServer", getLocalPlayer(), 38)
				setElementFrozen(getLocalPlayer(), false)
				setElementData(getLocalPlayer(), "alreadyUseRKM", "false")
			end
		end
	end
end
addEventHandler("onClientPlayerWasted", getLocalPlayer(), onClientPlayerWasted)

function showSpawnExclamation()
	SPAWN = true
end

function hideSpawnExclamation()
	SPAWN = false
end

function showPlantExclamation()
	SD = true
end

function hidePlantExclamation()
	SD = false
end

function showScore()
	local weapon = getPedWeapon(getLocalPlayer())
	local ammo = 0  clips = 0
	if(isReloadWeapon(weapon)) then
		clips = getPedTotalAmmo(getLocalPlayer()) - getPedAmmoInClip(getLocalPlayer())
		ammo = getPedAmmoInClip(getLocalPlayer())
	end
	if(isNotReloadWeapon(weapon)) then
		ammo = getPedTotalAmmo(getLocalPlayer())
	end
	
	if(SD_CLOCK_ROT < 0) then
		dxDrawImage(10, 400, 100, 100, "images/sd_clock.png")
		dxDrawImage(10, 400, 100, 100, "images/sd_needle.png", tonumber(SD_CLOCK_ROT), 0, 0)
	end
	if(SD_CLOCK_ROT >= 360) then
		dxDrawImage(screenWidth-200, screenHeight/2, 100, 100, "images/sd_clock.png")
		dxDrawImage(screenWidth-200, screenHeight/2, 100, 100, "images/sd_needle.png", tonumber(SD_CLOCK_ROT), 0, 0)
		dxDrawText("Round "..tonumber(getElementData(ALLIES, "Score")+getElementData(AXIS, "Score"))+1 .." started",
			screenWidth-200, screenHeight/2+100, 200, screenHeight/2-100, tocolor(255, 255, 255, 255), 2)
	end


	local myteam_flag
	if getPlayerTeam(getLocalPlayer()) == ALLIES then
		myteam_flag = allies_flag
	elseif getPlayerTeam(getLocalPlayer()) == AXIS then
		myteam_flag = axis_flag
	end
	
	if(SPAWN) then
		local font = "bankgothic" 
		local scale = 1
		local text = "PRESS |F| to respawn"
		local width = dxGetTextWidth(text, scale, font)
		dxDrawText(text, screenWidth/2-(width/2), screenHeight/10*9, screenWidth/2-(width/2), screenHeight/10*9, tocolor(255,255,255), scale, tostring(font))
	end
	
	for i,player in ipairs(getElementsByType("player")) do
		if(getPlayerTeam(player) == getPlayerTeam(getLocalPlayer()) and player ~= getLocalPlayer()) then
			local x,y,z = getElementPosition(player)
			local x2,y2,z2 = getElementPosition(getLocalPlayer())
			local distance = getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)
			if(distance <= 50 and distance >= 10) then
				local sx1, sy1 = getScreenFromWorldPosition(x, y, z+1.6, 0, false)
				local sx2, sy2 = getScreenFromWorldPosition(x, y, z+1.1, 0, false)
                if sx1 and sx2 and myteam_flag then
					local alpha1 = math.unlerpclamped( 50,40, distance )						
					local alpha2 = math.unlerpclamped( 10,20, distance )
					local alpha = alpha1 * alpha2
					local wide = math.abs(sy2-sy1)
                    dxDrawImage(sx1-wide/2, sy1, wide, wide, tostring(myteam_flag),0,0,0,tocolor(255,255,255,alpha*255))
                end
			end
		end
	end
	-- Following
	if(isElement(getCameraTarget(getLocalPlayer()))) then
		if(getElementType(getCameraTarget(getLocalPlayer())) == "player") then
			if(getCameraTarget(getLocalPlayer()) ~= getLocalPlayer()) then
				local text = "Following "..getPlayerName(getCameraTarget(getLocalPlayer()))
				local width = dxGetTextWidth(text, 1.7, "default-bold")
				dxDrawText(text, screenWidth/2-(width/2), screenHeight/6, screenWidth/2-(width/2), screenHeight/6, tocolor(255, 255, 255, 255), 1.7, "default-bold")
			end
		end
	end
	-- Use [F]
	for i,object in ipairs(getElementsByType("object")) do
		local x1, y1, z1 = getElementPosition(object)
		if(SD == true) then
			if(getElementModel(object) == 3884) then
				local x2, y2, z2 = getElementPosition(getLocalPlayer())
				if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= 3) then
					dxDrawText("Hold USE [F] to plant/defuse explosives", screenWidth/2-50, screenHeight/2-100)
				end
			end
		end
		if(getElementModel(object) == 2985) then
			local x2, y2, z2 = getElementPosition(getLocalPlayer())
			if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= 3) then
				dxDrawText("Press USE [F] to use", screenWidth/2-50, screenHeight/2-100)
			end
		end
		if(getElementModel(object) == 1575) then
			local x2, y2, z2 = getElementPosition(getLocalPlayer())
			if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= 3) then
				dxDrawText("Press USE [F] to pick up", screenWidth/2-50, screenHeight/2-100)
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement(), showScore)

function throwGrenade()
	local grenades = getElementData(getLocalPlayer(), "frag")
	if(tonumber(grenades) > 0 and not isPlayerDead(getLocalPlayer())) then
		local x1, y1, z1 = getElementPosition(getLocalPlayer())
		local x2, y2, z2 = getWorldFromScreenPosition(screenWidth/2, screenHeight/2, 100)
		local force = getDistanceBetweenPoints2D(x1, y1, x2, y2)
		setPedAnimation(getLocalPlayer(), "GRENADE", "WEAPON_throw", 1000, false, false)
		setTimer(setPedAnimation, 1000, 1, getLocalPlayer())
		local projectileGrenade = createProjectile(getLocalPlayer(), 16, x1, y1, z1+0.5, force/100)
		setElementCollidableWith(projectileGrenade, getRootElement(), false)
		grenades = grenades - 1
		setElementData(getLocalPlayer(), "frag", tostring(grenades))
	end
end
addCommandHandler("g", throwGrenade)

function throwSmoke()
	local smokes = getElementData(getLocalPlayer(), "smoke")
	if(tonumber(smokes) > 0 and not isPlayerDead(getLocalPlayer())) then
		local x1, y1, z1 = getElementPosition(getLocalPlayer())
		local x2, y2, z2 = getWorldFromScreenPosition(screenWidth/2, screenHeight/2, 100)
		local force = getDistanceBetweenPoints2D(x1, y1, x2, y2)
		setPedAnimation(getLocalPlayer(), "GRENADE", "WEAPON_throw", 1000, false, false)
		setTimer(setPedAnimation, 1000, 1, getLocalPlayer())
		local projectileSmoke = createProjectile(getLocalPlayer(), 17, x1, y1, z1+0.5, force/100)
		setElementCollidableWith(projectileSmoke, getRootElement(), false)
		smokes = smokes - 1
		setElementData(getLocalPlayer(), "smoke", tostring(smokes))
	end
end
addCommandHandler("4", throwSmoke)

addEventHandler("onClientPedChoke", getRootElement(),
    function()
        cancelEvent();
    end
);

function artilleryCalled(x, y, z)
	createProjectile(getLocalPlayer(), 21, x, y, z+50, 1.0)
	setTimer(createProjectile, 2000, 1, getLocalPlayer(), 21, x-1, y, z+50, 1.0)
	setTimer(createProjectile, 3000, 1, getLocalPlayer(), 21, x, y-1, z+50, 1.0)
	setTimer(createProjectile, 5000, 1, getLocalPlayer(), 21, x+1, y+1, z+50, 1.0)
end

function drawBombPlanted()
	PLANT_PROGRESS = 0
	guiSetVisible(bomb_ticker_frame, true)
	guiSetVisible(bomb_ticker, true)
	planttimer = setTimer(increasePlantProgress, 50, 100)
end

function increasePlantProgress()
	if(getKeyState("f") == true) then
		PLANT_PROGRESS = PLANT_PROGRESS + 0.003
		guiSetSize(bomb_ticker, tonumber(PLANT_PROGRESS), 0.025, true)
	else
		killTimer(planttimer)
		guiSetVisible(bomb_ticker_frame, false)
		guiSetVisible(bomb_ticker, false)
		PLANT_PROGRESS = 0
		guiSetSize(bomb_ticker, 0, 0.025, true)
	end
	if(tonumber(PLANT_PROGRESS) >= 0.3) then
		guiSetVisible(bomb_ticker_frame, false)
		guiSetVisible(bomb_ticker, false)
		PLANT_PROGRESS = 0
		guiSetSize(bomb_ticker, 0, 0.025, true)
		callServerFunction("playPlantBombForAll")
		callServerFunction("timerPlantedBombForAll")
		callServerFunction("createBomb", getLocalPlayer())
	end
end

function drawBombDefused()
	DEFUSE_PROGRESS = 0
	guiSetVisible(bomb_ticker_frame, true)
	guiSetVisible(bomb_ticker, true)
	defusetimer = setTimer(increaseDefuseProgress, 50, 100)
end

function increaseDefuseProgress()
	if(getKeyState("f") == true) then
		DEFUSE_PROGRESS = DEFUSE_PROGRESS + 0.003
		guiSetSize(bomb_ticker, tonumber(DEFUSE_PROGRESS), 0.025, true)
	else
		killTimer(defusetimer)
		guiSetVisible(bomb_ticker_frame, false)
		guiSetVisible(bomb_ticker, false)
		DEFUSE_PROGRESS = 0
		guiSetSize(bomb_ticker, 0, 0.025, true)
	end
	if(tonumber(DEFUSE_PROGRESS) >= 0.3) then
		guiSetVisible(bomb_ticker_frame, false)
		guiSetVisible(bomb_ticker, false)
		DEFUSE_PROGRESS = 0
		guiSetSize(bomb_ticker, 0, 0.025, true)
		callServerFunction("playDefuseBombForAll")
		callServerFunction("destroyBomb", getLocalPlayer())
		killTimersOnDefuse()
	end
end

function drawTimerRoundStart()
	if(isTimer(timerOnRoundStart)) then killTimer(timerOnRoundStart) end
	SD_CLOCK_ROT = 420
	timerOnRoundStart = setTimer(timerPlantedBomb, 1000, 10)
end

function drawTimerPlantedBomb()
	if(isTimer(timeOnExplodeClock)) then killTimer(timeOnExplodeClock) end
	if(isTimer(timeToExplodeTimer)) then killTimer(timeToExplodeTimer) end
	timeOnExplodeClock = setTimer(timerPlantedBomb, 1000, 60)
	timeToExplodeTimer = setTimer(callServerFunction, 62000, 1, "explodeBomb")
end

function timerPlantedBomb()
	SD_CLOCK_ROT = SD_CLOCK_ROT - 6
end

function useRKM()
	for i,object in ipairs(getElementsByType("object")) do
	if(getElementModel(object) == 2985) then
		local x1, y1, z1 = getElementPosition(object)
		local x2, y2, z2 = getElementPosition(getLocalPlayer())
		if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= 5) then
			if(getElementData(getLocalPlayer(), "alreadyUseRKM") == "true") then
				setCameraTarget(getLocalPlayer(), getLocalPlayer())
				callServerFunction("takeWeaponServer", getLocalPlayer(), 38)
				setElementFrozen(getLocalPlayer(), false)
				setElementData(getLocalPlayer(), "alreadyUseRKM", "false")
			elseif(getElementData(getLocalPlayer(), "alreadyUseRKM") == "false") then
				callServerFunction("giveWeaponServer", getLocalPlayer(), 38, 100, true)
				setElementFrozen(getLocalPlayer(), true)
				setElementData(getLocalPlayer(), "alreadyUseRKM", "true")
			end
			break
		end
	end
	end
end

function killTimersOnDefuse()
	SD_CLOCK_ROT = 0
	if(isTimer(planttimer)) then killTimer(planttimer) end
	if(isTimer(timerOnRoundStart)) then killTimer(timerOnRoundStart) end
	if(isTimer(timeOnExplodeClock)) then killTimer(timeOnExplodeClock) end
	if(isTimer(timeToExplodeTimer)) then killTimer(timeToExplodeTimer) end
end

function deathSlowMotion(totalAmmo, killer, killerWeapon, bodypart)
	if(source == getLocalPlayer()) then
		addEventHandler("onClientRender", getRootElement(), deathRenderSlowMotion)
		setGameSpeed(0.6)
		setTimer(deathStopSlowMotion, 1000, 1)
	end
end
--addEventHandler("onClientPlayerWasted", getRootElement(), deathSlowMotion)

function deathRenderSlowMotion()
	dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0, 100), true)
end

function deathStopSlowMotion()
	removeEventHandler("onClientRender", getRootElement(), deathRenderSlowMotion)
	setGameSpeed(1)
end

--------------------------------------------
-----[ DISABLE SMOKES - UNDER TESTING ]-----
--------------------------------------------
function disableSmokeEffect(attacker, weapon, bodypart, loss)
	if(weapon == 17) then
		cancelEvent()
	end
end
addEventHandler("onClientPlayerDamage", getRootElement(), disableSmokeEffect)
--------------------------------------------
-----[ DISABLE SMOKES - UNDER TESTING ]-----
--------------------------------------------

--------------------
-----[ SOUNDS ]-----
--------------------
function playAlliesWin()
	setTimer(playSound, 3000, 1, "sounds/allies_win.wav", false)
end

function playAxisWin()
	setTimer(playSound, 3000, 1, "sounds/axis_win.wav", false)
end

function playAlliesEliminated()
	setTimer(playSound, 1000, 1, "sounds/allies_elim.wav", false)
end

function playAxisEliminated()
	setTimer(playSound, 1000, 1, "sounds/axis_elim.wav", false)
end

function playRoundDraw()
	setTimer(playSound, 3000, 1, "sounds/round_draw.wav", false)
end

function playBombPlanted()
	setTimer(playSound, 1000, 1, "sounds/bomb_planted.wav", false)
end

function playBombDefused()
	setTimer(playSound, 1000, 1, "sounds/bomb_defused.wav", false)
	setTimer(playSound, 3000, 1, "sounds/axis_win.wav", false)
end

function playObjectiveDestroyed()
	setTimer(playSound, 1000, 1, "sounds/objective_destroyed.wav", false)
	setTimer(playSound, 3000, 1, "sounds/allies_win.wav", false)
end

function playFlagTaken()
	setTimer(playSound, 1000, 1, "sounds/flag_taken.wav", false)
end

function playFlagDropped()
	setTimer(playSound, 1000, 1, "sounds/flag_dropped.wav", false)
end

function playFlagReturned()
	setTimer(playSound, 1000, 1, "sounds/flag_returned.wav", false)
end

function playFlagCaptured()
	setTimer(playSound, 1000, 1, "sounds/flag_captured.wav", false)
end
--------------------
-----[ SOUNDS ]-----
--------------------

---------------------------
-----[ FPP FUNCTIONS ]-----
---------------------------
local x, y, z, x1, y1, z1
local fpcam = false
 
bindKey( "F2", "down",
   function()
      if fpcam then
         setCameraTarget(getLocalPlayer(), getLocalPlayer())
      end
      fpcam = not fpcam
   end
)
 
addEventHandler("onClientPreRender", root,
	function()
		if fpcam then
			x, y, z = getPedBonePosition(getLocalPlayer(), 6)
			setCameraMatrix(x, y, z, x + x1, y + y1, z + z1)
			dxDrawImage(screenWidth/2-10, screenHeight/2-10, 20, 20, "images/aimer.png")
			local tarX, tarY, tarZ = getWorldFromScreenPosition(screenWidth/2, screenHeight/2, 30)
			setPedAimTarget(getLocalPlayer(), tarX, tarY, tarZ)
		end
	end
)
 
addEventHandler("onClientCursorMove", root,
	function( _, _, _, _, wx, wy, wz )
		local cx, cy, cz = getCameraMatrix()
		x1 = ( wx - cx ) / 300
		y1 = ( wy - cy ) / 300
		z1 = ( wz - cz ) / 300
	end
)
---------------------------
-----[ FPP FUNCTIONS ]-----
---------------------------

-----------------------------
-----[ OTHER FUNCTIONS ]-----
-----------------------------
function isReloadWeapon(weapon)
	id = tonumber(weapon)
	if(id == 22 or id == 23 or id == 24 or id == 26 or id == 27 or id == 28 or id == 29 or id == 32 
		or id == 30 or id == 31 or id == 37 or id == 38 or id == 41 or id == 42 or id == 43) then
		return true
	else
		return false
	end
end

function isNotReloadWeapon(weapon)
	id = tonumber(weapon)
	if(id == 25 or id == 33 or id == 34 or id == 35 or id == 36) then --Projectiles isn't count
		return true
	else
		return false
	end
end

function isQuietWeapon(weaponid)
	if(weaponid >= 0 and weaponid <= 8 or weaponid == 23 or weaponid == 15 or weaponid == 41) then
		return true
	end
	return false
end
-----------------------------
-----[ OTHER FUNCTIONS ]-----
-----------------------------


----------------------------
-- Smoke check
----------------------------
function getClosestThrowDistance(px,py,prot, sx,sy)
	local dx = 6*4*math.cos(math.rad(prot + 90))
	local dy = 6*4*math.sin(math.rad(prot + 90))
	local closest = 9999
	for i=0.5,1,0.25 do
		local tx = px + dx * i
		local ty = py + dy * i
		local dist = getDistanceBetweenPoints2D(tx, ty, sx, sy)
		closest = math.min( closest, dist )
	end
	return closest
end

local MIN_SMOKE_DIST = 30
local lastTooClose = false
local lastTooCloseTime = 0
function isTooCloseForSmoke( bNoCache )
	if bNoCache or getTickCount() - lastTooCloseTime > 200 then
		lastTooCloseTime = getTickCount()
		lastTooClose = doIsTooCloseForSmoke()
	end
	return lastTooClose
end

function doIsTooCloseForSmoke()
	local px, py = getElementPosition(getLocalPlayer())
	local _, _, prot = getElementRotation(getLocalPlayer())
	local spawnAllies = getElementData( resourceRoot, "spawnAllies" )
	local spawnAxis = getElementData( resourceRoot, "spawnAxis" )
	if type(spawnAllies) == "table" then
		for i,pos in ipairs(spawnAllies) do
			local dist = getClosestThrowDistance(px,py,prot, pos[1], pos[2])
			if dist < MIN_SMOKE_DIST then
				return true
			end
		end
	end
	if type(spawnAxis) == "table" then
		for i,pos in ipairs(spawnAxis) do
			local dist = getClosestThrowDistance(px,py,prot, pos[1], pos[2])
			if dist < MIN_SMOKE_DIST then
				return true
			end
		end
	end
	return false
end



----------------------------
-- Fire blips
----------------------------
local firePlayerList = {}
function showFireBlip(other)
	local info = {}
	info.blip = createBlipAttachedTo(other, 0, 2, 255, 0, 0, 128, 10 )
	info.createTime = getTickCount()
	table.insert(firePlayerList, info)
end

addEventHandler("onClientRender", root,
	function()
		local tickCount = getTickCount()
		for i,info in ipairs(firePlayerList) do
			local u = math.unlerp(info.createTime+2000, info.createTime, tickCount)
			if u <= 0 then
				destroyElement(info.blip)
				table.removevalue( firePlayerList, info )
			else
				setBlipSize(info.blip, 1 + 10 * (1-u) )
				setBlipColor(info.blip, 255, 0, 0, 128 * u * u * u * u )
			end
		end
	end
)

-----------------------
-----[ ANTI PING ]-----
-----------------------
local pingCounter = 0
local pingWarning = false
setTimer(function()
	if(getPlayerPing(getLocalPlayer()) >= 750) then
		pingCounter = pingCounter + 1
	else
		if(pingCounter > 1) then
			pingCounter = pingCounter - 1
		end
	end
	if(pingCounter >= 70) then
		pingWarning = true
	else
		pingWarning = false
	end
	if(pingCounter >= 100) then
		callServerFunction("kickPlayerServer", getLocalPlayer(), "Your ping is too high!")
	end
end, 200, 0)
-----------------------
-----[ ANTI PING ]-----
-----------------------

----------------------
-----[ ANTI AFK ]-----
----------------------
local afkX = 9999
local afkY = 9999
local afkZ = 9999
local afkCounter = 0
local afkWarning = false
setTimer(function()
	local x, y, z = getElementPosition(getLocalPlayer())
	if(getDistanceBetweenPoints3D(x, y, z, afkX, afkY, afkZ) <= 1) then
		if(not isCursorShowing() and not getKeyState("mouse1") and not getKeyState("mouse2") and not isChatBoxInputActive() and getCameraTarget(getLocalPlayer()) == getLocalPlayer()) then
			afkCounter = afkCounter + 1
		end
	else
		afkCounter = 0
	end
	if(afkCounter >= 400) then
		afkWarning = true
	else
		afkWarning = false
	end
	if(afkCounter >= 600) then
		setElementData(getLocalPlayer(), "Status", "AFK")
	end
	afkX = x
	afkY = y
	afkZ = z
end, 200, 0)
----------------------
-----[ ANTI AFK ]-----
----------------------

----------------------------
-- Util
----------------------------
function table.removevalue(t, val)
	for i,v in ipairs(t) do
		if v == val then
			table.remove(t, i)
			return i
		end
	end
	return false
end

function math.lerp(from,to,alpha)
    return from + (to-from) * alpha
end

function math.unlerp(from,to,pos)
	if ( to == from ) then
		return 1
	end
	return ( pos - from ) / ( to - from )
end

function math.clamp(low,value,high)
    return math.max(low,math.min(value,high))
end

function math.unlerpclamped(from,to,pos)
	return math.clamp(0,math.unlerp(from,to,pos),1)
end
