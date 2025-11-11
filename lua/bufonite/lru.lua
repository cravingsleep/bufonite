---A Least Recently Used list where the item that has been added the most
---recently will be in the first position. It uses a doubly linked list
---and hashmap in order to provide O(1) addition and deletion.

---@class LRU.Node
---@field next LRU.Node|nil the next node in the list
---@field prev LRU.Node|nil the previous node in the list
---@field value any|nil the value stored in the node

---@class LRU
---@field head LRU.Node
---@field tail LRU.Node
---@field node_cache table<any, LRU.Node>
---@field length number
local LRU = {}
LRU.__index = LRU

---creates an empty list
---@return LRU
function LRU.new()
  local self = setmetatable({}, { __index = LRU })

  -- it is a lot easier to keep a constant head and tail
  -- when it comes to the methods so store them here
  self.head = {}
  self.tail = {}

  -- connect the head and tail so they both point at each other
  self.head.next = self.tail
  self.tail.prev = self.head

  -- this stores value->Node so we can find where in the list a value is in O(1)
  self.node_cache = {}
  -- lua does not have a reliable way to get the length of a table so keep track of it here
  -- it should always be the amount of entries in `node_cache`
  self.length = 0

  return self
end

---moves the node into the head position of the list
---@param node LRU.Node
function LRU:_put_into_head(node)
  node.prev = self.head
  self.head.next.prev = node
  node.next = self.head.next
  self.head.next = node

  self.node_cache[node.value] = node
  self.length = self.length + 1
end

---detaches the node from the list and connects the space left back together
---@param node LRU.Node
function LRU:_detach_node(node)
  node.prev.next = node.next
  node.next.prev = node.prev
  self.node_cache[node.value] = nil
  self.length = self.length - 1
end

---add a value to the list, making it the most recently used
---if the item already exists it moves to the first position
---@param value any
function LRU:add(value)
  local cached_node = self.node_cache[value]

  if cached_node == nil then
    -- add this as head
    self:_put_into_head({ value = value })
  else
    -- detach the node
    self:_detach_node(cached_node)
    self:_put_into_head(cached_node)
  end
end

---delete the value from the list completely
---@param value any
function LRU:delete(value)
  local cached_node = self.node_cache[value]

  if cached_node ~= nil then
    self:_detach_node(cached_node)
  end
end

---converts the linked list into an array
---@return any[]
function LRU:toarray()
  local arr = {}

  local node = self.head.next

  while node ~= nil and node ~= self.tail do
    table.insert(arr, node.value)
    node = node.next
  end

  return arr
end

---gets the item at the nth index, lua style so 1 is the most recently used
---@param index number
---@return any|nil the result or nil if not found
function LRU:at(index)
  local node = self.head

  for _ = 1, index do
    node = node.next

    if node == nil then
      return nil
    end
  end

  return node.value
end

-- function LRU:debug_print()
--   local content = {}
--
--   local node = self.head
--   while node ~= nil do
--     if node.type == Type.HEAD then
--       table.insert(content, 'H')
--     elseif node.type == Type.TAIL then
--       table.insert(content, 'T')
--     else
--       table.insert(content, node.value)
--     end
--
--     node = node.next
--   end
--
--   print(table.concat(content, ' -> '))
-- end
--

return LRU
