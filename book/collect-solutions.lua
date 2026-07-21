-- collect-solutions.lua  (runs at the default/post-quarto stage)
-- Numbers exercises + solutions per chapter and relocates solutions to a
-- "Solutions" section at the end of the document, with two-way links.
-- Quarto executes code BEFORE Lua filters run, so a relocated solution keeps
-- its already-executed {python} output (plots, stdout) and chapter-kernel state.
--
-- Author contract (matched pairs, in document order, one-to-one):
--   ::: {.exercise-block}      <prompt> :::
--   ::: {.exercise-solution}   ::: {.callout-tip collapse="true"} <answer> ::: :::

local collected = {}
local ex_n, sol_n = 0, 0

function Div(el)
  if el.classes:includes("exercise-block") then
    ex_n = ex_n + 1
    el.identifier = "exercise-" .. ex_n
    table.insert(el.content, 1,
      pandoc.Para({ pandoc.Strong({ pandoc.Str("Exercise " .. ex_n) }) }))
    return el
  elseif el.classes:includes("exercise-solution") then
    sol_n = sol_n + 1
    el.identifier = "solution-" .. sol_n
    table.insert(el.content, 1, pandoc.Para({
      pandoc.Strong({ pandoc.Str("Solution " .. sol_n) }),
      pandoc.Space(),
      pandoc.Link({ pandoc.Str("↩ back to exercise") }, "#exercise-" .. sol_n),
    }))
    table.insert(collected, el)
    return pandoc.Para({
      pandoc.Link({ pandoc.Str("→ See Solution " .. sol_n) }, "#solution-" .. sol_n)
    })
  end
end

function Pandoc(doc)
  if #collected == 0 then return doc end
  doc.blocks:insert(pandoc.Header(2, "Solutions", pandoc.Attr("sec-solutions")))
  for _, el in ipairs(collected) do doc.blocks:insert(el) end
  return doc
end
