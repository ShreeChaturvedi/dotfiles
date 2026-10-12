return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file tree" },
  },
  config = function()
    require("neo-tree").setup({
      sources = { "filesystem" },
      enable_diagnostics = false,
      default_component_configs = {
        indent = {
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
        },
        git_status = {
          symbols = {
            added = "",
            deleted = "",
            modified = "",
            renamed = "",
            untracked = "",
            ignored = "",
            unstaged = "",
            staged = "",
            conflict = "",
          },
        },
        file_size = { enabled = false },
        type = { enabled = false },
        last_modified = { enabled = false },
      },
      window = {
        position = "left",
        width = 28,
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["q"] = "close_window",
          ["<cr>"] = "open",
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_default",
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
      event_handlers = {
        {
          event = "file_open_requested",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
    })

    local black = "#000000"
    local function paint()
      local set = vim.api.nvim_set_hl
      local fg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).fg
      set(0, "NeoTreeNormal", { fg = fg, bg = black })
      set(0, "NeoTreeNormalNC", { fg = fg, bg = black })
      set(0, "NeoTreeEndOfBuffer", { fg = black, bg = black })
      set(0, "NeoTreeWinSeparator", { fg = black, bg = black })
      set(0, "NeoTreeIndentMarker", { fg = "#2a2a2a", bg = black })
    end
    paint()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("NeoTreeBlack", { clear = true }),
      callback = paint,
    })
  end,
}
