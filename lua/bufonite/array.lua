local M = {}

function M.map(array, fn)
  local arr = {}

  for i, n in ipairs(array) do
    table.insert(arr, fn(n, i))
  end

  return arr
end

function M.for_each(array, fn)
  for i, n in ipairs(array) do
    fn(n, i)
  end
end

function M.filter(array, fn)
  local arr = {}

  for _, n in ipairs(array) do
    if fn(n) then
      table.insert(arr, n)
    end
  end

  return arr
end

return M
