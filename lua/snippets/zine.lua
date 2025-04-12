local ls = require 'luasnip'
local s = ls.snippet
local f = ls.function_node

local function now()
  return os.date '!%Y-%m-%dT%H:%M:%SZ'
end
local snippets = {
  s({ trig = '@date', dscr = 'Date in the form of YYYY-MM-DD' }, {
    f(function()
      return { '@date("' .. now() .. '")' }
    end, {}),
  }),
  s({ trig = '.date', dscr = 'Date in the form of YYYY-MM-DD' }, {
    f(function()
      return { '.date = @date("' .. now() .. '"),' }
    end, {}),
  }),
}

ls.add_snippets('superhtml', snippets)
ls.add_snippets('supermd', snippets)
ls.add_snippets('ziggy', snippets)
