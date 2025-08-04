return {
  {
    "milanglacier/minuet-ai.nvim",
    config = function()
      require("minuet").setup {
        lsp = {
          enabled_ft = { "toml", "lua", "cpp", "go" },
          -- Enables automatic completion triggering using `vim.lsp.completion.enable`
          enabled_auto_trigger_ft = { "cpp", "lua", "go" },
          warn_on_blink_or_cmp = false,
        },
        sources = {
          -- Enable minuet for autocomplete
          default = { "lsp", "path", "buffer", "snippets", "minuet" },
          -- default = { "lsp", "path", "buffer", "snippets" },
          -- For manual completion only, remove 'minuet' from default
          providers = {
            minuet = {
              name = "minuet",
              module = "minuet.blink",
              async = true,
              -- Should match minuet.config.request_timeout * 1000,
              -- since minuet.config.request_timeout is in seconds
              timeout_ms = 2000,
              score_offset = 50, -- Gives minuet higher priority among suggestions
            },
          },
        },
        -- Recommended to avoid unnecessary request
        completion = { trigger = { prefetch_on_insert = false } },
        provider = "openai_compatible",
        request_timeout = 2.5,
        throttle = 1500, -- Increase to reduce costs and avoid rate limits
        debounce = 300, -- Increase to reduce costs and avoid rate limits
        provider_options = {
          openai_compatible = {
            api_key = function() return require("helpers.secret").load "~/.config/nvim/bothub_api_key.gpg" end,
            end_point = "https://bothub.chat/api/v2/openai/v1/chat/completions",
            model = "deepseek-chat-v3-0324",
            name = "Bothub",
            -- api_key = function() return require("helpers.secret").load "~/.config/nvim/ya_api_key.gpg" end,
            -- end_point = "https://llm.api.cloud.yandex.net/v1/chat/completions",
            -- model = "gpt://" .. require("helpers.secret").load "~/.config/nvim/ya_dir.gpg" .. "/yandexgpt-lite",
            -- name = "YandexGPT-Lite",
            stream = true,
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
  -- required.
  -- { "hrsh7th/nvim-cmp" },
  -- optional, if you are using virtual-text frontend, blink is not required.
  { "Saghen/blink.cmp" },

  { "AstroNvim/astroui", opts = { icons = { Minuet = "󱙺" } } },
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local prefix = "<Leader>M"
      if not opts.mappings then opts.mappings = {} end
      opts.mappings.n = opts.mappings.n or {}
      opts.mappings.n[prefix] = { desc = require("astroui").get_icon("Minuet", 1, true) .. "Minuet" }
      opts.mappings.n[prefix .. "e"] = { "<cmd>Minuet lsp attach<cr>", desc = "Enable autocompletion" }
      opts.mappings.n[prefix .. "d"] = { "<cmd>Minuet lsp detach<cr>", desc = "Disable autocompletion" }
    end,
  },
}
