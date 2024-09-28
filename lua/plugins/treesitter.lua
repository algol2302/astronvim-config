-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "lua",
      "vim",
      -- add more arguments for adding more treesitter parsers
      "go",
      "gomod",
      "gosum",
      "gowork",
      "gotmpl",
      "python",
      "sql",
      "json",
      "jsonc",
      "yaml",
      "gitignore",
      "dockerfile",
      "proto",
      "bash",
      "make",
      "markdown",
      "rust",
      "javascript",
      "typescript",
    })
  end,
}
