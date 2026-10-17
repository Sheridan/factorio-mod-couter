require("utils.mod")

-- log(serpent.block(data.raw['gui-style'].default['slot_button']))
local counter_entity_sprite_size = 20

data.raw['gui-style'].default['counter_sprite_style'] = {
  type = 'image_style',
  size = {counter_entity_sprite_size, counter_entity_sprite_size}
}

data.raw['gui-style'].default['counter_quality_sprite_style'] = {
  type = 'image_style',
  right_padding = counter_entity_sprite_size/2,
  top_padding = counter_entity_sprite_size/2,
  size = {counter_entity_sprite_size, counter_entity_sprite_size}
}

-- data.raw['gui-style'].default['counter_table_style'] = {
--   cell_padding = 0,
--   left_cell_padding = 4,
--   parent = "bordered_table",
--   right_cell_padding = 4,
--   type = "table_style"
-- }

-- data.raw['gui-style'].default['counter_button_style'] = {
--   parent = "slot_button",
--   type = "button_style",
--   size = 32
-- }


data:extend({
  {
    type = "shortcut",
    name = "counter-shortcut",
    icon = resource_path("graphics/icons/selection-tool-64.png"),
    small_icon = resource_path("graphics/icons/selection-tool-32.png"),
    icon_size = 64,
    small_icon_size = 32,
    action = "lua",
    on_lua_shortcut = "on_shortcut",
    toggleable = true
  },
  {
    type = "selection-tool",
    name = "counter-selection-tool",
    flags = { "only-in-cursor", "not-stackable" },
    hidden = true,
    hidden_in_factoriopedia = true,
    stack_size = 1,
    icons = {
      {
        icon = resource_path("graphics/icons/selection-tool-64.png"),
        scale = 0.2
      }
    },
    icon_size = 25,
    select = {
      border_color = {2, 126, 95},
      cursor_box_type = "entity",
      mode = {
        "any-entity",
        "any-tile",
        "blueprint"
      }
    },
    alt_select = {
      border_color = {31, 5, 177},
      cursor_box_type = "entity",
      mode = {
        "any-entity",
        "any-tile"
      }
    },
    always_include_tiles = true
  }
})
