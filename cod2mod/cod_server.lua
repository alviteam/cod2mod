VERSION = "1.1"
GAMETYPE = "TDM"
SCORE_LIMIT = 100
TIME_LIMIT = 900
--Teams
ALLIES = createTeam("ALLIES", 0, 100, 0)
AXIS = createTeam("AXIS", 100, 100, 100)
setElementID(ALLIES, "TEAM_WHITE")
setElementID(AXIS, "TEAM_BLACK")
setElementData(ALLIES, "Score", 0)
setElementData(AXIS, "Score", 0)
setTeamFriendlyFire(ALLIES, false)
setTeamFriendlyFire(AXIS, false)
ALLIES_SKIN = 287
AXIS_SKIN = 285
--Spawns
spawnAllies = {}
subspawnAllies = {}
spawnAxis = {}
subspawnAxis = {}
--Other variables
----S&D
AUTOBALANCE = false
SD_PLANTED = false
----CTF
ALLIES_FLAG = nil
AXIS_FLAG = nil
ALLIES_MARKER = nil
AXIS_MARKER = nil
ALLIES_TEMP = nil
AXIS_TEMP = nil

function setGameType(playerSource, commandName, gamemode)
	if(gamemode) then
		if(gamemode == "TDM" or gamemode == "S&D" or gamemode == "CTF") then
			if(hasObjectPermissionTo(playerSource, "command.kick", true)) then
				GAMETYPE = gamemode
				if(gamemode == "TDM") then
					TIME_LIMIT = 900
				end
				if(gamemode == "S&D") then
					TIME_LIMIT = 120
				end
				if(gamemode == "CTF") then
					TIME_LIMIT = 900
				end
				outputChatBox("* cod2mod: Game type was changed to "..gamemode.. " by "..getPlayerName(playerSource), getRootElement(), 255, 100, 100, true)
			else
				outputChatBox("* cod2mod: Setting game type failed! You're not an admin!", playerSource, 255, 100, 100, true)
			end
		else
			outputChatBox("* cod2mod: Setting game type failed! Valid types: TDM, S&D, CTF", playerSource, 255, 100, 100, true)
		end
	else
		outputChatBox("* cod2mod: Setting game type failed! Type: /setgametype [type]", playerSource, 255, 100, 100, true)
	end
end
addCommandHandler("setgametype", setGameType)

