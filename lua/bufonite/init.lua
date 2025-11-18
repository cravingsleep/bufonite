local config = require('bufonite.config')
local array = require('bufonite.array')
local buffers = require('bufonite.buffers')
local LRU = require('bufonite.lru')

local M = {}

---@type LRU
local buffer_lru

---@param opts? Bufonite.Opts
function M.setup(opts)
  M.config = config.get_config(opts)

  buffer_lru = LRU.new()

  -- get the list of initial buffers (i.e. from cmd line) and load them in to our lru
  -- add them in reverse since the first file in the cmd line will be the open one which
  -- will be the most recent
  local initial_buffers = vim.api.nvim_list_bufs()
  local selectable_initial_buffers = array.filter(
    initial_buffers,
    function(bufnr) return M.config.is_buffer_selectable(bufnr) end
  )
  array.reverse_for_each(selectable_initial_buffers, function(bufnr) buffer_lru:add(bufnr) end)

  local group = vim.api.nvim_create_augroup('BufoniteAutoCmds', { clear = true })

  -- set up the listener for opening buffers and add them to the lru
  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    group = group,
    callback = function(args)
      if M.config.is_buffer_selectable(args.buf) then
        buffer_lru:add(args.buf)
      end
    end,
  })

  -- set up the listener for closing buffers and delete them from the lru
  vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
    group = group,
    callback = function(args) buffer_lru:delete(args.buf) end,
  })
end

---Switches to the Bufonite alternate buffer
function M.switch_to_alt()
  local bufonite_alt_buffer = buffer_lru:at(2)

  if bufonite_alt_buffer ~= nil then
    vim.api.nvim_set_current_buf(bufonite_alt_buffer)
  end
end

---Gets the buffer number for the Bufonite alternate buffer
---@return number
function M.get_alt_buffernr() return buffer_lru:at(2) end

---Gets the amount of buffers currently open
---@return number
function M.get_buffer_count() return buffer_lru.length end

---@alias LuaLineAltBufferOpts {folders_shown?:number, prefix_icon?:string}
---A Lualine plugin to show the Bufoite alt buffer name
---@param opts LuaLineAltBufferOpts?
function M.lualine_altbuffer(opts)
  local folders_shown = (opts or {}).folders_shown or 0
  local prefix_icon = (opts or {}).prefix_icon or '⇄'

  local alt_bufnr = M.get_alt_buffernr()
  if alt_bufnr == nil then
    return ''
  end

  local fullpath = vim.api.nvim_buf_get_name(alt_bufnr)
  local filename = buffers.last_n_folders(fullpath, folders_shown)

  return prefix_icon .. ' ' .. filename
end

return M
