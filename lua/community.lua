-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder
  -- { import = "astrocommunity.colorscheme.vscode-nvim" },
  -- { import = "astrocommunity.colorscheme.onedarkpro-nvim" },
  -- { import = "astrocommunity.colorscheme.everforest" },
  -- { import = "astrocommunity.colorscheme.monokai-pro-nvim" },
  -- { import = "astrocommunity.colorscheme.catppuccin" },
  -- { import = "astrocommunity.colorscheme.kanagawa-nvim" },
  -- { import = "astrocommunity.colorscheme.nordic-nvim" },
  -- { import = "astrocommunity.colorscheme.nightfox-nvim" },
  -- { import = "astrocommunity.colorscheme.sonokai" },
  -- { import = "astrocommunity.colorscheme.github-nvim-theme" },
  -- { import = "astrocommunity.editing-support.auto-save-nvim" },

  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.editing-support.text-case-nvim" },
  { import = "astrocommunity.editing-support.codecompanion-nvim" },
  { import = "astrocommunity.recipes.picker-nvchad-theme" },
  { import = "astrocommunity.recipes.heirline-mode-text-statusline" },
  { import = "astrocommunity.recipes.heirline-vscode-winbar" },
  { import = "astrocommunity.git.diffview-nvim" },
  { import = "astrocommunity.git.blame-nvim" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.search.grug-far-nvim" },
  { import = "astrocommunity.motion.flash-nvim" },
  { import = "astrocommunity.quickfix.nvim-bqf" },
  { import = "astrocommunity.project.project-nvim" },
  { import = "astrocommunity.lsp.nvim-lsp-file-operations" },
  { import = "astrocommunity.utility.mason-tool-installer-nvim" },
  { import = "astrocommunity.indent.indent-rainbowline" },
  { import = "astrocommunity.test.neotest" },
  { import = "astrocommunity.pack.helm" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
}