-----------------------
----- Vote system -----
-----------------------
--Maps
function getMaps()
	local list = {}
	for _,map in ipairs(exports.mapmanager:getMapsCompatibleWithGamemode( getResourceFromName("cod2mod") )) do
		list[#list+1] = getResourceName(map)
	end
	return list
end

local randomizerCurrentMap = 1
local list = {}
function randomizer()
	list = getMaps()
	randomizerCurrentMap = randomizerCurrentMap + 1
	if(randomizerCurrentMap > #list) then randomizerCurrentMap = 1 end
	local pollGameType = exports.votemanager:startPoll {
			title=list[randomizerCurrentMap],
			percentage=40,
			timeout=15,
			allowchange=true,
			visibleTo=getRootElement(),
			[1]={'TDM', 'randomizerGameTypeEvent', getRootElement(), "TDM"},
			[2]={'S&D', 'randomizerGameTypeEvent', getRootElement(), "S&D"},
			[3]={'CTF', 'randomizerGameTypeEvent', getRootElement(), "CTF"},
	}
	setTimer(outputChatBox, 60000, 1, "* You can use /nextmap command if you want to skip this map", getRootElement(), 255, 0, 0, true)
	setTimer(outputChatBox, 60000, 1, "* Next map: "..list[randomizerCurrentMap+1], getRootElement(), 255, 0, 0, true)
	
	setTimer(setElementData, 15000, 1, ALLIES, "Score", 0)
	setTimer(setElementData, 15000, 1, AXIS, "Score", 0)
	
	for i,player in ipairs(getElementsByType("player")) do
		toggleControl(player, "fire", false)
	end
end

addEvent('randomizerGameTypeEvent')
addEventHandler('randomizerGameTypeEvent', getRootElement(),
	function(gametype)
		GAMETYPE = gametype
		if(GAMETYPE == "TDM") then TIME_LIMIT = 900 end
		if(GAMETYPE == "S&D") then TIME_LIMIT = 120 end
		if(GAMETYPE == "CTF") then TIME_LIMIT = 900 end
		setElementData(ALLIES, "Score", "0")
		setElementData(AXIS, "Score", "0")
		setTimer(call, 1000, 1, getResourceFromName("mapmanager"), "changeGamemodeMap", getResourceFromName(list[randomizerCurrentMap]))
	end
)

local isVoteRunning
function startVoting(playerSource)
	local timeSinceLastVoteEnd = getTickCount() - ( lastVoteEndTime or 0 )
	if timeSinceLastVoteEnd < 10000 then
		outputServerLog( "startVoting called while timeSinceLastVoteEnd < 10000 - " .. tostring(timeSinceLastVoteEnd) .. " " .. tostring(playerSource and getPlayerName(playerSource) or "") )
		return
	end
	if isVoteRunning then
		outputServerLog( "startVoting called while vote running. " .. tostring(playerSource and getPlayerName(playerSource) or "") )
		return
	end
	local votingTime = 20
	if(playerSource) then
		if(hasObjectPermissionTo(playerSource, "command.kick", true)) then
			exports.votemanager:stopPoll()
			outputServerLog("* cod2mod: 'vote' started by " .. tostring(getPlayerName(playerSource)) )
			local bestresult = -1
			local bestscorer = nil
			for i,player in ipairs(getElementsByType("player")) do
				setCameraMatrix(player, -1227, 528, 34, -1345, 501, 20.5)
				isVoteRunning = true
				voteEndTimer = setTimer( voteEndedStartMap, votingTime * 1000 + 2000, 1 )
				callClientFunction(player, "startVoting", getMaps(), votingTime)
				VOTE_TDM = 0  VOTE_SD = 0  VOTE_CTF = 0
				VOTED = 0
				local score = tonumber(getElementData(player, "Score")) or 0
				if(score > bestresult) then
					bestresult = score
					bestscorer = player
				end
			end
			for i,player in ipairs(getElementsByType("player")) do
				setElementData(player, "Score", 0)
			end
		else
			outputChatBox("* cod2mod: You're not an admin!", playerSource, 255, 100, 100, true)
		end
	else
		local bestresult = -1
		local bestscorer = nil
		for i,player in ipairs(getElementsByType("player")) do
			setCameraMatrix(player, -1227, 528, 34, -1345, 501, 20.5)
			isVoteRunning = true
			voteEndTimer = setTimer( voteEndedStartMap, votingTime * 1000 + 2000, 1 )
			callClientFunction(player, "startVoting", getMaps(), votingTime)
			VOTE_TDM = 0  VOTE_SD = 0  VOTE_CTF = 0
			VOTED = 0
		end
	end
end
addCommandHandler("vote", startVoting)

function voteEndedStartMap()
	if isVoteRunning then
		lastVoteEndTime = getTickCount()
		isVoteRunning = false
		outputChatBox("* cod2mod voting system: Vote ended! Counting votes...", root, 255, 100, 100, true)

		local votes = {}
		local vmaps = {}
		for i,player in ipairs(getElementsByType("player")) do
			if(getElementData(player, "vote") ~= false) then
				table.insert(vmaps, getElementData(player, "vote"))
			end
		end

		if(#vmaps == 0) then vmaps = {getMaps()[math.random(1, #getMaps())]} end
		
		this = 1
		highresultvote = 1
		for i=1, #vmaps do
			count = 1
			for j = i + 1, #vmaps do
				if(vmaps[i] == vmaps[j]) then
					count = count + 1
				end
				if(count > highresultvote) then
					this = i
					highresultvote = count
				end
			end
		end
			
		for i,player in ipairs(getElementsByType("player")) do
			if(getElementData(player, "vote2") == "Team Death Match") then
				VOTE_TDM = VOTE_TDM + 1
			end
			if(getElementData(player, "vote2") == "Search & Destroy") then
				VOTE_SD = VOTE_SD + 1
			end
			if(getElementData(player, "vote2") == "Capture The Flag") then
				VOTE_CTF = VOTE_CTF + 1
			end
			callClientFunction(player, "drawTimerRoundStart")
			setTimer(callClientFunction, 10000, 1, player, "killTimersOnDefuse")
		end
			
		local highresultvote2 = math.max(VOTE_CTF, VOTE_SD, VOTE_TDM)
		if(VOTE_TDM == highresultvote2) then
			GAMETYPE = "TDM"
			SCORE_LIMIT = 100
		end
		if(VOTE_SD == highresultvote2) then
			GAMETYPE = "S&D"
			SCORE_LIMIT = 20
		end
		if(VOTE_CTF == highresultvote2) then
			GAMETYPE = "CTF"
			SCORE_LIMIT = 20
		end
			
		call(getResourceFromName("mapmanager"), "changeGamemodeMap", getResourceFromName(vmaps[this]))
			
		setElementData(ALLIES, "Score", 0)
		setElementData(AXIS, "Score", 0)
			
		for i,player in ipairs(getElementsByType("player")) do
			setElementData(player, "vote", false)
			setElementData(player, "vote2", false)
			callClientFunction(player, "createMenu")
			--if(isElement(medicBlip[player])) then destroyElement(medicBlip[player]) end
		end
			
		outputChatBox("* cod2mod voting system: "..vmaps[this].." started ("..GAMETYPE..")", root, 255, 100, 100, true)
	end
end
-----------------------
----- Vote system -----
-----------------------

function startMap(startedMap)
	local map = getResourceRootElement(startedMap)
	-- Countries
	local game = getElementsByType("game", map)
	for key, value in pairs(game) do
		ALLIES_COUNTRY = getElementData(value, "allies")
		AXIS_COUNTRY = getElementData(value, "axis")
	end
	for i,player in ipairs(getElementsByType("player")) do
		callClientFunction(player, "setCountries", ALLIES_COUNTRY, AXIS_COUNTRY)
	end
	-- Spawnpoints
	spawnAllies = {}
	spawnAxis = {}
    local spawnpoint = getElementsByType("spawnpoint", map)
	local i = 1 j = 1
    for key, value in pairs(spawnpoint) do
		if(getElementData(value, "id") == "allies") then
			subspawnAllies[1] = getElementData(value, "posX")
			subspawnAllies[2] = getElementData(value, "posY")
			subspawnAllies[3] = getElementData(value, "posZ")
			spawnAllies[i] = {subspawnAllies[1], subspawnAllies[2], subspawnAllies[3]}
			i = i + 1
		end
		if(getElementData(value, "id") == "axis") then
			subspawnAxis[1] = getElementData(value, "posX")
			subspawnAxis[2] = getElementData(value, "posY")
			subspawnAxis[3] = getElementData(value, "posZ")
			spawnAxis[j] = {subspawnAxis[1], subspawnAxis[2], subspawnAxis[3]}
			j = j + 1
		end
	end
	setElementData( resourceRoot, "spawnAllies", spawnAllies )
	setElementData( resourceRoot, "spawnAxis", spawnAxis )
	
	if(GAMETYPE == "TDM" or GAMETYPE == "CTF") then
		TIME_LIMIT = 900
	end
	if(GAMETYPE == "S&D") then
		TIME_LIMIT = 120
	end

	for i,player in ipairs(getElementsByType("player")) do
		setElementData(player, "allowSpawn", true)
		setTimer(toggleControl, 1000, 1, player, "fire", true)
		setTimer(callClientFunction, 1000, 1, player, "createMenu")
	end
		
	for i,object in ipairs(getElementsByType("object")) do
		if(getElementModel(object) == 3884) then
			--SD_TARGET[i] = createBlipAttachedTo(object, 48, 2, 0, 0, 0, 255, 0, 9999.0)
		end
		if(getElementModel(object) == 2993) then
			local x, y, z = getElementPosition(object)
			setElementPosition(object, x, y, z+0.5)
			ALLIES_FLAG = object
            if isElement(ALLIES_MARKER) then destroyElement(ALLIES_MARKER) end
			ALLIES_MARKER = createMarker(x, y, z+0.5, "cylinder", 1, 0, 200, 0, 200)
		end
		if(getElementModel(object) == 2914) then
			local x, y, z = getElementPosition(object)
			setElementPosition(object, x, y, z+0.5)
			AXIS_FLAG = object
            if isElement(AXIS_MARKER) then destroyElement(AXIS_MARKER) end
			AXIS_MARKER = createMarker(x, y, z+0.5, "cylinder", 1, 0, 0, 0, 200)
		end
	end
	
	setElementData(ALLIES, "Score", 0)
	setElementData(AXIS, "Score", 0)
	
	if(isTimer(missionTime)) then killTimer(missionTime) end
	setTimer(missionTimer, 1000, 1)
end
addEventHandler("onGamemodeMapStart", getRootElement(), startMap)

function stopMap(stoppedMap)
	local bestresult = -1
	local bestplayer = ""
	for i,player in ipairs(getElementsByType("player")) do
		if(tonumber(getElementData(player, "Score")) > bestresult) then 
			bestplayer = getPlayerName(player)
			bestresult = tonumber(getElementData(player, "Score"))
		end
		setElementData(player, "Score", 0)
	end
	outputChatBox("* "..bestplayer.." #969600had the best result last round ("..bestresult..")", getRootElement(), 150, 150, 0, true)
	
	for i,vehicle in ipairs(getElementsByType("vehicle")) do
		destroyElement(vehicle)
	end
	for i,object in ipairs(getElementsByType("object")) do
		destroyElement(object)
	end
	for i,marker in ipairs(getElementsByType("marker")) do
		destroyElement(marker)
	end
	for i,blip in ipairs(getElementsByType("blip")) do
		destroyElement(blip)
	end
end
addEventHandler("onGamemodeMapStop", getRootElement(), stopMap)

function missionTimer()
	TIME_LIMIT = math.floor(TIME_LIMIT - 1)
	local minutes = math.floor(TIME_LIMIT / 60)
	local seconds = TIME_LIMIT - minutes * 60
	local sec = 0
	if(seconds < 10) then sec = tostring("0"..seconds) else sec = seconds end
	if(minutes <= 0 and seconds <= 0) then
		if(GAMETYPE == "S&D") then
			setElementData(AXIS, "Score", tonumber(getElementData(AXIS, "Score")) + 1)
			for i,player in ipairs(getElementsByType("player")) do
				callClientFunction(player, "playAxisWin")
				spawn(player)
			end
			if(tonumber(getElementData(ALLIES, "Score")) ~= SCORE_LIMIT and tonumber(getElementData(AXIS, "Score")) ~= SCORE_LIMIT) then
				TIME_LIMIT = 120
				missionTime = setTimer(missionTimer, 11000, 1)
				autobalancingTeams()
			end
			if(tonumber(getElementData(ALLIES, "Score")) == SCORE_LIMIT or tonumber(getElementData(AXIS, "Score")) == SCORE_LIMIT) then
				if(tonumber(getElementData(ALLIES, "Score")) == SCORE_LIMIT
					and tonumber(getElementData(ALLIES, "Score")) > tonumber(getElementData(AXIS, "Score"))) then
					for i,player in ipairs(getElementsByType("player")) do
						callClientFunction(player, "playAlliesWin")
					end
				end
				if(tonumber(getElementData(AXIS, "Score")) == SCORE_LIMIT 
					and tonumber(getElementData(ALLIES, "Score")) < tonumber(getElementData(AXIS, "Score"))) then
					for i,player in ipairs(getElementsByType("player")) do
						callClientFunction(player, "playAxisWin")
					end
				end
				startVoting()
			end
		else
			if(tonumber(getElementData(ALLIES, "Score")) > tonumber(getElementData(AXIS, "Score"))) then
				for i,player in ipairs(getElementsByType("player")) do
					callClientFunction(player, "playAlliesWin")
				end
			end
			if(tonumber(getElementData(ALLIES, "Score")) < tonumber(getElementData(AXIS, "Score"))) then
				for i,player in ipairs(getElementsByType("player")) do
					callClientFunction(player, "playAxisWin")
				end
			end
			if(tonumber(getElementData(ALLIES, "Score")) == tonumber(getElementData(AXIS, "Score"))) then
				for i,player in ipairs(getElementsByType("player")) do
					callClientFunction(player, "playRoundDraw")
				end
			end
			startVoting()
		end
	else
		missionTime = setTimer(missionTimer, 1000, 1)
	end
end

function spawn(thePlayer)
	if isElement(thePlayer) then
		bindKey(thePlayer, "f", "down", spawnOnPress, thePlayer)
		callClientFunction(thePlayer, "showSpawnExclamation")
	end
end

function spawnOnPress(thePlayer)
	if not isElement(thePlayer) then return end
	if(getPlayerTeam(thePlayer) == ALLIES) then
		local i = math.random(1, #spawnAllies)
		local x,y,z = spawnAllies[i][1], spawnAllies[i][2], spawnAllies[i][3]
		x = x + ( math.random() - 0.5 )
		y = y + ( math.random() - 0.5 )
		spawnPlayer(thePlayer, x, y, z, 0, ALLIES_SKIN)
	end
	if(getPlayerTeam(thePlayer) == AXIS) then
		local j = math.random(1, #spawnAxis)
		local x,y,z = spawnAxis[j][1], spawnAxis[j][2], spawnAxis[j][3]
		x = x + ( math.random() - 0.5 )
		y = y + ( math.random() - 0.5 )
		spawnPlayer(thePlayer, x, y, z, 0, AXIS_SKIN)
	end
	local team = getPlayerTeam(thePlayer)
	if(getElementData(thePlayer, "type") == "lightsmg") then
		giveWeapon(thePlayer, 32, 500, true)
		setElementData(thePlayer, "type", "lightsmg")
	end
	if(getElementData(thePlayer, "type") == "semiauto") then
		giveWeapon(thePlayer, 27, 500, true)
		setElementData(thePlayer, "type", "semiauto")
	end
	if(getElementData(thePlayer, "type") == "boltaction") then
		giveWeapon(thePlayer, 25, 500, true)
		setElementData(thePlayer, "type", "boltaction")
	end
	if(getElementData(thePlayer, "type") == "sniper") then
		giveWeapon(thePlayer, 34, 250, true)
		setElementData(thePlayer, "type", "sniper")
	end
	if(getElementData(thePlayer, "type") == "shotgun") then
		giveWeapon(thePlayer, 26, 500, true)
		setElementData(thePlayer, "type", "shotgun")
	end
	if(getElementData(thePlayer, "type") == "smg") then
		giveWeapon(thePlayer, 29, 500, true)
		setElementData(thePlayer, "type", "smg")
	end
	if(getElementData(thePlayer, "type") == "modern") then
		local team = getPlayerTeam(thePlayer)
		if(team) then
			if(team == ALLIES) then
				giveWeapon(thePlayer, 30, 500, true)
			end
			if(team == AXIS) then
				giveWeapon(thePlayer, 31, 500, true)
			end
		end
		setElementData(thePlayer, "type", "modern")
	end
	if(getElementData(thePlayer, "type") == "engineer") then
		giveWeapon(thePlayer, 39, 5, true)
	end
	if(getElementData(thePlayer, "type") == "signaller") then
		giveWeapon(thePlayer, 40, 1, true)
	end
	giveWeapon(thePlayer, 22, 100)
	unbindKey(thePlayer, "f", "down", spawnOnPress)
	callClientFunction(thePlayer, "hideSpawnExclamation")
end

function onPlayerSpawn()
	if(getPlayerTeam(source) == ALLIES) then
		setElementModel(source, ALLIES_SKIN)
	end
	if(getPlayerTeam(source) == AXIS) then
		setElementModel(source, AXIS_SKIN)
	end
	setElementData(source, "frag", "2")
	setElementData(source, "smoke", "2")
	if(getElementData(source, "type") == "medic") then
		setElementData(source, "medicpacks", "3")
	end
	if(getElementData(source, "type") == "signaller") then
		setElementData(source, "signals", "1")
	end
	setElementData(source, "alreadyUseRKM", "false")
	setElementData(source, "Status", "Alive")
	unbindKey(source, "f6")
	unbindKey(source, "x")
	unbindKey(source, "f")
	unbindKey(source, "h")
	unbindKey(source, "mouse1", callForArtillery)
	bindKey(source, "f6", "down", setYourTeam, source)
	bindKey(source, "x", "down", setYourWeapon, source)
	bindKey(source, "f", "down", useFbutton)
	if(getElementData(source, "type") == "medic") then
		bindKey(source, "h", "down", healAsMedic, source)
	end
	if(getElementData(source, "type") == "signaller") then
		bindKey(source, "mouse1", "down", callForArtillery, source)
	end
	setEnabledHudComponents(source)
	setSkill(source)
	
	fadeCamera(source, true)
	setCameraTarget(source, source)
	stopSpectacing(source)
	setTimer(takeWeapon, 1000, 1, source, 38)
	
	if(GAMETYPE == "S&D") then
		for i,player in ipairs(getElementsByType("player")) do
			callClientFunction(player, "showPlantExclamation")
		end
	else
		for i,player in ipairs(getElementsByType("player")) do
			callClientFunction(player, "hidePlantExclamation")
		end
	end
	if(getElementAttachedTo(source) == ALLIES_FLAG) then detachElements(ALLIES_FLAG) end
	if(getElementAttachedTo(source) == AXIS_FLAG) then detachElements(AXIS_FLAG) end
end
addEventHandler("onPlayerSpawn", getRootElement(), onPlayerSpawn)

function onResourceStart(startedResource)
	for i,player in ipairs(getElementsByType("player")) do
		setElementData(player, "allowSpawn", true)
		
		--outputChatBox("* "..getPlayerName(player).. " Connected", getRootElement(), 255, 100, 100, true)
		setElementData(player, "Score", 0)
		setElementData(player, "Kills", 0)
		setElementData(player, "Deaths", 0)
		setElementData(player, "Rank", "Private")
		setElementData(player, "Status", "Dead")
		
		callClientFunction(player, "createMenu")
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), onResourceStart)

function onPlayerJoin()
	setElementData(source, "allowSpawn", true)
	
	--outputChatBox("* "..getPlayerName(source).. " Connected", getRootElement(), 255, 100, 100, true)
	setElementData(source, "Score", 0)
	setElementData(source, "Kills", 0)
	setElementData(source, "Deaths", 0)
	setElementData(source, "Rank", "Private")
	setElementData(source, "C2M-Points", 0)
	setElementData(source, "Status", "Dead")
	
	callClientFunction(source, "createMenu")
end
addEventHandler("onPlayerJoin", getRootElement(), onPlayerJoin)

function onPlayerQuit(quitType, reason, responsibleElement)
	if(GAMETYPE == "CTF") then
		for _,item in ipairs(getAttachedElements(source)) do
			if item == ALLIES_FLAG or item == AXIS_FLAG then
				setScore()  -- Drop flag
				break
			end
		end
	end
	if(isElement(playerBlip[source])) then destroyElement(playerBlip[source]) end
    playerBlip[source] = nil
end
addEventHandler("onPlayerQuit", getRootElement(), onPlayerQuit)

function onPlayerChangeTeamOrWeapon(thePlayer)
	if(GAMETYPE == "TDM") then
		if(getElementHealth(thePlayer) == false or getElementData(thePlayer, "allowSpawn") == true) then
			setTimer(spawn, 1000, 1, thePlayer)
		else
			outputChatBox("* You will be spawned with new gun next round", thePlayer, 255, 100, 100, true)
		end
	end
	if(GAMETYPE == "S&D") then
		if(TIME_LIMIT < 110 and getElementData(thePlayer, "allowSpawn") == false) then
			outputChatBox("* You will be spawned with new gun next round", thePlayer, 255, 100, 100, true)
			spectacing(thePlayer)
		else
			setTimer(spawn, 1000, 1, thePlayer)
		end
	end
	if(GAMETYPE == "CTF") then
		callClientFunction(thePlayer, "drawTimerRoundStart")
		setTimer(callClientFunction, 10000, 1, thePlayer, "killTimersOnDefuse")
		if(getElementHealth(thePlayer) == false or getElementData(thePlayer, "allowSpawn") == true) then
			setTimer(spawn, 11000, 1, thePlayer)
		else
			outputChatBox("* You will be spawned with new gun next round", thePlayer, 255, 100, 100, true)
		end
	end
	setElementData(thePlayer, "allowSpawn", false)
end

function setYourTeam(thePlayer)
	setElementHealth(thePlayer, 0.0)
	setPlayerTeam(thePlayer, nil)
	callClientFunction(thePlayer, "createMenu")
end

function setYourWeapon(thePlayer)
	setElementData(thePlayer, "type", false)
	callClientFunction(thePlayer, "createWeaponMenu")
end

function playerDamage(attacker, weapon, bodypart, loss)
	attacker = resolveAttacker(attacker)
    --Friendly-fire
	local diedTeam = getPlayerTeam(source)
	local scorerTeam = nil
	if(attacker) then
		scorerTeam = getPlayerTeam(attacker)
	end
	if(diedTeam == scorerTeam) then
		cancelEvent()
	end
	if(weapon == 33) then
		setElementHealth(source, 0.0)
	end
	if(bodypart == 3 and weapon == 25) then
		local rand = math.random(1, 3)
		if(rand == 1) then
			setElementHealth(source, 0.0)
		end
		if(rand == 2) then
			if(getElementHealth(source) ~= false) then
				if(getElementHealth(source) > 50) then
					setElementHealth(source, getElementHealth(source) - 50)
				else
					setElementHealth(source, 0.0)
				end
			end
		end
	end
	fadeCamera(source, false, 1.0, 255, 0, 0)
	setTimer(fadeCamera, 500, 1, source, true, 0.5) 
end
--addEventHandler("onPlayerDamage", getRootElement(), playerDamage)

function setScore(totalAmmo, killer, killerWeapon, bodypart)
	killer = resolveAttacker(killer)
	local tempsource = source
	local diedTeam = getPlayerTeam(source)
	local scorerTeam = nil
	if(killer) then
		scorerTeam = getPlayerTeam(killer)
	end
	
	-- Auto-balance
	if(AUTOBALANCE == 1 or AUTOBALANCE == 2) then
		if(AUTOBALANCE == 1) then
			setPlayerTeam(source, AXIS)
		end
		if(AUTOBALANCE == 2) then
			setPlayerTeam(source, ALLIES)
		end
		AUTOBALANCE = 0
	end
	-- Game modes
	if(GAMETYPE == "TDM") then
		if(source ~= killer) then
			if scorerTeam then
				setElementData(scorerTeam, "Score", tonumber(getElementData(scorerTeam, "Score")) + 1)
			end
			if killer then
				setElementData(killer, "Score", (tonumber(getElementData(killer, "Score")) or 0) + 1)
			end
		
			if(tonumber(getElementData(ALLIES, "Score")) == SCORE_LIMIT or tonumber(getElementData(AXIS, "Score")) == SCORE_LIMIT) then
				if(tonumber(getElementData(ALLIES, "Score")) == SCORE_LIMIT
					and tonumber(getElementData(ALLIES, "Score")) > tonumber(getElementData(AXIS, "Score"))) then
					for i,player in ipairs(getElementsByType("player")) do
						callClientFunction(player, "playAlliesWin")
					end
				end
				if(tonumber(getElementData(AXIS, "Score")) == SCORE_LIMIT 
					and tonumber(getElementData(ALLIES, "Score")) < tonumber(getElementData(AXIS, "Score"))) then
					for i,player in ipairs(getElementsByType("player")) do
						callClientFunction(player, "playAxisWin")
					end
				end
				startVoting()
			else
				setTimer(spawn, 1000, 1, source)
			end
		else
			setTimer(spawn, 1000, 1, source)
		end
	end
	if(GAMETYPE == "S&D") then
		
		--Spectacing
		spectacing(source)
		
		--If is winner
		if(allies_count == 0 or axis_count == 0) then
			if(allies_count > 0 and axis_count == 0) then
				for i,player in ipairs(getElementsByType("player")) do
					callClientFunction(player, "playAxisEliminated")
					callClientFunction(player, "playAlliesWin")
				end
				outputChatBox("Axis have been eliminated")
				setElementData(ALLIES, "Score", tonumber(getElementData(ALLIES, "Score")) + 1)
				autobalancingTeams()
			end
			if(axis_count > 0 and allies_count == 0) then
				for i,player in ipairs(getElementsByType("player")) do
					callClientFunction(player, "playAlliesEliminated")
					callClientFunction(player, "playAxisWin")
				end
				outputChatBox("Allies have been eliminated")
				setElementData(AXIS, "Score", tonumber(getElementData(AXIS, "Score")) + 1)
				autobalancingTeams()
			end
			if(allies_count == 0 and axis_count == 0) then
				for i,player in ipairs(getElementsByType("player")) do
					callClientFunction(player, "playRoundDraw")
				end
				autobalancingTeams()
				if(isElement(SD_WAYPOINT)) then destroyElement(SD_WAYPOINT) end
			end
			
			if(tonumber(getElementData(ALLIES, "Score")) == SCORE_LIMIT or tonumber(getElementData(AXIS, "Score")) == SCORE_LIMIT) then
				if(tonumber(getElementData(ALLIES, "Score")) == SCORE_LIMIT
					and tonumber(getElementData(ALLIES, "Score")) > tonumber(getElementData(AXIS, "Score"))) then
					for i,player in ipairs(getElementsByType("player")) do
						callClientFunction(player, "playAlliesWin")
					end
				end
				if(tonumber(getElementData(AXIS, "Score")) == SCORE_LIMIT 
					and tonumber(getElementData(ALLIES, "Score")) < tonumber(getElementData(AXIS, "Score"))) then
					for i,player in ipairs(getElementsByType("player")) do
						callClientFunction(player, "playAxisWin")
					end
				end
				startVoting()
			else
				for i,player in ipairs(getElementsByType("player")) do
					callClientFunction(player, "drawTimerRoundStart")
					setTimer(callClientFunction, 10000, 1, player, "killTimersOnDefuse")
					setTimer(spawn, 11000, 1, player)
				end
			end
		end
	end
	if(GAMETYPE == "CTF") then
		if(isElementAttached(ALLIES_FLAG) or isElementAttached(AXIS_FLAG)) then
			local tableElements = getAttachedElements(source)
			for i=1, #tableElements do
				if(getElementModel(tableElements[i]) == 2993) then
					local x, y, z = getElementPosition(ALLIES_FLAG)
					detachElements(ALLIES_FLAG)
					destroyElement(ALLIES_FLAG)
					ALLIES_FLAG = createObject(2993, x, y, z)
                    if isElement(ALLIES_TEMP) then destroyElement(ALLIES_TEMP) end
					ALLIES_TEMP = createMarker(x, y, z, "cylinder", 1, 0, 200, 0, 200)
					for i,player in ipairs(getElementsByType("player")) do
						callClientFunction(player, "playFlagDropped")
					end
					outputChatBox(getPlayerName(source).." has dropped Allies flag")
				elseif(getElementModel(tableElements[i]) == 2914) then
					local x, y, z = getElementPosition(AXIS_FLAG)
					detachElements(AXIS_FLAG)
					destroyElement(AXIS_FLAG)
					AXIS_FLAG = createObject(2914, x, y, z)
                    if isElement(AXIS_TEMP) then destroyElement(AXIS_TEMP) end
					AXIS_TEMP = createMarker(x, y, z, "cylinder", 1, 0, 0, 0, 200)
					for i,player in ipairs(getElementsByType("player")) do
						callClientFunction(player, "playFlagDropped")
					end
					outputChatBox(getPlayerName(source).." has dropped Axis flag")
				end
			end
		end
		callClientFunction(source, "drawTimerRoundStart")
		setTimer(callClientFunction, 10000, 1, source, "killTimersOnDefuse")
		setTimer(spawn, 11000, 1, source)
		autobalancingTeams()
	end
	
	-- Scoreboard update
	if(diedTeam ~= scorerTeam and killer ~= source) then
		if(killer) then
			setElementData(killer, "Score", tonumber(getElementData(killer, "Score")) + 1)
			setElementData(killer, "Kills", tonumber(getElementData(killer, "Kills")) + 1)
			setElementData(source, "Deaths", tonumber(getElementData(source, "Deaths")) + 1)
		end
	end
	
	for i,player in ipairs(getElementsByType("player")) do
		local kills = tonumber(getElementData(player, "Kills"))
		local deaths = tonumber(getElementData(player, "Deaths"))
		if(deaths ~= 0) then
			setElementData(player, "Ratio", round(kills/deaths))
		else
			setElementData(player, "Ratio", 0)
		end
	end
	call(getResourceFromName("scoreboard"), "scoreboardSetSortBy", "Ratio", false)
	setElementData(source, "Status", "Dead")

	if tempsource ~= source then
		outputDebugString ( "ERROR: setScore tempsource ~= source" )
	end
end
addEventHandler("onPlayerWasted", getRootElement(), setScore)

function autobalancingTeams()
	local allies = tonumber(countPlayersInTeam(ALLIES))
	local axis = tonumber(countPlayersInTeam(AXIS))
	if(allies - axis > 1) then
		outputChatBox("Teams will be auto-balanced next round")
		AUTOBALANCE = 1
	end
	if(axis - allies > 1) then
		outputChatBox("Teams will be auto-balanced next round")
		AUTOBALANCE = 2
	end
end

local spectatedPlayers = {}
function spectacing(thePlayer)
	spectatedPlayers[thePlayer] = 1
	local aliveInTeam = getPlayersInTeam(getPlayerTeam(thePlayer))
	if(getElementHealth(aliveInTeam[spectatedPlayers[thePlayer]]) ~= false and getElementHealth(aliveInTeam[spectatedPlayers[thePlayer]]) > 0) then
		setCameraTarget(thePlayer, aliveInTeam[spectatedPlayers[thePlayer]])
	else
		nextSpectated(thePlayer)
	end
	bindKey(thePlayer, "arrow_l", "down", previousSpectated, thePlayer)
	bindKey(thePlayer, "arrow_r", "down", nextSpectated, thePlayer)
end

function nextSpectated(thePlayer)
	spectatedPlayers[thePlayer] = spectatedPlayers[thePlayer] + 1
	local aliveInTeam = getPlayersInTeam(getPlayerTeam(thePlayer))
	if(spectatedPlayers[thePlayer] > #aliveInTeam) then
		spectatedPlayers[thePlayer] = 1
	end
	if(getElementHealth(aliveInTeam[spectatedPlayers[thePlayer]]) ~= false and getElementHealth(aliveInTeam[spectatedPlayers[thePlayer]]) > 0) then
		setCameraTarget(thePlayer, aliveInTeam[spectatedPlayers[thePlayer]])
	end
end

function previousSpectated(thePlayer)
	spectatedPlayers[thePlayer] = spectatedPlayers[thePlayer] - 1
	local aliveInTeam = getPlayersInTeam(getPlayerTeam(thePlayer))
	if(spectatedPlayers[thePlayer] < 1) then
		spectatedPlayers[thePlayer] = #aliveInTeam
	end
	if(getElementHealth(aliveInTeam[spectatedPlayers[thePlayer]]) ~= false and getElementHealth(aliveInTeam[spectatedPlayers[thePlayer]]) > 0) then
		setCameraTarget(thePlayer, aliveInTeam[spectatedPlayers[thePlayer]])
	end
end

function stopSpectacing(thePlayer)
	unbindKey(thePlayer, "arrow_l", "down", previousSpectated)
	unbindKey(thePlayer, "arrow_r", "down", nextSpectated)
end

function useFbutton(playerSource)
	local team = getPlayerTeam(playerSource)
	for i,object in ipairs(getElementsByType("object")) do
		if(GAMETYPE == "S&D") then
			if(getElementModel(object) == 3884) then
				local x1, y1, z1 = getElementPosition(object)
				local x2, y2, z2 = getElementPosition(playerSource)
				if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= 5) then
					if(team == ALLIES) then
						callClientFunction(playerSource, "drawBombPlanted")
					end
					if(team == AXIS and isElement(bomb)) then
						callClientFunction(playerSource, "drawBombDefused")
					end
				end
			end
		end
		--machine gun
		if(getElementModel(object) == 2985) then
			local x1, y1, z1 = getElementPosition(object)
			local x2, y2, z2 = getElementPosition(playerSource)
			if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= 5) then
				if(getElementAttachedTo(ALLIES_FLAG) ~= playerSource and getElementAttachedTo(AXIS_FLAG) ~= playerSource) then
					callClientFunction(playerSource, "useRKM")
					break
				end
			end
		end
		--medic packs
		if(getElementModel(object) == 1575) then
			local x, y, z = getElementPosition(playerSource)
			local dx, dy, dz = getElementPosition(object)
			if(getDistanceBetweenPoints3D(x, y, z, dx, dy, dz) <= 2) then
				setElementHealth(playerSource, 100.0)
				destroyElement(object)
			end
		end
	end
end
--addCommandHandler("use", useFbutton)
	
function createBomb(playerSource)
	for i,object in ipairs(getElementsByType("object")) do
		if(getElementModel(object) == 3884) then
			local x1, y1, z1 = getElementPosition(object)
			local x2, y2, z2 = getElementPosition(playerSource)
			if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= 5) then
                if isElement(bomb) then destroyElement(bomb) end
				bomb = createObject(1252, x1, y1+0.5, z1+1)
                if isElement(SD_WAYPOINT) then destroyElement(SD_WAYPOINT) end
				SD_WAYPOINT = createBlipAttachedTo(object, 41, 2, 0, 0, 0, 255, 0, 9999.0)
			end
		end
	end
end

function destroyBomb(playerSource)
	for i,object in ipairs(getElementsByType("object")) do
		if(getElementModel(object) == 1252) then
			local x1, y1, z1 = getElementPosition(object)
			local x2, y2, z2 = getElementPosition(playerSource)
			if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= 5) then
				destroyElement(object)
				if(isElement(SD_WAYPOINT)) then destroyElement(SD_WAYPOINT) end
			end
		end
	end
