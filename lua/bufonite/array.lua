local M = {}

---Map the values using a supplied function
---@param array table
---@param fn function called for each value to get the next value
---@return table
function M.map(array, fn)
  local arr = {}

  for i, n in ipairs(array) do
    table.insert(arr, fn(n, i))
  end

  return arr
end

---Run a function for each value in the array
---@param array table
---@param fn function
function M.for_each(array, fn)
  for i, n in ipairs(array) do
    fn(n, i)
  end
end

---Run a function for each value in the array in reverse order
---@param array table
---@param fn function
function M.reverse_for_each(array, fn)
  for i = #array, 1, -1 do
    fn(array[i], i)
  end
end

---Filter the values using a supplied function
---@param array table
---@param fn function
---@return table
function M.filter(array, fn)
  local arr = {}

  for _, n in ipairs(array) do
    if fn(n) then
      table.insert(arr, n)
    end
  end

  return arr
end

---Group together sequential values to a limit of #n
---@param array table
---@param n number
---@return table
function M.zip(array, n)
  local arr = {}

  for i = 1, #array, n do
    local zipped = {}

    for z = i, math.min(i + n - 1, #array) do
      table.insert(zipped, array[z])
    end

    table.insert(arr, zipped)
  end

  return arr
end

return M
