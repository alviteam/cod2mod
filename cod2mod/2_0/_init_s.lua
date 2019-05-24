outputDebugString('==================================================')
outputDebugString('/')
outputDebugString('/= Call of Duty 2 MOD by bmat')
outputDebugString('/')
outputDebugString('==================================================')

GameTypes = {}

local resMapmanager = getResourceFromName('mapmanager')
local resScoreboard = getResourceFromName('scoreboard')
assert(getResourceState(resMapmanager) == 'running', 'Resource \'Mapmanager\' is not running.')
assert(getResourceState(resScoreboard) == 'running', 'Resource \'Scoreboard\' is not running.')