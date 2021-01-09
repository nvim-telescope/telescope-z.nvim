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

List directories by `z -l`. When you input `<CR>`, it runs `builtin.find_files` on the directory.

## TODO

* [ ] `cd` or `lcd` on the selected dir.
* [ ] Highlight results.
