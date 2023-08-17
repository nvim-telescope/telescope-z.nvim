local actions = require "telescope.actions"
local actions_set = require "telescope.actions.set"
local actions_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local entry_display = require "telescope.pickers.entry_display"
local finders = require "telescope.finders"
local from_entry = require "telescope.from_entry"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers.term_previewer"
local utils = require "telescope.utils"
local Path = require "plenary.path"

local uv = vim.uv or vim.loop

local M = {}

local sep = Path.path.sep
local home = (function(h)
  return h .. (h:sub(-1) ~= sep and sep or "")
end)(assert(Path.path.home))
local basename_regex = (".*%s([^%s]+)"):format(sep, sep)

local function replace_home(path)
  local start, finish = path:find(home, 1, true)
  if start == 1 then
    path = "~" .. sep .. path:sub(finish + 1, -1)
  end
  return path
end

local function make_items(opts, path)
  if path == Path.path.root() then
    return { "", path }
  end
  local transformed = utils.transform_path(opts, path)
  local replaced = replace_home(transformed)
  local basename = replaced:match(basename_regex)
  if not basename then
    return { "", replaced }
  end
  local parent = replaced:sub(1, #replaced - #basename)
  return { { parent, "Directory" }, basename }
end

local displayer = entry_display.create {
  separator = "",
  items = {
    { width = 7, right_justify = true }, -- score
    {}, -- separator
    {}, -- directory
    {}, -- basename
  },
}

local function gen_from_z(opts)
  return function(line)
    local score_str, dir = line:match "([%.%d]+)%s+(.+)"
    local score = tonumber(score_str)

    return {
      value = score,
      ordinal = dir,
      path = dir,
      display = function(entry)
        local items = make_items(opts, entry.path)
        return displayer {
          { ("%.2f"):format(entry.value), "TelescopeResultsNumber" },
          { " " },
          items[1],
          items[2],
        }
      end,
    }
  end
end

M.list = function(opts)
  opts = opts or {}
  local cmd = vim.F.if_nil(opts.cmd, { vim.o.shell, "-c", "z -l" })
  opts.cwd = utils.get_lazy_default(opts.cwd, vim.loop.cwd)
  opts.entry_maker = utils.get_lazy_default(opts.entry_maker, gen_from_z, opts)
  if opts.tail_path then
    opts.path_display = { "tail" }
  elseif opts.shorten_path then
    opts.path_display = { "shorten" }
  end

  pickers
    .new(opts, {
      prompt_title = "Visited directories from z",
      finder = finders.new_table {
        results = utils.get_os_command_output(cmd),
        entry_maker = opts.entry_maker,
      },
      sorter = conf.file_sorter(opts),
      previewer = previewers.cat.new(opts),
      attach_mappings = function(prompt_bufnr)
        actions_set.select:replace(function(_, type)
          local entry = actions_state.get_selected_entry()
          local dir = from_entry.path(entry)
          if type == "default" then
            require("telescope.builtin").find_files { cwd = dir, hidden = true }
            return
          end
          actions.close(prompt_bufnr)
          if type == "horizontal" then
            vim.cmd("cd " .. dir)
            print("chdir to " .. dir)
          elseif type == "vertical" then
            vim.cmd("lcd " .. dir)
            print("lchdir to " .. dir)
          elseif type == "tab" then
            vim.cmd("tcd " .. dir)
            print("tchdir to " .. dir)
          end
        end)
        return true
      end,
    })
    :find()
end

return M