end

function explodeBomb(playerSource)
	if(isElement(bomb)) then
		local x, y, z = getElementPosition(bomb)
		createExplosion(x, y, z, 10)
		destroyElement(bomb)
		for i,player in ipairs(getElementsByType("player")) do
			callClientFunction(player, "playObjectiveDestroyed")
		end
		if(isElement(SD_WAYPOINT)) then destroyElement(SD_WAYPOINT) end
		setElementData(ALLIES, "Score", tonumber(getElementData(ALLIES, "Score")) + 1)
		autobalancingTeams()
		if(tonumber(getElementData(ALLIES, "Score")) == SCORE_LIMIT or tonumber(getElementData(AXIS, "Score")) == SCORE_LIMIT) then
			if(tonumber(getElementData(ALLIES, "Score")) == SCORE_LIMIT
				and tonumber(getElementData(ALLIES, "Score")) > tonumber(getElementData(AXIS, "Score"))) then
				for i,player in ipairs(getElementsByType("player")) do
					callClientFunction(player, "playAlliesWin")
				end
			end
			if(tonumber(getElementData(AXIS, "Score")) == SCORE_LIMIT 
				and tonumber(getElementData(ALLIES, "Score")) < tonumber(getElementData(AXIS, "Score"))) then
				for i,player in ipairs(getElementsByType("player")) do
					callClientFunction(player, "playAxisWin")
				end
			end
			startVoting()
		else
			for i,player in ipairs(getElementsByType("player")) do
				callClientFunction(player, "drawTimerRoundStart")
				setTimer(callClientFunction, 10000, 1, player, "killTimersOnDefuse")
				setTimer(spawn, 11000, 1, player)
			end
		end
		TIME_LIMIT = 120
		setTimer(missionTimer, 11000, 1)
	end
