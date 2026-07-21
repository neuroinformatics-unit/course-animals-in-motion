-- collect-solutions.lua  (runs at the default/post-quarto stage)
-- Numbers exercises + solutions per chapter and relocates solutions to a
-- "Solutions" section at the end of the document. Each solution is wrapped in a
-- collapsible callout titled to match its exercise ("Exercise N") and links back
-- to it (there is deliberately no forward link, to discourage jumping to answers).
-- Quarto executes code BEFORE Lua filters run, so a relocated solution keeps
-- its already-executed {python} output (plots, stdout) and chapter-kernel state.
--
-- Author contract (matched pairs, in document order, one-to-one):
--   ::: {.exercise-block}     <prompt> :::
--   ::: {.exercise-solution}  <answer> :::
-- The filter builds the collapsible callout around the answer; authors don't.

local collected = {}
local ex_n, sol_n = 0, 0

function Div(el)
  if el.classes:includes("exercise-block") then
    ex_n = ex_n + 1
    el.identifier = "exercise-" .. ex_n
    -- Wrap the prompt in a static (always-open) tip callout, so exercises and
    -- their solutions share one visual style. Omitting `collapse` keeps it open.
    el.content = pandoc.Blocks({
      quarto.Callout({
        type = "tip",
        title = pandoc.Inlines({ pandoc.Str("Exercise " .. ex_n) }),
        content = pandoc.Blocks(el.content),
      }),
    })
    return el
  elseif el.classes:includes("exercise-solution") then
    sol_n = sol_n + 1
    el.identifier = "solution-" .. sol_n
    -- Back-link at the top of the answer, so it shows only once expanded.
    table.insert(el.content, 1, pandoc.Para({
      pandoc.Link({ pandoc.Str("↩ back to exercise") }, "#exercise-" .. sol_n),
    }))
    -- Wrap the answer in a collapsible callout titled to match its exercise.
    el.content = pandoc.Blocks({
      quarto.Callout({
        type = "tip",
        title = pandoc.Inlines({ pandoc.Str("Exercise " .. sol_n) }),
        collapse = true,
        content = pandoc.Blocks(el.content),
      }),
    })
    table.insert(collected, el)
    return {}  -- remove from original position; relocated in Pandoc()
  end
end

function Pandoc(doc)
  assert(ex_n == sol_n, "collect-solutions: " .. ex_n .. " exercise-block(s) but " .. sol_n .. " exercise-solution(s) — each .exercise-block needs exactly one .exercise-solution")
  if #collected == 0 then return doc end
  doc.blocks:insert(pandoc.Header(2, { pandoc.Str("Solutions") }, pandoc.Attr("sec-solutions")))
  doc.blocks:insert(pandoc.Para({
    pandoc.Emph({ pandoc.Str("Click each solution to reveal it.") }),
  }))
  for _, el in ipairs(collected) do doc.blocks:insert(el) end
  return doc
end
