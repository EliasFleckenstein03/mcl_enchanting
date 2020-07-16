local default_tool_enchantments = {"efficiency", "unbreaking", "silk_touch"}
local default_tool_materials = {"wood", "stone", "iron", "gold", "diamond"}
local default_tool = {enchantments = default_tool_enchantments, materials = default_tool_materials}
local default_armor_enchantments = {"unbreaking"}--, "protection"}
local default_armor_materials = {"leather", "chain", "iron", "gold", "diamond"}
local default_armor = {enchantments = default_armor_enchantments, materials = default_armor_materials}

mcl_enchanting = {
	lapis_itemstring = "mcl_dye:blue",
	max_cost = 24,
	level_rarity_grade = 3,
	enchantment_name_list = {},
	all_tools = {},
	book_offset = vector.new(0, 0.75, 0),
	enchantments = {
		silk_touch = {
			name = "Silk Touch",
			max_level = 1,
			create_itemdef = function(def)
				def.tool_capabilities.max_drop_level = -5000
				def._silk_touch = true
			end
		},
		sharpness = {
			name = "Sharpness",
			max_level = 5,
			create_itemdef = function(def, level)
				def.tool_capabilities.damage_groups.fleshy = def.tool_capabilities.damage_groups.fleshy + (level + 1) / 2
			end,
		},
		efficiency = {
			name = "Efficiency",
			max_level = 5,
			create_itemdef = function(def, level)
				local groupcaps = def.tool_capabilities.groupcaps
				for _, groupcap in pairs(groupcaps) do
					for i, t in pairs(groupcap.times) do
						local m = 1 / t
						m = m + math.pow(level, 2) + 1
						groupcap.times[i] = 1 / m
					end
				end
			end,
		},
		unbreaking = {
			name = "Unbreaking",
			max_level = 3,
			create_itemdef = function(def, level)
				local toolcaps = def.tool_capabilities
				local armor_uses = def.groups.mcl_armor_uses
				local factor = 0.5
				if toolcaps then
					local groupcaps = toolcaps.groupcaps
					for _, groupcap in pairs(groupcaps) do
						groupcap.uses = math.floor(groupcap.uses * (1 + level))
					end
					def.tool_capabilities.punch_attack_uses = math.floor(def.tool_capabilities.punch_attack_uses * (1 + level))
				elseif armor_uses then
					def.groups.mcl_armor_uses = math.floor(armor_uses / (0.6 + (0.4 / (level + 1))))
				end
			end
		},
		--[[
		protection = {
			name = "Protection",
			max_level = 4,
			create_itemdef = function(def, level)
				local groups = def.groups
				groups.mcl_armor_points = groups.mcl_armor_points + (0.04 * level)
			end,
		},
		--]]
	},
	tools = {
		["mcl_tools:pick"] = default_tool,
		["mcl_tools:axe"] = {materials = default_tool_materials, enchantments = {"efficiency", "unbreaking", "sharpness", "silk_touch"}},
		["mcl_tools:shovel"] = default_tool,
		["mcl_tools:sword"] = {materials = default_tool_materials, enchantments = {"unbreaking", "sharpness"}},
		["mcl_tools:hoe"] = {materials = default_tool_materials, enchantments = {"unbreaking", "silk_touch"}},
		["mcl_armor:helmet"] = default_armor,
		["mcl_armor:chestplate"] = default_armor,
		["mcl_armor:leggings"] = default_armor,
		["mcl_armor:boots"] = default_armor,
	}
}

for k in pairs(mcl_enchanting.enchantments) do
	table.insert(mcl_enchanting.enchantment_name_list, k)
end

local modpath = minetest.get_modpath("mcl_enchanting")

for _, f in pairs({"engine", "book", "table", "bookshelf_particles", "silk_touch"}) do
	dofile(modpath .. "/" .. f .. ".lua")
end
