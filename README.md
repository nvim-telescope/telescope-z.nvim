# telescope-z.nvim

`telescope-z` is an extension for [telescope.nvim][] that provides its users with operating [rupa/z][] or its compatibles.

[telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
[rupa/z]: https://github.com/rupa/z

## Installation

```lua
-- packer.nvim:
use { 'nvim-telescope/telescope-z.nvim',
  requires = {
    {'nvim-lua/plenary.nvim'},
    {'nvim-lua/popup.nvim'},
    {'nvim-telescope/telescope.nvim'},
  },
  config = function()
    require'telescope'.load_extension'z'
    -- ... other telescope settings
  end,
}
...
-- paq-nvim:
paq 'nvim-lua/plenary.nvim'
paq 'nvim-lua/popup.nvim'
paq 'nvim-telescope/telescope.nvim'
paq 'nvim-telescope/telescope-z.nvim'
...
require'telescope'.load_extension'z'
```

## Usage

Set keybinding like `vim.api.nvim_set_keymap('n', '<leader>tez', [[<cmd>lua require'telescope'.extensions.z.list{}<CR>]], {noremap=true, silent=true})`
and adapt the options listed below.

### list

`:Telescope z list`

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

Default value: `{vim.o.shell, '-c', 'z -l'}`

#### `cwd`

Transform the result paths into relative ones with this value as the base dir.

Default value: `vim.fn.getcwd()`

#### `tail_path`

Show only basename of the path.

Default value: `false`

#### `shorten_path`

Call `pathshorten()` for each path.

Default value: `false`

## TODO

* [x] `cd` or `lcd` on the selected dir.
* [x] Highlight results.
* [x] Customizable command for `z -l`.
