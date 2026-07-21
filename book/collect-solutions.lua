-- collect-solutions.lua  (runs at the default/post-quarto stage)
-- Numbers exercises + solutions per chapter and relocates solutions to a
-- "Solutions" section at the end of the document. Each solution links back to its
-- exercise (there is deliberately no forward link, to discourage jumping to answers).
-- Quarto executes code BEFORE Lua filters run, so a relocated solution keeps
-- its already-executed {python} output (plots, stdout) and chapter-kernel state.
--
-- Author contract (matched pairs, in document order, one-to-one):
--   ::: {.exercise-block}      <prompt> :::
--   ::: {.exercise-solution}   ::: {.callout-tip title="..." collapse="true"} <answer> ::: :::
-- The callout's authored title is replaced with a numbered "Solution N".

local collected = {}
local ex_n, sol_n = 0, 0

-- Set the title of the Quarto callout nested in `block` to `title_str` and prepend
-- a "back to exercise" link at the top of its body. At this (default) filter stage
-- the callout is an un-decoded Quarto custom node whose children are scaffold divs:
-- for a titled callout, child 1 is the title and child 2 the body. We rewrite the
-- title scaffold and insert into the body scaffold (a `Callout` filter key is not
-- dispatched inside walk_block, so we match the raw node by attribute). Putting the
-- backlink in the body means it only shows once the solution is expanded.
-- Returns the block and whether the callout was found.
local function decorate_callout(block, title_str, exercise_id)
  local found = false
  local out = pandoc.walk_block(block, {
    Div = function(d)
      if d.attributes["__quarto_custom_type"] == "Callout" and #d.content >= 2 then
        d.content[1].content = { pandoc.Plain({ pandoc.Str(title_str) }) }
        table.insert(d.content[2].content, 1, pandoc.Para({
          pandoc.Link({ pandoc.Str("↩ back to exercise") }, "#" .. exercise_id),
        }))
        found = true
        return d
      end
    end,
  })
  return out, found
end

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
    local ok
    el, ok = decorate_callout(el, "Exercise " .. sol_n, "exercise-" .. sol_n)
    assert(ok, "collect-solutions: solution " .. sol_n ..
      " must wrap a titled collapsible callout (::: {.callout-tip title=\"...\" collapse=\"true\"})")
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
