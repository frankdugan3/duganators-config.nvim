local ls = require 'luasnip'
local s = ls.snippet
local f = ls.function_node
local t = ls.text_node
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

-- Tailwind utility snippets for CSS

-- Tailwind 4 mostly references custom properties.
-- See: https://tailwindcss.com/docs/theme#default-theme-variable-reference

local function merge_properties(properties, value)
  local merged = {}
  for idx, property in ipairs(properties) do
    merged[idx] = property .. ': ' .. value .. ';'
  end
  return merged
end

local snippets = {
  s({ trig = 'spacing', desc = 'Tailwind spacing' }, fmt('calc(var(--spacing) * {}){}', { i(1), i(0) })),
  s({ trig = 'fraction', desc = 'Tailwind fraction' }, fmt('calc({} * {}100%){}', { i(1), i(2), i(0) })),
}

local container_sizes = { '3xs', '2xs', 'xs', 'sm', 'md', 'lg', 'xl', '2xl', '3xl', '4xl', '5xl', '6xl', '7xl' }
for _, size in ipairs(container_sizes) do
  table.insert(snippets, s({ trig = 'container-' .. size, desc = 'Tailwind container size' }, t { 'var(--container-' .. size .. ')' }))
end

table.insert(
  snippets,
  s(
    { trig = 'sr-only', desc = 'Tailwind sr-only' },
    t {
      'position: absolute;',
      'width: 1px;',
      'height: 1px;',
      'padding: 0;',
      'margin: -1px;',
      'overflow: hidden;',
      'clip: rect(0, 0, 0, 0);',
      'white-space: nowrap;',
      'border-width: 0;',
    }
  )
)

table.insert(
  snippets,
  s(
    { trig = 'not-sr-only', desc = 'Tailwind not-sr-only' },
    t {
      'position: static;',
      'width: auto;',
      'height: auto;',
      'padding: 0;',
      'margin: 0;',
      'overflow: visible;',
      'clip: auto;',
      'white-space: normal;',
    }
  )
)

-- All of the utility categories will be separated by a comment matching the Tailwind documentation section
-- If no implementation is given, it's because a CSS LSP has adequate coverage

-- LAYOUT

-- aspect-ratio
for prefix, ratio in pairs { square = '1 / 1', video = 'var(--aspect-ratio-video)', auto = 'auto' } do
  table.insert(snippets, s({ trig = 'aspect-' .. prefix, desc = 'Tailwind aspect-ratio' }, t { 'aspect-ratio: ' .. ratio .. ';' }))
end

-- columns
-- break-after
-- break-before
-- break-inside
-- box-decoration-break
-- box-sizing
-- display
-- float
-- clear
-- isolation
-- object-fit
-- object-position
-- overflow
-- overscroll-behavior
-- position
-- top / right / bottom / left
-- visibility
-- z-index

-- FLEXBOX & GRID

-- flex-basis
local flex_basis_desc = 'Tailwind flex-basis'
table.insert(snippets, s({ trig = 'basis', desc = flex_basis_desc }, fmt('flex-basis: {};{}', { i(1), i(0) })))
table.insert(snippets, s({ trig = 'basis-full', desc = flex_basis_desc }, t { 'flex-basis: 100%;' }))
table.insert(snippets, s({ trig = 'basis-auto', desc = flex_basis_desc }, t { 'flex-basis: auto;' }))
for _, size in ipairs(container_sizes) do
  table.insert(snippets, s({ trig = 'basis-' .. size, desc = flex_basis_desc }, t { 'flex-basis: var(--container-' .. size .. ');' }))
end

-- flex-direction
local flex_direction_desc = 'Tailwind flex-direction'
local flex_directions = { row = 'row', col = 'column' }
flex_directions['row-reverse'] = 'row-reverse'
flex_directions['col-reverse'] = 'column-reverse'
for trig, value in pairs(flex_directions) do
  table.insert(snippets, s({ trig = 'flex-' .. trig, desc = flex_direction_desc }, t { 'flex-direction: ' .. value .. ';' }))
end

-- flex-wrap
local flex_wrap_desc = 'Tailwind flex-wrap'
for _, value in ipairs { 'nowrap', 'wrap', 'wrap-reverse' } do
  table.insert(snippets, s({ trig = 'flex-' .. value, desc = flex_wrap_desc }, t { 'flex-wrap: ' .. value .. ';' }))
end

-- flex
local flex_desc = 'Tailwind flex'
local flexes = { auto = '1 1 auto', initial = '0 1 auto', none = 'none' }
for trig, value in pairs(flexes) do
  table.insert(snippets, s({ trig = 'flex-' .. trig, desc = flex_desc }, t { 'flex: ' .. value .. ';' }))