end

function timerPlantedBombForAll()
	for i,player in ipairs(getElementsByType("player")) do
		callClientFunction(player, "drawTimerPlantedBomb")
	end
end

function playPlantBombForAll()
	for i,player in ipairs(getElementsByType("player")) do
		callClientFunction(player, "playBombPlanted")
	end
	if(isTimer(missionTime)) then killTimer(missionTime) end
end

function playDefuseBombForAll()
	setElementData(AXIS, "Score", tonumber(getElementData(AXIS, "Score")) + 1)
	
	for i,player in ipairs(getElementsByType("player")) do
		callClientFunction(player, "playBombDefused")
	end
	
	if(tonumber(getElementData(ALLIES, "Score")) == SCORE_LIMIT or tonumber(getElementData(AXIS, "Score")) == SCORE_LIMIT) then
		if(tonumber(getElementData(ALLIES, "Score")) == SCORE_LIMIT
			and tonumber(getElementData(ALLIES, "Score")) > tonumber(getElementData(AXIS, "Score"))) then
			for i,player in ipairs(getElementsByType("player")) do
				callClientFunction(player, "playAlliesWin")
			end
		end
		if(tonumber(getElementData(AXIS, "Score")) == SCORE_LIMIT 
			and tonumber(getElementData(ALLIES, "Score")) < tonumber(getElementData(AXIS, "Score"))) then
			for i,player in ipairs(getElementsByType("player")) do
				callClientFunction(player, "playAxisWin")
			end
		end
		startVoting()
	else
		for i,player in ipairs(getElementsByType("player")) do
			callClientFunction(player, "drawTimerRoundStart")
			setTimer(callClientFunction, 10000, 1, player, "killTimersOnDefuse")
			setTimer(spawn, 11000, 1, player)
		end
	end
	
	autobalancingTeams()
	TIME_LIMIT = 120
	setTimer(missionTimer, 11000, 1)
