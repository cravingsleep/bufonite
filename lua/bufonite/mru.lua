local Node = {}
Node.__index = Node

local Type = {
  HEAD = 1,
  TAIL = 2,
}

function Node:new(value, next, prev, type)
  local obj = {}
  setmetatable(obj, self)

  obj.value = value
  obj.next = next
  obj.prev = prev
  obj.type = type

  return obj
end

local MRU = {}
MRU.__index = MRU

function MRU:new()
  local obj = {}
  setmetatable(obj, self)

  self.head = Node:new(nil, nil, nil, Type.HEAD)
  self.tail = Node:new(nil, nil, nil, Type.TAIL)

  self.head.next = self.tail
  self.tail.prev = self.head

  self.map = {}

  return obj
end

function MRU:get_latest() return self.head.next.value end

function MRU:_put_into_head(node)
  node.prev = self.head
  self.head.next.prev = node
  node.next = self.head.next
  self.head.next = node

  self.map[node.value] = node
end

function MRU:add(value)
  local cached_node = self.map[value]

  if cached_node == nil then
    -- add this as head
    local new_node = Node:new(value)
    self:_put_into_head(new_node)
  else
    -- detach the node
    cached_node.prev.next = cached_node.next
    cached_node.next.prev = cached_node.prev

    self:_put_into_head(cached_node)
  end
end

-- function MRU:debug_print()
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

return MRU
