minetest.register_node("mcl_enchanting:table", {
	description = "Enchanting Table",
	drawtype = "nodebox",
	tiles = {"mcl_enchanting_table_top.png",  "mcl_enchanting_table_bottom.png", "mcl_enchanting_table_side.png", "mcl_enchanting_table_side.png", "mcl_enchanting_table_side.png", "mcl_enchanting_table_side.png"},
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.25, 0.5},
	},
	sounds = mcl_sounds.node_sound_stone_defaults(),
	groups = {pickaxey = 2},
	_mcl_blast_resistance = 1200,
	_mcl_hardness = 5,
	on_rotate = (screwdriver or {}).rotate_simple,
	on_construct = mcl_enchanting.init_table,
	on_destruct = mcl_enchanting.drop_inventory,
	after_destruct = mcl_enchanting.check_book,
	on_receive_fields = mcl_enchanting.progress_formspec_input,
	on_metadata_inventory_put = mcl_enchanting.update_formspec,
	on_metadata_inventory_take = mcl_enchanting.update_formspec,
	allow_metadata_inventory_put = function(_, listname, _, stack)
		if listname == "lapis" then
			return (stack:get_name() == mcl_enchanting.lapis_itemstring) and stack:get_count() or 0
		end
		return 1 
	end,
	allow_metadata_inventory_move = function()
		return 0
	end,
}) 
