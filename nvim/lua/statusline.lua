local modes = {
  n = "NORMAL",
  no = "NORMAL",
  i = "INSERT",
  v = "VISUAL",
  V = "V-LINE",
  ["\22"] = "V-BLOCK",
  c = "COMMAND",
  R = "REPLACE",
  Rv = "REPLACE",
  s = "SELECT",
  S = "S-LINE",
  t = "TERMINAL",
}

function _G.NvimStatusline()
  local mode = modes[vim.api.nvim_get_mode().mode] or "NORMAL"
  local name = vim.fn.expand("%:t")
  if name == "" then
    return string.format(" %s", mode)
  end
  return string.format(" %s  %s", mode, name)
end

vim.opt.statusline = "%{%v:lua.NvimStatusline()%}"