end

-- flex-grow
local flex_grow_desc = 'Tailwind flex-grow'
table.insert(snippets, s({ trig = 'grow', desc = flex_grow_desc }, t { 'flex-grow: 1;' }))
table.insert(snippets, s({ trig = 'grow-', desc = flex_grow_desc }, fmt('flex-grow: {};{}', { i(1), i(0) })))

-- flex-shrink
local flex_shrink_desc = 'Tailwind flex-shrink'
table.insert(snippets, s({ trig = 'shrink', desc = flex_shrink_desc }, t { 'flex-shrink: 1;' }))
table.insert(snippets, s({ trig = 'shrink-', desc = flex_shrink_desc }, fmt('flex-shrink: {};{}', { i(1), i(0) })))

-- order
local order_desc = 'Tailwind order'
table.insert(snippets, s({ trig = 'order-', desc = order_desc }, fmt('order: {};{}', { i(1), i(0) })))
table.insert(snippets, s({ trig = '-order-', desc = order_desc }, fmt('order: calc({} * -1);{}', { i(1), i(0) })))
table.insert(snippets, s({ trig = 'order-first', desc = order_desc }, t { 'order: calc(-infinity);' }))
table.insert(snippets, s({ trig = 'order-last', desc = order_desc }, t { 'order: calc(infinity);' }))
table.insert(snippets, s({ trig = 'order-none', desc = order_desc }, t { 'order: 0;' }))

-- grid-template-columns
local grid_columns_desc = 'Tailwind grid-template-columns'
table.insert(snippets, s({ trig = 'grid-cols-', desc = grid_columns_desc }, fmt('grid-template-columns: {};{}', { i(1), i(0) })))
table.insert(
  snippets,
  s(
    { trig = 'grid_cols_(%d+)', regTrig = true, desc = grid_columns_desc },
    f(function(_, snip)
      return 'grid-template-columns: repeat(' .. snip.captures[1] .. ', minmax(0, 1fr));'
    end, {})
  )
)
table.insert(snippets, s({ trig = 'grid-cols-none', desc = grid_columns_desc }, t { 'grid-template-columns: none;' }))
table.insert(snippets, s({ trig = 'grid-cols-subgrid', desc = grid_columns_desc }, t { 'grid-template-columns: subgrid;' }))

-- font-family
for _, font in ipairs { 'sans', 'serif', 'mono' } do
  table.insert(snippets, s({ trig = 'font-' .. font, desc = 'Tailwind font' }, t { 'font-family: var(--font-' .. font .. ');' }))
end

local color_grades = { '50', '100', '200', '300', '400', '500', '600', '700', '800', '900', '950' }
local colors = {
  'red',
  'orange',
  'amber',
  'yellow',
  'lime',
  'green',
  'emerald',
  'teal',
  'cyan',
  'sky',
  'blue',
  'indigo',
  'violet',
  'purple',
  'fuchsia',
  'pink',
  'rose',
  'slate',
  'gray',
  'zinc',
  'neutral',
  'stone',
  'black',
  'white',
}
for _, color in ipairs(colors) do
  if color == 'black' or color == 'white' then
    table.insert(snippets, s({ trig = 'color-' .. color, desc = 'Tailwind color' }, t { 'var(--color-' .. color .. ')' }))
  else
    for _, grade in ipairs(color_grades) do
      table.insert(snippets, s({ trig = 'color-' .. color .. '-' .. grade, desc = 'Tailwind color' }, t { 'var(--color-' .. color .. '-' .. grade .. ')' }))
    end
  end
end

local breakpoints = { 'sm', 'md', 'lg', 'xl', '2xl' }
for idx, size in ipairs(breakpoints) do
  table.insert(
    snippets,
    s({ trig = 'breakpoint-' .. size, desc = 'Tailwind breakpoint' }, {
      t { '@media (width >= var(--breakpoint-' .. size .. ')) {', '  ' },
      i(0),
      t { '', '}' },
    })
  )
  table.insert(
    snippets,
    s({ trig = 'breakpoint-max-' .. size, desc = 'Tailwind breakpoint' }, {
      t { '@media (width < var(--breakpoint-' .. size .. ')) {', '  ' },
      i(0),
      t { '', '}' },
    })
  )
  if size ~= '2xl' then
    table.insert(
      snippets,
      s({ trig = 'breakpoint-only-' .. size, desc = 'Tailwind breakpoint' }, {
        t { '@media (width >= var(--breakpoint-' .. size .. ')) and (width < var(--breakpoint-' .. breakpoints[idx + 1] .. ')) {', '  ' },
        i(0),
        t { '', '}' },
      })
    )
    for _, max in ipairs { unpack(breakpoints, idx + 1) } do
      table.insert(
        snippets,
        s({ trig = 'breakpoint-' .. size .. '-to-' .. max, desc = 'Tailwind breakpoint' }, {
          t { '@media (width >= var(--breakpoint-' .. size .. ')) and (width < var(--breakpoint-' .. max .. ')) {', '  ' },
          i(0),
          t { '', '}' },
        })
      )
    end
  end
