LAAS = LAAS or {}
LAAS.Debug = LAAS.Debug or {}

function LAAS.Debug.AddDebugPoint()
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

concommand.Add("laas_debug_addpoint", function()
	LAAS.Debug.AddDebugPoint()
	LAAS.Util.PrintToChat("Added a point!")
end)

concommand.Add("laas_debug_play", function()
	LAAS.Util.PrintToChat("Playing sequence!")
	LAAS.Playback.BeginPlayingCurrentPoints()
end)