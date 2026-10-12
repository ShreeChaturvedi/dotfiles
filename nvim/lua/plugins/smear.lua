return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  opts = {
    cursor_color = "#e0b04a",
    stiffness = 0.55,
    trailing_stiffness = 0.5,
    distance_stop_animating = 0.1,
    time_interval = 7,
    smear_between_neighbor_lines = true,
    never_draw_over_target = false,
    hide_target_hack = false,
    legacy_computing_symbols_support = true,
  },
  config = function(_, opts)
    require("smear_cursor").setup(opts)
    -- Pause while the tmux pane is unfocused so timers don't pile up.
    vim.api.nvim_create_autocmd("FocusLost", {
      callback = function()
        require("smear_cursor").enabled = false
      end,
    })
    vim.api.nvim_create_autocmd("FocusGained", {
      callback = function()
        require("smear_cursor").enabled = true
      end,
    })
  end,
}
