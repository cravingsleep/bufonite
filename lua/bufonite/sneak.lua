local M = {}

---Get a sneak key for the left hand
---@param i number
---@return string
function M.get_left_sneak_key(i)
  local keys = 'fsagtrewqvcxz'

  return string.sub(keys, i, i)
end

---Get a sneak key for the right hand
---@param i number
---@return string
function M.get_right_sneak_key(i)
  local keys = 'jkl;hyuiopbnm'

  return string.sub(keys, i, i)
end

return M
