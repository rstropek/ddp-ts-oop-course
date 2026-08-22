--[[
  research.lua — Quarto *filter* for the book's "Research task" boxes.

  Usage in a chapter:

      ::: {.research title="What does querySelectorAll give back?"}
      The next exercise changes every `li` on the page. Find out:

      1. What does `document.querySelectorAll("li")` return? Not an array, so what?
      2. Name two ways to loop over it.
      3. Does it notice when a new `li` is added later? What word does MDN use?
      :::

  Why this exists: the book names concepts, APIs, and standards, but it is not
  a reference for them. Students are expected to look things up on MDN, with a
  search engine, or with their AI tools, the way they will in every job. A
  research box marks the spot where the book deliberately stops explaining:
  the exercise that follows needs what the box asks for, and the prose after
  the box never supplies it.

  The box lists the research questions; the chapter's end-of-chapter quiz
  (linked with the `quiz` shortcode) asks the same questions again, so the
  student finds out now and gets checked later. That loop is the fixed footer
  below, written once. The author writes only the title and the questions.

  Rendering: a quarto.Callout, so it works in the HTML site and the PDF alike.
--]]

local script_dir = PANDOC_SCRIPT_FILE:gsub("[^/\\]+$", "")
local css_added = false

local FOOTER = "Find the answers now: on MDN, with a search engine, or by asking "
  .. "your AI tutor or coding buddy, and check one source against another. "
  .. "Write them down in your own words. The next step needs them, the book "
  .. "will not explain them, and the quiz at the end of this chapter asks "
  .. "exactly these questions."

local function research(div)
  if not div.classes:includes("research") then
    return nil
  end

  if quarto.doc.is_format("html") and not css_added then
    quarto.doc.add_html_dependency({
      name = "quarto-research",
      version = "1.0.0",
      stylesheets = { script_dir .. "research.css" },
    })
    css_added = true
  end

  local title = div.attributes["title"] or ""
  if title == "" then title = "Research task" else title = "Research task: " .. title end

  local content = pandoc.List(div.content)
  content:insert(pandoc.Para({ pandoc.Emph(pandoc.Str(FOOTER)) }))

  local callout = quarto.Callout({
    type = "important",
    title = title,
    content = content,
    collapse = false,
  })
  return pandoc.Div(callout, pandoc.Attr("", { "research-box" }))
end

return { { Div = research } }
