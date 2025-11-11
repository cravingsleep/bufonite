local config = require('bufonite.config')
local array = require('bufonite.array')
local ui = require('bufonite.ui')
local buffers = require('bufonite.buffers')
local sneak = require('bufonite.sneak')
local keymaps = require('bufonite.keymaps')
local printer = require('bufonite.content')
local highlight = require('bufonite.highlight')
local MRU = require('bufonite.mru')

local M = {}

---@type MRU
local buffer_mru = MRU:new()

---@param opts? Bufonite.Opts
function M.setup(opts)
  M.config = config.get_config(opts)

  -- get the list of initial buffers (i.e. from cmd line) and load them in to our mru
  -- add them in reverse since the first file in the cmd line will be the open one which
  -- will be the most recent
  local initial_buffers = vim.api.nvim_list_bufs()
  local selectable_initial_buffers = array.filter(
    initial_buffers,
    function(bufnr) return M.config.is_buffer_selectable(bufnr) end
  )
  array.reverse_for_each(selectable_initial_buffers, function(bufnr) buffer_mru:add(bufnr) end)

  local group = vim.api.nvim_create_augroup('BufoniteAutoCmds', { clear = true })

  -- set up the listener for opening buffers and add them to the mru
  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    group = group,
    callback = function(args)
      if M.config.is_buffer_selectable(args.buf) then
        buffer_mru:add(args.buf)
      end
    end,
  })

  -- set up the listener for closing buffers and delete them from the mru
  vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
    group = group,
    callback = function(args) buffer_mru:delete(args.buf) end,
  })
end

---Switches to the Bufonite alternate buffer
function M.switch_to_alt()
  local bufonite_alt_buffer = buffer_mru:at(2)

  if bufonite_alt_buffer ~= nil then
    vim.api.nvim_set_current_buf(bufonite_alt_buffer)
  end
end

---Gets the buffer number for the Bufonite alternate buffer
---@return number
function M.get_alt_buffernr() return buffer_mru:at(2) end

---Gets the amount of buffers currently open
---@return number
function M.get_buffer_count() return buffer_mru.length end

---Show the Bufonite buffer selector
function M.show_buffers()
  local current_bufnr = vim.api.nvim_get_current_buf()
  local selectable_bufnrs = array.filter(buffer_mru:toarray(), function(bufnr) return bufnr ~= current_bufnr end)
  if #selectable_bufnrs == 0 then
    vim.notify('Bufonite: no buffers to show...')
    return
  end

  local win_info = ui.create_window(M.config.width, M.config.height)
  local win_id = win_info.win_id
  local window_bufnr = win_info.bufnr

  local buffer_infos = array.map(selectable_bufnrs, function(bufnr) return buffers.get_buffer_info(bufnr) end)

  local paired = array.zip(buffer_infos, 2)
  local content = {}

  array.for_each(paired, function(pair, i)
    keymaps.add_sneak_keymap(win_id, window_bufnr, pair[1].bufnr, sneak.get_left_sneak_key(i))
    if pair[2] ~= nil then
      keymaps.add_sneak_keymap(win_id, window_bufnr, pair[2].bufnr, sneak.get_right_sneak_key(i))
    end

    printer.add_file_boxes(
      content,
      M.config.width,
      sneak.get_left_sneak_key(i),
      pair[1].last_folder .. '/' .. pair[1].filename,
      pair[2] and sneak.get_right_sneak_key(i),
      pair[2] and pair[2].last_folder .. '/' .. pair[2].filename
    )
  end)

  vim.api.nvim_buf_set_lines(window_bufnr, 0, #content, false, content)
  highlight.highlight_sneak_keys(window_bufnr, buffer_mru.length, M.config.width)
  win_info.lock_content()

  keymaps.add_close_keymap(win_id, window_bufnr)
end

return M
