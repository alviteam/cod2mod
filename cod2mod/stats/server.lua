Stats = {}
local DBHANDLER = false
local TimeOnline = {}

addEventHandler('onResourceStart', resourceRoot,
	function ()
		DBHANDLER = dbConnect('sqlite', 'users.db')
	end
)

--
-- Time online
--
addEventHandler('onResourceStart', resourceRoot,
	function ()
		if(DBHANDLER) then
			for i, player in ipairs(getElementsByType('player')) do
				local query = dbQuery(DBHANDLER, 'select * from stats_timeonline where serial = ?', getPlayerSerial(player))
				local result = dbPoll(query, -1)

				if #result > 0 then
					TimeOnline[player] = result[1]['seconds']

					local formattedString = convertSecondsToFormattedTime(TimeOnline[player])
					setElementData(player, 'Time online', formattedString)
				else
					TimeOnline[player] = 0
					setElementData(player, 'Time online', '0:00')
				end
			end
		end
	end
)

addEventHandler('onResourceStop', resourceRoot,
	function ()
		if(DBHANDLER) then
			for i, player in ipairs(getElementsByType('player')) do
				local query = dbQuery(DBHANDLER, 'select * from stats_timeonline where serial = ?', getPlayerSerial(player))
				local result = dbPoll(query, -1)

				if #result > 0 then
					dbExec(DBHANDLER, 'update stats_timeonline set seconds = ? where serial = ?', TimeOnline[player], getPlayerSerial(player))
				else
					dbExec(DBHANDLER, 'insert into stats_timeonline (serial, seconds) values (?, ?)', getPlayerSerial(player), TimeOnline[player])
				end
			end
		end
	end
)

addEventHandler('onPlayerJoin', root,
	function ()
		if(DBHANDLER) then
			local query = dbQuery(DBHANDLER, 'select * from stats_timeonline where serial = ?', getPlayerSerial(source))
			local result = dbPoll(query, -1)

			if #result > 0 then
				TimeOnline[source] = result[1]['seconds']

				local formattedString = convertSecondsToFormattedTime(TimeOnline[source])
				setElementData(source, 'Time online', formattedString)
			else
				TimeOnline[source] = 0
				setElementData(source, 'Time online', '0:00')
			end
		end
	end
)

addEventHandler('onPlayerQuit', root,
	function ()
		if(DBHANDLER) then
			local query = dbQuery(DBHANDLER, 'select * from stats_timeonline where serial = ?', getPlayerSerial(source))
			local result = dbPoll(query, -1)

			if #result > 0 then
				dbExec(DBHANDLER, 'update stats_timeonline set seconds = ? where serial = ?', TimeOnline[source], getPlayerSerial(source))
			else
				dbExec(DBHANDLER, 'insert into stats_timeonline (serial, seconds) values (?, ?)', getPlayerSerial(source), TimeOnline[source])
			end
		end
	end
)

function updateTimeOnlineTimer()
	for i, player in ipairs(getElementsByType('player')) do
		if(TimeOnline[player]) then
			TimeOnline[player] = TimeOnline[player] + 1

			local formattedString = convertSecondsToFormattedTime(TimeOnline[player])
			setElementData(player, 'Time online', formattedString)
		end
	end
end
setTimer(updateTimeOnlineTimer, 1000, 0)


--
-- Killstreaks
--
function Stats.saveKillstreak(player, count)
	if(DBHANDLER) then
		local query = dbQuery(DBHANDLER, 'select * from stats_killstreak where serial = ?', getPlayerSerial(player))
		local result = dbPoll(query, -1)

		if #result > 0 then
			if count > result[1]['kills'] then
				dbExec(DBHANDLER, 'update stats_killstreak set kills = ? where serial = ?', count, getPlayerSerial(player))
				setElementData(source, 'Best KS', count)
			end
		else
			dbExec(DBHANDLER, 'insert into stats_killstreak (serial, kills) values (?, ?)', getPlayerSerial(player), count or 0)
		end
	end
end

addEventHandler('onResourceStart', resourceRoot,
	function ()
		if(DBHANDLER) then
			for i, player in ipairs(getElementsByType('player')) do
				local query = dbQuery(DBHANDLER, 'select * from stats_killstreak where serial = ?', getPlayerSerial(player))
				local result = dbPoll(query, -1)

				if #result > 0 then
					setElementData(player, 'Best KS', result[1]['kills'])
				else
					setElementData(player, 'Best KS', 0)
				end
			end
		end
	end
)

addEventHandler('onPlayerJoin', root,
	function ()
		if(DBHANDLER) then
			local query = dbQuery(DBHANDLER, 'select * from stats_killstreak where serial = ?', getPlayerSerial(source))
			local result = dbPoll(query, -1)

			if #result > 0 then
				setElementData(source, 'Best KS', result[1]['kills'])
			else
				setElementData(source, 'Best KS', 0)
			end
		end
	end
)

addEventHandler('onResourceStop', resourceRoot,
	function ()
		if(DBHANDLER) then
			for i, player in ipairs(getElementsByType('player')) do
				local query = dbQuery(DBHANDLER, 'select * from stats_killstreak where serial = ?', getPlayerSerial(player))
				local result = dbPoll(query, -1)

				if #result > 0 then
					if Killstreaks[player] > result[1]['kills'] then
						dbExec(DBHANDLER, 'update stats_killstreak set kills = ? where serial = ?', Killstreaks[player], getPlayerSerial(player))
						setElementData(player, 'Best KS', Killstreaks[player])
					end
				else
					dbExec(DBHANDLER, 'insert into stats_killstreak (serial, kills) values (?, ?)', getPlayerSerial(player), Killstreaks[player] or 0)
				end
			end
		end
	end
)

addEventHandler('onPlayerQuit', root,
	function ()
		if(DBHANDLER) then
			local query = dbQuery(DBHANDLER, 'select * from stats_killstreak where serial = ?', getPlayerSerial(source))
			local result = dbPoll(query, -1)

			if #result > 0 then
				if Killstreaks[source] > result[1]['kills'] then
					dbExec(DBHANDLER, 'update stats_killstreak set kills = ? where serial = ?', Killstreaks[source], getPlayerSerial(source))
					setElementData(source, 'Best KS', Killstreaks[source])
				end
			else
				dbExec(DBHANDLER, 'insert into stats_killstreak (serial, kills) values (?, ?)', getPlayerSerial(source), Killstreaks[source] or 0)
			end
		end
	end
)


--
-- Utils
--
function convertSecondsToFormattedTime(seconds)
	local hours = math.floor(seconds / 3600)
	seconds = seconds - hours * 3600
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

	local formattedString = ''
	if(hours > 0) then
		formattedString = hours..':'
	end
	if(minutes > 0) then
		if(minutes < 10) then
			formattedString = formattedString..'0'
		end
		formattedString = formattedString..minutes..':'
	else
		formattedString = formattedString..'00:'
	end
	if(seconds < 10) then
		formattedString = formattedString..'0'
	end
	formattedString = formattedString..seconds

	return formattedString
end