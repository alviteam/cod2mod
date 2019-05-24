local screenWidth, screenHeight = guiGetScreenSize()

function dropWeaponShowedInfo()
	local x, y, z = getElementPosition(getLocalPlayer())
	for i,weapon in ipairs(getElementsByType("object")) do
		local xo, yo, zo = getElementPosition(weapon)
		if(getDistanceBetweenPoints3D(x, y, z, xo, yo, zo) <= 2 and getElementHealth(getLocalPlayer()) ~= false) then
			if(getElementHealth(getLocalPlayer()) > 0) then
				if(getElementModel(weapon) == 346 or getElementModel(weapon) == 349 or getElementModel(weapon) == 350 or
				getElementModel(weapon) == 351 or getElementModel(weapon) == 353 or getElementModel(weapon) == 372 or
				getElementModel(weapon) == 357 or getElementModel(weapon) == 358 or getElementModel(weapon) == 363 or
				getElementModel(weapon) == 355 or getElementModel(weapon) == 356) then
					local font = "bankgothic" 
					local scale = 1
					local text = "Press USE |F| to pick up"
					local width = dxGetTextWidth(text, scale, font)
					dxDrawText(text, screenWidth/2-(width/2), screenHeight/4*3, screenWidth/2-(width/2), screenHeight/4*3, tocolor(255,255,255), scale, tostring(font))
					if(getKeyState("f")) then triggerServerEvent("takeDroppedWeapon", getLocalPlayer(), getLocalPlayer(), weapon) end
				end
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement(), dropWeaponShowedInfo)