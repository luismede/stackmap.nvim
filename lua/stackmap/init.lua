P = function(v)
  print(vim.inspect(v))
  return v
end

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

  for lhs, rhs in pairs(mappings) do
    local existing = find_mapping(maps, lhs)
    if existing then
      table.insert(existing_maps, existing)
    end
  end

  M._stack[name] = existing_maps
end

M.pop = function(mode) end

M.push("debug_mode", "n", {
  [" h"] = "echo 'Hello'",
  [" e"] = "echo 'Goodbye'",
})

return M