end

function takeTheFlag(thePlayer, matchingDimension)
	if(getElementType(thePlayer) == "player") then
		if(GAMETYPE == "CTF") then
			local mainteam = getPlayerTeam(thePlayer)
			--take the flag
			if(source == ALLIES_MARKER and mainteam == AXIS) then
				local x1, y1, z1 = getElementPosition(ALLIES_FLAG)
				local x2, y2, z2 = getElementPosition(ALLIES_MARKER)
				if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) < 1) then
					if(not isElementAttached(ALLIES_FLAG)) then
						outputChatBox(getPlayerName(thePlayer).." has taken Allies flag")
						attachElements(ALLIES_FLAG, thePlayer, 0.2, 0, 0, 0, 0, 270)
						if(isElement(ALLIES_TEMP)) then destroyElement(ALLIES_TEMP) end
						for i,player in ipairs(getElementsByType("player")) do
							callClientFunction(player, "playFlagTaken")
						end
					end
				end
			end
			if(source == AXIS_MARKER and mainteam == ALLIES) then
				local x1, y1, z1 = getElementPosition(AXIS_FLAG)
				local x2, y2, z2 = getElementPosition(AXIS_MARKER)
				if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) < 1) then
					if(not isElementAttached(AXIS_FLAG)) then
						outputChatBox(getPlayerName(thePlayer).." has taken Axis flag")
						attachElements(AXIS_FLAG, thePlayer, 0.2, 0, 0, 0, 0, 270)
						if(isElement(AXIS_TEMP)) then destroyElement(AXIS_TEMP) end
						for i,player in ipairs(getElementsByType("player")) do
							callClientFunction(player, "playFlagTaken")
						end
					end
				end
			end
			--retake the flag
			if(source == ALLIES_TEMP and mainteam == AXIS) then
				local x1, y1, z1 = getElementPosition(ALLIES_FLAG)
				local x2, y2, z2 = getElementPosition(ALLIES_TEMP)
				if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) < 1) then
					outputChatBox(getPlayerName(thePlayer).." has retaken Allies flag")
					attachElements(ALLIES_FLAG, thePlayer, 0.2, 0, 0, 0, 0, 270)
					if(isElement(ALLIES_TEMP)) then destroyElement(ALLIES_TEMP) end
					for i,player in ipairs(getElementsByType("player")) do
						callClientFunction(player, "playFlagTaken")
					end
				end
			end
			if(source == AXIS_TEMP and mainteam == ALLIES) then
				local x1, y1, z1 = getElementPosition(AXIS_FLAG)
				local x2, y2, z2 = getElementPosition(AXIS_TEMP)
				if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) < 1) then
					outputChatBox(getPlayerName(thePlayer).." has retaken Axis flag")
					attachElements(AXIS_FLAG, thePlayer, 0.2, 0, 0, 0, 0, 270)
					if(isElement(AXIS_TEMP)) then destroyElement(AXIS_TEMP) end
					for i,player in ipairs(getElementsByType("player")) do
						callClientFunction(player, "playFlagTaken")
					end
				end
			end
			--return the flag
			if(source == ALLIES_TEMP and mainteam == ALLIES) then
				if(getElementPosition(ALLIES_FLAG) ~= getElementPosition(ALLIES_MARKER)) then
					outputChatBox(getPlayerName(thePlayer).." has return Allies flag")
					local x, y, z = getElementPosition(ALLIES_MARKER)
					setElementPosition(ALLIES_FLAG, x, y, z)
					if(isElement(ALLIES_TEMP)) then destroyElement(ALLIES_TEMP) end
					for i,player in ipairs(getElementsByType("player")) do
						callClientFunction(player, "playFlagReturned")
					end
					setElementData(thePlayer, "Score", tonumber(getElementData(thePlayer, "Score")) + 2)
				end
			end
			if(source == AXIS_TEMP and mainteam == AXIS) then
				if(getElementPosition(AXIS_FLAG) ~= getElementPosition(AXIS_MARKER)) then
					outputChatBox(getPlayerName(thePlayer).." has return Axis flag")
					local x, y, z = getElementPosition(AXIS_MARKER)
					setElementPosition(AXIS_FLAG, x, y, z)
					if(isElement(AXIS_TEMP)) then destroyElement(AXIS_TEMP) end
					for i,player in ipairs(getElementsByType("player")) do
						callClientFunction(player, "playFlagReturned")
					end
					setElementData(thePlayer, "Score", tonumber(getElementData(thePlayer, "Score")) + 2)
				end
			end
			--capture the flag
			if(source == ALLIES_MARKER and mainteam == ALLIES) then
				local x1, y1, z1 = getElementPosition(ALLIES_FLAG)
				local x2, y2, z2 = getElementPosition(AXIS_FLAG)
				if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) < 1) then
					outputChatBox(getPlayerName(thePlayer).." has captured the Axis flag")
					detachElements(AXIS_FLAG)
					local x, y, z = getElementPosition(AXIS_MARKER)
					setElementPosition(AXIS_FLAG, x, y, z)
					if(isElement(AXIS_TEMP)) then destroyElement(AXIS_TEMP) end
					for i,player in ipairs(getElementsByType("player")) do
						callClientFunction(player, "playFlagCaptured")
					end
					setElementData(thePlayer, "Score", tonumber(getElementData(thePlayer, "Score")) + 5)
					setElementData(ALLIES, "Score", tonumber(getElementData(ALLIES, "Score")) + 1)
					
					if(tonumber(getElementData(ALLIES, "Score")) == SCORE_LIMIT or tonumber(getElementData(AXIS, "Score")) == SCORE_LIMIT) then
						if(tonumber(getElementData(ALLIES, "Score")) == SCORE_LIMIT
							and tonumber(getElementData(ALLIES, "Score")) > tonumber(getElementData(AXIS, "Score"))) then
							for i,player in ipairs(getElementsByType("player")) do
								callClientFunction(player, "playAlliesWin")
							end
						end
						if(tonumber(getElementData(AXIS, "Score")) == SCORE_LIMIT 
							and tonumber(getElementData(ALLIES, "Score")) < tonumber(getElementData(AXIS, "Score"))) then
							for i,player in ipairs(getElementsByType("player")) do
								callClientFunction(player, "playAxisWin")
							end
						end
						startVoting()
					end
				end
			end
			if(source == AXIS_MARKER and mainteam == AXIS) then
				local x1, y1, z1 = getElementPosition(ALLIES_FLAG)
				local x2, y2, z2 = getElementPosition(AXIS_FLAG)
				if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) < 1) then
					outputChatBox(getPlayerName(thePlayer).." has captured the Allies flag")
					detachElements(ALLIES_FLAG)
					local x, y, z = getElementPosition(ALLIES_MARKER)
					setElementPosition(ALLIES_FLAG, x, y, z)
					if(isElement(ALLIES_TEMP)) then destroyElement(ALLIES_TEMP) end
					for i,player in ipairs(getElementsByType("player")) do
						callClientFunction(player, "playFlagCaptured")
					end
					setElementData(thePlayer, "Score", tonumber(getElementData(thePlayer, "Score")) + 5)
					setElementData(AXIS, "Score", tonumber(getElementData(AXIS, "Score")) + 1)
					
					if(tonumber(getElementData(ALLIES, "Score")) == SCORE_LIMIT or tonumber(getElementData(AXIS, "Score")) == SCORE_LIMIT) then
						if(tonumber(getElementData(ALLIES, "Score")) == SCORE_LIMIT
							and tonumber(getElementData(ALLIES, "Score")) > tonumber(getElementData(AXIS, "Score"))) then
							for i,player in ipairs(getElementsByType("player")) do
								callClientFunction(player, "playAlliesWin")
							end
						end
						if(tonumber(getElementData(AXIS, "Score")) == SCORE_LIMIT 
							and tonumber(getElementData(ALLIES, "Score")) < tonumber(getElementData(AXIS, "Score"))) then
							for i,player in ipairs(getElementsByType("player")) do
								callClientFunction(player, "playAxisWin")
							end
						end
						startVoting()
					end
				end
			end
		end
	end
