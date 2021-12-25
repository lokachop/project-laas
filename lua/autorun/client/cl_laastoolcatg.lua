language.Add("tool.laas_objm.name", "LAAS Object Manipulator")
language.Add("tool.laas_objm.desc", "Manipulate LAAS Entities!")

hook.Add("AddToolMenuCategories", "LAASAddToolMenuCategory", function()
	spawnmenu.AddToolCategory("Main", "LAAS", "Lokachop's Advanced Anim System")
end)