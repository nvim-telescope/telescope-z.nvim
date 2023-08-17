# telescope-z.nvim

`telescope-z` is an extension for [telescope.nvim][] that provides its users with operating [rupa/z][] or its compatibles.

[telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
[rupa/z]: https://github.com/rupa/z

## Installation

### for lazy.nvim

```lua
{
  "nvim-telescope/telescope-z.nvim",
  config = function()
    require("telescope").load_extension "z"
  end,
}
```

### for paq-nvim

```lua
paq "nvim-telescope/telescope-z.nvim"

require("telescope").load_extension "z"
```

## Usage

```vim
:Telescope z
```

Or Lua way

```lua
require("telescope").extensions.z.z {}
```

List directories by `z -l`. In default, it does actions below when you input keys.

| key               | action               |
|-------------------|----------------------|
| `<CR>` (edit)     | `builtin.find_files` |
| `<C-x>` (split)   | `:chdir` to the dir  |
| `<C-v>` (vsplit)  | `:lchdir` to the dir |
| `<C-t>` (tabedit) | `:tchdir` to the dir |

#### options

##### `cmd`

Set command list to execute `z -l` or compatibles. In default, it does `bash -c 'z -l'` or so.

Default value: `{ vim.o.shell, "-c", "z -l" }`

#### `cwd`

Transform the result paths into relative ones with this value as the base dir.

Default value: `vim.uv.cwd()`

#### `tail_path` (deprecated)

***This is deprecated. Use `path_display` (`:h telescope.defaults.path_display`).***

Show only basename of the path.

Default value: `false`

#### `shorten_path` (deprecated)

***This is deprecated. Use `path_display` (`:h telescope.defaults.path_display`).***

Call `pathshorten()` for each path.

Default value: `false`
