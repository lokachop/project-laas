language.Add("tool.laas_objm.name", "LAAS Object Manipulator")
language.Add("tool.laas_objm.desc", "Manipulate LAAS Entities!")
language.Add("tool.laas_objm.0", "Press LMB to select an entity!")


hook.Add("AddToolMenuCategories", "LAASAddToolMenuCategory", function()
	spawnmenu.AddToolCategory("Main", "LAAS", "Lokachop's Advanced Anim System")
end)