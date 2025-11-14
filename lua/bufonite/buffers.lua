local M = {}

---Gets some info about the buffers
---@param bufnr number
---@return {bufnr:number, current_path:string}
function M.get_buffer_info(bufnr)
  local current_path = vim.api.nvim_buf_get_name(bufnr)

  return { bufnr = bufnr, current_path = current_path }
end

---@param bufnr number
---@return boolean
function M.is_terminal_buffer(bufnr)
  local buffer_name = vim.api.nvim_buf_get_name(bufnr)

  return string.sub(buffer_name, 1, string.len('term://')) == 'term://'
end

---@param path string
---@param n number
---@return string
function M.last_n_folders(path, n)
  local parts = {}

  for part in string.gmatch(path, '[^/]+') do
    table.insert(parts, part)
  end

  -- Get the last n+1 parts (n folders + filename)
  local start_idx = math.max(1, #parts - n)
  local result = table.concat(parts, '/', start_idx)

  return result
end

return M
