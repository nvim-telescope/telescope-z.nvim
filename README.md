# telescope-z.nvim

`telescope-z` is an extension for [telescope.nvim][] that provides its users with operating [rupa/z][] or its compatibles.

[telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
[rupa/z]: https://github.com/rupa/z

## Installation

```lua
use{
  'nvim-telescope/telescope.nvim',
  requires = {
    'delphinus/telescope-z.nvim',
  },
  config = function()
    require'telescope'.load_extension'z'
  end,
}
```

## Usage

### list

`:Telescope z list`

List directories by `z -l`. In default, it does actions below when you input keys.

| key              | action               |
|------------------|----------------------|
| `<CR>` (edit)    | `builtin.find_files` |
| `<C-x>` (split)  | `:chdir` to the dir  |
| `<C-v>` (vsplit) | `:lchdir` to the dir |

## TODO

* [x] `cd` or `lcd` on the selected dir.
* [x] Highlight results.
* [ ] Customizable command for `z -l`.
