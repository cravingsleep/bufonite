local M = {}

function M.get_left_sneak_key(i)
  local keys = 'fsagtrewqvcxz'

  return string.sub(keys, i, i)
end

function M.get_right_sneak_key(i)
  local keys = 'jkl;hyuiopbnm'

  return string.sub(keys, i, i)
end

return M
