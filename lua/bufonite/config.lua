local buffers = require('bufonite.buffers')

local M = {}

---@class Bufonite.KeymapsOpts
---@field close? string[] keymaps which should close the buffer selection window

---@class Bufonite.Opts
---@field is_buffer_selectable? fun(bufnr: number): boolean should this buffer be added to the list?
---@field keymaps? Bufonite.KeymapsOpts

---@class Bufonite.Keymaps
---@field close string[] keymaps which should close the buffer selection window

---@class Bufonite.Config
---@field is_buffer_selectable fun(bufnr: number): boolean should this buffer be added to the list?
---@field keymaps Bufonite.Keymaps

---@type Bufonite.Config
local defaults = {
  is_buffer_selectable = function(bufnr)
    return vim.api.nvim_buf_is_loaded(bufnr)
      and vim.bo[bufnr].buflisted
      and vim.bo[bufnr].buftype == ''
      and vim.api.nvim_buf_get_name(bufnr) ~= ''
      and not buffers.is_terminal_buffer(bufnr)
  end,
  keymaps = {
    close = { 'q', '<C-[>', '<esc>' },
  },
}

---@param opts? Bufonite.Opts
---@return Bufonite.Config
function M.get_config(opts) return vim.tbl_deep_extend('force', defaults, opts or {}) end

return M
