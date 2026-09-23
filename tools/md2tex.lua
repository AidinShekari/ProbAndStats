--[[
  md2tex.lua — Pandoc filter that turns the course Markdown into LaTeX
  for the ProbAndStats template (template/probstats.sty).

  * PS_LANG=fa  → Persian (RTL) mode: Latin runs are wrapped in \lr{...}
  * PS_LANG=en  → English (LTR) mode
  * Unicode math symbols (σ, ≤, X̄, x₁ …) become proper math / scripts
  * "### Definition", "### Engineering Example", "### Problem" … become
    coloured boxes; "## 1.2 Title" becomes a numbered section badge.
  * The level-1 heading is removed and handed back as metadata (cover page).
]]

local LANG = os.getenv("PS_LANG") or "en"
local RTL = (LANG == "fa")

---------------------------------------------------------------------------
-- character tables
---------------------------------------------------------------------------
local MATHSYM = {
  ["α"]="\\alpha", ["β"]="\\beta", ["γ"]="\\gamma", ["δ"]="\\delta",
  ["ε"]="\\varepsilon", ["θ"]="\\theta", ["λ"]="\\lambda", ["μ"]="\\mu",
  ["ν"]="\\nu", ["π"]="\\pi", ["ρ"]="\\rho", ["σ"]="\\sigma", ["τ"]="\\tau",
  ["φ"]="\\phi", ["χ"]="\\chi", ["ω"]="\\omega", ["Γ"]="\\Gamma",
  ["Δ"]="\\Delta", ["Θ"]="\\Theta", ["Σ"]="\\Sigma", ["Φ"]="\\Phi",
  ["Ω"]="\\Omega", ["→"]="\\to", ["←"]="\\leftarrow", ["↑"]="\\uparrow",
  ["↔"]="\\leftrightarrow", ["≤"]="\\le", ["≥"]="\\ge", ["≈"]="\\approx",
  ["≠"]="\\neq", ["±"]="\\pm", ["×"]="\\times", ["·"]="\\cdot",
  ["√"]="\\sqrt{\\,}", ["∞"]="\\infty", ["∫"]="\\int", ["∂"]="\\partial",
  ["∈"]="\\in", ["∩"]="\\cap", ["∪"]="\\cup", ["⊆"]="\\subseteq",
  ["∅"]="\\emptyset", ["ℝ"]="\\mathbb{R}", ["ℓ"]="\\ell", ["°"]="^{\\circ}",
}
-- √ is followed by its argument in the sources ("√n", "√(2π)"), so it is
-- rendered as a plain radical sign rather than an empty \sqrt.
MATHSYM["√"] = "\\surd"

local SUPER = {
  ["⁰"]="0", ["¹"]="1", ["²"]="2", ["³"]="3", ["⁴"]="4", ["⁵"]="5",
  ["⁶"]="6", ["⁷"]="7", ["⁸"]="8", ["⁹"]="9", ["⁻"]="-", ["ᶜ"]="c",
  ["ˣ"]="x", ["ᵏ"]="k", ["ʸ"]="y", ["ᶻ"]="z", ["ᵀ"]="T", ["ᴺ"]="N",
}
local SUB = {
  ["₀"]="0", ["₁"]="1", ["₂"]="2", ["₃"]="3", ["₄"]="4", ["ᵢ"]="i",
  ["ₙ"]="n", ["ⱼ"]="j", ["ₓ"]="x", ["ₖ"]="k",
}
local COMBINING = { ["\u{0304}"]="\\bar", ["\u{0302}"]="\\hat" }
local ICONS = {
  ["✅"]="\\PSyes{}", ["✓"]="\\PSyes{}", ["❌"]="\\PSno{}", ["⚠"]="\\PSwarn{}",
  ["○"]="\\ensuremath{\\circ}", ["\u{FE0F}"]="",
}
local ESC = {
  ["\\"]="\\textbackslash{}", ["{"]="\\{", ["}"]="\\}", ["$"]="\\$",
  ["&"]="\\&", ["#"]="\\#", ["%"]="\\%", ["~"]="\\textasciitilde{}",
  ["^"]="\\textasciicircum{}", ["_"]="\\_", ["<"]="\\textless{}",
  [">"]="\\textgreater{}", ["|"]="\\textbar{}",
}

