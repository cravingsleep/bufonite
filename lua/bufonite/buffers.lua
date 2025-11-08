local array = require('bufonite.array')

local M = {}

function M.get_selectable_buffernrs()
  local current_bufnr = vim.api.nvim_get_current_buf()

  return array.filter(
    vim.api.nvim_list_bufs(),
    function(bufnr) return bufnr ~= current_bufnr and vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted end
  )
end

function M.get_buffer_info(bufnr)
  local current_path = vim.api.nvim_buf_get_name(bufnr)
  local last_folder = vim.fn.fnamemodify(current_path, ':h:t')
  local filename = vim.fn.fnamemodify(current_path, ':t')

  return { bufnr = bufnr, last_folder = last_folder, filename = filename }
end

return M
