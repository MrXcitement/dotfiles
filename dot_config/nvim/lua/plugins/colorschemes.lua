return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      -- 1. Palette selection: "latte", "frappe", "macchiato", "mocha", or "auto"
      flavour = "auto",
      background = { -- used when flavour = "auto"
        light = "latte",
        dark = "mocha",
      },

      -- 2. Transparency settings
      transparent_background = true, -- disables main editor background
      float = {
        transparent = true, -- makes floating windows (Telescope/Snacks, Mason, Lazy, LSP) transparent
        solid = false, -- use bordered floats instead of solid blocks
      },

      -- 3. Terminal & window appearance
      term_colors = true, -- sets terminal colors (g:terminal_color_0..15)
      dim_inactive = {
        enabled = false, -- dims unfocused splits (keep false if you want full transparency everywhere)
        shade = "dark",
        percentage = 0.15,
      },

      -- 4. Font styles ("italic", "bold", "underline", "strikethrough", or {})
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },

      -- 5. Plugin integrations (auto-detected by default in LazyVim)
      auto_integrations = true,
      integrations = {
        gitsigns = true,
        neotree = true,
        treesitter = true,
        snacks = true,
        mini = { enabled = true },
      },

      -- 6. Optional: override specific palette colors or highlight groups
      color_overrides = {},
      highlight_overrides = {},
    },
  },

  -- Tell LazyVim to use Catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      -- Use "catppuccin-nvim" on Neovim 0.12+, or "catppuccin" on older versions
      colorscheme = "catppuccin-nvim",
    },
  },
}
