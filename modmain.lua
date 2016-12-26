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

-- changing crop component
local function changeCropAction(self)
	print("crop component instance detected")
	local oldResume = self.Resume
	local oldDoGrow = self.DoGrow

	function self:Resume()
		if (self.grower and self.grower:HasTag("g_house"))  then
			self.inst.AnimState:SetMultColour(1, 1, 1, .5)
		end
		oldResume(self)
	end

	function self:DoGrow(dt, nowither)
		oldDoGrow(self, dt, nowither)
		if not self.inst:HasTag("withered") then
			if (self.grower and self.grower:HasTag("g_house")) then
				self.inst.AnimState:SetMultColour(1, 1, 1, .5)
			end

			if self.cantgrowtime == 0 then
				if self.grower and self.grower:HasTag("g_house") and (GLOBAL.TheWorld.state.iswinter and GLOBAL.TheWorld.state.temperature <= 0) then
					self.growthpercent = self.growthpercent + dt * self.rate
				end
			end
		end
	end
end

AddComponentPostInit("crop", changeCropAction)





