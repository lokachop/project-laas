TOOL.Category = "LAAS"
TOOL.Name = "#tool.laas_rps.name"
TOOL.AddToMenu = true

TOOL.LeftClickAutomatic = false
TOOL.RightClickAutomatic = false

TOOL.ClientConvar = {

}

if SERVER then
	util.AddNetworkString("LokaLAASRPSLuaIsDumbWhyIsThisNotCalledOnTheClient")
end


function TOOL:Reload(tr)
	print("re")
end


function TOOL:LeftClick(tr)
	if game.SinglePlayer() then
		
	end
	print("lc")
end

function TOOL:RightClick(tr)
	print("rc")
end

function TOOL:Think()

end

function TOOL:Deploy()
	if game.SinglePlayer() then
		if SERVER then
			net.Start("LokaLAASRPSLuaIsDumbWhyIsThisNotCalledOnTheClient")
				net.WriteString("DeployCopy")
			net.Send(Entity(1))
		end
	end
	for k, v in pairs(self) do
		print(k, v)
	end
	print("deployed")
end

function TOOL:Holster()

end

if CLIENT then
	net.Receive("LokaLAASRPSLuaIsDumbWhyIsThisNotCalledOnTheClient", function()
		local gettype = net.ReadString()
	end)
end



local function DrawFilledCircle(xp, yp, s)
	local circt = {}
	local iterations = 16
	for i = 0, iterations do
		local curri = i / iterations
		local xc = xp + math.sin(curri * (math.pi * 2)) * s
		local yc = yp + math.cos(curri * (math.pi * 2)) * s

		table.insert(circt, 0, {x = xc, y = yc})
	end

	surface.DrawPoly(circt)
end

function TOOL:DrawToolScreen(w, h)
	draw.NoTexture()
	surface.SetDrawColor(50, 50, 75)
	surface.DrawRect(0, 0, w, h)

	
	local xc = CurTime() * 64 % (w + 64 + 32)
	local yc = h * 0.9 + -math.abs(math.sin(CurTime() * 3.269) * h / 2)
	
	DrawFilledCircle((self.RenderToolScreenPrevXC or 0) - 32, self.RenderToolScreenPrevYC or 0, 32)

	surface.SetDrawColor(100, 100, 150, 255)
	DrawFilledCircle(xc - 32, yc, 32)
	surface.SetDrawColor(115, 115, 150)
	DrawFilledCircle((xc - 32) - 8, yc - 8, 16)


	self.RenderToolScreenPrevXC = xc
	self.RenderToolScreenPrevYC = yc


	draw.SimpleText("LAAS v"..(tostring(LAAS.Version) or "error!"), "Trebuchet18", w, h, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
	draw.SimpleText("#tool.laas_rps.name", "Trebuchet24", w / 2, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

function TOOL.BuildCPanel(dform)
	dform:SetName("#tool.laas_rps.name")
	dform:Help("WIP :/")
end