end

local rounded_options = {}
rounded_options['rounded'] = { 'border-radius' }
rounded_options['rounded-s'] = { 'border-start-start-radius', 'border-end-start-radius' }
rounded_options['rounded-e'] = { 'border-start-end-radius', 'border-end-end-radius' }
rounded_options['rounded-t'] = { 'border-top-left-radius', 'border-top-right-radius' }
rounded_options['rounded-r'] = { 'border-top-right-radius', 'border-bottom-right-radius' }
rounded_options['rounded-b'] = { 'border-bottom-right-radius', 'border-bottom-left-radius' }
rounded_options['rounded-l'] = { 'border-top-left-radius', 'border-bottom-left-radius' }
rounded_options['rounded-ss'] = { 'border-start-start-radius' }
rounded_options['rounded-se'] = { 'border-start-end-radius' }
rounded_options['rounded-ee'] = { 'border-end-end-radius' }
rounded_options['rounded-es'] = { 'border-end-start-radius' }
rounded_options['rounded-tl'] = { 'border-top-left-radius' }
rounded_options['rounded-tr'] = { 'border-top-right-radius' }
rounded_options['rounded-br'] = { 'border-bottom-right-radius' }
rounded_options['rounded-bl'] = { 'border-bottom-left-radius' }
for prefix, properties in pairs(rounded_options) do
  for _, size in ipairs { 'none', 'xs', 'sm', 'md', 'lg', 'xl', '2xl', '3xl', '4xl', 'full' } do
    table.insert(
      snippets,
      s({ trig = prefix .. '-' .. size, desc = 'Tailwind border radius' }, {
        f(function(_args, _snip)
          local value
          if size == 'none' then
            value = '0'
          elseif size == 'full' then
            value = 'calc(infinity * 1px)'
          else
            value = 'var(--radius-' .. size .. ')'
          end
          return merge_properties(properties, value)
        end, {}),
      })
    )
  end
end

for _, breakpoint in ipairs { 'sm', 'md', 'lg', 'xl', '2xl' } do
  -- TODO: Make a media query
  table.insert(snippets, s('twbp' .. breakpoint, { t('var(--breakpoint-' .. breakpoint .. ')') }))
end

for _, container in ipairs { '3xs', '2xs', 'xs', 'sm', 'md', 'lg', 'xl', '2xl', '3xl', '4xl', '5xl', '6xl', '7xl' } do
  -- TODO: Make a container query
  table.insert(snippets, s('twct' .. container, { t('var(--container-' .. container .. ')') }))
end

for _, size in ipairs { 'xs', 'sm', 'base', 'lg', 'xl', '2xl', '3xl', '4xl', '5xl', '6xl', '7xl', '8xl', '9xl' } do
  table.insert(
    snippets,
    s(
      { trig = 'text-' .. size, desc = 'Tailwind text size' },
      t { 'font-size: var(--text-' .. size .. ');', 'line-height: var(--text-' .. size .. '--line-height);' }
    )
  )
end

for _, weight in ipairs { 'thin', 'extralight', 'light', 'normal', 'medium', 'semibold', 'bold', 'extrabold', 'black' } do
  table.insert(snippets, s({ trig = 'font-' .. weight, desc = 'Tailwind font weight' }, t { 'font-weight: var(--font-weight-' .. weight .. ');' }))
end

for _, tracking in ipairs { 'tighter', 'tight', 'normal', 'wide', 'wider', 'widest' } do
  table.insert(snippets, s({ trig = 'tracking-' .. tracking, desc = 'Tailwind letter spacing' }, t { 'letter-spacing: var(--tracking-' .. tracking .. ');' }))
end

table.insert(snippets, s({ trig = 'leading-none', desc = 'Tailwind leading' }, t { 'line-height: 1;' }))
table.insert(snippets, s({ trig = 'leading', desc = 'Tailwind leading' }, fmt('line-height: calc(var(--spacing) * {});{}', { i(1), i(0) })))
for _, leading in ipairs { 'tight', 'snug', 'normal', 'relaxed', 'loose' } do
  table.insert(snippets, s({ trig = 'leading-' .. leading, desc = 'Tailwind leading' }, t { 'line-height: var(--leading-' .. leading .. ');' }))
end

ls.add_snippets('css', snippets)
