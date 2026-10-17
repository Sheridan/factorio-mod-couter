require("__fui__.utils.class")

CounterBase = class()

function CounterBase:initialize()
  self.data = {
    entities = {},
    tiles = {},
    wires = {},
    signals = {},
    fluids_content = {},
    items_content = {},
    equipments_content = {},
    belts_content = {},
    inserters_content = {}
  }
end

function CounterBase:wire_type(wire_connector_id)
  if wire_connector_id == defines.wire_connector_id.circuit_green
  or wire_connector_id == defines.wire_connector_id.combinator_input_green
  or wire_connector_id == defines.wire_connector_id.combinator_output_green   then return defines.wire_type.green end

  if wire_connector_id == defines.wire_connector_id.circuit_red
  or wire_connector_id == defines.wire_connector_id.combinator_input_red
  or wire_connector_id == defines.wire_connector_id.combinator_output_red     then return defines.wire_type.red end

  if wire_connector_id == defines.wire_connector_id.pole_copper
  or wire_connector_id == defines.wire_connector_id.power_switch_left_copper
  or wire_connector_id == defines.wire_connector_id.power_switch_right_copper then return defines.wire_type.copper end

  return defines.wire_type.copper
end

function CounterBase:wire_name(wire_define)
  if wire_define == defines.wire_connector_id.circuit_green
  or wire_define == defines.wire_connector_id.combinator_input_green
  or wire_define == defines.wire_connector_id.combinator_output_green   then return "green-wire" end

  if wire_define == defines.wire_connector_id.circuit_red
  or wire_define == defines.wire_connector_id.combinator_input_red
  or wire_define == defines.wire_connector_id.combinator_output_red     then return "red-wire" end

  if wire_define == defines.wire_connector_id.pole_copper
  or wire_define == defines.wire_connector_id.power_switch_left_copper
  or wire_define == defines.wire_connector_id.power_switch_right_copper then return "copper-wire" end

    -- if wire_define == defines.wire_type.red    then return "red-wire" end
    -- if wire_define == defines.wire_type.green  then return "green-wire" end
    -- if wire_define == defines.wire_type.copper then return "copper-wire" end
    return "copper-wire"
end

function CounterBase:add(to, key, data, count)
  if not self.data[to][key]
  then
    self.data[to][key] = data
    self.data[to][key].count = 0
  end
  self.data[to][key].count = self.data[to][key].count + (count or 1)
end

function CounterBase:add_entity(entity, quality)
  self:add("entities", entity .. quality,
  {
    type = "entity",
    thing  = entity,
    quality = quality
  })
end

function CounterBase:add_tile(tile)
  self:add("tiles", tile,
  {
    type = "tile",
    thing  = tile
  })
end

function CounterBase:add_fluids_content(fluid, count)
  self:add("fluids_content", fluid,
  {
    type = "fluid",
    thing = fluid
  }, count)
end

function CounterBase:add_items_content(item, quality, count)
  self:add("items_content", item .. quality,
  {
    type = "item",
    thing = item,
    quality = quality
  }, count)
end

function CounterBase:add_equipments_content(equipment, quality, count)
  self:add("equipments_content", equipment .. quality,
  {
    type = "equipment",
    thing = equipment,
    quality = quality
  }, count)
end

function CounterBase:add_belts_content(content, quality, count)
  self:add("belts_content", content .. quality,
  {
    type = "item",
    thing = content,
    quality = quality
  }, count)
end

function CounterBase:add_inserters_content(content, quality, count)
  self:add("inserters_content", content .. quality,
  {
    type = "item",
    thing = content,
    quality = quality
  }, count)
end

function CounterBase:add_wire(wire, from, to)
  for _, w in pairs(self.data.wires)
  do
    if (w.to   == to and w.from == from) or
       (w.from == to and w.to   == from)
    then return end
  end
  -- game.print(to .. ":" .. from)
  local wire_name = self:wire_name(wire)
  self:add("wires", wire_name,
  {
    type = "item",
    thing = wire_name,
    from = from,
    to = to
  })
end

function CounterBase:add_signal(name, type, quality)
  type = (type or "item")
  if type == "virtual" then type = "virtual-signal" end
  self:add("signals", type .. name .. quality,
  {
    type = type,
    thing = name,
    quality = quality
  })
end

function CounterBase:has(what)
  -- game.print(serpent.block(self.data[what]))
  return table_size(self.data[what]) > 0
end

function CounterBase:has_entities()
  return self:has("entities")
end

function CounterBase:has_tiles()
  return self:has("tiles")
end

function CounterBase:has_fluids_content()
  return self:has("fluids_content")
end

function CounterBase:has_items_content()
  return self:has("items_content")
end

function CounterBase:has_equipments_content()
  return self:has("equipments_content")
end

function CounterBase:has_belts_content()
  return self:has("belts_content")
end

function CounterBase:has_inserters_content()
  return self:has("inserters_content")
end

function CounterBase:has_wires()
  return self:has("wires")
end

function CounterBase:has_signals()
  return self:has("signals")
end

function CounterBase:entities()
  return self.data.entities
end

function CounterBase:tiles()
  return self.data.tiles
end

function CounterBase:fluids_content()
  return self.data.fluids_content
end

function CounterBase:items_content()
  return self.data.items_content
end

function CounterBase:equipments_content()
  return self.data.equipments_content
end

function CounterBase:belts_content()
  return self.data.belts_content
end

function CounterBase:inserters_content()
  return self.data.inserters_content
end

function CounterBase:wires()
  return self.data.wires
end

function CounterBase:signals()
  return self.data.signals
end
