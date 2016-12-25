require "prefabutil"

local Assets =
{
	Asset("ATLAS", "images/inventoryimages/hybrid_banana_seeds.xml"),
	Asset("IMAGE", "images/inventoryimages/hybrid_banana_seeds.tex"),
}

local prefabs =
{
	"hybrid_banana_tree",
} 

local notags = {'NOBLOCK', 'player', 'FX'}

local function test_ground(inst, pt)
	print("TEST:GROUND CALLED")
	local tiletype = GetGroundTypeAtPosition(pt)
	local ground_OK = tiletype ~= GROUND.ROCKY and tiletype ~= GROUND.ROAD and tiletype ~= GROUND.IMPASSABLE and
						tiletype ~= GROUND.UNDERROCK and tiletype ~= GROUND.WOODFLOOR and 
						tiletype ~= GROUND.CARPET and tiletype ~= GROUND.CHECKER and tiletype < GROUND.UNDERGROUND
	if ground_OK then
		local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 4, nil, notags) -- or we could include a flag to the search?
		local min_spacing = inst.components.deployable.min_spacing or 2

		for k, v in pairs(ents) do
			if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
				if distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
					return false
				end
			end
		end
		return true
	end
	return false
end

local function OnDeploy (inst, pt) 
	local banana = SpawnPrefab("hybrid_banana_tree")
	if banana then
		banana.Transform:SetPosition(pt.x, pt.y, pt.z)
		inst.AnimState:PlayAnimation("idle_loop")
		inst.components.stackable:Get():Remove()
	end
end

local function fn(Sim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()	

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("seeds")
	inst.AnimState:SetBuild("seeds")
	inst.AnimState:SetRayTestOnBB(true)
	
    if not TheWorld.ismastersim then
		return inst
	end

    inst.entity:SetPristine()

	inst:AddComponent("edible")
	inst.components.edible.foodtype = "SEEDS"
	inst.components.edible.healthvalue = TUNING.HEALING_TINY/2
	inst.components.edible.hungervalue = TUNING.CALORIES_TINY

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hybrid_banana_seeds.xml"
	
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "seeds_cooked"
	
	inst:AddComponent("bait")

	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = OnDeploy

	return inst
end

STRINGS.RECIPE_DESC.HYBRID_BANANA_SEEDS = " It's a banana seed!"
STRINGS.NAMES.HYBRID_BANANA_SEEDS = "Hybrid Banana Seeds"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HYBRID_BANANA_SEEDS = "These are worth their weight in gold!"

return Prefab( "common/inventory/hybrid_banana_seeds", fn, Assets),
	MakePlacer( "hybrid_banana_seeds_placer", "cave_banana_tree", "cave_banana_tree", "idle_loop") 