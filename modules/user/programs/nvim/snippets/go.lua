local ls = require('luasnip')
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local s, c, d, i, sn = ls.snippet, ls.choice_node, ls.dynamic_node, ls.insert_node, ls.snippet_node

local function make_tag_choices(args)
  local camelName = args[1][1]:sub(1, 1):lower() .. args[1][1]:sub(2)

  return sn(nil, {
    c(1, {
      fmta('`json:"<jsonName>" yaml:"<yamlName>"`', {
        jsonName = i(1, camelName),
        yamlName = rep(1)
      }),
      fmta('`json:"<jsonName>" yaml:"<yamlName>" validate:"<validate>"`', {
        jsonName = i(1, camelName),
        yamlName = rep(1),
        validate = i(2, "required"),
      }),
      i(1)
    })
  })
end

return {
  s("fie", fmta("<name> <type> <tags>", {
    name = i(1, "FieldName"),
    type = i(2, "interface{}"),
    tags = d(3, make_tag_choices, { 1 })
  })),
}
