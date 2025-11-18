local M = {}

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
