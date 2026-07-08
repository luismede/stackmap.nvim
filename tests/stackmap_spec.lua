local PREFIX = "<Plug>(stackmap-test-)"
local RHS = "echo 'This is a test!'"

local function find_map(mode, lhs)
	for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
		if map.lhs == lhs then
			return map
		end
	end
end

local function push_mapping(multiple)
	local mappings

	if multiple then
		mappings = {
			[PREFIX .. "1)"] = RHS .. "1",
			[PREFIX .. "2)"] = RHS .. "2",
		}
	else
		mappings = {
			[PREFIX .. "1)"] = RHS,
		}
	end

	require("stackmap").push("test", "n", mappings)
end

describe("stackmap", function()
	before_each(function()
		require("stackmap")._clear()

		pcall(vim.keymap.del, "n", PREFIX .. "1)")
		pcall(vim.keymap.del, "n", PREFIX .. "2)")
	end)

	after_each(function()
		require("stackmap")._clear()

		pcall(vim.keymap.del, "n", PREFIX .. "1)")
		pcall(vim.keymap.del, "n", PREFIX .. "2)")
	end)
	it("can be required", function()
		assert.not_nil(require("stackmap"))
	end)

	it("can push a single mapping", function()
		push_mapping(false)

		local found = find_map("n", PREFIX .. "1)")
		assert.are.same(RHS, found.rhs)
	end)

	it("can push multiple mappings", function()
		push_mapping(true)

		local found1 = find_map("n", PREFIX .. "1)")
		local found2 = find_map("n", PREFIX .. "2)")

		assert.are.same(RHS .. "1", found1.rhs)
		assert.are.same(RHS .. "2", found2.rhs)
	end)

	it("removes mappings after pop when no mapping existed before", function()
		push_mapping(false)

		assert.not_nil(find_map("n", PREFIX .. "1)"))

		require("stackmap").pop("test")

		assert.is_nil(find_map("n", PREFIX .. "1)"))
	end)

	it("restores an existing mapping after pop", function()
		vim.keymap.set("n", PREFIX .. "1)", "echo 'Hello, Joe!'")

		push_mapping(false)

		assert.are.same(RHS, find_map("n", PREFIX .. "1)").rhs)

		require("stackmap").pop("test")

		assert.are.same("echo 'Hello, Joe!'", find_map("n", PREFIX .. "1)").rhs)
	end)
end)
