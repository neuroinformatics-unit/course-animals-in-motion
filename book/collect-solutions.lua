-- collect-solutions.lua  (runs at the default/post-quarto stage)
-- Numbers exercises + solutions per chapter and relocates solutions to a
-- "Solutions" section at the end of the document. Each solution is wrapped in a
-- collapsible callout titled to match its exercise ("Exercise C.N", where C is the
-- chapter number) and links back to it (there is deliberately no forward link, to
-- discourage jumping to answers).
-- Quarto executes code BEFORE Lua filters run, so a relocated solution keeps
-- its already-executed {python} output (plots, stdout) and chapter-kernel state.
--
-- The filter enforces a one‑to‑one pairing between exercises and solutions, in this order:
--   ::: {.exercise-prompt}     <prompt> :::
--   ::: {.exercise-solution}  <answer> :::

local collected = {}
local ex_n, sol_n = 0, 0
-- Tracks whether the last prompt is still waiting for its solution, so we can
-- enforce strict prompt-solution alternation.
local awaiting_solution = false

-- Chapter-number prefix ("4.") derived from the source filename (e.g.
-- 04-movement-intro.qmd -> chapter 4). Files with no numeric
-- prefix fall back to bare numbering.
local chap_prefix
local function chapter_prefix()
  if chap_prefix == nil then
    local path = quarto.doc and quarto.doc.input_file or ""
    local base = path:match("([^/\\]+)$") or path
    local n = base:match("^(%d+)")
    chap_prefix = n and (tonumber(n) .. ".") or ""
  end
  return chap_prefix
end

local function exercise_title(n)
  return pandoc.Inlines({ pandoc.Str("Exercise " .. chapter_prefix() .. n) })
end

function Div(el)
  if el.classes:includes("exercise-prompt") then
    assert(not awaiting_solution, ".exercise-prompt #" .. (ex_n + 1) .. " appears before the previous exercise's .exercise-solution — each prompt must be immediately followed by its solution.")
    awaiting_solution = true
    ex_n = ex_n + 1
    el.identifier = "exercise-" .. ex_n
    -- Wrap the exercise prompt in a static (always-open) callout
    el.content = pandoc.Blocks({
      quarto.Callout({
        type = "tip",
        title = exercise_title(ex_n),
        content = pandoc.Blocks(el.content),
      }),
    })
    return el
  elseif el.classes:includes("exercise-solution") then
    assert(awaiting_solution, ".exercise-solution #" .. (sol_n + 1) .. " has no preceding .exercise-prompt — each solution must directly follow its prompt.")
    awaiting_solution = false
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
        title = exercise_title(sol_n),
        collapse = true,
        content = pandoc.Blocks(el.content),
      }),
    })
    table.insert(collected, el)
    return {}
  end
end

function Pandoc(doc)
  assert(not awaiting_solution, ".exercise-prompt #" .. ex_n .. " has no following .exercise-solution — each prompt must be immediately followed by its solution.")
  if #collected == 0 then return doc end
  doc.blocks:insert(pandoc.Header(2, { pandoc.Str("Solutions") }, pandoc.Attr("sec-solutions")))
  doc.blocks:insert(pandoc.Para({
    pandoc.Emph({ pandoc.Str("Click each solution to reveal it.") }),
  }))
  for _, el in ipairs(collected) do doc.blocks:insert(el) end
  return doc
end
