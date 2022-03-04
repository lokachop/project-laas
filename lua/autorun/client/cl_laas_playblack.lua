LAAS = LAAS or {}
LAAS.Playback = LAAS.Playback or {}
LAAS.Playback.Playing = false
LAAS.Playback.CurrentPoint = 0
LAAS.Playback.CurrentDelta = 0
LAAS.Playback.PlayType = 0



function LAAS.Playback.BeginPlayingCurrentPoints()
	if #LAAS.CameraPoints < 2 then
		LAAS.Util.PrintToChat("Add more camera points! (minimum 2)")
		return
	end

	if #LAAS.CameraPoints == 2 then
		LAAS.Playback.PlayType = 1 -- linear movement
	elseif #LAAS.CameraPoints == 3 then
		LAAS.Playback.PlayType = 2 -- single bezier movement
	else
		LAAS.Playback.PlayType = 0 -- spline movement
	end

	LAAS.Playback.CurrentPoint = 1
	LAAS.Playback.CurrentDelta = 0
	LAAS.Playback.Playing = true
end

function LAAS.Playback.EndPlayingCurrentPoints()
	LAAS.Playback.Playing = false
	LAAS.Playback.CurrentPoint = 1
	LAAS.Playback.CurrentDelta = 0
	LAAS.Playback.PlayType = 0
end


function LAAS.Playback.GetPosFromPointAndDelta(point, delta)
	local pointc = #LAAS.CameraPoints
	local pointmax = delta / pointc
	local pointtranslate = point / pointc
	return LAAS.Util.LerpVectorOffCameraPath(pointmax + pointtranslate)
end

function LAAS.Playback.GetCurrentPos()
	return LAAS.Playback.GetPosFromPointAndDelta(LAAS.Playback.CurrentPoint, LAAS.Playback.CurrentDelta)
end





function LAAS.Playback.GetCamPosFromPointAndDelta(point, delta)
	local pointtbl = LAAS.Util.LokaPointDataToPosTablePlusDir(LAAS.CameraPoints)

	local pointc = #LAAS.CameraPoints
	local pointmax = delta / pointc
	local pointtranslate = point / pointc
	return LAAS.Util.LerpVectorOffCameraPath(pointmax + pointtranslate, pointtbl)
end

function LAAS.Playback.GetCurrentCamPos()
	return LAAS.Playback.GetCamPosFromPointAndDelta(LAAS.Playback.CurrentPoint, LAAS.Playback.CurrentDelta)
end







function LAAS.Playback.GetCamDirFrom2Pos(p1, p2)
	return (p2 - p1):Angle()
end



function LAAS.Playback.GetCurrFOVLerp()
	local currNode = LAAS.CameraPoints[LAAS.Playback.CurrentPoint] or {}
	local nextNode = LAAS.CameraPoints[LAAS.Playback.CurrentPoint + 1] or {}


	return Lerp(LAAS.Playback.CurrentDelta, currNode.fov or 90, nextNode.fov or currNode.fov or 90)
end


hook.Add("Think", "LAASPlaybackThink", function()
	if not LAAS.Playback.Playing then
		return
	end

	if LAAS.Playback.CurrentPoint > #LAAS.CameraPoints then
		LAAS.Playback.EndPlayingCurrentPoints()
	end


	local currNode = LAAS.CameraPoints[LAAS.Playback.CurrentPoint]
	local nextNode = LAAS.CameraPoints[LAAS.Playback.CurrentPoint + 1] or {}

	local currnodesp = currNode.vel or 1
	local nextnodesp = nextNode.vel or currNode.vel

	local lerpedVel = Lerp(LAAS.Playback.CurrentDelta, currnodesp, nextnodesp)


	local vadd = FrameTime() * lerpedVel
	--local ddiv =  currNode.pos:Distance(nextNode.pos or currNode.pos + currNode.dir) / 128
	LAAS.Playback.CurrentDelta = LAAS.Playback.CurrentDelta + vadd --/ ddiv

	if LAAS.Playback.CurrentDelta > 1 then
		LAAS.Playback.CurrentDelta = 0
		LAAS.Playback.CurrentPoint = LAAS.Playback.CurrentPoint + 1
	end
end)


hook.Add("CalcView", "LAASPlaybackRender", function()
	if not LAAS.Playback.Playing then
		return
	end


	local view = {
		origin = LAAS.Playback.GetCurrentPos(),
		angles = LAAS.Playback.GetCamDirFrom2Pos(LAAS.Playback.GetCurrentPos(), LAAS.Playback.GetCurrentCamPos()),
		fov = LAAS.Playback.GetCurrFOVLerp(),
		drawviewer = true
	}

	return view
end)