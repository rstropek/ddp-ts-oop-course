--[[
  exercise.lua — Quarto *shortcode* for the files an exercise starts from.

  Usage in a chapter, inside the exercise section:

      {{< exercise todo-list >}}
      {{< exercise todo-list title="Files for the to-do list" tests=true >}}

  Every exercise in this book starts from a fresh app created from the course
  starter (vite-ts-starter; vite-ts-starter-tests when `tests=true`). An
  exercise that needs more than the bare starter keeps those files in
  exercises/<folder>/ in this repository: an index.html, a src/styles.css, a
  base class, a half-written test file. This shortcode reads that folder at
  render time and emits ONE standard callout: create the app, then copy each
  listed file to the same relative path inside it. The instruction is
  generated, never hand-written, so it is identical and complete in every
  chapter — the book is worked through by an LLM agent as a test, and an
  exercise that needs an unstated file is a bug.

  Links: every file links to its raw GitHub URL, the folder to its GitHub
  tree URL, both built from `exercises-base-url` in _quarto.yml. A missing
  folder aborts the render. In the PDF the callout also carries a QR code and
  the printed folder address (the shared print-link block below, duplicated
  in quiz.lua, tutor.lua, writing.lua and coding.lua — change one, change the
  others).
--]]

local script_dir = PANDOC_SCRIPT_FILE:gsub("[^/\\]+$", "")

local css_added = false
local function ensure_css()
  if not css_added and quarto.doc.is_format("html") then
    quarto.doc.add_html_dependency({
      name = "quarto-exercise",
      version = "1.0.0",
      stylesheets = { script_dir .. "exercise.css" },
    })
    css_added = true
  end
end

-- ── print-friendly links (PDF only) — shared block ──────────────────────────

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

-- ── the folder ──────────────────────────────────────────────────────────────

local function project_dir()
  if quarto.project and quarto.project.directory then
    return quarto.project.directory
  end
  return os.getenv("QUARTO_PROJECT_DIR") or "."
end

-- Every file below `dir`, as paths relative to `dir`, sorted.
local function list_files(dir, prefix, out)
  prefix = prefix or ""
  out = out or {}
  local ok, entries = pcall(pandoc.system.list_directory, dir)
  if not ok then return nil end
  for _, name in ipairs(entries) do
    local full = dir .. "/" .. name
    local rel = prefix .. name
    local sub = pcall(pandoc.system.list_directory, full)
    if sub then
      list_files(full, rel .. "/", out)
    elseif name ~= "README.md" and name ~= ".gitkeep" then
      out[#out + 1] = rel
    end
  end
  table.sort(out)
  return out
end

local function meta_string(meta, key)
  local v = meta and meta[key]
  if not v then return nil end
  local s = pandoc.utils.stringify(v)
  if s == "" then return nil end
  return (s:gsub("/+$", ""))
end

local function exercise(args, kwargs, meta)
  if not args[1] then
    error("exercise shortcode: no folder name given", 0)
  end
  local folder = pandoc.utils.stringify(args[1])
  local root = project_dir() .. "/exercises/" .. folder
  local files = list_files(root)
  if not files then
    error("exercise shortcode: folder exercises/" .. folder .. " does not exist", 0)
  end
  if #files == 0 then
    error("exercise shortcode: folder exercises/" .. folder .. " is empty", 0)
  end

  local tree_base = meta_string(meta, "exercises-base-url")
  local raw_base = meta_string(meta, "exercises-raw-base-url")
  if not tree_base or not raw_base then
    error("exercise shortcode: set exercises-base-url and exercises-raw-base-url in _quarto.yml", 0)
  end
  local folder_url = tree_base .. "/" .. folder

  ensure_css()

  local title = kwargs["title"] and pandoc.utils.stringify(kwargs["title"]) or ""
  if title == "" then title = "Files for this exercise" end
  local with_tests = kwargs["tests"] and pandoc.utils.stringify(kwargs["tests"]) == "true"
  local starter = with_tests and "vite-ts-starter-tests" or "vite-ts-starter"
  local starter_url = "https://github.com/Teaching-HTL-Leonding/" .. starter

  local content = pandoc.List()
  content:insert(pandoc.Para({
    pandoc.Str("Create a new app from the "),
    pandoc.Link(pandoc.Str(starter), starter_url),
    pandoc.Str(" template and run "),
    pandoc.Code("npm install"),
    pandoc.Str(". Then copy these files from the folder "),
    pandoc.Link(pandoc.Code("exercises/" .. folder), folder_url),
    pandoc.Str(" into your new app, each to the same path. A file that already exists in the app is replaced."),
  }))
  local items = pandoc.List()
  for _, rel in ipairs(files) do
    items:insert({ pandoc.Plain({ pandoc.Link(pandoc.Code(rel), raw_base .. "/" .. folder .. "/" .. rel) }) })
  end
  content:insert(pandoc.BulletList(items))
  local print_block = print_link_block(folder_url, "L")
  if print_block then content:insert(print_block) end

  return keep_print_card_together(quarto.Callout({
    type = "note",
    title = title,
    content = content,
    collapse = false,
  }))
end

return { ["exercise"] = exercise }
