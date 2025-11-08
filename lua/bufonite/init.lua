local array = require('bufonite.array')
local ui = require('bufonite.ui')
local buffers = require('bufonite.buffers')
local sneak = require('bufonite.sneak')
local keymaps = require('bufonite.keymaps')

local M = {}

function M.setup() end

function M.show_buffers()
  local win_info = ui.create_window()
  local win_id = win_info.win_id
  local window_bufnr = win_info.bufnr

  local selectable_bufnrs = buffers.get_selectable_buffernrs()
  local buffer_infos = array.map(selectable_bufnrs, function(bufnr) return buffers.get_buffer_info(bufnr) end)

  array.for_each(
    buffer_infos,
    function(info, i) keymaps.add_sneak_keymap(win_id, window_bufnr, info.bufnr, sneak.get_sneak_key(i)) end
  )

  local content = array.map(
    buffer_infos,
    function(info, i) return sneak.get_sneak_key(i) .. ' : ' .. info.last_folder .. '/' .. info.filename end
  )
  vim.api.nvim_buf_set_lines(window_bufnr, 0, -1, false, content)

  keymaps.add_close_keymap(win_id, window_bufnr)
end

return M
