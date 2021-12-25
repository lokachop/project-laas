TOOL.Category = "LAAS"
TOOL.Name = "#tool.laas_objm.name"
TOOL.AddToMenu = true

TOOL.LeftClickAutomatic = false
TOOL.RightClickAutomatic = false

TOOL.ClientConvar = {

}

function TOOL:Reload(tr)
	print("re")
end


function TOOL:LeftClick(tr)
	print("lc")
end

function TOOL:RightClick(tr)
	print("rc")
end

function TOOL:Think()

end

function TOOL:Deploy()

end

function TOOL:Holster()

end

function TOOL.BuildCPanel(dform)
	dform:SetName("#tool.laas_objm.name")
	dform:Help("WIP :/")
end