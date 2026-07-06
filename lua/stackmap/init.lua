-- It's like a Module
-- M is a table, but used as a Module
local M = {}

local find_mapping = function(maps, lhs)
	for _, value in ipairs(maps) do
		if value.lhs == lhs then
			return value
		end
	end

	return nil
end

M._stack = {}

---@param name string
---@param mode string
---@param mappings table
M.push = function(name, mode, mappings)
	local maps = vim.api.nvim_get_keymap(mode)

	local existing_maps = {}

	for lhs, _ in pairs(mappings) do
		local existing = find_mapping(maps, lhs)
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

	for lhs, rhs in pairs(state.mappings) do
		if state.existing[lhs] then
			-- TODO: Implement logic when maps existing
		else
			vim.keymap.del(state.mode, lhs, rhs)
		end
	end
end

M.push("debug_mode", "n", {
	[" h"] = "echo 'Hello'",
	[" e"] = "echo 'Goodbye'",
})

return M
