local sX, sY = guiGetScreenSize()

TeamSelector = {}
TeamSelector.bg = {}
TeamSelector.bg.path = 'images/worldmap.png'

function drawStuff()

	dxDrawImage(0, 0, sX, sY, TeamSelector.bg.path, 0, 0, 0, tocolor(255,255,255), true)

end
--addEventHandler("onClientRender", root, drawStuff)