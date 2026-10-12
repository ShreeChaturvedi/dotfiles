return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
    ts_config = {
      lua = { "string", "source", "string_content" },
      cpp = { "string_literal", "raw_string_literal", "comment" },
    },
    disable_filetype = {
      "dashboard",
      "fzf",
      "TelescopePrompt",
      "neo-tree",
      "oil",
    },
  },
}
