language.Add("tool.laas_objm.name", "LAAS Object Manipulator")
language.Add("tool.laas_objm.desc", "Manipulate LAAS Entities!")
language.Add("tool.laas_objm.0", "Press LMB to select an entity!")

language.Add("tool.laas_rps.name", "LAAS Camera Path Selector")
language.Add("tool.laas_rps.desc", "Make the camera path!")
language.Add("tool.laas_rps.0", "Press LMB to add a point to the path!")



hook.Add("AddToolMenuCategories", "LAASAddToolMenuCategory", function()
	spawnmenu.AddToolCategory("Main", "LAAS", "Lokachop's Advanced Anim System")
	spawnmenu.AddToolCategory("Options", "LAAS", "Lokachop's Advanced Anim System")
end)

hook.Add("PopulateToolMenu", "LAASMakeOptionMenu", function()
	spawnmenu.AddToolMenuOption("Options", "LAAS", "LAAS_ConfigMenu", "#LAAS Options", "", "", function(dform)
		dform:ClearControls()

		dform:CheckBox("Draw Camera Points", "laas_renderpoints")
		dform:CheckBox("Draw Camera Path", "laas_renderpath")
		dform:CheckBox("Draw Camera Target Path", "laas_rendereyepath")
		dform:Help("LAAS v" .. LAAS.Util.GetVersionString() .. ", by lokachop!")
	end)
end)


CreateClientConVar("laas_renderpoints", 1, true, false, "Toggles rendering the camera points in LAAS", 0, 1)
CreateClientConVar("laas_renderpath", 0, true, false, "Toggles rendering the camera path in LAAS", 0, 1)
CreateClientConVar("laas_rendereyepath", 0, true, false, "Toggles rendering the visual target path in LAAS", 0, 1)