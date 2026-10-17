require("base")

CounterSelection = class(CounterBase)

function CounterSelection:initialize()
  self.super.initialize(self)
end

function CounterSelection:collect_entities(entities)
  if entities == nil then return end
  for _, entity in ipairs(entities)
  do
    self:add_entity(entity.name, entity.quality.name)

    --- inventories
    for i = 1, entity.get_max_inventory_index()
    do
      local inventory = entity.get_inventory(i)
      if inventory
      then
        for _, item in ipairs(inventory.get_contents())
        do
          self:add_items_content(item.name, item.quality, item.count)
        end
      end
    end

    --- fluids
    for fluid, count in pairs(entity.get_fluid_contents())
    do
      self:add_fluids_content(fluid, count)
    end


    --- grid
    if entity.grid
    then
      for _, equipment in ipairs(entity.grid.get_contents())
      do
        self:add_equipments_content(equipment.name, equipment.quality, equipment.count)
      end
    end

    --- belts
    if entity.prototype.belt_speed
    then
      for i = 1, entity.get_max_transport_line_index()
      do
        local line = entity.get_transport_line(i)
        for _, item in ipairs(line.get_contents())
        do
          self:add_belts_content(item.name, item.quality, item.count)
        end
      end
    end

    --- inserters
    if entity.prototype.inserter_pickup_position and entity.held_stack.valid_for_read
    then
      local stack = entity.held_stack
      self:add_inserters_content(stack.name, stack.quality.name, stack.count)
    end

    --- wires
    for wire_connector_id, connector in pairs(entity.get_wire_connectors())
    do
      for _, connection in ipairs(connector.connections)
      do
        local other_connector = connection.target
        local other_entity = other_connector.owner
        self:add_wire(wire_connector_id, entity.unit_number, other_entity.unit_number)
      end
      if self:wire_type(wire_connector_id) ~= defines.wire_type.copper
      then
        for _, signal in ipairs(entity.get_signals(wire_connector_id) or {})
        do
          local quality = "normal"
          if signal.signal and signal.signal.quality then quality = signal.signal.quality end
          self:add_signal(signal.signal.name, signal.signal.type, quality)
        end
      end
    end
  end
end

function CounterSelection:collect_tiles(tiles)
  if tiles == nil then return end
  for _, tile in ipairs(tiles)
  do
    self:add_tile(tile.name)
  end
end

function CounterSelection:collect(selection)
  self:collect_entities(selection.entities)
  self:collect_tiles(selection.tiles)
end
