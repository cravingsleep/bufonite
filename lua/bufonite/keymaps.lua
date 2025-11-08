local M = {}

function M.add_sneak_keymap(win_id, window_bufnr, bufnr, sneak_key)
  vim.api.nvim_buf_set_keymap(window_bufnr, 'n', sneak_key, '', {
    nowait = true,
    noremap = true,
    silent = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true)
      end

      vim.api.nvim_set_current_buf(bufnr)
    end,
  })
end

function M.add_close_keymap(win_id, window_bufnr)
  vim.api.nvim_buf_set_keymap(window_bufnr, 'n', 'q', '', {
    nowait = true,
    noremap = true,
    silent = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true)
      end
    end,
  })
end

return M
