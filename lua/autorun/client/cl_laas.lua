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

LAAS.Util.SetConfigVar("CameraPathDebugIterations", 4)

function LAAS.Util.DrawCameraPointDebug()
	for k, v in pairs(LAAS.CameraPoints) do
		local col = HSVToColor((k / #LAAS.CameraPoints) * 360, 1, 1)
		local colb = HSVToColor((k / #LAAS.CameraPoints) * 360, 0.4, 1)

		debugoverlay.Cross(v.pos, 2, FrameTime() * 2, col) -- i know debugoverlay is slow and dumb and stupid but its meant for debug
		debugoverlay.Line(v.pos, v.pos + v.dir * 8, FrameTime() * 2, colb)
	end
end

function LAAS.Util.DrawCameraPathDebug()
	local itr = LAAS.Util.GetConfigVar("CameraPathDebugIterations", 4) * #LAAS.CameraPoints


	for i = 0, itr do -- 64 iterations of path
		local cpp = math.Clamp((i) / itr, 0, 1)
		local cpp2 = math.Clamp((i + 1) / itr, 0, 1)

		local p1 = LAAS.Util.LerpVectorOffCameraPath(cpp, LAAS.CameraPoints)
		local p2 = LAAS.Util.LerpVectorOffCameraPath(cpp2, LAAS.CameraPoints)

		local col = HSVToColor(cpp * 360, 1, 1)
		debugoverlay.Line(p1, p2, FrameTime() * 2, col)
	end
end


function LAAS.Util.PrintToChat(...)
	chat.AddText(Color(50, 50, 100), "[LAAS] ", Color(180, 180, 180), ...)
end


function LAAS.Util.AddDebugPoint()
	if not CLIENT then
		return -- client only!
	end

	local pos = LocalPlayer():EyePos()
	local dir = LocalPlayer():EyeAngles():Forward()
	local pdata = {
		pos = pos,
		dir = dir,
		vel = 1,
		fov = 90,
		type = 1
	} 

	LAAS.CameraPoints[#LAAS.CameraPoints + 1] = pdata
end

function LAAS.Util.DeleteAllPoints()
	LAAS.CameraPoints = {}
end

concommand.Add("laas_debug_addpoint", function()
	LAAS.Util.AddDebugPoint()
	LAAS.Util.PrintToChat("Added a point!")
end)

concommand.Add("laas_debug_wipepoints", function()
	LAAS.Util.DeleteAllPoints()
	LAAS.Util.PrintToChat("Wiped all points!")
end)


hook.Add("Think", "ThinkLAAS", function()
	LAAS.Util.DrawCameraPointDebug()
	LAAS.Util.DrawCameraPathDebug()
end)