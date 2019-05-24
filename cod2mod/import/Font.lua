Font = {}

Font.adjustSize = function(font, maxheight)
	if(not font) then return false end
	if(type(maxheight) ~= 'number') then return false end
	
	local fontsize = 0
	local height
	while(true) do
		fontsize = fontsize + 0.01
		height = dxGetFontHeight(fontsize, font)
		if(height and height >= maxheight) then
			return fontsize
		end
	end
end

Font.Calibri = dxCreateFont('fonts/Calibri.ttf', 40)
if(not Font.Calibri) then Font.Calibri = "clear" end

Font.Segoe = dxCreateFont('fonts/SegoeUI.ttf', 30)
if(not Font.Segoe) then Font.Segoe = "clear" end