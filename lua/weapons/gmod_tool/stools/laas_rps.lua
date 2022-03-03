TOOL.Category = "LAAS"
TOOL.Name = "#tool.laas_rps.name"
TOOL.AddToMenu = true
TOOL.LeftClickAutomatic = false
TOOL.RightClickAutomatic = false
TOOL.ClientConVar["speed"] = 1
TOOL.ClientConVar["type"] = 1
TOOL.ClientConVar["fov"] = 90


if SERVER and game.SinglePlayer() then
	util.AddNetworkString("LAAS_RPS_Deploy")
	util.AddNetworkString("LAAS_RPS_Holster")
	util.AddNetworkString("LAAS_RPS_LC")
	util.AddNetworkString("LAAS_RPS_RC")
	util.AddNetworkString("LAAS_RPS_RE")
end



local function DeployToCall()
	print("Deployed!")
end

local function HolsterToCall()
	print("Holstered!")
end

local function ReloadToCall()
	print("Reloaded!")
end

local function LeftClickToCall()
	print("Left clicked!")
end

local function RightClickToCall()
	print("Right clicked!")
end




function TOOL:Reload(tr)
	if game.SinglePlayer() and SERVER then
		net.Start("LAAS_RPS_RE")
		net.Send(self:GetOwner())
	end
	ReloadToCall()
end

function TOOL:LeftClick(tr)
	if game.SinglePlayer() and SERVER then
		net.Start("LAAS_RPS_LC")
		net.Send(self:GetOwner())
	end
	LeftClickToCall()
end

function TOOL:RightClick(tr)
	if game.SinglePlayer() and SERVER then
		net.Start("LAAS_RPS_RC")
		net.Send(self:GetOwner())
	end
	RightClickToCall()
end

function TOOL:Think()
end

function TOOL:Deploy()
	if game.SinglePlayer() and SERVER then -- why garry, whyyyy
		net.Start("LAAS_RPS_Deploy")
		net.Send(self:GetOwner())
	end
	DeployToCall()
end

function TOOL:Holster()
	HolsterToCall()
end

if CLIENT then
	-- setup receives on client for singleplayer
	net.Receive("LAAS_RPS_Deploy", function()
		DeployToCall()
	end)

	net.Receive("LAAS_RPS_Holster", function()
		HolsterToCall()
	end)

	net.Receive("LAAS_RPS_RE", function()
		ReloadToCall()
	end)

	net.Receive("LAAS_RPS_LC", function()
		LeftClickToCall()
	end)

	net.Receive("LAAS_RPS_RC", function()
		RightClickToCall()
	end)
end



















-- VIS VELOW

local function DrawFilledCircle(xp, yp, s)
	local circt = {}
	local iterations = 16

	for i = 0, iterations do
		local curri = i / iterations
		local xc = xp + math.sin(curri * (math.pi * 2)) * s
		local yc = yp + math.cos(curri * (math.pi * 2)) * s

		table.insert(circt, 0, {
			x = xc,
			y = yc
		})
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

	draw.SimpleText("LAAS v" .. LAAS.Util.GetVersionString(), "Trebuchet18", w, h, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
	draw.SimpleText("#tool.laas_rps.name", "Trebuchet24", w / 2, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

function TOOL.BuildCPanel(dform)
	dform:SetName("#tool.laas_rps.name")
	dform:Help("WIP :/")

	dform:NumSlider("New node FOV", "laas_rps_fov", 10, 170, 1)
	dform:NumSlider("New node speed", "laas_rps_speed", 0.01, 5, 2)
	dform:NumSlider("New node type", "laas_rps_type", 1, 1, 0)
end