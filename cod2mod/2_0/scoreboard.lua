local scoreboardRes = getResourceFromName('scoreboard')

-- Try to attach columns after 5 seconds from start
setTimer(
	function()
		if (scoreboardRes and getResourceState(scoreboardRes) == "running") then
			local columns = call(scoreboardRes, 'scoreboardGetColumnCount')
			if(columns < 5) then
				addScoreboardColumns()
			end
		end
	end,
	5000, 1
)

-- Check each 2 minutes if columns exist
setTimer(
	function()
		if (scoreboardRes and getResourceState(scoreboardRes) == "running") then
			local columns = call(scoreboardRes, 'scoreboardGetColumnCount')
			if(columns < 5) then
				addScoreboardColumns()
			end
		end
	end,
	120000, 0
)

-- Try to attach columns on scoreboard resource start
addEventHandler('onResourceStart', getResourceRootElement(scoreboardRes),
	function()
		addScoreboardColumns()
	end
)

--------------------------------------------------
-- function attaches custom scoreboard columns
-- input: none
-- output: none
--------------------------------------------------
function addScoreboardColumns()
	call(scoreboardRes, 'scoreboardAddColumn', 'Score', getRootElement(), 50)
	call(scoreboardRes, 'scoreboardAddColumn', 'Kills', getRootElement(), 50)
	call(scoreboardRes, 'scoreboardAddColumn', 'Deaths', getRootElement(), 50)
	call(scoreboardRes, 'scoreboardAddColumn', 'Time online', getRootElement(), 70)
	call(scoreboardRes, 'scoreboardAddColumn', 'Best KS', getRootElement(), 50)
	call(scoreboardRes, 'scoreboardAddColumn', 'FPS', getRootElement(), 40)

	call(scoreboardRes, 'scoreboardSetColumnPriority', 'Name', 100)
	call(scoreboardRes, 'scoreboardSetColumnPriority', 'Voice', 101)
	call(scoreboardRes, 'scoreboardSetColumnPriority', 'Score', 102)
	call(scoreboardRes, 'scoreboardSetColumnPriority', 'Kills', 103)
	call(scoreboardRes, 'scoreboardSetColumnPriority', 'Deaths', 104)
	call(scoreboardRes, 'scoreboardSetColumnPriority', 'Time online', 497)
	call(scoreboardRes, 'scoreboardSetColumnPriority', 'Best KS', 498)
	call(scoreboardRes, 'scoreboardSetColumnPriority', 'FPS', 499)

	call(scoreboardRes, 'scoreboardSetSortBy', 'Score', false)
end