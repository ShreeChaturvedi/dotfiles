vim.diagnostic.config({
  signs = false,
  virtual_text = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "none",
    source = "if_many",
    header = "",
    prefix = "",
    suffix = "",
    focusable = false,
    wrap = true,
    max_width = math.min(80, vim.o.columns - 8),
    max_height = 6,
  },
})

local map = vim.keymap.set
map("n", "gl", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

local float_win

local group = vim.api.nvim_create_augroup("diagnostics", { clear = true })

vim.api.nvim_create_autocmd("CursorHold", {
  group = group,
  callback = function()
    if float_win and vim.api.nvim_win_is_valid(float_win) then
      return
    end
    local _, winid = vim.diagnostic.open_float({
      scope = "cursor",
      focusable = false,
      header = "",
      prefix = "",
      suffix = "",
      source = "if_many",
      border = "none",
      wrap = true,
      max_width = math.min(80, vim.o.columns - 8),
      max_height = 6,
    })
    if winid then
      vim.wo[winid].wrap = true
      vim.wo[winid].linebreak = true
    end
    float_win = winid
  end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
  group = group,
  callback = function()
    if float_win and vim.api.nvim_win_is_valid(float_win) then
      vim.api.nvim_win_close(float_win, true)
    end
    float_win = nil
  end,
})
