return {
  "AstroNvim/astrolsp",
  -- https://github.com/coder3101/protocols

  ---@type AstroLSPOpts
  opts = function(plugin, opts)
    opts.servers = opts.servers or {}
    table.insert(opts.servers, "protols")

    opts.config = require("astrocore").extend_tbl(opts.config or {}, {
      --   -- this must be a function to get access to the `lspconfig` module
      protols = {
        --     -- the command for starting the server
        cmd = { "protols" },
        filetypes = "proto",
        single_file_support = true,
        root_dir = function() end,
      },
    })
  end,
}
