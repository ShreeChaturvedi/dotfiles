vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd.colorscheme("default")

-- Neovim's builtin maps *.tpp to the TPP presentation language, not C++.
vim.filetype.add({ extension = { tpp = "cpp" } })

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.statuscolumn = "%=%{v:relnum ? v:relnum : v:lnum} "
vim.opt.cursorline = true
vim.opt.signcolumn = "no"
vim.opt.showtabline = 2
vim.opt.laststatus = 2
vim.opt.cmdheight = 1
vim.opt.showmode = false
vim.opt.ruler = false

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.wrap = false
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.fillchars = { eob = " ", vert = "│" }
vim.opt.list = false

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false

vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
if vim.fn.has("mac") == 0 then
  -- wl-paste blocks forever on this compositor when the pane isn't focused.
  vim.g.clipboard = {
    name = "wl-copy-timeout",
    copy = {
      ["+"] = { "wl-copy", "--type", "text/plain" },
      ["*"] = { "wl-copy", "--type", "text/plain" },
    },
    paste = {
      ["+"] = { "timeout", "0.15", "wl-paste", "--no-newline" },
      ["*"] = { "timeout", "0.15", "wl-paste", "--no-newline" },
    },
    cache_enabled = 1,
  }
end

-- Block in normal, bar in insert, underline in replace (port of ~/.vimrc DECSCUSR)
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

vim.diagnostic.config({
  signs = false,
  virtual_text = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "none", source = "if_many" },
})
