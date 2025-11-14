local M = {}

---@class Bufonite.KeymapsOpts
---@field close? string[] keymaps which should close the buffer selection window
---@field vsplit_prepend? string the key to press before you open a buffer in vsplit
---@field split_prepend? string the key to press before you open a buffer in split

---@class Bufonite.Opts
---@field is_buffer_selectable? fun(bufnr: number): boolean should this buffer be added to the list?
---@field width? number
---@field height? number
---@field keymaps? Bufonite.KeymapsOpts
---@field capacity? number
---@field folders_shown? number

---@class Bufonite.Keymaps
---@field close string[] keymaps which should close the buffer selection window
---@field vsplit_prepend string the key to press before you open a buffer in vsplit
---@field split_prepend string the key to press before you open a buffer in split

---@class Bufonite.Config
---@field width number
---@field height number
---@field is_buffer_selectable fun(bufnr: number): boolean should this buffer be added to the list?
---@field keymaps Bufonite.Keymaps
---@field capacity number
---@field folders_shown number

---@type Bufonite.Config
local defaults = {
  is_buffer_selectable = function(bufnr)
    return vim.api.nvim_buf_is_loaded(bufnr)
      and vim.bo[bufnr].buflisted
      and vim.bo[bufnr].buftype == ''
      and vim.api.nvim_buf_get_name(bufnr) ~= ''
  end,
  width = 70,
  height = 30,
  keymaps = {
    close = { 'q', '<C-[>', '<esc>' },
    vsplit_prepend = '<C-v>',
    split_prepend = '<C-h>',
  },
  capacity = 5,
  folders_shown = 2,
}

---@param opts? Bufonite.Opts
---@return Bufonite.Config
function M.get_config(opts) return vim.tbl_deep_extend('force', defaults, opts or {}) end

return M
