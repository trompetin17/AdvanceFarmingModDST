GLOBAL.b_banana_room = (GetModConfigData("b_banana_room")=="yes")
GLOBAL.banana_tree_rate = GetModConfigData("banana_tree_rate")


local baseDivider = {
	Forest = 40,
	CrappyForest = 20,
	DeepForest = 80,
	CrappyDeepForest = 20
}
local function onTaskSetInitAny(self)
	if self.name ~= "bananas" then 
		table.insert(self.tasks, "bananastask")
		table.insert(self.optionaltasks, "bananastask")
	end
end

local function onRoomForest(self)
	local divider = baseDivider[self.name]
	self.contents.distributeprefabs.hybrid_banana_tree = (GLOBAL.banana_tree_rate / divider)
end

if GLOBAL.b_banana_room then
	modimport("scripts/map/rooms/terrain_banana_tree")
	modimport("scripts/map/tasks/terrain_banana_tree")
	modimport("scripts/map/levels/terrain_banana_tree")
	modimport("scripts/map/tasksets/terrain_banana_tree")

	AddTaskSetPreInitAny(onTaskSetInitAny)
	AddRoomPreInit("Forest", onRoomPreInit)
	AddRoomPreInit("CrappyForest", onRoomPreInit)
	AddRoomPreInit("DeepForest", onRoomPreInit)
	AddRoomPreInit("CrappyDeepForest", onRoomPreInit)
end