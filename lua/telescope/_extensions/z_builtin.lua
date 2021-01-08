local conf = require'telescope.config'.values
local finders = require'telescope.finders'
local pickers = require'telescope.pickers'

local M = {}

M.list = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = 'Visited directories from z',
    finder = finders.new_oneshot_job(
      {vim.o.shell, '-c', 'z -l'},
      opts
    ),
    sorter = conf.file_sorter(opts),
  }):find()
end

return M
