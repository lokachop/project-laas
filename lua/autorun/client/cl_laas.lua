-- main file for LAAS
-- coded by lokachop
LAAS = LAAS or {}
LAAS.Version = 0.1
LAAS.Config = {}
LAAS.Objects = LAAS.Objects or {}
LAAS.CameraPoints = LAAS.CameraPoints or {}
--[[
example camera point for refence
local exPoint = {
	pos = Vector(0, 0, 0), -- point position
	dir = Vector(0, 1, 0), -- direction it is aiming at
	vel = 1, -- velocity at point
	fov = 90, -- fov at point
	type = 1 -- type of point, refer to point types below
}

local pointTypes = {
	1 = "Generic", -- generic point that camera travels along
	2 = "Skip", -- just jump the entire point
	3 = "FadeTeleport" -- fades screen out and teleports to next point, fading in
}
]]--



LAAS.Util = LAAS.Util or {}
-- init basic config
LAAS.Util.SetConfigVar("CameraPathDebugIterations", 1)
LAAS.Util.SetConfigVar("DrawCamPoints", 1)
LAAS.Util.SetConfigVar("DrawCamPath", 0)


function LAAS.Util.DrawCameraPoints()
	for k, v in pairs(LAAS.CameraPoints) do
		local col = HSVToColor((k / #LAAS.CameraPoints) * 360, 1, 1)
		--local colb = HSVToColor((k / #LAAS.CameraPoints) * 360, 0.4, 1)

		local vec = Vector(4, 2, 2)
		local vec2 = Vector(0.3, 1.4, 1.4)
		local ang = (v.pos - (v.pos + v.dir)):Angle()

		render.DrawWireframeBox(v.pos, ang, vec, -vec, col, true)

		local transl = LocalToWorld(Vector(-4.2, 0, 0), Angle(0, 0, 0), v.pos, ang)
		render.DrawWireframeBox(transl, ang, vec2, -vec2, col, true) -- boxes are probs more expensive due to all the localtoworld stuff but they look nicer
	end
end

function LAAS.Util.DrawCameraPath()
	local itr = LAAS.Util.GetConfigVar("CameraPathDebugIterations", 4) * (#LAAS.CameraPoints) -- calculate iterations based on # of points and user-set ipp


	for i = 0, itr do
		local cpp = math.Clamp(i / itr, 0, 1)
		local cpp2 = math.Clamp((i + 1) / itr, 0, 1)

		local pt = LAAS.Util.LokaPointDataToPosTable(LAAS.CameraPoints)

		local p1 = LAAS.Util.LerpVectorOffCameraPath(cpp, pt)
		local p2 = LAAS.Util.LerpVectorOffCameraPath(cpp2, pt)

		local col = HSVToColor(cpp * 360, 1, 1)
		render.DrawLine(p1, p2, col, true)
	end
end


function LAAS.Util.DrawVisualCameraPath()
	local itr = LAAS.Util.GetConfigVar("CameraPathDebugIterations", 4) * (#LAAS.CameraPoints) -- calculate iterations based on # of points and user-set ipp

	for i = 0, itr do
		local cpp = math.Clamp(i / itr, 0, 1)
		local cpp2 = math.Clamp((i + 1) / itr, 0, 1)

		local col = HSVToColor(cpp * 360, 1, 1)

		local ptc = LAAS.Util.LokaPointDataToPosTablePlusDir(LAAS.CameraPoints)
		local p1 = LAAS.Util.LerpVectorOffCameraPath(cpp, ptc)
		local p2 = LAAS.Util.LerpVectorOffCameraPath(cpp2, ptc)
		render.DrawLine(p1, p2, col, true)
	end
end



function LAAS.Util.PrintToChat(...)
	chat.AddText(Color(50, 50, 100), "[LAAS] ", Color(180, 180, 180), ...)
end

function LAAS.Util.AddPoint(pos, dir, vel, fov, type)
	local pdata = {
		pos = pos,
		dir = dir,
		vel = vel,
		fov = fov,
		type = type
	}
	LAAS.CameraPoints[#LAAS.CameraPoints + 1] = pdata
end


function LAAS.Util.RemoveLast()
	LAAS.CameraPoints[#LAAS.CameraPoints] = nil
end


function LAAS.Util.DeleteAllPoints()
	LAAS.CameraPoints = {}
end

concommand.Add("laas_debug_wipepoints", function()
	LAAS.Util.DeleteAllPoints()
	LAAS.Util.PrintToChat("Wiped all points!")
end)


hook.Add("Think", "ThinkLAAS", function()
end)

hook.Add("PostDrawOpaqueRenderables", "LAASRenderPathAndPoints", function()
	if GetConVar("laas_renderpoints"):GetBool() then
		LAAS.Util.DrawCameraPoints()
	end

	if GetConVar("laas_renderpath"):GetBool() then
		LAAS.Util.DrawCameraPath() -- expensive!
	end

	if GetConVar("laas_rendereyepath"):GetBool() then
		LAAS.Util.DrawVisualCameraPath() -- expensive!
	end
end)