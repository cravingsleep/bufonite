local M = {}

local close_window = function(win_id)
  if vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
  end
end

---Adds a keymap to go straight to the file using a sneak key
---@param win_id number
---@param window_bufnr number
---@param bufnr number
---@param sneak_key string
function M.add_sneak_keymap(win_id, window_bufnr, bufnr, sneak_key)
  vim.api.nvim_buf_set_keymap(window_bufnr, 'n', sneak_key, '', {
    nowait = true,
    noremap = true,
    silent = true,
    callback = function()
      close_window(win_id)

      vim.api.nvim_set_current_buf(bufnr)
    end,
  })
end

---Add the keymaps to close the buffer selector window
---@param win_id number
---@param window_bufnr number
---@param close_keymaps string[]
function M.add_close_keymap(win_id, window_bufnr, close_keymaps)
  for _, key in ipairs(close_keymaps) do
    vim.api.nvim_buf_set_keymap(window_bufnr, 'n', key, '', {
      nowait = true,
      noremap = true,
      silent = true,
      callback = function() close_window(win_id) end,
    })
  end
end

return M
