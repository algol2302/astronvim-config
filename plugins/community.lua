return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of importing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  -- { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.colorscheme.everforest" },

  -- { import = "astrocommunity.completion.copilot-lua-cmp" },
  { import = "astrocommunity.editing-support.nvim-ts-rainbow2" },
  { import = "astrocommunity.syntax.hlargs-nvim" },
  {
    "m-demare/hlargs.nvim",
    opts = { color = "#ebdbb2" },
  },
}