end
addEventHandler("onMarkerHit", getRootElement(), takeTheFlag)

playerBlip = {}
function showPlayerFromTheSameTeamOnMap()
	local team = getPlayerTeam(source)
	local c1, c2, c3 = getTeamColor(team)
	
	if(isElement(playerBlip[source])) then destroyElement(playerBlip[source]) end
	playerBlip[source] = createBlipAttachedTo(source, 0, 2, c1, c2, c3, 255, 10, getRootElement())
    setElementVisibleTo(playerBlip[source], root, false)
	for i,player in ipairs(getElementsByType("player")) do
		if(getPlayerTeam(source) == getPlayerTeam(player)) then
			setElementVisibleTo(playerBlip[source], player, true)
		end
	end
end
addEventHandler("onPlayerSpawn", getRootElement(), showPlayerFromTheSameTeamOnMap)

function hidePlayerOnMap()
	if(isElement(playerBlip[source])) then destroyElement(playerBlip[source]) end
end
addEventHandler("onPlayerWasted", getRootElement(), hidePlayerOnMap)

function showPlayerOnMap(thePlayer)
	local team = getPlayerTeam(thePlayer)
	for i,player in ipairs(getElementsByType("player")) do
		if team ~= getPlayerTeam(player) then
			callClientFunction(player, "showFireBlip", thePlayer)
		end
	end
