local M = {}

---Map the values using a supplied function
---@generic T, K
---@param array T[]
---@param fn fun(item: T, index: number): K called for each value to get the next value
---@return K[]
function M.map(array, fn)
  local arr = {}

  for i, n in ipairs(array) do
    table.insert(arr, fn(n, i))
  end

  return arr
end

---Run a function for each value in the array in reverse order
---@generic T
---@param array T[]
---@param fn fun(item: T, index: number): nil
function M.reverse_for_each(array, fn)
  for i = #array, 1, -1 do
    fn(array[i], i)
  end
end

---Filter the values using a supplied function
---@generic T
---@param array T[]
---@param fn fun(item: T): boolean
---@return T[]
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
