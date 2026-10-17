local mod_name = "counter"

function resource_path(path, base)
  local base = base or mod_name
  return "__" .. base .. "__/" .. path
end
