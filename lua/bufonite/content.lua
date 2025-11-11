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

-- { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
local top_border = '╭─╮'
-- be careful because the byte length of the borders is 9
local top_border_length = 3
local bottom_border = '╰─╯'
local bottom_border_length = 3

---@param sneak_key string
---@return string
local function get_middle(sneak_key) return '│' .. sneak_key .. '│' end

---Gives n spaces
---@param n number
---@return string
local function ws(n) return string.rep(' ', n) end

---Add two side by side file boxes to the content array
---@param contents string[]
---@param window_width number
---@param sneak_key_left string
---@param filename_left string
---@param sneak_key_right string
---@param filename_right string
function M.add_file_boxes(contents, window_width, sneak_key_left, filename_left, sneak_key_right, filename_right)
  if filename_right ~= nil then
    local middle_space = window_width - 8
    local max_filename_length = math.floor(middle_space / 2)
    local truncated_filename_left = truncate_from_start(filename_left, max_filename_length)
    local truncated_filename_right = truncate_from_start(filename_right, max_filename_length)

    table.insert(contents, top_border .. ws(window_width - (top_border_length * 2)) .. top_border)

    local left_middle = get_middle(sneak_key_left) .. ' ' .. truncated_filename_left
    local right_middle = truncated_filename_right .. ' ' .. get_middle(sneak_key_right)

    -- get rid of the 8 extra bytes by the unicode line length
    table.insert(contents, left_middle .. ws(window_width - (#right_middle + #left_middle - 8)) .. right_middle)
    table.insert(contents, bottom_border .. ws(window_width - (bottom_border_length * 2)) .. bottom_border)
  else
    local max_space = window_width - 4
    table.insert(contents, top_border)
    table.insert(contents, get_middle(sneak_key_left) .. ' ' .. truncate_from_start(filename_left, max_space))
    table.insert(contents, bottom_border)
  end
end

return M
