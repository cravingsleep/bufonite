local M = {}

local box_width = 27
local box_separation = 10

local function truncate_from_start(str, max_len)
  if #str <= max_len then
    return str
  else
    return string.sub(str, -max_len)
  end
end

local function get_top_border(sneak_key)
  local halfway = math.floor(box_width / 2)

  return '╭' .. string.rep('─', halfway - 1) .. ' ' .. sneak_key .. ' ' .. string.rep('─', halfway - 1) .. '╮'
end

local function get_bottom_border() return '╰' .. string.rep('─', box_width) .. '╯' end

local function center_text(text, width)
  local pad = math.floor((width - #text) / 2)

  return string.rep(' ', pad) .. text .. string.rep(' ', width - pad - #text + 2)
end

local function get_middle(filename)
  local filename_truncated = truncate_from_start(filename, box_width - 2)

  return '│' .. center_text(filename_truncated, box_width - 2) .. '│'
end

function M.add_file_boxes(contents, sneak_key_left, filename_left, sneak_key_right, filename_right)
  if filename_right ~= nil then
    table.insert(
      contents,
      get_top_border(sneak_key_left) .. string.rep(' ', box_separation) .. get_top_border(sneak_key_right)
    )
    table.insert(contents, get_middle(filename_left) .. string.rep(' ', box_separation) .. get_middle(filename_right))
    table.insert(contents, get_bottom_border() .. string.rep(' ', box_separation) .. get_bottom_border())
  else
    table.insert(contents, get_top_border(sneak_key_left))
    table.insert(contents, get_middle(filename_left))
    table.insert(contents, get_bottom_border())
  end
end

return M