end

function healAsMedic(thePlayer)
	if(getElementData(thePlayer, "type") == "medic") then
		if(getElementData(thePlayer, "medicpacks") ~= false) then
			if(tonumber(getElementData(thePlayer, "medicpacks")) > 0) then
				setElementData(thePlayer, "medicpacks", tonumber(getElementData(thePlayer, "medicpacks")) - 1)
				local x, y, z = getElementPosition(thePlayer)
				local _, _, r = getElementRotation(thePlayer)
				local absX, absY = getPointFromDistanceRotation(x, y, 2, -r)
				createObject(1575, absX, absY, z-0.6)
			end
		end
	end
end

function callForArtillery(thePlayer)
	if(getElementData(thePlayer, "type") == "signaller") then
		if(getPedWeapon(thePlayer) == 40) then
			if(getElementData(thePlayer, "signals") ~= false) then
				if(tonumber(getElementData(thePlayer, "signals")) > 0) then
					setElementData(thePlayer, "signals", tonumber(getElementData(thePlayer, "signals")) - 1)
					local x, y, z = getElementPosition(thePlayer)
					setTimer(function(x, y, z)
						callClientFunction(thePlayer, "artilleryCalled", x, y, z)
					end, 10000, 1, x, y, z)
				end
			end
		end
	end
