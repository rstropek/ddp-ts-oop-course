--[[
  research.lua — Quarto *filter* for the book's "Research task" boxes.

  Usage in a chapter:

      ::: {.research quiz="research-nodelist" title="What does querySelectorAll give back?"}
      Optional prose that frames the task: what the next exercise needs, and
      what must stick for the exam.
      :::

  Why this exists: the book names concepts, APIs, and standards, but it is not
  a reference for them. Students are expected to look things up on MDN, with a
  search engine, or with their AI tools, the way they will in every job. A
  research box marks the spot where the book deliberately stops explaining:
  the exercise that follows needs what the box asks for, and the prose after
  the box never supplies it.

  The quiz DRIVES the research. The box links to a novedu quiz (an open-ended,
  LLM-graded quiz whose questions are the research questions). The student
  opens it, reads a question, answers it if they can, and goes researching if
  they cannot, until every question is answered. The standing instructions for
  that loop are the fixed text below, written once; the author writes only the
  framing prose and names the quiz.

  `quiz` is the quiz's key in the activity registry (ddp-activities.yaml), never
  an activity code; it resolves through the `activity-codes` map exactly like
  the `quiz` and `tutor` shortcodes, and an unknown key aborts the render. A
  box without `quiz` renders with the deliverable-based fallback text, for the
  rare research task that ends in something other than a quiz.

  Rendering: a quarto.Callout, so it works in the HTML site and the PDF alike.
  In print the button is dead ink, so the PDF also gets a QR code and the
  printed address; that block is shared with example.lua, quiz.lua, and
  tutor.lua. Change one, change the others.
--]]

local script_dir = PANDOC_SCRIPT_FILE:gsub("[^/\\]+$", "")

local css_added = false
local function ensure_css()
  if not css_added and quarto.doc.is_format("html") then
    quarto.doc.add_html_dependency({
      name = "quarto-research",
      version = "1.0.0",
      stylesheets = { script_dir .. "research.css" },
    })
    css_added = true
  end
end

-- ── print-friendly links (PDF only) ─────────────────────────────────────────
-- Shared block, see the note in the header comment.

