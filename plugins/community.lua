return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of importing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  -- { import = "astrocommunity.colorscheme.catppuccin" },
  -- { import = "astrocommunity.colorscheme.everforest" },
  -- { import = "astrocommunity.colorscheme.monokai-pro-nvim" },

  -- { import = "astrocommunity.completion.copilot-lua-cmp" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.project.nvim-spectre" },
  { import = "astrocommunity.syntax.hlargs-nvim" },
  { import = "astrocommunity.git.diffview-nvim" },
  { import = "astrocommunity.motion.leap-nvim" },
  { import = "astrocommunity.debugging.nvim-bqf" },
  -- { import = "astrocommunity.utility.noice-nvim" },

  {
    "m-demare/hlargs.nvim",
    opts = { color = "#ebdbb2" },
  },

  { import = "astrocommunity.editing-support.refactoring-nvim" },

  { import = "astrocommunity.diagnostics.trouble-nvim" },
}
