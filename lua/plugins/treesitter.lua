-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
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
    },
  },
}
