local array = require('bufonite.array')
local ui = require('bufonite.ui')
local buffers = require('bufonite.buffers')
local sneak = require('bufonite.sneak')
local keymaps = require('bufonite.keymaps')
local printer = require('bufonite.content')

local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup('BufoniteAutoCmds', { clear = true })

  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    group = group,
    callback = function(args) print(tostring(args.buf)) end,
  })
end

function M.show_buffers()
  local win_info = ui.create_window()
  local win_id = win_info.win_id
  local window_bufnr = win_info.bufnr

  local selectable_bufnrs = buffers.get_selectable_buffernrs()
  local buffer_infos = array.map(selectable_bufnrs, function(bufnr) return buffers.get_buffer_info(bufnr) end)

  local paired = array.zip(buffer_infos, 2)
  local content = {}

  array.for_each(paired, function(pair, i)
    keymaps.add_sneak_keymap(win_id, window_bufnr, pair[1].bufnr, sneak.get_left_sneak_key(i))
    if pair[2] ~= nil then
      keymaps.add_sneak_keymap(win_id, window_bufnr, pair[2].bufnr, sneak.get_right_sneak_key(i))
    end

    printer.add_file_boxes(
      content,
      sneak.get_left_sneak_key(i),
      pair[1].last_folder .. '/' .. pair[1].filename,
      pair[2] and sneak.get_right_sneak_key(i),
      pair[2] and pair[2].last_folder .. '/' .. pair[2].filename
    )
  end)

  vim.api.nvim_buf_set_lines(window_bufnr, 0, #content, false, content)

  keymaps.add_close_keymap(win_id, window_bufnr)
end

return M
