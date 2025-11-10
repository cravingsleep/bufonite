local popup = require('plenary.popup')

local M = {}

---Creates a floating window
---@return {bufnr:number, win_id:number, lock_content: function}
function M.create_window()
  local width = 68
  local height = 20

  local win_config = {
    title = 'Bufonite',
    line = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = height,
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  }

  local bufnr = vim.api.nvim_create_buf(false, false)
  local win_id = popup.create(bufnr, win_config)

  vim.api.nvim_set_option_value('filetype', 'bufonite', { buf = bufnr })
  vim.api.nvim_set_option_value('bufhidden', 'delete', { buf = bufnr })
  vim.api.nvim_set_option_value('buftype', 'acwrite', { buf = bufnr })

  return {
    bufnr = bufnr,
    win_id = win_id,
    lock_content = function() vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr }) end,
  }
end

return M
