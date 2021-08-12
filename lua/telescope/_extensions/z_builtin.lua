local actions = require'telescope.actions'
local actions_set = require'telescope.actions.set'
local conf = require'telescope.config'.values
local entry_display = require'telescope.pickers.entry_display'
local finders = require'telescope.finders'
local from_entry = require'telescope.from_entry'
local pickers = require'telescope.pickers'
local previewers = require'telescope.previewers.term_previewer'
local utils = require'telescope.utils'
local Path = require('plenary.path')

local os_home = vim.loop.os_homedir()

local M = {}

local function gen_from_z(opts)
  local displayer = entry_display.create{
    separator = ' ',
    items = {
      {width = 7, right_justify = true}, -- score
      {remaining = true}, -- path
    },
  }

  local function make_display(entry)
    local dir
    if entry.path == Path.path.root() then
      dir = entry.path
    else
      local original = Path:new(entry.path)
      if opts.tail_path then
        local parts = original:_split()
        dir = parts[#parts]
      elseif opts.shorten_path then
        dir = original:shorten()
      else
        local relpath = Path:new(original):make_relative(opts.cwd)
        local p
        if vim.startswith(relpath, os_home) then
          p = Path:new'~' / Path:new(relpath):make_relative(os_home)
        elseif relpath.filename ~= original then
          p = Path:new'.' / relpath
        end
        dir = p and p.filename or relpath
      end
    end

    return displayer{
      {('%.2f'):format(entry.value), 'TelescopeResultsIdentifier'},
      dir,
    }
  end

  return function(line)
    local score_str, dir = line:match'([%.%d]+)%s+(.+)'
    local score = tonumber(score_str)

    return {
      value = score,
      ordinal = dir,
      path = dir,
      display = make_display,
    }
  end
end

M.list = function(opts)
  opts = opts or {}
  opts.cmd = utils.get_default(opts.cmd, {vim.o.shell, '-c', 'z -l'})
  opts.cwd = utils.get_lazy_default(opts.cwd, vim.loop.cwd)
  opts.entry_maker = utils.get_lazy_default(opts.entry_maker, gen_from_z, opts)

  pickers.new(opts, {
    prompt_title = 'Visited directories from z',
    finder = finders.new_table{
      results = utils.get_os_command_output(opts.cmd),
      entry_maker = opts.entry_maker,
    },
    sorter = conf.file_sorter(opts),
    previewer = previewers.cat.new(opts),
    attach_mappings = function(prompt_bufnr)
      actions_set.select:replace(function(_, type)
        local entry = actions.get_selected_entry()
        actions.close(prompt_bufnr)
        local dir = from_entry.path(entry)
        if type == 'default' then
          require'telescope.builtin'.find_files{cwd = dir}
        elseif type == 'horizontal' then
          vim.cmd('cd '..dir)
          print('chdir to '..dir)
        elseif type == 'vertical' then
          vim.cmd('lcd '..dir)
          print('lchdir to '..dir)
        elseif type == 'tab' then
          vim.cmd('tcd '..dir)
          print('tchdir to '..dir)
        end
      end)
      return true
    end,
  }):find()
end

return M
