local M = {}

---Erases chars from a string from the front if it exceeds a max length
---@param str string
---@param max_len number
---@return string
local function truncate_from_start(str, max_len)
  if #str <= max_len then
    return str
  else
    return string.sub(str, -max_len)
  end
end

---Gets the top border of a box
---@param box_width number
---@param sneak_key string
---@return string
local function get_top_border(box_width, sneak_key)
  local halfway = math.floor(box_width / 2)

  return '╭' .. string.rep('─', halfway - 2) .. ' ' .. sneak_key .. ' ' .. string.rep('─', halfway - 2) .. '╮'
end

---Gets the bottom border of a box
---@param box_width number
---@return string
local function get_bottom_border(box_width) return '╰' .. string.rep('─', box_width - 2) .. '╯' end

---Centers text by padding the sides with empty strings
---@param text string
---@param width number
---@return string
local function center_text(text, width)
  local pad = math.floor((width - #text) / 2)

  return string.rep(' ', pad) .. text .. string.rep(' ', width - pad - #text)
end

---Get the middle of the box with the filename inside
---@param box_width number
---@param filename string
---@return string
local function get_middle(box_width, filename)
  local filename_truncated = truncate_from_start(filename, box_width - 2)

  return '│' .. center_text(filename_truncated, box_width - 2) .. '│'
end

---Add two side by side file boxes to the content array
---@param contents string[]
---@param window_width number
---@param sneak_key_left string
---@param filename_left string
---@param sneak_key_right string
---@param filename_right string
function M.add_file_boxes(contents, window_width, sneak_key_left, filename_left, sneak_key_right, filename_right)
  local box_width = math.floor(window_width / 2)

  if filename_right ~= nil then
    table.insert(contents, get_top_border(box_width, sneak_key_left) .. get_top_border(box_width, sneak_key_right))
    table.insert(contents, get_middle(box_width, filename_left) .. get_middle(box_width, filename_right))
    table.insert(contents, get_bottom_border(box_width) .. get_bottom_border(box_width))
  else
    table.insert(contents, get_top_border(box_width, sneak_key_left))
    table.insert(contents, get_middle(box_width, filename_left))
    table.insert(contents, get_bottom_border(box_width))
  end
end

return M
