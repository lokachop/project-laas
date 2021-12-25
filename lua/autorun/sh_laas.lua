LAAS = LAAS or {}
LAAS.Util = LAAS.Util or {}
LAAS.Config = LAAS.Config or {}

function LAAS.Util.LokaPointDataToPosTable(pdata)
	local ptbl = {}

	for k, v in pairs(pdata) do
		ptbl[k] = v.pos
	end
	return ptbl
end


function LAAS.Util.LerpVectorOffCameraPath(lg, cpath)
	local tcpath = cpath or LAAS.CameraPoints
	
	local ptbl = LAAS.Util.LokaPointDataToPosTable(tcpath)
	return math.BSplinePoint(lg, ptbl, 1)
end

function LAAS.Util.SetConfigVar(var, val)
	LAAS.Config[var] = val
end

function LAAS.Util.GetConfigVar(var, fb)
	return LAAS.Config[var] or fb
end


print("hi from shared laas!")