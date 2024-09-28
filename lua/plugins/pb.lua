return {
  "AstroNvim/astrolsp",

  -- ---@type AstroLSPOpts
  -- opts = function(plugin, opts)
  --   -- insert "prolog_lsp" into our list of servers
  --   opts.servers = opts.servers or {}
  --   table.insert(opts.servers, "pb")
  --
  --   opts.config = require("astrocore").extend_tbl(opts.config or {}, {
  --     --   -- this must be a function to get access to the `lspconfig` module
  --     pb = {
  --       --     -- the command for starting the server
  --       cmd = { "pb", "lsp" },
  --       filetypes = "proto",
  --       single_file_support = true,
  --       root_dir = function() end,
  --     },
  --   })
  -- end,
}
