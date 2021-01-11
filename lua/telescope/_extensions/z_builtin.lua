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
    attach_mappings = function(prompt_bufnr)
      actions._goto_file_selection:replace(function(_, cmd)
        local selection = actions.get_selected_entry()
        actions.close(prompt_bufnr)
        local result = parse_entry(selection.value)
        if cmd == 'edit' then
          require'telescope.builtin'.find_files{cwd = result.dir}
        elseif cmd == 'new' then
          vim.cmd('cd '..result.dir)
          print('chdir to '..result.dir)
        elseif cmd == 'vnew' then
          vim.cmd('lcd '..result.dir)
          print('lchdir to '..result.dir)
        end
      end)
      return true
    end,
  }):find()
end

return M
