local bookshelf_positions = {{x = 1}, {x = -1}, {z = 1}, {z = -1}}

for _, p in pairs(bookshelf_positions) do
	for _, d in pairs({"x", "y", "z"}) do
		p[d] = p[d] or 0
	end
end

minetest.register_abm({
	name = "Enchanting table bookshelf particles",
	interval = 0.1,
	chance = 1,
	nodenames = "mcl_books:bookshelf",
	action = function(pos)
		for _, relative_pos in pairs(bookshelf_positions) do
			if minetest.get_node(vector.add(pos, vector.multiply(relative_pos, 2))).name == "mcl_enchanting:table" and minetest.get_node(vector.add(pos, relative_pos, 2)).name == "air" then
				minetest.add_particle({
					pos = pos,
					velocity = vector.subtract(relative_pos, vector.new(0, -2, 0)),
					acceleration = {x = 0, y = -2, z = 0},
					expirationtime = 2,
					size = 2,
					texture = "mcl_enchanting_glyph_" .. math.random(18) .. ".png"
				})
			end
		end
	end
}) 
