-- local cspell_config = vim.fn.expand "$HOME/.cspell/cspell.json"
-- local shared_config = {
--   find_json = function() return cspell_config end,
-- }
--
return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- Set a formatter
      -- null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.formatting.prettier,
      null_ls.builtins.diagnostics.sqlfluff.with {
        extra_args = { "--dialect", "postgres" }, -- change to your dialect
      },
      null_ls.builtins.formatting.sqlfluff.with {
        extra_args = { "--dialect", "postgres" }, -- change to your dialect
      },
      -- null_ls.builtins.completion.spell,
      null_ls.builtins.diagnostics.codespell,
      -- null_ls.builtins.diagnostics.cspell.with {
      --   config = shared_config,
      -- },
      -- null_ls.builtins.code_actions.cspell.with {
      --   config = shared_config,
      -- },
    }
    return config -- return final config table
  end,
}
