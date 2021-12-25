language.Add("tool.laas_objm.name", "LAAS Object Manipulator")
language.Add("tool.laas_objm.desc", "Manipulate LAAS Entities!")
language.Add("tool.laas_objm.0", "Press LMB to select an entity!")

language.Add("tool.laas_rps.name", "LAAS Rail Path Selector")
language.Add("tool.laas_rps.desc", "Make the camera path!")
language.Add("tool.laas_rps.0", "Press LMB to add a point to the path!")



hook.Add("AddToolMenuCategories", "LAASAddToolMenuCategory", function()
	spawnmenu.AddToolCategory("Main", "LAAS", "Lokachop's Advanced Anim System")
end)