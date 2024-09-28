-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  dependencies = "davidmh/cspell.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"

    -- cspell config:
    local cspell = require "cspell"
    local cspell_config = {
      diagnostics_postprocess = function(diagnostic)
        diagnostic.severity = vim.diagnostic.severity["WARN"] -- ERROR, WARN, INFO, HINT
      end,
      config = {
        -- The CSpell configuration file can take a few different names this option
        -- lets you specify which name you would like to use when creating a new
        -- config file from within the `Add word to cspell json file` action.
        --
        -- See the currently supported files in https://github.com/davidmh/cspell.nvim/blob/main/lua/cspell/helpers.lua
        -- config_file_preferred_name = "/home/algol/.config/nvim/spell/cspell.json",

        --- A way to define your own logic to find the CSpell configuration file.
        -- ---@params cwd The same current working directory defined in the source,
        --             defaulting to vim.loop.cwd()
        -- ---@return string|nil The path of the json file
        -- find_json = function(cwd) end,

        find_json = function(_) return vim.fn.expand "~/.config/nvim/spell/cspell.json" end,
        --- A way to define your own logic to find the CSpell configuration file.
        --             defaulting to vim.loop.cwd()
        -- -@return string|nil The path of the json file
        -- find_json = function(cwd) end,
        ---@param payload UseSuggestionSuccess
        on_use_suggestion = function(payload) end,

        ---@param payload AddToJSONSuccess
        on_add_to_json = function(payload)
          -- For example, you can format the cspell config file after you add a word
          os.execute(
            string.format(
              "jq -S '.words |= sort' %s > %s.tmp && mv %s.tmp %s",
              payload.cspell_config_path,
              payload.cspell_config_path,
              payload.cspell_config_path,
              payload.cspell_config_path
            )
          )
        end,

        ---@param payload AddToDictionarySuccess
        on_add_to_dictionary = function(payload)
          -- Includes:
          -- payload.new_word
          -- payload.cspell_config_path
          -- payload.generator_params
          -- payload.dictionary_path

          -- For example, you can sort the dictionary after adding a word
          os.execute(string.format("sort %s -o %s", payload.dictionary_path, payload.dictionary_path))
        end,
      },
    }

    config.sources = {
      -- Set a formatter
      -- null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.isort,
      null_ls.builtins.formatting.black,
      null_ls.builtins.diagnostics.tidy,
      -- null_ls.builtins.formatting.prettier,
      null_ls.builtins.diagnostics.sqlfluff.with {
        extra_args = { "--dialect", "postgres" }, -- change to your dialect
      },
      null_ls.builtins.formatting.sqlfluff.with {
        extra_args = { "--dialect", "postgres" }, -- change to your dialect
      },
      -- null_ls.builtins.completion.spell,
      null_ls.builtins.diagnostics.codespell,
      null_ls.builtins.diagnostics.protolint,
      null_ls.builtins.formatting.protolint,
      -- null_ls.builtins.diagnostics.protoc_gen_lint,

      -- Check supported formatters and linters
      -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

      -- cspell config:
      cspell.diagnostics.with(cspell_config),
      cspell.code_actions.with(cspell_config),
    }
    return config -- return final config table
  end,
  requires = { "nvim-lua/plenary.nvim" },
}
