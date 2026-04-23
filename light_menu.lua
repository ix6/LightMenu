-- lighting menu by alviin
-- do !light in chat to open it

if SERVER then

	util.AddNetworkString("LightMenu_Open")

	hook.Add("PlayerSay", "lightmenuhook", function(ply, text)
		local txt = string.lower(string.Trim(text))
		if txt == "!light" then
			net.Start("LightMenu_Open")
			net.Send(ply)
			return ""
		end
	end)

	return
end

local isOn = false
local myMode = 0
local theFrame

hook.Add("PreRender", "lightmenu_prerender", function()
	if isOn then
		render.SetLightingMode(myMode)
	end
end)

hook.Add("RenderScreenspaceEffects", "lightmenu_reset1", function()
	render.SetLightingMode(0)
end)

hook.Add("PreHUDPaint", "lightmenu_reset2", function()
	render.SetLightingMode(0)
end)

hook.Add("HUDPaint", "lightmenu_reset3", function()
	render.SetLightingMode(0)
end)

hook.Add("PostRender", "lightmenu_reset4", function()
	render.SetLightingMode(0)
end)

local function MakeTheMenu()

	if IsValid(theFrame) then
		theFrame:Remove()
	end

	local fw = 220
	local fh = 140

	theFrame = vgui.Create("DFrame")
	theFrame:SetSize(fw, fh)
	theFrame:SetTitle("")
	theFrame:ShowCloseButton(false)
	theFrame:MakePopup()
	theFrame:SetDraggable(false)

	local xpos = 20
	local ypos = ScrH() / 2 - fh / 2
	theFrame:SetPos(xpos, ypos)

	theFrame.Paint = function(s, w, h)
		draw.RoundedBox(6, 0, 0, w, h, Color(35, 35, 35, 240))
		draw.RoundedBox(6, 0, 0, w, 24, Color(25, 25, 25, 255))
		draw.SimpleText("Lighting Menu", "DermaDefaultBold", 10, 6, color_white)
	end

	local closeBtn = vgui.Create("DButton", theFrame)
	closeBtn:SetSize(20, 20)
	closeBtn:SetPos(fw - 22, 2)
	closeBtn:SetText("X")
	closeBtn.DoClick = function()
		theFrame:Remove()
	end

	local cb1
	local cb2
	local cb3

	cb1 = vgui.Create("DCheckBoxLabel", theFrame)
	cb1:SetPos(10, 35)
	cb1:SetText("Activate Brightness")
	cb1:SetValue(isOn)
	cb1.OnChange = function(s, v)
		isOn = v
	end

	cb2 = vgui.Create("DCheckBoxLabel", theFrame)
	cb2:SetPos(10, 60)
	cb2:SetText("Bright+")
	cb2:SetValue(myMode == 1)
	cb2.OnChange = function(s, v)
		if v == true then
			myMode = 1
			cb3:SetValue(false)
		else
			if myMode == 1 then myMode = 0 end
		end
	end

	cb3 = vgui.Create("DCheckBoxLabel", theFrame)
	cb3:SetPos(10, 85)
	cb3:SetText("Bright++")
	cb3:SetValue(myMode == 2)
	cb3.OnChange = function(s, v)
		if v == true then
			myMode = 2
			cb2:SetValue(false)
		else
			if myMode == 2 then myMode = 0 end
		end
	end

end

hook.Add("OnPlayerChat", "lightmenu_chatbackup", function(ply, text)
	if ply ~= LocalPlayer() then return end
	local txt = string.lower(string.Trim(text))
	if txt == "!light" then
		MakeTheMenu()
		return true
	end
end)

net.Receive("LightMenu_Open", function()
	MakeTheMenu()
end)
