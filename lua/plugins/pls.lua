return {
  -- "AstroNvim/astrolsp",
  -- -- https://github.com/lasorda/protobuf-language-server

  -- ---@type AstroLSPOpts
  -- opts = function(plugin, opts)
  --   opts.servers = opts.servers or {}
  --   table.insert(opts.servers, "protobuf_language_server")
  --
  --   opts.config = require("astrocore").extend_tbl(opts.config or {}, {
  --     --   -- this must be a function to get access to the `lspconfig` module
  --     protobuf_language_server = {
  --       cmd = { "protobuf-language-server" },
  --       filetypes = { "proto", "cpp" },
  --       root_dir = require("lspconfig.util").root_pattern ".git",
  --       single_file_support = true,
  --       settings = {
  --         ["additional-proto-dirs"] = {
  --           -- path to additional protobuf directories
  --           "vendor",
  --           "vendor.protogen",
  --           -- "third_party",
  --         },
  --       },
  --     },
  --   })
  -- end,
}
