LAAS = LAAS or {}
LAAS.Util = LAAS.Util or {}
LAAS.Config = LAAS.Config or {}
LAAS.CameraPoints = LAAS.CameraPoints or {}

function LAAS.Util.LokaPointDataToPosTable(pdata)
	local ptbl = {}

	for k, v in pairs(pdata) do
		ptbl[k] = v.pos
	end
	return ptbl
end

function LAAS.Util.LokaPointDataToPosTablePlusDir(pdata)
	local ptbl = {}

	for k, v in pairs(pdata) do
		ptbl[k] = v.pos + (v.dir * 32)
	end
	return ptbl
end


function LAAS.Util.LerpVectorOffCameraPath(lg, ptbl)
	local tptbl = ptbl or LAAS.Util.LokaPointDataToPosTable(LAAS.CameraPoints)

	return math.BSplinePoint(lg, tptbl, 1)
end

function LAAS.Util.SetConfigVar(var, val)
	LAAS.Config[var] = val
end

function LAAS.Util.GetConfigVar(var, fb)
	return LAAS.Config[var] or fb
end

function LAAS.Util.GetVersionString()
	return tostring(LAAS.Version) or "error!"
end

function LAAS.Util.BezQuadratic1P(t, p1, p2, p3)
	return (1 - t) * ((1 - t) * p1 + t * p2) + t * ((1 - t) * p2 + t * p3)
end