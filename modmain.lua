Assets= {
	Asset("ATLAS", "images/inventoryimages/hybrid_banana.xml"),
	Asset("ATLAS", "images/inventoryimages/g_house.xml"),
	Asset("IMAGE", "minimap/g_house.tex" ),
	Asset("ATLAS", "minimap/g_house.xml" ),
}

AddMinimapAtlas("minimap/g_house.xml")

PrefabFiles = {
	"g_house",
	"hybrid_banana_seeds",
	"hybrid_banana_tree",
	"hybrid_banana",
}

GLOBAL.Winter_Grow = (GetModConfigData("W_Grow")=="no")
local b_seeds = (GetModConfigData("b_seeds")=="no")
local easy = (GetModConfigData("greenhouserecipe")=="easy")
local normal = (GetModConfigData("greenhouserecipe")=="normal")

local ingredients = nil;
if easy then
	ingredients = {
		Ingredient("boards", 3),
		Ingredient("silk", 3),
		Ingredient("rope", 1)
	}
elseif normal then
	ingredients = {
		Ingredient("boards", 3),
		Ingredient("silk", 3),
		Ingredient("rope", 2),
		Ingredient("poop", 10)
	}
else
	ingredients = {
		Ingredient("boards", 5),
		Ingredient("silk", 6),
		Ingredient("rope", 4),
		Ingredient("poop", 10)
	}
end

AddRecipe("g_house",ingredients, GLOBAL.RECIPETABS.FARM, GLOBAL.TECH.NONE, "g_house_placer", nil, nil, nil, nil, "images/inventoryimages/g_house.xml")

if not b_seeds then
	AddRecipe("hybrid_banana_seeds", {
		Ingredient("carrot_seeds", 1),
		Ingredient("dragonfruit_seeds", 1)
	}, GLOBAL.RECIPETABS.REFINE, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, "images/inventoryimages/hybrid_banana_seeds.xml")
end

local fruits = {"pomegranate", "dragonfruit", "cave_banana", "hybrid_banana"}
AddIngredientValues(fruits, {fruit=1}, true)