local PRINT_LINK_HEADER = [[
\ifdefined\ddplinkrow\else
  \usepackage{iftex}
  \usepackage{qrcode}   % draws QR codes in pure TeX — no external tool needed
  \usepackage{needspace} % keeps a compact link card away from a page boundary
  \newsavebox{\ddpqrbox}
  \newlength{\ddpqrsize}\setlength{\ddpqrsize}{3cm}
  % A monospace face for printed addresses. Inconsolata's zero is slashed, so a
  % reader cannot mistake 0 for O, and 1, l, and I stay apart too. Only this one
  % macro switches to it; code listings keep the book's usual typewriter font.
  \ifPDFTeX
    \newcommand{\ddpurlfont}{\fontencoding{T1}\fontfamily{zi4}\selectfont}
  \else
    \usepackage{fontspec}
    \newfontfamily{\ddpurlfont}{inconsolata}
  \fi
  % A long address has to wrap. The Lua side decides where: \allowbreak at the
  % places a reader can follow, \ddpurlbrk everywhere else, whose penalty makes
  % TeX break there only when nothing else fits. No hyphen is ever inserted, so
  % what stands on the page is exactly what you type.
  \newcommand{\ddpurlbrk}{\penalty700\relax}
  % One row inside the callout: QR code on the left, caption and address right.
  \newcommand{\ddplinkrow}[1]{%
    % \nopagebreak keeps the row with the call-to-action above it: a callout
    % that breaks between the two would leave an orphaned QR code on the next
    % page.
    \par\nopagebreak\smallskip\noindent
    \begin{minipage}[c]{\ddpqrsize}\usebox{\ddpqrbox}\end{minipage}%
    \hfill
    \begin{minipage}[c]{\dimexpr\linewidth-\ddpqrsize-1em\relax}%
      \raggedright\footnotesize
      Scan the code, or type this address into your browser:\par
      \smallskip
      {\ddpurlfont\small #1\par}%
    \end{minipage}%
    \par\smallskip}
\fi
]]

-- Characters that LaTeX would otherwise read as markup.
local LATEX_ESCAPE = {
  ["\\"] = "\\textbackslash{}", ["{"] = "\\{",  ["}"] = "\\}",
  ["$"]  = "\\$",               ["&"] = "\\&",  ["#"] = "\\#",
  ["%"]  = "\\%",               ["_"] = "\\_",
  ["~"]  = "\\textasciitilde{}", ["^"] = "\\textasciicircum{}",
}

-- Where a long address may wrap. A wrap must never change what the reader
-- types, which rules out the obvious choices:
--   * break AFTER "/", "?", "&" or "=" — a line ending in one of those is
--     plainly part of the address;
--   * break BEFORE "-", "." and friends — a line ending in a hyphen looks like
--     a hyphenation the printer added, and the reader drops it;
--   * never break inside "://", because a line ending in "https:/" reads as a
--     single slash.
-- Anywhere else a break is allowed but expensive (see \ddpurlbrk), so TeX takes
-- one only when nothing else fits. Such a break adds no character at all and so
-- cannot be misread.
local BREAK_AFTER = { ["/"] = true, ["?"] = true, ["&"] = true, ["="] = true }
local BREAK_BEFORE = {
  ["-"] = true, ["."] = true, ["_"] = true, ["~"] = true, [":"] = true,
  [","] = true, ["+"] = true, ["#"] = true, ["%"] = true,
}

-- Turn a URL into LaTeX that is safe to typeset and wraps at readable places.
local function typeset_url(url)
  local out, last = {}, #url
  for i = 1, last do
    local c, next_c = url:sub(i, i), url:sub(i + 1, i + 1)
    out[#out + 1] = LATEX_ESCAPE[c] or c
    if i == last or (c == "/" and next_c == "/") then
      -- nothing: the end of the address, or the middle of "://"
    elseif BREAK_AFTER[c] or BREAK_BEFORE[next_c] then
      out[#out + 1] = "\\allowbreak "
    else
      out[#out + 1] = "\\ddpurlbrk "
    end
  end
  return table.concat(out)
end

-- Add the LaTeX definitions above to the preamble, at most once per document.
local header_added = false
local function ensure_print_link_header()
  if not header_added then
    quarto.doc.include_text("in-header", PRINT_LINK_HEADER)
    header_added = true
  end
end

-- The QR code plus the printed address, as a block for the callout's body.
-- Returns nil for every format other than PDF: on the web the button already
-- takes the reader there, and a printed address would only add clutter.
--
-- `level` is the QR error-correction level: "L" holds the most data (use it for
-- long addresses), "M" survives more smudges (fine for short ones).
--
-- \qrcode reads its argument verbatim, so the raw URL is written straight into
-- the LaTeX — it must not be escaped. Building it inside an \lrbox keeps that
-- verbatim reading intact and lets \ddplinkrow place the finished box.
local function print_link_block(url, level)
  if not quarto.doc.is_format("pdf") then return nil end
  ensure_print_link_header()
  return pandoc.RawBlock("latex", table.concat({
    "\\begin{lrbox}{\\ddpqrbox}\\qrcode*[height=\\ddpqrsize,level=", level, "]{",
    url, "}\\end{lrbox}\n",
    "\\ddplinkrow{", typeset_url(url), "}",
  }))
end

-- Quarto renders callouts as breakable tcolorboxes in PDF output. A compact
-- QR card that lands exactly at the bottom of a page can leave XeLaTeX's color
-- state unbalanced after the page break, which makes later body text invisible.
-- Reserve a little more room than the tallest link card needs so the complete
-- card moves to the next page instead of touching or crossing the boundary.
local function keep_print_card_together(callout)
  if quarto.doc.is_format("pdf") then
    return pandoc.Blocks({
      pandoc.RawBlock("latex", "\\Needspace{5.5cm}"),
      callout,
    })
  end
  return callout
end

-- The label of a callout's call-to-action link. The ▶ character has no glyph in
-- the PDF's text font and would silently vanish there, so the PDF gets LaTeX's
-- own triangle instead.
local function cta_label(text)
  if quarto.doc.is_format("pdf") then
    return { pandoc.RawInline("latex", "$\\blacktriangleright$~"), pandoc.Str(text) }
  end
  return { pandoc.Str("▶ " .. text) }
end

-- Read the configurable novedu base URL from document metadata
-- (`novedu-base-url` in _quarto.yml). Returns nil when unset/empty so callers
-- can degrade gracefully. Trailing slashes are trimmed so we can safely
-- append "/<code>".
local function novedu_base(meta)
  local v = meta and meta["novedu-base-url"]
  if not v then return nil end
  local s = pandoc.utils.stringify(v)
  if s == "" then return nil end
  return (s:gsub("/+$", ""))
end

-- Resolve a registry key to the activity code novedu minted for it, using the
-- `activity-codes` map that ddp-activities.lock.yaml contributes to the document
-- metadata (metadata-files in _quarto.yml).
--
-- An unresolvable key ABORTS the render instead of rendering a marker: the whole
-- point of keys is that a chapter can never link to a code that is not there, and
-- a bold marker in a 200-page PDF is easy to miss. `error(msg, 0)` drops the Lua
-- position prefix so the reader sees just the instruction.
local function activity_code(meta, key)
  local map = meta and meta["activity-codes"]
  if not map then
    error(
      "research box: no `activity-codes` metadata. Check that _quarto.yml lists "
        .. "ddp-activities.lock.yaml under metadata-files, and that the file exists "
        .. "(regenerate it with: novedu-cli codes sync ddp-activities.yaml).",
      0
    )
  end
  local entry = map[key]
  if not entry then
    error(
      "research box: unknown activity key '" .. key .. "'. Add it to "
        .. "ddp-activities.yaml, run `novedu-cli codes sync ddp-activities.yaml`, "
        .. "and commit the regenerated ddp-activities.lock.yaml.",
      0
    )
  end
  return pandoc.utils.stringify(entry)
end

-- ── the box ─────────────────────────────────────────────────────────────────

local DRIVE_TEXT = "Open the quiz and let it drive your research. Read the first "
  .. "question. If you can answer it, answer it. If you can't, go and find out: "
  .. "MDN, a search engine, your AI tutor or coding buddy, and check one source "
  .. "against another. Then come back and answer. Repeat until every question "
  .. "is answered. The next step of the book needs what you find, and the book "
  .. "will not explain it."

local FALLBACK_TEXT = "Look it up on MDN, with a search engine, or ask your AI "
  .. "tutor or coding buddy, and check one source against another. Write the "
  .. "answer down in your own words before you go on. The next step needs it, "
  .. "and the book will not explain it."

local doc_meta = nil

local function research(div)
  if not div.classes:includes("research") then
    return nil
  end
  ensure_css()

  local title = div.attributes["title"] or ""
  if title == "" then title = "Research task" else title = "Research task: " .. title end

  local content = pandoc.List(div.content)
  local key = div.attributes["quiz"]

  if key then
    local base = novedu_base(doc_meta)
    if not base then
      error("research box: novedu-base-url not set in _quarto.yml", 0)
    end
    local url = base .. "/" .. activity_code(doc_meta, key)
    content:insert(pandoc.Para(pandoc.Str(DRIVE_TEXT)))
    content:insert(pandoc.Div(
      pandoc.Para(pandoc.Link(cta_label("Open the research quiz"), url)),
      pandoc.Attr("", { "research-cta" })
    ))
    local print_block = print_link_block(url, "M")
    if print_block then content:insert(print_block) end
  else
    content:insert(pandoc.Para({ pandoc.Emph(pandoc.Str(FALLBACK_TEXT)) }))
  end

  local callout = quarto.Callout({
    type = "important",
    title = title,
    content = content,
    collapse = false,
  })
  local wrapped = pandoc.Div(callout, pandoc.Attr("", { "research-box" }))
  if key then
    return keep_print_card_together(wrapped)
  end
  return wrapped
end

return {
  { Meta = function(m) doc_meta = m end },
  { Div = research },
}
