local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local bufonite = require('bufonite')
local buffers = require('bufonite.buffers')
local array = require('bufonite.array')

local M = {}

M.picker = function(opts)
  opts = opts or {}

  local buffer_numbers = bufonite.buffer_lru:all_but_mru()
  local infos = array.map(buffer_numbers, function(bufnr) return buffers.get_buffer_info(bufnr) end)

  pickers
    .new(opts, {
      prompt_title = 'Bufonite',
      finder = finders.new_table({
        results = infos,
        entry_maker = function(entry)
          local relative_path = vim.fn.fnamemodify(entry.current_path, ':.')

          return {
            value = relative_path,
            display = relative_path,
            ordinal = relative_path,
          }
        end,
      }),
      previewer = conf.file_previewer(opts),
      sorter = conf.file_sorter(opts),
    })
    :find()
end

return M
