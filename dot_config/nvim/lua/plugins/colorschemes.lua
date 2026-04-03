return {
  { "clearaspect/onehalf", lazy = false, priority = 1000 },
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 500,
      set_dark_mode = function()
        vim.cmd("colorscheme onehalfdark")
        vim.api.nvim_set_option_value("background", "dark", {})
      end,
      set_light_mode = function()
        vim.cmd("colorscheme onehalflight")
        vim.api.nvim_set_option_value("background", "light", {})
      end,
    },
  },
}
