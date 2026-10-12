-- White: language keywords and builtin types (if, return, public, int, void)
-- Gold: calls and values (println, numbers, true/false/nullptr, constructors)
-- Green: literal text (strings, chars, include paths <random>)
-- Gray #8a8a8a: ordinary identifiers (gen, dist)
-- Lighter gray #b4b4b4: namespaces (std)
-- Dimmer grays: punctuation, operators, comments
local BLACK = "#000000"

local COMMENT = "#4a4a4a"
local PUNCT = "#5a5a5a"
local OPERATOR = "#6a6a6a"
local FG = "#8a8a8a"
local TYPE = "#9a9a9a"
local NAMESPACE = "#d0d0d0"
local KEYWORD = "#ffffff"
local GOLD = "#c9b177"
local CONSTANT = "#bba065"
local STRING = "#84a384"
local VISUAL = "#3f3a2e"

local function apply()
  local set = vim.api.nvim_set_hl

  local function bg(name, guibg, extra)
    local cur = vim.api.nvim_get_hl(0, { name = name, link = false })
    local val = { fg = cur.fg, bg = guibg, sp = cur.sp }
    if extra then
      for k, v in pairs(extra) do
        val[k] = v
      end
    end
    set(0, name, val)
  end

  local function fg(names, guifg)
    for _, name in ipairs(names) do
      set(0, name, { fg = guifg })
    end
  end

  -- Chrome
  set(0, "Normal", { fg = FG, bg = BLACK })
  set(0, "NormalNC", { fg = FG, bg = BLACK })
  set(0, "NormalFloat", { fg = FG, bg = BLACK })
  bg("EndOfBuffer", BLACK)
  bg("SignColumn", BLACK)
  bg("FoldColumn", BLACK)
  bg("VertSplit", BLACK)
  bg("WinSeparator", BLACK)
  bg("MsgArea", BLACK)
  set(0, "LineNr", { fg = "#3c3c3c", bg = BLACK })
  set(0, "CursorLine", { bg = "#161616", bold = false })
  set(0, "CursorLineNr", { fg = "#c8c8c8", bg = "#161616", bold = false })
  set(0, "StatusLine", { fg = "#d0d0d0", bg = "#141414" })
  set(0, "StatusLineNC", { fg = "#5a5a5a", bg = "#101010" })
  bg("TabLineFill", BLACK)
  bg("TabLine", BLACK)
  set(0, "Visual", { bg = VISUAL })
  bg("Pmenu", "#0c0c0c")
  bg("WinBar", BLACK)
  bg("WinBarNC", BLACK)
  bg("ColorColumn", "#0c0c0c")

  set(0, "Search", { fg = KEYWORD, bg = "#3a3228" })
  set(0, "IncSearch", { fg = BLACK, bg = CONSTANT })
  set(0, "CurSearch", { fg = BLACK, bg = CONSTANT })

  set(0, "DiagnosticUnderlineError", { underline = true, sp = "#d06060" })
  set(0, "DiagnosticUnderlineWarn", { underline = true, sp = "#c4a04c" })

  -- Comments
  fg({ "Comment", "@comment", "@comment.documentation" }, COMMENT)

  -- Punctuation
  fg({
    "Delimiter",
    "@punctuation",
    "@punctuation.bracket",
    "@punctuation.delimiter",
    "@punctuation.special",
  }, PUNCT)

  -- Operators
  fg({ "Operator", "@operator" }, OPERATOR)

  -- Body text / identifiers (gray, not white)
  fg({
    "Identifier",
    "@variable",
    "@variable.builtin",
    "@variable.parameter",
    "@variable.member",
    "@parameter",
    "@property",
    "@field",
  }, FG)

  -- Namespaces (lighter than identifiers so std stands off)
  fg({
    "@namespace",
    "@namespace.cpp",
    "@module",
    "@module.builtin",
    "@lsp.type.namespace",
    "@lsp.type.namespace.cpp",
    "@lsp.typemod.namespace",
    "@lsp.typemod.namespace.cpp",
    "@lsp.typemod.namespace.defaultLibrary",
    "@lsp.typemod.namespace.defaultLibrary.cpp",
  }, NAMESPACE)

  -- User-defined types
  fg({ "Type", "Typedef", "@type", "@type.definition" }, TYPE)

  -- Keywords and builtin types (direct white)
  fg({
    "Keyword",
    "Statement",
    "Repeat",
    "Conditional",
    "Label",
    "Exception",
    "StorageClass",
    "Structure",
    "@keyword",
    "@keyword.function",
    "@keyword.conditional",
    "@keyword.repeat",
    "@keyword.exception",
    "@keyword.modifier",
    "@keyword.type",
    "@keyword.coroutine",
    "@keyword.return",
    "@type.qualifier",
    "@type.builtin",
    "@lsp.type.builtinType",
  }, KEYWORD)

  -- Functions / constructors / numbers / bools (muted gold)
  fg({
    "Function",
    "Number",
    "Float",
    "Boolean",
    "@function",
    "@function.call",
    "@function.builtin",
    "@function.method",
    "@function.method.call",
    "@function.macro",
    "@method",
    "@constructor",
    "@number",
    "@number.float",
    "@float",
    "@boolean",
    "@constant.builtin",
    "@keyword.operator",
  }, GOLD)

  -- Named constants
  fg({ "Constant", "@constant", "@constant.macro" }, CONSTANT)

  -- Strings, chars, include paths
  fg({
    "String",
    "Character",
    "@string",
    "@string.escape",
    "@string.regexp",
    "@string.special",
    "@string.special.path",
    "@character",
  }, STRING)

  -- #include / #define are language words (white). Paths inside <> stay STRING.
  fg({
    "PreProc",
    "Include",
    "Define",
    "PreCondit",
    "@keyword.import",
    "@keyword.directive",
    "@keyword.directive.define",
    "@include",
    "@preproc",
  }, KEYWORD)
  fg({ "Macro" }, GOLD)

  -- Special is cyan in default; gold so it never goes blue
  fg({ "Special", "SpecialChar", "Tag" }, CONSTANT)
end

apply()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("TrueBlackChrome", { clear = true }),
  callback = apply,
})
