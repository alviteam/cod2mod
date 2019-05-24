function dropWeapon(totalAmmo, killer, killerWeapon, bodypart, stealth)
	local object
	local weapon = getPedWeapon(source)
	local ammo = getPedTotalAmmo(source)
	local x, y, z = getElementPosition(source)
	if(weapon == 22) then object = createObject(346, x, y, z-0.25, 90, 0, 0) setTimer(destroyElement, 30000, 1, object) end
	if(weapon == 25) then object = createObject(349, x, y, z-0.25, 90, 0, 0) setTimer(destroyElement, 30000, 1, object) end
	if(weapon == 26) then object = createObject(350, x, y, z-0.25, 90, 0, 0) setTimer(destroyElement, 30000, 1, object) end
	if(weapon == 27) then object = createObject(351, x, y, z-0.25, 90, 0, 0) setTimer(destroyElement, 30000, 1, object) end
	if(weapon == 29) then object = createObject(353, x, y, z-0.25, 90, 0, 0) setTimer(destroyElement, 30000, 1, object) end
	if(weapon == 30) then object = createObject(355, x, y, z-0.25, 90, 0, 0) setTimer(destroyElement, 30000, 1, object) end
	if(weapon == 31) then object = createObject(356, x, y, z-0.25, 90, 0, 0) setTimer(destroyElement, 30000, 1, object) end
	if(weapon == 32) then object = createObject(372, x, y, z-0.25, 90, 0, 0) setTimer(destroyElement, 30000, 1, object) end
	if(weapon == 33) then object = createObject(357, x, y, z-0.25, 90, 0, 0) setTimer(destroyElement, 30000, 1, object) end
	if(weapon == 34) then object = createObject(358, x, y, z-0.25, 90, 0, 0) setTimer(destroyElement, 30000, 1, object) end
	if(weapon == 39) then object = createObject(363, x, y, z-0.25, 90, 0, 0) setTimer(destroyElement, 30000, 1, object) end
	if(isElement(object)) then setElementData(object, "dropWeaponID", weapon) end
	if(isElement(object)) then setElementData(object, "dropWeaponAmmo", ammo) end
end
addEventHandler("onPlayerWasted", getRootElement(), dropWeapon)

function takeDroppedWeapon(thePlayer, weapon)
	if(weapon and getElementData(weapon, "dropWeaponID") ~= false and getElementData(weapon, "dropWeaponAmmo") ~= false) then
		if(getElementHealth(thePlayer) ~= false) then
			if(getElementHealth(thePlayer) > 0) then
				giveWeapon(thePlayer, tonumber(getElementData(weapon, "dropWeaponID")), tonumber(getElementData(weapon, "dropWeaponAmmo")))
				destroyElement(weapon)
			end
		end
	end
end
addEvent("takeDroppedWeapon", true)
addEventHandler("takeDroppedWeapon", getRootElement(), takeDroppedWeapon)