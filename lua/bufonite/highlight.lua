local M = {}

local hl_name = 'BufoniteSneakKey'
local hl_ns = vim.api.nvim_create_namespace(hl_name)
if vim.fn.hlexists(hl_name) == 0 then
  -- If the hl group does not exist, just set it to bold
  vim.api.nvim_set_hl(0, hl_name, { bold = true })
end

---Highlights the sneak keys
---@param bufnr number
---@param buffer_count number
---@param window_width number
function M.highlight_sneak_keys(bufnr, buffer_count, window_width)
  local rows = math.fmod(buffer_count, 2)

  for i = 0, rows do
    local buffer_line = 3 * i
    vim.hl.range(bufnr, hl_ns, hl_name, { buffer_line, 0 }, { buffer_line, window_width }, {})
  end
end

return M
