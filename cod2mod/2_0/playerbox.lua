PBox = {}
PBox.color = tocolor(255, 255, 255, 180)
PBox.height = math.floor(sX / 15)
PBox.width = PBox.height * 3
PBox.left = sX - PBox.width
PBox.top = 0
PBox.right = sX
PBox.bottom = PBox.top + PBox.height
PBox.avatar = {}
PBox.avatar.src = 'images/default_avatar.png'
PBox.avatar.height = math.ceil(PBox.height * 0.8)
PBox.avatar.width = PBox.avatar.height
PBox.avatar.top = PBox.top + math.floor(PBox.height * 0.1)
PBox.avatar.bottom = PBox.avatar.top + PBox.avatar.height
PBox.avatar.left = PBox.left + PBox.avatar.top
PBox.avatar.right = PBox.avatar.left + PBox.avatar.width
PBox.info = {}
PBox.info.color = tocolor(20, 20, 20, 180)
PBox.info.text = 'Press F1 for player card'
PBox.info.left = PBox.left + math.floor(PBox.width / 20)
PBox.info.right = PBox.right - math.floor(PBox.width / 20)
PBox.info.bottom = PBox.bottom
PBox.info.top = PBox.bottom - math.floor(PBox.height / 6)
PBox.info.font = dxCreateFont('fonts/Calibri.ttf', 20)
PBox.info.fontsize = Font.adjustSize(PBox.info.font, PBox.info.bottom - PBox.info.top)
PBox.label = {}
PBox.label.height = math.floor(PBox.height / 5)
PBox.label.left = PBox.avatar.right + math.floor(PBox.width / 20)
PBox.label.right = PBox.right - math.floor(PBox.width / 20)
PBox.label.font = dxCreateFont('fonts/Calibri.ttf', 20)
PBox.label.fontsize = Font.adjustSize(PBox.label.font, PBox.label.height)
PBox.label.element = {}
PBox.label.element[1] = {}
PBox.label.element[1].text = 'Account: Unknown'
PBox.label.element[1].top = math.floor(PBox.avatar.height * 1/4) + PBox.avatar.top
PBox.label.element[2] = {}
PBox.label.element[2].text = 'Rank: Unknown'
PBox.label.element[2].top = math.floor(PBox.avatar.height * 2/4) + PBox.avatar.top
PBox.label.element[3] = {}
PBox.label.element[3].text = 'Score: Unknown'
PBox.label.element[3].top = math.floor(PBox.avatar.height * 3/4) + PBox.avatar.top

addEventHandler('onClientRender', getRootElement(),
	function()
		dxDrawRectangle(PBox.left, PBox.top, PBox.width, PBox.height, PBox.color)
		
		dxDrawImage(PBox.avatar.left, PBox.avatar.top, PBox.avatar.width, PBox.avatar.height, PBox.avatar.src)
		
		dxDrawText(PBox.label.element[1].text, PBox.label.left, PBox.label.element[1].top, PBox.label.right, PBox.label.element[1].top, PBox.info.color, PBox.label.fontsize, PBox.label.font, 'left', 'center')
		dxDrawText(PBox.label.element[2].text, PBox.label.left, PBox.label.element[2].top, PBox.label.right, PBox.label.element[2].top, PBox.info.color, PBox.label.fontsize, PBox.label.font, 'left', 'center')
		dxDrawText(PBox.label.element[3].text, PBox.label.left, PBox.label.element[3].top, PBox.label.right, PBox.label.element[3].top, PBox.info.color, PBox.label.fontsize, PBox.label.font, 'left', 'center')
		
		dxDrawText(PBox.info.text, PBox.info.left, PBox.info.top, PBox.info.right, PBox.info.bottom, PBox.info.color, PBox.info.fontsize, PBox.info.font, 'right', 'center')
	end
)

setTimer(
	function()
		triggerServerEvent('onPlayerBoxRequest', getLocalPlayer())
	end,
	3000, 0
)

addEvent('onPlayerBoxDataSync', true)
addEventHandler('onPlayerBoxDataSync', getRootElement(),
	function(accountname, rankname, scorenumber)
		PBox.label.element[1].text = 'Account: '..tostring(accountname)
	end
)