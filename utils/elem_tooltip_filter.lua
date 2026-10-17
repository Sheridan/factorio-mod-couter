local unknown_prototypes = {
  ["curved-rail-a"]               = "rail",
  ["curved-rail-b"]               = "rail",
  ["elevated-curved-rail-a"]      = "rail",
  ["elevated-curved-rail-b"]      = "rail",
  ["elevated-half-diagonal-rail"] = "rail",
  ["elevated-straight-rail"]      = "rail",
  ["half-diagonal-rail"]          = "rail",
  ["straight-rail"]               = "rail",
}

function filter_unknown_prototype_name(prototype_name)
  return (unknown_prototypes[prototype_name] or prototype_name)
end
