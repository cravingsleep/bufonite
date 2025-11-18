# Bufonite

A Neovim plugin that simplifies alt buffer navigation to be more intuitive and respect deleted buffers.

## Brief

Bufonite offers a different, perhaps more intuitive approach to the alternate buffer. Since deleted buffers are removed from
its LRU the alternate buffer will always be the most recently used buffer that is still open. This differs from base Vim which will
despite deleting the buffer will still keep it as the alternate.

## Installation

Using setup:
```lua
local bufonite = require('bufonite');

bufonite.setup {}

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
  end,
}
```

|field|description|
|-----|-----------|
|is_buffer_selectable|decide whether to add the buffer to the lru|

## Lualine Integration

You can show the alternate buffer name in Lualine using:
```lua
function() return require('bufonite').lualine_altbuffer() end,
```

It has the options:
|field|description|default|
|-----|-----------|-------|
|folders_shown|how many folders to show before the filename|0|
|prefix_icon|what icon to show before the text|⇄| 

You can also use `get_buffer_count` if you need to know how many buffers are in the LRU.
