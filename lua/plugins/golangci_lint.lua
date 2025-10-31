return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = function(plugin, opts)
    opts.servers = opts.servers or {}
    table.insert(opts.servers, "golangci_lint_ls")

    opts.config = require("astrocore").extend_tbl(opts.config or {}, {
      --   -- this must be a function to get access to the `lspconfig` module
      golangci_lint_ls = {
        cmd = { "golangci-lint-langserver" },
        root_markers = { ".git", "go.mod" },
        filetypes = { "go", "gomod" },
        -- root_dir = function(fname) return vim.fs.dirname(fname) end,
        init_options = {
          command = {
            "golangci-lint",
            "run",
            "--output.json.path",
            "stdout",
            "--show-stats=false",
            "--issues-exit-code=1",
          },
        },
      },
    })
  end,
}

-- return
-- --- @type LangSpec
-- {
--   -- lsp = "golangci_lint_ls",
--   opt = {
--     init_options = {
--       command = {
--         "golangci-lint",
--         "run",
--         "--output.json.path",
--         "stdout",
--         "--show-stats=false",
--         "--issues-exit-code=1",
--       },
--     },
--   },
-- }
