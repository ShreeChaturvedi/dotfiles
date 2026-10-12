return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "c", "cpp", "lua", "query", "vim", "vimdoc" },
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = false },
    })
  end,
}
