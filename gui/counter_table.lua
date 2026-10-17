require("__factorio-user-interface__.fui")
require("__factorio-user-interface__.utils.class")
require("utils.elem_tooltip_filter")

CounterTable = class()

function CounterTable:initialize(name, parent, caption, things)
  self.count_table = FUITable.new("counter_count_table_" .. name, parent, caption, "fui_table_style", {
    { caption = " "    , type = "sprites"},
    { caption = "Name" , type = "localised_text" },
    { caption = "Count", type = "text" }
  })
  self.things = things
  self:make()
end

function CounterTable:make()
  for _, thing in pairs(self.things)
  do
    -- log(thing.type .. "/" .. thing.thing)
    if self:thing_has_prototype(thing)
    then
      self.count_table:add_row({ self:thing_sprites(thing), self:thing_name(thing), self:thing_count(thing) })
    end
  end
  self.count_table:update()
end

function CounterTable:fix_prototype_type(name)
  if name == "virtual-signal" then name = "virtual_signal" end
  return name
end

function CounterTable:thing_has_prototype(thing)
  local type = self:fix_prototype_type(thing.type)
  return prototypes[type] and prototypes[type][thing.thing]
end

function CounterTable:thing_prototype(thing)
  local type = self:fix_prototype_type(thing.type)
  return prototypes[type][thing.thing]
end

-- function CounterTable:thing_quality(thing)
--   if thing.quality then return prototypes.quality[thing.quality] end
--   return nil
-- end

function CounterTable:thing_sprites(thing)
  -- local type = thing.type
  -- if type == "virtual_signal" then type = "virtual-signal" end
  local result = {
    {
      path = thing.type .. "/" .. thing.thing,
      style = "counter_sprite_style"
    }
  }
  -- local quality = self:thing_quality(thing)
  if thing.quality and thing.quality ~= "normal"
  then
    table.insert(result,
    {
      path = 'quality/' .. thing.quality,
      style = "counter_quality_sprite_style"
    })
  end
  return {
    content = result,
    elem_tooltip =  self:get_elem_tooltip(thing)
  }
end

function CounterTable:get_elem_type(thing)
  if thing.type == "virtual-signal" then return "signal" end
  if thing.quality and ( thing.type ~= "fluid" and thing.type ~= "tile" ) then return thing.type .. "-with-quality" end
  return thing.type
end

function CounterTable:get_elem_signal_type(thing)
  if thing.type == "virtual-signal" then return "virtual" end
  return nil
end

function CounterTable:get_elem_tooltip(thing)
  return {
    type        = self:get_elem_type(thing),
    signal_type = self:get_elem_signal_type(thing),
    name        = thing.thing,
    quality     = thing.quality or "normal",
  }
end

function CounterTable:thing_name(thing)
  local prototype = self:thing_prototype(thing)
  return {
    content = prototype.localised_name,
    tooltip = {"?", {"", prototype.localised_description, "\n"}, prototype.localised_name, ""},
  }
end

function CounterTable:thing_count(thing)
  return { content = thing.count }
end
