local pickaxes = {"mcl_tools:pick_wood", "mcl_tools:pick_stone", "mcl_tools:pick_gold", "mcl_tools:pick_iron", "mcl_tools:pick_diamond"}
local pickaxes_better_than_iron = {"mcl_tools:pick_iron", "mcl_tools:pick_diamond"}
local pickaxes_better_than_stone = {"mcl_tools:pick_stone", "mcl_tools:pick_gold", "mcl_tools:pick_iron", "mcl_tools:pick_diamond"}
local shovels = {"mcl_tools:shovel_wood", "mcl_tools:shovel_stone", "mcl_tools:shovel_gold", "mcl_tools:shovel_iron", "mcl_tools:shovel_diamond"}

local silk_touch_tool_lists = {
	["mcl_books:bookshelf"] = true,
	["mcl_core:clay"] = true,
	["mcl_core:stone_with_coal"] = pickaxes,
	["group:coral_block"] = pickaxes,
	["group:coral"] = true,
	["group:coral_fan"] = true,
	["mcl_core:stone_with_diamond"] = pickaxes_better_than_iron,
	["mcl_core:stone_with_emerald"] = pickaxes_better_than_iron,
	["mcl_chests:ender_chest"] = pickaxes,
	["group:glass"] = true,
	["mcl_nether:glowstone"] = true,
	["mcl_core:dirt_with_grass"] = true,
	["mcl_core:gravel"] = true,
	["mcl_core:ice"] = true,
	["mcl_core:stone_with_lapis"] = pickaxes_better_than_stone,
	["group:leaves"] = true,
	["mcl_farming:melon"] = true,
	["group:huge_mushroom"] = true,
	["mcl_core:mycelium"] = true,
	["mcl_nether:quartz_ore"] = pickaxes,
	["mcl_core:packed_ice"] = true,
	["mcl_core:podzol"] = true,
	["mcl_core:stone_with_redstone"] = pickaxes_better_than_iron,
	["mcl_ocean:sea_lantern"] = true,
	["group:top_snow"] = shovels,
	["mcl_core:snowblock"] = shovels,
	["mcl_core:stone"] = pickaxes,
}

minetest.register_on_mods_loaded(function()
	local old_handle_node_drops = minetest.handle_node_drops
	function minetest.handle_node_drops(pos, drops, digger)
		if digger and digger:is_player() then
			local wielditem = digger:get_wielded_item()
			local tooldef = wielditem:get_definition()
			if tooldef._silk_touch then
				local nodename = minetest.get_node(pos).name
				local nodedef = minetest.registered_nodes[nodename]
				local silk_touch_spec = silk_touch_tool_lists[nodename]
				local suitable_tool = false
				local tool_list
				if silk_touch_spec == true then
					suitable_tool = true
				elseif silk_touch_spec then
					tool_list = silk_touch_spec
				else
					for k, v in pairs(nodedef.groups) do
						if v > 0 then
							local group_spec = silk_touch_tool_lists["group:" .. k]
							if group_spec == true then
								suitable_tool = true
							elseif group_spec then
								toollist = group_spec
								break
							end
						end
					end
				end
				if tool_list and not suitable_tool then
					suitable_tool = (table.indexof(tool_list, tooldef._original_tool) ~= -1)
				end
				if suitable_tool then
					drops = {nodename}
				end
			end
		end
		old_handle_node_drops(pos, drops, digger)
	end
end) 
