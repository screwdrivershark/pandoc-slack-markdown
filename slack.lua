-- TODO
-- need to escape str? https://github.com/jgm/djot.lua/blob/de9072094039fe4181a23d116eb0fd3d86c223fd/djot-writer.lua#L319
-- option for how to render horizontal rule

-- list:
-- * abc

--   def
-- * abc

-- use markdown writer's function when possible?
-- difference between linebreak and softbreak?


local layout = pandoc.layout
local literal, empty, cr, concat, blankline, chomp, space, cblock, rblock,
prefixed, nest, hang, nowrap =
    layout.literal, layout.empty, layout.cr, layout.concat, layout.blankline,
    layout.chomp, layout.space, layout.cblock, layout.rblock,
    layout.prefixed, layout.nest, layout.hang, layout.nowrap

local bold <const> = "*"
local italic <const> = "_"
local strike <const> = "~"

Writer = pandoc.scaffolding.Writer

Writer.Inline.Str = function(el)
  return el.text
end

Writer.Inline.Space = function(_)
  return space
end

Writer.Inline.LineBreak = cr

Writer.Inline.SoftBreak = function(_, opts)
  return opts.wrap_text == "wrap-preserve"
      and cr
      or space
end

Writer.Inline.RawInline = function(el)
  -- raw inlines are not supported by Slack
  return Writer.Inline.Code(el)
end

Writer.Inline.Strong = function(el)
  return { bold .. Writer.Inlines(el.content) .. bold }
end

Writer.Inline.Emph = function(el)
  return { italic .. Writer.Inlines(el.content) .. italic }
end

Writer.Inline.Code = function(el)
  return { "`" .. el.text .. "`" }
end

Writer.Block.Plain = function(el)
  return el.content -- ?
end

Writer.Block.Para = function(el)
  return { Writer.Inlines(el.content) }
end

Writer.Block.Header = function(el)
  return { bold .. Writer.Inlines(el.content) .. bold }
end

Writer.Block.BlockQuote = function(el)
  return prefixed(nest(Writer.Blocks(el.content), 1), ">")
end

-- Writer.Block.BulletList = function(el)
--   return Writer.Blocks(el.content[1])
-- end

Writer.Block.CodeBlock = function(el)
  return "```\n" .. el.text .. "\n```"
end
