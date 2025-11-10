local M = {}

---Gets some info about the buffers
---@param bufnr number
---@return {bufnr:number, last_folder:string, filename:string}
function M.get_buffer_info(bufnr)
  local current_path = vim.api.nvim_buf_get_name(bufnr)
  local last_folder = vim.fn.fnamemodify(current_path, ':h:t')
  local filename = vim.fn.fnamemodify(current_path, ':t')

  return { bufnr = bufnr, last_folder = last_folder, filename = filename }
end

---@param bufnr number
---@return boolean
function M.is_terminal_buffer(bufnr)
  local buffer_name = vim.api.nvim_buf_get_name(bufnr)

  return string.sub(buffer_name, 1, string.len('term://')) == 'term://'
end

return M
