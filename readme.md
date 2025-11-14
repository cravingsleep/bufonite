# Bufonite

![A visual look at the Bufonite selector](https://github.com/user-attachments/assets/71248ac7-fabb-4b75-a17b-6562dbbadb34)

A Neovim plugin that simplifies buffer navigation and provides a better experience for alternate buffers.

## Brief

Keeping track of open buffers is difficult and time consuming. Bufonite stores your buffers in a LRU cache with a default
capacity of 5. When you are at capacity the least recently used buffer is evicted when a new one is open.

Switching to a new buffer is as simple as opening the buffer selection window and pressing the assigned key. Keys are assigned
from the home row and those rendered on the left are for the left hand and vice versa.

Bufonite also offers a different, perhaps more intuitive approach to the alternate buffer. Since deleted buffers are removed from
its LRU the alternate buffer will always be the most recently used buffer that is still open. This differs from base Vim which will
despite deleting the buffer will still keep it as the alternate.

## Installation

Using setup:
```lua
local bufonite = require('bufonite');

bufonite.setup {}

vim.keymap.set('n', '<C-e>', function() bufonite.show_buffers() end)
vim.keymap.set('n', '<Tab>', function() bufonite.switch_to_alt() end)
```

with lazy:
```lua
return {
  'cravingsleep/bufonite',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = false,
  opts = {},
  keys = {
    { '<leader>b', function() require('bufonite').show_buffers() end },
    { '<Tab>', function() require('bufonite').switch_to_alt() end },
  },
}
```

## Config

See the [types here](./lua/bufonite/config.lua), the default config is:
```lua
local defaults = {
  is_buffer_selectable = function(bufnr)
    return vim.api.nvim_buf_is_loaded(bufnr)
      and vim.bo[bufnr].buflisted
      and vim.bo[bufnr].buftype == ''
      and vim.api.nvim_buf_get_name(bufnr) ~= ''
      and not buffers.is_terminal_buffer(bufnr)
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
```

|field|description|
|is_buffer_selectable|decide whether to add the buffer to the lru|
|width|width of the buffer selector window|
|height|height of the buffer selector window|
|keymaps.close|what keys close the buffer selector window|
|keymaps.vsplit_prepend|what key to press before the sneak key to vertical split|
|keymaps.split_prepend|what key to press before the sneak key to horizontal split|
|capacity|the max amount of buffers to store in the lru|
|folders_shown|how many folders to show before the buffer filename|
