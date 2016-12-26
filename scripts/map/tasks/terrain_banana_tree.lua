SIZE_VARIATION = 3

AddTask("bananastask", {
	locks = LOCKS.NONE,
	keys_given={KEYS.PICKAXE,KEYS.AXE,KEYS.GRASS,KEYS.WOOD,KEYS.TIER1},
	room_choices = {
		["banana_tree_forest"] = function() return 1 + math.random(SIZE_VARIATION) end
	},
	room_bg = GROUND.GRASS,
	background_room = "BGGrass",
	colour = {r = 0, g = 0, b = 0, a = 0}
})