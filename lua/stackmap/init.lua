-- It's like a Module
-- M is a table, but used as a Module
--
local M = {}

---@param maps table
---@return table
local function map_by_lhs(maps)
	local indexed = {}

	for _, map in ipairs(maps) do
		indexed[map.lhs] = map
	end

	return indexed
end

M._stack = {}

M._clear = function()
	M._stack = {}
end

---@param name string
---@param mode string
---@param mappings table
M.push = function(name, mode, mappings)
	local maps = map_by_lhs(vim.api.nvim_get_keymap(mode))

	local existing_maps = {}

	for lhs, _ in pairs(mappings) do
		local existing = maps[lhs]
		if existing then
			existing_maps[lhs] = existing
		end
	end

	M._stack[name] = {
		mode = mode,
		existing = existing_maps,
		mappings = mappings,
	}

	for lhs, rhs in pairs(mappings) do
		-- TODO: need some way to pass options in here
		vim.keymap.set(mode, lhs, rhs)
	end
end

---@param name string
M.pop = function(name)
	local state = M._stack[name]
	M._stack[name] = nil

	for lhs, _ in pairs(state.mappings) do
		if state.existing[lhs] then
			local og_mapping = state.existing[lhs]

			-- TODO: handle the options from the table
			vim.keymap.set(state.mode, lhs, og_mapping.rhs)
		else
			vim.keymap.del(state.mode, lhs)
		end
	end
end

return M
