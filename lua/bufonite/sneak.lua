local M = {}

function M.get_sneak_key(i)
  local keys = 'fjksla;ghurieowpqvmcxz'

  return string.sub(keys, i, i)
end

return M
