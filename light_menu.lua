--  Client-Side Lighting menu by alviin
-- works with !light in-game chat

if SERVER then

	util.AddNetworkString("LightMenu_Open")

	hook.Add("PlayerSay", "lightmenuhook", function(ply, text)

		-- trim and lower the text 
		local txt = string.lower(string.Trim(text))

		if txt == "!light" then
			net.Start("LightMenu_Open")
			net.Send(ply)
			return "" -- hides the message in chat
		end

	end)

	return

end

-- client below this

local isOn = false  -- is lighting on or off
local myMode = 0    -- 0 nothing, 1 = bright, 2 = real bright
local theFrame      -- the menu panel 

local function doLight()
	if isOn == true then
		render.SetLightingMode(myMode)
	else
		render.SetLightingMode(0)
	end
end

-- runs every frame 
hook.Add("PreRender", "lightmenu_prerender", function()
	doLight()
end)

-- reset it after so other stuff doesnt break
hook.Add("PostRender", "lightmenu_postrenderreset", function()
	render.SetLightingMode(0)
end)


-- menu 

local function MakeTheMenu()

	-- close it if already open
	if IsValid(theFrame) then
		theFrame:Remove()
	end

	local fw = 220
	local fh = 140


	theFrame = vgui.Create("DFrame")
	theFrame:SetSize(fw, fh)
	theFrame:SetTitle("")  -- 
	theFrame:ShowCloseButton(false)  --  close button
	theFrame:MakePopup()
	theFrame:SetDraggable(false)  

	-- position on left side of screen
	local xpos = 20
	local ypos = ScrH() / 2 - fh / 2
	theFrame:SetPos(xpos, ypos)

	-- custom background painting
	theFrame.Paint = function(s, w, h)
		draw.RoundedBox(6, 0, 0, w, h, Color(35, 35, 35, 240))
		draw.RoundedBox(6, 0, 0, w, 24, Color(25, 25, 25, 255))
		draw.SimpleText("Lighting Menu", "DermaDefaultBold", 10, 6, color_white)
	end

	-- close button 
	local closeBtn = vgui.Create("DButton", theFrame)
	closeBtn:SetSize(20, 20)
	closeBtn:SetPos(fw - 22, 2)
	closeBtn:SetText("X")
	closeBtn.DoClick = function()
		theFrame:Remove()
	end

	-- had to put these here or it crashes idk why
	local cb1
	local cb2
	local cb3

	-- enable checkbox
	cb1 = vgui.Create("DCheckBoxLabel", theFrame)
	cb1:SetPos(10, 35)
	cb1:SetText("Activate Brightness")
	cb1:SetValue(isOn)
	cb1.OnChange = function(s, v)
		isOn = v
		doLight()
	end

	-- bright mode 1
	cb2 = vgui.Create("DCheckBoxLabel", theFrame)
	cb2:SetPos(10, 60)
	cb2:SetText("Bright+")
	cb2:SetValue(myMode == 1)
	cb2.OnChange = function(s, v)
		if v == true then
			myMode = 1
			cb3:SetValue(false)  -- turn off the other one
		else
			if myMode == 1 then
				myMode = 0
			end
		end
		doLight()
	end

	-- bright mode 2 (brighter)
	cb3 = vgui.Create("DCheckBoxLabel", theFrame)
	cb3:SetPos(10, 85)
	cb3:SetText("Bright++")
	cb3:SetValue(myMode == 2)
	cb3.OnChange = function(s, v)
		if v == true then
			myMode = 2
			cb2:SetValue(false)  -- turn off the other one
		else
			if myMode == 2 then
				myMode = 0
			end
		end
		doLight()
	end

end

-- this is a backup incase the net message doesnt work
hook.Add("OnPlayerChat", "lightmenu_chatbackup", function(ply, text)

	if ply ~= LocalPlayer() then return end

	local txt = string.lower(string.Trim(text))

	if txt == "!light" then
		MakeTheMenu()
		return true
	end

end)

-- open menu when server tells us to
net.Receive("LightMenu_Open", function()
	MakeTheMenu()
end)