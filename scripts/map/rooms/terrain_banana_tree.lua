AddRoom("banana_tree_forest", {
	colour={r=.5,g=0.6,b=.080,a=.10},
	value = GROUND.FOREST,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents = {
		--countprefabs = {
		--	hybrid_banana_tree = 2
		--},
		distributepercent = .3,
		distributeprefabs = {
			hybrid_banana_tree = (GLOBAL.banana_tree_rate/80),
			fireflies = 0.2,
			--evergreen = 6,
            rock1 = 0.05,
            grass = .05,
            sapling=.8,
			twiggytree = 0.8,
			ground_twigs = 0.06,        
			--rabbithole=.05,
            berrybush=.03,
            berrybush_juicy = 0.015,
            red_mushroom = .03,
            green_mushroom = .02,
			trees = {weight = 6, prefabs = {"evergreen", "evergreen_sparse"}}
		}
	}
})