end

function killYourself(thePlayer)
	if(thePlayer) then
		if(getElementType(thePlayer) == "player") then
			setElementHealth(thePlayer, 0.0)
		end
	end
end
addCommandHandler("kill", killYourself)

function preventJacking(enteringPlayer, seat, jacked, door)
	if(jacked) then
		cancelEvent()
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), preventJacking)

------------------------------
-----[ CAMPER FUNCTIONS ]-----
------------------------------
--[[
campertimer = {}
camperBlip = {}
function getMovingCamper()
	setElementData(source, "x", tostring(9999))
	setElementData(source, "y", tostring(9999))
	setElementData(source, "z", tostring(9999))
	campertimer[source] = setTimer(camperTimer, 20000, 0, source)
end
addEventHandler("onPlayerJoin", getRootElement(), getMovingCamper)

function camperQuit()
	if(isTimer(campertimer[source])) then killTimer(campertimer[source]) end
end
addEventHandler("onPlayerQuit", getRootElement(), camperQuit)

function camperTimer(thePlayer)
	if(not isPedDead(thePlayer) and not isPedFrozen(thePlayer)) then
		local newx, newy, newz = getElementPosition(thePlayer)
		local oldx = getElementData(thePlayer, "x")
		local oldy = getElementData(thePlayer, "y")
		local oldz = getElementData(thePlayer, "z")
		if(tonumber(oldx) == tonumber(newx) and tonumber(oldy) == tonumber(newy) and tonumber(oldz) == tonumber(newz)) then
			outputChatBox("Get Moving Camper!", thePlayer)
			local health = tonumber(getElementHealth(thePlayer))
			health = health - 10
			if(health < 10) then health = 0 end
			setElementHealth(thePlayer, health)
			camperBlip[thePlayer] = createBlipAttachedTo(thePlayer, 12, 1)
			setTimer(destroyElement, 5000, 1, camperBlip[thePlayer])
		end
		setElementData(thePlayer, "x", tostring(newx))
		setElementData(thePlayer, "y", tostring(newy))
		setElementData(thePlayer, "z", tostring(newz))
	end
end
]]--
------------------------------
-----[ CAMPER FUNCTIONS ]-----
------------------------------

-----------------------------
-----[ OTHER FUNCTIONS ]-----
-----------------------------
function setSkill(thePlayer)
	setPedStat(thePlayer, 69, 500) --pistol skill
	setPedStat(thePlayer, 75, 500) --tec9 skill
	setPedStat(thePlayer, 72, 1000) --shotgun skill
	setPedStat(thePlayer, 74, 1000) --spas12 skill
	setPedStat(thePlayer, 76, 1000) --mp5 skill
	setPedStat(thePlayer, 79, 1000) --sniper rifle skill
	setPedStat(thePlayer, 77, 1000) --ak47 skill
	setPedStat(thePlayer, 78, 900) --m4 skill
end

function setEnabledHudComponents(thePlayer)
	setPlayerNametagShowing(thePlayer, true)
	showPlayerHudComponent(thePlayer, "ammo", false)
	showPlayerHudComponent(thePlayer, "area_name", false)
	showPlayerHudComponent(thePlayer, "clock", false)
	showPlayerHudComponent(thePlayer, "money", false)
	showPlayerHudComponent(thePlayer, "vehicle_name", false)
	showPlayerHudComponent(thePlayer, "weapon", false)
end

function getAlivePlayerInTeam(theTeam)
	local players = getPlayersInTeam(theTeam)
	local count = countPlayersInTeam(theTeam)
	for i=1, #players do
		if(isPedDead(players[i])) then
			count = count - 1
		end
	end
	return count
end

function setPlayerTeamServer(thePlayer, theTeam)
	setPlayerTeam(thePlayer, theTeam)
end

function takeWeaponServer(thePlayer, theWeapon)
	takeWeapon(thePlayer, theWeapon)
end

function giveWeaponServer(thePlayer, theWeapon, theAmmo, current)
	giveWeapon(thePlayer, theWeapon, theAmmo, current)
end

function setPlayerTeamServer(kickedPlayer, team)
	setPlayerTeam(kickedPlayer, team)
end

function kickPlayerServer(kickedPlayer, reason)
	kickPlayer(kickedPlayer, reason)
end

----------------------------------------------------------------------------
-- startMidMapVoteForRandomMap
--
-- Start the vote menu if during a race and more than 30 seconds from the end
-- No messages if this was not started by a player
----------------------------------------------------------------------------
local lastVoteStartTimeAll
local lastVoteStartTimePlr = {}
local locktimeAll = 60
local locktimePlr = 360
--locktimeAll = 20
--locktimePlr = 40

addEventHandler("onPlayerQuit", root,
	function()
		lastVoteStartTimePlr[source] = nil
	end
)

function startMidMapVote(player)

	if isVoteRunning then
		outputChatBox( "Another poll is already running.", player)
		return
	end

	local time = getTickCount() / 1000

	lastVoteStartTimeAll = lastVoteStartTimeAll or -1e9
	lastVoteStartTimePlr[player] = lastVoteStartTimePlr[player] or -1e9

	local timeleftAll = lastVoteStartTimeAll + locktimeAll - time
	local timeleftPlr = lastVoteStartTimePlr[player] + locktimePlr - time
	local timeleft = math.max(timeleftAll,timeleftPlr)

	if timeleft > 2 then
		local t = math.ceil(timeleft/10)*10
		outputChatBox( "You have to wait "..tostring(t).." seconds before starting another vote.", player)
		return
	end

	outputServerLog("* cod2mod: 'nextmap' started by " .. tostring(getPlayerName(player)) )

	lastVoteStartTimeAll = time
	lastVoteStartTimePlr[player] = time

	exports.votemanager:stopPoll()

	-- Actual vote started here
	local pollDidStart = exports.votemanager:startPoll {
			title='Do you want to skip current map?',
			percentage=65,
			timeout=15,
			allowchange=true,
			visibleTo=getRootElement(),
			[1]={'Yes', 'midMapVoteResult', getRootElement(), true},
			[2]={'No', 'midMapVoteResult', getRootElement(), false;default=true},
	}
	outputChatBox("* "..getPlayerName(player).."#ff6464 has started a new vote", getRootElement(), 255, 100, 100, true);

end
addCommandHandler('nextmap',startMidMapVote)


----------------------------------------------------------------------------
-- event midMapVoteResult
--
-- Called from the votemanager when the poll has completed
----------------------------------------------------------------------------
addEvent('midMapVoteResult')
addEventHandler('midMapVoteResult', getRootElement(),
	function( votedYes )
		if votedYes then
			startVoting()
		end
	end
)

function resolveAttacker(other)
	if other and getElementType(other) == "vehicle" then
		other = getVehicleController(other)
	end
	if other and getElementType(other) == "player" then
		return other
	end
	return nil
end
