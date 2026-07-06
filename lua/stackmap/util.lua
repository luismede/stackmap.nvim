-- It's like a Module
-- M is a table, but used as a Module
local M = {}

-- Module: setup
M.setup = function(opts)
	print("Options:", opts)
end

return M
