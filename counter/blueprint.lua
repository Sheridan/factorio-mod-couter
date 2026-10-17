require("base")

CounterBlueprint = class(CounterBase)

function CounterBlueprint:initialize()
  self.super.initialize(self)
end

function CounterBlueprint:collect_entities(entities)
  if entities == nil then return end
  for _, entity in ipairs(entities)
  do
    self:add_entity(entity.name, (entity.quality or "normal"))
    if entity.items
    then
      for _, item in ipairs(entity.items)
      do
        if item.items.in_inventory
        then
          local item_prototype = item.id.name
          local quality_prototype = (item.id.quality or {name = "normal"} )
          local total_count = 0
          for _, count in ipairs(item.items.in_inventory)
          do
            total_count = total_count + (count.count or 1)
          end
          self:add_items_content(item_prototype, quality_prototype.name, total_count)
        end
      end
    end
    if entity.wires
    then
      for _, wire in ipairs(entity.wires)
      do
        self:add_wire(wire[2], wire[1], wire[3])
      end
    end
  end
end

function CounterBlueprint:collect_tiles(tiles)
  if tiles == nil then return end
  for _, tile in ipairs(tiles)
  do
    self:add_tile(tile.name)
  end
end

function CounterBlueprint:collect(blueprint)
  self:collect_entities(blueprint.get_blueprint_entities())
  self:collect_tiles(blueprint.get_blueprint_tiles())
end
