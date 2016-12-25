local assets=
{
	Asset("ANIM", "anim/hybrid_banana.zip"),
	Asset("ATLAS", "images/inventoryimages/hybrid_banana.xml"),
	Asset("ATLAS", "images/inventoryimages/hybrid_banana_cooked.xml")
}

local prefabs =
{
	"hybrid_banana",
	"hybrid_banana_cooked",
	"spoiled_food",
}

local function raw(cooked)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("hybrid_banana")
	inst.AnimState:SetBuild("hybrid_banana")
	if cooked then
		inst.AnimState:PlayAnimation("cooked")
	else
		inst.AnimState:PlayAnimation("raw", true)
	end
	
	inst.Transform:SetScale(3,3,3)

	if not TheWorld.ismastersim then
		return inst
	end

	inst.entity:SetPristine()

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.HEALING_MED
	inst.components.edible.hungervalue = TUNING.CALORIES_MED
	inst.components.edible.sanityvalue = TUNING.SANITY_MED
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	if cooked then
		inst.components.inventoryitem.atlasname = "images/inventoryimages/hybrid_banana_cooked.xml"
	else
		inst.components.inventoryitem.atlasname = "images/inventoryimages/hybrid_banana.xml"
	end

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	inst:AddComponent("bait")

	if not cooked then
		inst:AddComponent("cookable")
		inst.components.cookable.product = "hybrid_banana_cooked"
	end

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function hybridBanana()
	return raw(false)
end
local function cookedhybridBanana()
	return raw(true)
end

STRINGS.CHARACTERS.GENERIC.DESCRIBE.HYBRID_BANANA = "Love these guys fresh!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HYBRID_BANANA_COOKED = "Well now my mouth is watering!"
STRINGS.NAMES.HYBRID_BANANA = "Hybrid Bananas"
STRINGS.NAMES.HYBRID_BANANA_COOKED = "Cooked Hybrid Bananas"

return Prefab( "hybrid_banana", hybridBanana, assets, prefabs),
	Prefab( "hybrid_banana_cooked", cookedhybridBanana, assets)