local function is_arabic(cp)
  return (cp >= 0x0600 and cp <= 0x06FF) or (cp >= 0xFB50 and cp <= 0xFDFF)
      or (cp >= 0xFE70 and cp <= 0xFEFF) or cp == 0x200C
end

local function escape_plain(s)
  local out = {}
  for _, ch in ipairs((function()
      local t = {}
      for _, cp in utf8.codes(s) do t[#t + 1] = utf8.char(cp) end
      return t end)()) do
    out[#out + 1] = ESC[ch] or ch
  end
  return table.concat(out)
end

local function fix_math(m)
  if RTL then m = m:gsub("\\text{", "\\PSmtext{") end
  return m
end

local function has_arabic(s)
  for _, cp in utf8.codes(s) do
    if is_arabic(cp) then return true end
  end
  return false
end

-- "strong" LTR content: any letter / symbol that is not a digit or plain
-- punctuation.  Pure digits/punctuation are "neutral".
local function has_ltr(s)
  for _, cp in utf8.codes(s) do
    local ch = utf8.char(cp)
    if ch:match("%a") or MATHSYM[ch] or SUPER[ch] or SUB[ch] or COMBINING[ch]
       or ch == "=" or ch == "<" or ch == ">" or ch == "^" or ch == "_"
       or ch == "~" or ch == "+" or ch == "*" or ch == "/" then
      return true
    end
    if cp > 127 and not is_arabic(cp) and not ch:match("[«»—–]") then
      return true
    end
  end
  return false
end

local function chars(s)
  local t = {}
  for _, cp in utf8.codes(s) do t[#t + 1] = utf8.char(cp) end
  return t
end

---------------------------------------------------------------------------
-- plain text → LaTeX
---------------------------------------------------------------------------
local text2tex

-- characters B Nazanin can draw besides Arabic script
local BN_OK = {}
for _, cp in utf8.codes(" !%()*+,-./0123456789:=[]{}«·»×÷‘’“”\u{200C}\u{200D}") do
  BN_OK[utf8.char(cp)] = true
end

-- read a script argument after ^ or _ starting at index i of char list c
local function script_arg(c, i)
  if c[i] == "(" or c[i] == "{" then
    local open, close = c[i], (c[i] == "(" and ")" or "}")
    local depth, j = 0, i
    while j <= #c do
      if c[j] == open then depth = depth + 1
      elseif c[j] == close then
        depth = depth - 1
        if depth == 0 then break end
      end
      j = j + 1
    end
    if j > #c then return nil end
    return table.concat(c, "", i + 1, j - 1), j + 1
  end
  local j = i
  while j <= #c and (c[j]:match("^[%w]$") or MATHSYM[c[j]]) do j = j + 1 end
  if j == i then return nil end
  return table.concat(c, "", i, j - 1), j
end

text2tex = function(s, rtl_ctx)
  local c = chars(s)
  local out, i = {}, 1
  while i <= #c do
    local ch = c[i]
    local nxt = c[i + 1]
    if nxt and COMBINING[nxt] then
      local base = MATHSYM[ch] or ch
      out[#out + 1] = "\\ensuremath{" .. COMBINING[nxt] .. "{" .. base .. "}}"
      i = i + 2
    elseif (ch == "^" or ch == "_") and i > 1 and c[i + 1] then
      local arg, j = script_arg(c, i + 1)
      if arg then
        local cmd = ch == "^" and "\\textsuperscript{" or "\\textsubscript{"
        out[#out + 1] = cmd .. text2tex(arg) .. "}"
        i = j
      else
        out[#out + 1] = ESC[ch]
        i = i + 1
      end
    elseif SUPER[ch] or SUB[ch] then
      local tbl = SUPER[ch] and SUPER or SUB
      local buf = {}
      while c[i] and tbl[c[i]] do buf[#buf + 1] = tbl[c[i]]; i = i + 1 end
      out[#out + 1] = (tbl == SUPER and "\\textsuperscript{" or "\\textsubscript{")
        .. table.concat(buf) .. "}"
    elseif MATHSYM[ch] then
      out[#out + 1] = "\\ensuremath{" .. MATHSYM[ch] .. "}"
      i = i + 1
    elseif ICONS[ch] then
      out[#out + 1] = ICONS[ch]
      i = i + 1
    elseif rtl_ctx and not BN_OK[ch] and not has_arabic(ch) then
      -- glyph missing from the Persian font → typeset with the Latin font
      local buf = {}
      while c[i] and not BN_OK[c[i]] and not has_arabic(c[i]) and not MATHSYM[c[i]]
            and not SUPER[c[i]] and not SUB[c[i]] and not ICONS[c[i]] do
        buf[#buf + 1] = ESC[c[i]] or c[i]; i = i + 1
      end
      if #buf == 0 then buf[1] = ESC[ch] or ch; i = i + 1 end
      out[#out + 1] = "\\lr{" .. table.concat(buf) .. "}"
    elseif ESC[ch] then
      out[#out + 1] = ESC[ch]
      i = i + 1
    else
      out[#out + 1] = ch
      i = i + 1
    end
  end
  return table.concat(out)
end

---------------------------------------------------------------------------
-- inline rendering with bidi grouping
---------------------------------------------------------------------------
-- item = { tex = <latex>, cls = "P"|"L"|"N"|"S"|"B", raw = <text for Str> }
local render_inlines

local function classify_text(s)
  if has_arabic(s) then return "P" end
  if has_ltr(s) then return "L" end
  return "N"
end

local function wrap_cls(inner_items)
  local p, l = false, false
  for _, it in ipairs(inner_items) do
    if it.cls == "P" then p = true elseif it.cls == "L" then l = true end
  end
  return p and "P" or (l and "L" or "N")
end

local function inline_items(inl)
  local items = {}
  for _, el in ipairs(inl) do
    local t = el.t
    if t == "Str" and RTL then el = pandoc.Str((el.text:gsub("ئ", "ی"))) end
    if t == "Str" then
      if RTL then
        local buf, cur = {}, nil
        local function flush()
          if #buf > 0 then
            local txt = table.concat(buf)
            items[#items + 1] = { raw = txt, cls = classify_text(txt) }
            buf = {}
          end
        end
        for _, cp in utf8.codes(el.text) do
          local ch = utf8.char(cp)
          local a = is_arabic(cp)
          local neutral = (not a) and (ch:match("^[%p%s]$") ~= nil
                          or ch:match("^[«»“”‘’—–…]$") ~= nil)
          if neutral then
            -- punctuation joins whatever run it touches
          elseif cur == nil then
            cur = a
          elseif a ~= cur then
            flush(); cur = a
          end
          buf[#buf + 1] = ch
        end
        flush()
      else
        items[#items + 1] = { raw = el.text, cls = classify_text(el.text) }
      end
    elseif t == "Space" then
      items[#items + 1] = { tex = " ", cls = "S" }
    elseif t == "SoftBreak" then
      items[#items + 1] = { tex = " ", cls = "S" }
    elseif t == "LineBreak" then
      items[#items + 1] = { tex = "\\PSbr{}", cls = "B" }
    elseif t == "Code" then
      items[#items + 1] = { tex = "\\PScode{" .. escape_plain(el.text) .. "}", cls = "L" }
    elseif t == "Math" then
      if el.mathtype == "DisplayMath" then
        items[#items + 1] = { tex = "\\[" .. fix_math(el.text) .. "\\]", cls = "B" }
      else
        items[#items + 1] = { tex = "$" .. fix_math(el.text) .. "$", cls = "L" }
      end
    elseif t == "Emph" or t == "Strong" or t == "Underline" or t == "Strikeout"
        or t == "Superscript" or t == "Subscript" or t == "SmallCaps"
        or t == "Span" or t == "Link" or t == "Quoted" or t == "Cite" then
      local sub = inline_items(el.content)
      local inner = render_inlines(el.content)
      local pre, post = "{", "}"
      if t == "Emph" then pre = "\\emph{"
      elseif t == "Strong" then pre = "\\textbf{"
      elseif t == "Superscript" then pre = "\\textsuperscript{"
      elseif t == "Subscript" then pre = "\\textsubscript{"
      elseif t == "Link" and el.target:match("^https?://") then
        pre = "\\href{" .. el.target:gsub("([%%#])", "\\%1") .. "}{"
      elseif t == "Quoted" then
        if RTL then pre, post = "«", "»" else pre, post = "``", "''" end
      end
      items[#items + 1] = { tex = pre .. inner .. post, cls = wrap_cls(sub) }
    elseif t == "RawInline" then
      if el.format == "latex" or el.format == "tex" then
        items[#items + 1] = { tex = el.text, cls = "N" }
      end
    elseif t == "Note" then
      -- not used in the sources
    end
  end
  return items
end

local TRAIL_PUNCT = "[%.,:;!%?،؛]"

-- split trailing sentence punctuation (and an unbalanced ')') off a group,
-- and a leading unbalanced '(' — they stay in RTL so bidi mirrors them.
local function paren_balance(group)
  local o, cl = 0, 0
  for _, it in ipairs(group) do
    if it.raw then
      local _, a = it.raw:gsub("[%(%[]", "")
      local _, b = it.raw:gsub("[%)%]]", "")
      o, cl = o + a, cl + b
    end
  end
  return o, cl
end

local function trim_group(group)
  local tail = {}
  while #group > 0 do
    local last = group[#group]
    if last.cls == "S" or not last.raw then
      if last.cls == "S" then
        table.insert(tail, 1, last); group[#group] = nil
      else
        break
      end
    else
      local c = chars(last.raw)
      local ch = c[#c]
      local strip = ch:match(TRAIL_PUNCT) ~= nil or ch == "(" or ch == "["
      if ch == ")" or ch == "]" then
        local o, cl = paren_balance(group)
        strip = cl > o
      end
      if not strip then break end
      table.insert(tail, 1, { raw = ch, cls = "N" })
      c[#c] = nil
      if #c == 0 then group[#group] = nil else last.raw = table.concat(c) end
    end
  end
  local head = {}
  while #group > 0 do
    local first = group[1]
    if first.cls == "S" then
      head[#head + 1] = table.remove(group, 1)
    elseif first.raw and first.raw:sub(1, 1) == "(" then
      local o, cl = paren_balance(group)
      if o <= cl then break end
      head[#head + 1] = { raw = "(", cls = "N" }
      first.raw = first.raw:sub(2)
      if first.raw == "" then table.remove(group, 1) end
    else
      break
    end
  end
  return head, group, tail
end

local function tex_of(it, rtl_ctx)
  if it.tex then return it.tex end
  if rtl_ctx and it.cls == "N" and it.raw:match("%d") and it.raw:match("%d%p+%d") then
    -- numbers such as 0.5 or 1/2 keep their left-to-right order
    return "\\PSnum{" .. text2tex(it.raw, rtl_ctx) .. "}"
  end
  return text2tex(it.raw, rtl_ctx)
end

local function concat_items(items, rtl_ctx)
  local out = {}
  for _, it in ipairs(items) do out[#out + 1] = tex_of(it, rtl_ctx) end
  return table.concat(out)
end

render_inlines = function(inl)
  local items = inline_items(inl)
  if not RTL then return concat_items(items) end

  local out = {}
  local i = 1
  while i <= #items do
    local it = items[i]
    if it.cls == "L" or it.cls == "N" or it.cls == "S" then
      -- collect maximal run without Persian / breaks
      local j = i
      local any_ltr = false
      while j <= #items and (items[j].cls == "L" or items[j].cls == "N"
                             or items[j].cls == "S") do
        if items[j].cls == "L" then any_ltr = true end
        j = j + 1
      end
      local run = {}
      for k = i, j - 1 do run[#run + 1] = items[k] end
      if any_ltr then
        local head, group, tail = trim_group(run)
        out[#out + 1] = concat_items(head, true)
        if #group > 0 then
          out[#out + 1] = "\\lr{" .. concat_items(group, false) .. "}"
        end
        out[#out + 1] = concat_items(tail, true)
      else
        out[#out + 1] = concat_items(run, true)
      end
      i = j
    else
      out[#out + 1] = tex_of(it, true)
      i = i + 1
    end
  end
  return table.concat(out)
end

local function stringify_title(inl)
  return pandoc.utils.stringify(inl)
end

---------------------------------------------------------------------------
-- block-level passes
---------------------------------------------------------------------------
local function raw(s) return pandoc.RawBlock("latex", s) end

local SOLUTION = { ["Solution:"]=true, ["Solution"]=true, ["حل:"]=true,
                   ["حل"]=true, ["پاسخ:"]=true, ["Answer:"]=true }

local function para_tex(inl)
  -- "**Solution:** ..." → solution label
  local first = inl[1]
  if first and first.t == "Strong" and SOLUTION[stringify_title(first.content)] then
    local rest = pandoc.List()
    for k = 2, #inl do rest:insert(inl[k]) end
    while rest[1] and (rest[1].t == "Space" or rest[1].t == "SoftBreak"
                       or rest[1].t == "LineBreak") do rest:remove(1) end
    return "\\PSsolution{} " .. render_inlines(rest)
  end
  return render_inlines(inl)
end

local pass1 = {
  Para = function(el)
    return pandoc.Para({ pandoc.RawInline("latex", para_tex(el.content)) })
  end,
  Plain = function(el)
    return pandoc.Plain({ pandoc.RawInline("latex", para_tex(el.content)) })
  end,
  RawBlock = function(el)
    if el.format == "html" then return {} end
  end,
  HorizontalRule = function() return {} end,
  CodeBlock = function(el)
    el.text = el.text:gsub("ₙ", "_n")
    local _, nl = el.text:gsub("\n", "")
    local mode = (nl < 40) and "unbreakable" or "breakable"
    local pre = raw("\\tcbset{PScodemode/.style={" .. mode .. "}}")
    if el.classes[1] == "matlab" or el.classes[1] == "octave" then
      return { pre, el } -- highlighted by pandoc → Shaded (styled in the template)
    end
    return {
      pre,
      raw("\\begin{PSplaincode}\n\\begin{Verbatim}\n" .. el.text .. "\n\\end{Verbatim}\n\\end{PSplaincode}"),
    }
  end,
  BlockQuote = function(el)
    local blocks = pandoc.List({ raw("\\begin{PSquote}") })
    blocks:extend(el.content)
    blocks:insert(raw("\\end{PSquote}"))
    return blocks
  end,
  Table = function(tbl)
    for _, row in ipairs(tbl.head.rows) do
      for _, cell in ipairs(row.cells) do
        cell.contents = cell.contents:map(function(b)
          if b.t == "Plain" or b.t == "Para" then
            local tex
            if #b.content == 1 and b.content[1].t == "RawInline" then
              tex = b.content[1].text
            else
              tex = render_inlines(b.content)
            end
            return pandoc.Plain({ pandoc.RawInline("latex", "\\PSth{" .. tex .. "}") })
          end
          return b
        end)
      end
    end
    return tbl
  end,
}

-- which H3 headings become boxes
local BOXES = {
  { "^Mathematical Definition", "def" }, { "^Definition", "def" },
  { "^تعریف", "def" },
  { "^Engineering Example", "ex" }, { "^Example", "ex" },
  { "^Worked Example", "ex" }, { "^مثال", "ex" },
  { "^Problem", "prob" }, { "^مسئله", "prob" }, { "^تمرین", "prob" },
  { "^Theorem", "thm" }, { "^قضیه", "thm" },
}

local function box_kind(title)
  for _, p in ipairs(BOXES) do
    if title:match(p[1]) then return p[2] end
  end
  return nil
end

-- rough height of a block list in text lines (A4, ~85 chars per line)
local function est_lines(blocks)
  local n = 0
  for _, b in ipairs(blocks) do
    pandoc.walk_block(pandoc.Div(b), {
      CodeBlock = function(cb) local _, k = cb.text:gsub("\n", ""); n = n + k + 3 end,
      RawBlock = function(rb)
        if rb.format == "latex" then local _, k = rb.text:gsub("\n", ""); n = n + k end
      end,
      Para = function(pa) n = n + 1.2 + #pandoc.utils.stringify(pa) / 85 end,
      Plain = function(pl) n = n + 1 + #pandoc.utils.stringify(pl) / 85 end,
      Math = function(m) if m.mathtype == "DisplayMath" then n = n + 3 end end,
    })
  end
  return n
end
local KEEP_LINES = 30   -- boxes shorter than this never split across pages

local function contains_heavy(blocks)
  local heavy = false
  for _, b in ipairs(blocks) do
    pandoc.walk_block(pandoc.Div(b), {
      Table = function() heavy = true end,
      CodeBlock = function(cb)
        local _, n = cb.text:gsub("\n", "")
        if n > 30 then heavy = true end
      end,
    })
    if b.t == "Table" then heavy = true end
  end
  return heavy
end

local function section_tex(h)
  local inl = pandoc.List(h.content)
  local num = ""
  if inl[1] and inl[1].t == "Str" and inl[1].text:match("^%d+%.%d+$") then
    num = inl[1].text
    inl:remove(1)
    while inl[1] and inl[1].t == "Space" do inl:remove(1) end
  end
  local title = render_inlines(inl)
  local plain = pandoc.utils.stringify(inl)
  if h.level == 2 then
    return string.format("\\PSsection{%s}{%s}", num, title), plain
  elseif h.level == 3 then
    return string.format("\\PSsubsection{%s}", title), plain
  else
    return string.format("\\PSsubsubsection{%s}", title), plain
  end
end

local OBJECTIVES = { ["Learning Objectives"]=true, ["اهداف یادگیری"]=true }

local pass2 = {
  Pandoc = function(doc)
    local blocks = doc.blocks
    local out = pandoc.List()
    local i = 1
    while i <= #blocks do
      local b = blocks[i]
      if b.t == "Header" and b.level == 1 then
        doc.meta.pstitle = pandoc.MetaString(pandoc.utils.stringify(b.content))
        i = i + 1
      elseif b.t == "Header" and b.level <= 3 then
        local tex, plain = section_tex(b)
        local kind = (b.level == 3) and box_kind(plain) or nil
        if b.level == 2 and OBJECTIVES[plain] then kind = "obj" end
        -- gather the body up to the next heading of level ≤ current
        local j = i + 1
        local body = pandoc.List()
        while j <= #blocks and not (blocks[j].t == "Header" and blocks[j].level <= b.level) do
          body:insert(blocks[j]); j = j + 1
        end
        if kind and not contains_heavy(body) then
          local title = render_inlines(b.content)
          local opt = est_lines(body) < KEEP_LINES and "unbreakable" or "breakable"
          out:insert(raw(string.format("\\begin{PSbox}[%s]{%s}{%s}", opt, kind, title)))
          out:extend(body)
          out:insert(raw("\\end{PSbox}"))
          i = j
        else
          out:insert(raw(tex))
          i = i + 1
        end
      elseif b.t == "Header" then
        local tex = section_tex(b)
        out:insert(raw(tex))
        i = i + 1
      else
        out:insert(b)
        i = i + 1
      end
    end
    doc.blocks = out
    return doc
  end,
}

return { pass1, pass2 }
