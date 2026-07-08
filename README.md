# stackmap.nvim

Push a bunch of mappings on some event, then pop them when you're done. Original mappings are preserved and restored on pop.

## Requirements

- Neovim >= 0.7

## Installation

**[lazy.nvim](https://github.com/folke/lazy.nvim)**

```lua
{
  "luismede/stackmap.nvim",
}
```

**[packer.nvim](https://github.com/wbthomason/packer.nvim)**

```lua
use { "luismede/stackmap.nvim" }
```

## API

### `stackmap.push(name, mode, mappings)`

Push the `mappings` for a particular `mode` under the name `name`.

- `name` (`string`): identifier for this group of mappings, used later to pop.
- `mode` (`string`): a Neovim mode short name, e.g. `"n"`, `"i"`, `"v"`.
- `mappings` (`table`): key-value pairs of `{ lhs = rhs, ... }`. Any `lhs`
  that already has a mapping is saved and restored when `pop` is called.

```lua
require("stackmap").push("example", "n", {
  ["<Space>st"] = "echo 'Wow! this is awesome!'",
})
```

### `stackmap.pop(name)`

Pop the `name` mappings. Restores the original mappings from before the
corresponding `stackmap.push()` call, or deletes the mapping if none existed.

```lua
require("stackmap").pop("example")
```

## Usage example

A common use case is transient mappings, e.g. while a split window or a
floating UI is open:

```lua
local stackmap = require("stackmap")

-- Open a window and push transient mappings
stackmap.push("my-window", "n", {
  ["q"] = function() require("my-window").close() end,
  ["<CR>"] = function() require("my-window").confirm() end,
})

-- ...later, when the window closes
stackmap.pop("my-window")
```

## License

MIT
