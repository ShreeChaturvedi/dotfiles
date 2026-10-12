local M = {}

local CUBE_W = 32
local CUBE_H = 16
local KEYS = {
  { "f", "Find file", function() require("fzf-lua").files() end },
  { "r", "Recent files", function() require("fzf-lua").oldfiles() end },
  { "n", "New file", function() vim.cmd("enew") end },
  { "c", "Config", function() vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua") end },
  { "q", "Quit", function() vim.cmd("qa") end },
}

local function center_line(text, width)
  local pad = math.max(0, math.floor((width - vim.fn.strdisplaywidth(text)) / 2))
  return string.rep(" ", pad) .. text
end

local function build_keys(width)
  local raw = {}
  local max_w = 0
  for _, item in ipairs(KEYS) do
    local line = string.format("%s  %s", item[1], item[2])
    raw[#raw + 1] = line
    max_w = math.max(max_w, vim.fn.strdisplaywidth(line))
  end
  local pad = math.max(0, math.floor((width - max_w) / 2))
  local prefix = string.rep(" ", pad)
  local lines = { "" }
  for _, line in ipairs(raw) do
    lines[#lines + 1] = prefix .. line
  end
  return lines
end

function M.open()
  if vim.fn.argc() > 0 then
    return
  end
  if #vim.api.nvim_list_uis() == 0 then
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].filetype = "dashboard"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true
  vim.keymap.set("n", "q", KEYS[5][3], { buffer = buf, nowait = true, silent = true })
  for _, item in ipairs(KEYS) do
    vim.keymap.set("n", item[1], item[3], { buffer = buf, nowait = true, silent = true })
  end

  vim.api.nvim_set_current_buf(buf)
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.cursorline = false
  vim.opt_local.signcolumn = "no"
  vim.opt_local.foldcolumn = "0"
  vim.opt_local.statuscolumn = ""
  vim.opt.showtabline = 0

  local win = vim.api.nvim_get_current_win()
  local width = vim.api.nvim_win_get_width(win)
  local height = vim.api.nvim_win_get_height(win)
  local keys = build_keys(width)
  local top = math.max(1, math.floor((height - CUBE_H - #keys - 2) / 2))

  local cube_ok, cube = pcall(require, "cube")
  if not cube_ok then
    vim.notify("cube module missing", vim.log.levels.WARN)
    return
  end

  local function paint(frame)
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    local lines = {}
    for _ = 1, top do
      lines[#lines + 1] = ""
    end
    for _, row in ipairs(frame) do
      lines[#lines + 1] = center_line(row, width)
    end
    for _, row in ipairs(keys) do
      lines[#lines + 1] = row
    end
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].modified = false
  end

  paint(cube.render(0, CUBE_W, CUBE_H))
  cube.start({
    fps = 12,
    width = CUBE_W,
    height = CUBE_H,
    on_frame = paint,
  })

  vim.api.nvim_create_autocmd({ "BufLeave", "BufWipeout", "VimLeavePre" }, {
    buffer = buf,
    once = true,
    callback = function()
      cube.stop()
      vim.opt.showtabline = 2
    end,
  })
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.schedule(M.open)
  end,
})

return M
