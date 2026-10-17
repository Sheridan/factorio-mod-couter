
require("__factorio-user-interface__.fui")

require("counter.selection")
require("counter.blueprint")

require("gui.counter_table")

local function make_tabs_list(counted)
  local result = {}
  if counted:has_entities()
  or counted:has_tiles()              then table.insert( result, { name = "surface"  , caption = "Surface"           }) end
  if counted:has_fluids_content()
  or counted:has_items_content()
  or counted:has_equipments_content() then table.insert( result, { name = "inventory", caption = "Inventories"       }) end
  if counted:has_belts_content()
  or counted:has_inserters_content()  then table.insert( result, { name = "belts"    , caption = "Belt system"       }) end
  if counted:has_wires()
  or counted:has_signals()            then table.insert( result, { name = "wires"    , caption = "Wires and Signals" }) end
  return result
end

local function open_gui(player, counted)
  local tabs = make_tabs_list(counted)
  -- game.print(serpent.block(tabs))
  if #tabs > 0
  then
    -- if player.opened then player.opened = nil end
    local window = GUIWindow.new(player, "counter-main", {"counter_gui.window_caption"})
    local tabs = FUITabbedPane.new("counter_tabs", window, "fui_tabbed_pane", "fui_tab", "horizontal_flow", tabs)
    if counted:has_entities()           then CounterTable.new("entities"  , tabs:tab("surface"  ), "Entities"   , counted:entities()          ) end
    if counted:has_tiles()              then CounterTable.new("tiles"     , tabs:tab("surface"  ), "Tiles"      , counted:tiles()             ) end
    if counted:has_items_content()      then CounterTable.new("items"     , tabs:tab("inventory"), "Inventories", counted:items_content()     ) end
    if counted:has_fluids_content()     then CounterTable.new("fluids"    , tabs:tab("inventory"), "Fluids"     , counted:fluids_content()    ) end
    if counted:has_equipments_content() then CounterTable.new("equipments", tabs:tab("inventory"), "Equipment"  , counted:equipments_content()) end
    if counted:has_belts_content()      then CounterTable.new("belts"     , tabs:tab("belts"    ), "Belts"      , counted:belts_content()     ) end
    if counted:has_inserters_content()  then CounterTable.new("inserters" , tabs:tab("belts"    ), "Inserters"  , counted:inserters_content() ) end
    if counted:has_wires()              then CounterTable.new("wires"     , tabs:tab("wires"    ), "Wires"      , counted:wires()             ) end
    if counted:has_signals()            then CounterTable.new("signals"   , tabs:tab("wires"    ), "Signals"    , counted:signals()           ) end
  end
end

local function on_area_selected(event)
  if event.item ~= "counter-selection-tool" then return end
  local player = game.get_player(event.player_index)
  -- if event.entities == nil or eve then return end
  local counter = CounterSelection:new()
  counter:collect(event)
  -- game.print(serpent.block(counter))
  open_gui(player, counter)
  player.clear_cursor()
end

local function on_shortcut(event)
  local player = game.get_player(event.player_index)
  if not player or not player.valid then return end

  if  player.is_cursor_blueprint() and
      player.cursor_record and
      player.cursor_record.type == "blueprint" and
      not player.cursor_record.is_preview
  then
    local counter = CounterBlueprint:new()
    counter:collect(player.cursor_record)
    open_gui(player, counter)
    player.clear_cursor()
  else
    if player.cursor_stack and player.cursor_stack.valid then
      player.cursor_stack.set_stack({name = "counter-selection-tool"})
    end
  end
end

local function init_storage()
  storage = storage or {}
  fui_init_storage()
end

local function register_event_handlers()
  ------------------------------------------------------------------------------------------------------------
  script.on_event(defines.events.on_player_selected_area    , on_area_selected)
  script.on_event(defines.events.on_player_alt_selected_area, on_area_selected)
  ------------------------------------------------------------------------------------------------------------
  script.on_event(defines.events.on_gui_click, function(event)
    fui_event_on_gui_click_notify(event)
  end)
  ------------------------------------------------------------------------------------------------------------
  script.on_event(defines.events.on_gui_closed, function(event)
    fui_event_on_gui_closed_notify(event)
  end)
  ------------------------------------------------------------------------------------------------------------
  script.on_event(defines.events.on_lua_shortcut,function(event)
    if event.prototype_name == "counter-shortcut" then on_shortcut(event) end
  end)
  ------------------------------------------------------------------------------------------------------------
  script.on_event(defines.events.on_string_translated, function(event)
    fui_event_on_string_translated_notify(event)
  end)
  ------------------------------------------------------------------------------------------------------------
end

local function configuration_changed()
  init_storage()
end

local function on_init()
  init_storage()
  register_event_handlers()
end

local function on_load()
  register_event_handlers()
end

script.on_init(on_init)
script.on_load(on_load)
script.on_configuration_changed(configuration_changed)
