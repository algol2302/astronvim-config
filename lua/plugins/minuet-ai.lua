return {
  {
    "milanglacier/minuet-ai.nvim",
    keys = {
      {
        "<leader>Me",
        "<cmd>Minuet lsp attach<CR>",
        mode = "n",
        desc = "Enable Minuet autocompletion",
      },
      {
        "<leader>Md",
        "<cmd>Minuet lsp detach<CR>",
        mode = "n",
        desc = "Enable Minuet autocompletion",
      },
    },
    config = function()
      require("minuet").setup {
        lsp = {
          enabled_ft = { "toml", "lua", "cpp", "go" },
          -- Enables automatic completion triggering using `vim.lsp.completion.enable`
          enabled_auto_trigger_ft = { "cpp", "lua", "go" },
        },
        -- keymap = {
        --   -- Manually invoke minuet completion.
        --   ["<A-y>"] = require("minuet").make_blink_map(),
        -- },
        -- sources = {
        --   -- Enable minuet for autocomplete
        --   default = { "lsp", "path", "buffer", "snippets", "minuet" },
        --   -- default = { "lsp", "path", "buffer", "snippets" },
        --   -- For manual completion only, remove 'minuet' from default
        --   providers = {
        --     minuet = {
        --       name = "minuet",
        --       module = "minuet.blink",
        --       async = true,
        --       -- Should match minuet.config.request_timeout * 1000,
        --       -- since minuet.config.request_timeout is in seconds
        --       timeout_ms = 2000,
        --       score_offset = 50, -- Gives minuet higher priority among suggestions
        --     },
        --   },
        -- },
        -- Recommended to avoid unnecessary request
        completion = { trigger = { prefetch_on_insert = false } },
        provider = "openai_compatible",
        request_timeout = 2.5,
        throttle = 1500, -- Increase to reduce costs and avoid rate limits
        debounce = 600, -- Increase to reduce costs and avoid rate limits

        provider_options = {
          openai_compatible = {
            api_key = function()
              local handle, err = io.popen("gpg --batch --quiet --decrypt ~/.config/nvim/bothub_api_key.gpg", "r")
              if not handle then error("Failed to start GPG: " .. (err or "unknown error")) end
              local result = handle:read "*a"
              handle:close()
              return result:gsub("\n", "")
            end,
            end_point = "https://bothub.chat/api/v2/openai/v1/chat/completions",
            model = "deepseek-chat-v3-0324",
            stream = true,
            name = "Bothub",
            optional = {
              max_tokens = 100,
              top_p = 0.9,
              provider = {
                sort = "latency",
              },
            },
          },
        },
      }
    end,
  },
  { "nvim-lua/plenary.nvim" },
  -- optional, if you are using virtual-text frontend, nvim-cmp is not
  --
  -- required.
  -- { "hrsh7th/nvim-cmp" },
  -- optional, if you are using virtual-text frontend, blink is not required.
  { "Saghen/blink.cmp" },
}
