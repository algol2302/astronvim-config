-- https://github.com/olimorris/codecompanion.nvim/discussions/813
-- https://github.com/milanglacier/minuet-ai.nvim/pull/99

local minuet_fidget_spinner = {}

function minuet_fidget_spinner:init()
  local group = vim.api.nvim_create_augroup("MinuetFidgetHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "MinuetRequestStarted",
    group = group,
    callback = function(request)
      local handle = minuet_fidget_spinner:create_progress_handle(request)
      minuet_fidget_spinner:store_progress_handle(request.data.timestamp, handle)
    end,
  })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "MinuetRequestFinished",
    group = group,
    callback = function(request)
      local handle = minuet_fidget_spinner:pop_progress_handle(request.data.timestamp)
      if handle then
        handle.message = "Done"
        handle:finish()
      end
    end,
  })
end

minuet_fidget_spinner.handles = {}

function minuet_fidget_spinner:store_progress_handle(id, handle) minuet_fidget_spinner.handles[id] = handle end

function minuet_fidget_spinner:pop_progress_handle(id)
  local handle = minuet_fidget_spinner.handles[id]
  minuet_fidget_spinner.handles[id] = nil
  return handle
end

function minuet_fidget_spinner:create_progress_handle(request)
  local progress = require "fidget.progress"

  return progress.handle.create {
    title = " Requesting completion " .. request.data.name,
    message = "In progress " .. request.data.n_requests .. "...",
    lsp_client = {
      name = request.data.name,
    },
  }
end

return {
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
      -- opts.mappings.n[prefix .. "t"] =
      --   { "<cmd>Minuet virtualtext toggle<cr>", desc = "Toggle virtual text autocompletion" }
    end,
  },
  {
    "milanglacier/minuet-ai.nvim",
    dependences = {
      "nvim-lua/plenary.nvim",
      "j-hui/fidget.nvim",
      "Saghen/blink.cmp",
    },
    config = function()
      require("minuet").setup {
        -- virtualtext = {
        --   auto_trigger_ft = {},
        --
        --   keymap = {
        --     -- accept whole completion
        --     accept = "<A-l>",
        --     -- accept one line
        --     accept_line = "<A-;>",
        --     accept_n_lines = nil,
        --     -- Cycle to prev completion item, or manually invoke completion
        --     prev = "<A-k>",
        --     -- Cycle to next completion item, or manually invoke completion
        --     next = "<A-j>",
        --     dismiss = "<A-h>",
        --   },
        --
        --   -- Whether show virtual text suggestion when the completion menu
        --   -- (nvim-cmp or blink-cmp) is visible.
        --   show_on_completion_menu = false,
        -- },
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
            -- Sbercloud
            -- api_key = require("helpers.secret").load "~/.config/nvim/sbercloud_api_key.gpg",
            -- end_point = "https://foundation-models.api.cloud.ru/v1/chat/completions",
            -- model = "Qwen/Qwen3-235B-A22B-Instruct-2507",
            -- name = "Qwen3-235B",

            -- Openrouter.ai
            api_key = function() return require("helpers.secret").load "~/.config/nvim/openrouter_key.gpg" end,
            end_point = "https://openrouter.ai/api/v1/chat/completions",
            model = "deepseek/deepseek-chat-v3-0324:free",
            name = "Deepseek",

            -- Bothub API
            -- api_key = function() return require("helpers.secret").load "~/.config/nvim/bothub_api_key.gpg" end,
            -- end_point = "https://bothub.chat/api/v2/openai/v1/chat/completions",
            -- model = "deepseek-chat-v3-0324",
            -- name = "Deepseek",

            -- Yandex API
            -- api_key = function() return require("helpers.secret").load "~/.config/nvim/ya_api_key.gpg" end,
            -- end_point = "https://llm.api.cloud.yandex.net/v1/chat/completions",
            --
            -- model = "gpt://"
            --   .. require("helpers.secret").load "~/.config/nvim/ya_dir.gpg"
            --   .. "/qwen3-235b-a22b-fp8/latest",
            -- name = "Qwen3",
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

      minuet_fidget_spinner:init()
    end,
  },
}
