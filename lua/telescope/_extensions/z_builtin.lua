local actions = require'telescope.actions'
local conf = require'telescope.config'.values
local finders = require'telescope.finders'
local pickers = require'telescope.pickers'

local M = {}

local function parse_entry(value)
  local score, dir = value:match'([%.%d]+)%s+(.+)'
  return {score = score, dir = dir}
end

M.list = function(opts)
  opts = vim.tbl_extend('force', {
    z_command_list = {vim.o.shell, '-c', 'z -l'},
  }, opts or {})
  pickers.new(opts, {
    prompt_title = 'Visited directories from z',
    finder = finders.new_oneshot_job(opts.z_command_list, opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function()
      actions.goto_file_selection_edit:replace(function(prompt_bufnr)
        local selection = actions.get_selected_entry()
        actions.close(prompt_bufnr)
        local result = parse_entry(selection.value)
        require'telescope.builtin'.find_files{cwd = result.dir}
      end)
      actions.goto_file_selection_split:replace(function(prompt_bufnr)
        local selection = actions.get_selected_entry()
        actions.close(prompt_bufnr)
        local result = parse_entry(selection.value)
        vim.cmd('cd '..result.dir)
        print('chdir to '..result.dir)
      end)
      actions.goto_file_selection_vsplit:replace(function(prompt_bufnr)
        local selection = actions.get_selected_entry()
        actions.close(prompt_bufnr)
        local result = parse_entry(selection.value)
        vim.cmd('lcd '..result.dir)
        print('lchdir to '..result.dir)
      end)
      return true
    end,
  }):find()
end

return M
