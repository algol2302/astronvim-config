-- https://github.com/olimorris/codecompanion.nvim/discussions/813

local codecompanion_fidget_spinner = {}

function codecompanion_fidget_spinner:init()
  local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(request)
      local handle = codecompanion_fidget_spinner:create_progress_handle(request)
      codecompanion_fidget_spinner:store_progress_handle(request.data.id, handle)
    end,
  })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(request)
      local handle = codecompanion_fidget_spinner:pop_progress_handle(request.data.id)
      if handle then
        codecompanion_fidget_spinner:report_exit_status(handle, request)
        handle:finish()
      end
    end,
  })
end

codecompanion_fidget_spinner.handles = {}

function codecompanion_fidget_spinner:store_progress_handle(id, handle)
  codecompanion_fidget_spinner.handles[id] = handle
end

function codecompanion_fidget_spinner:pop_progress_handle(id)
  local handle = codecompanion_fidget_spinner.handles[id]
  codecompanion_fidget_spinner.handles[id] = nil
  return handle
end

function codecompanion_fidget_spinner:create_progress_handle(request)
  local progress = require "fidget.progress"
  local description = ""
  if request.data.strategy then description = "(" .. request.data.strategy .. ")" end

  return progress.handle.create {
    title = " Requesting assistance " .. description,
    message = "In progress...",
    lsp_client = {
      name = codecompanion_fidget_spinner:llm_role_title(request.data.adapter),
    },
  }
end

function codecompanion_fidget_spinner:llm_role_title(adapter)
  local parts = {}
  table.insert(parts, adapter.formatted_name)
  if adapter.model and adapter.model ~= "" then table.insert(parts, "(" .. adapter.model .. ")") end
  return table.concat(parts, " ")
end

function codecompanion_fidget_spinner:report_exit_status(handle, request)
  if request.data.status == "success" then
    handle.message = "Completed"
  elseif request.data.status == "error" then
    handle.message = " Error"
  else
    handle.message = "󰜺 Cancelled"
  end
end

codecompanion_fidget_spinner:init()

-- other settings
local temperature = {
  order = 2,
  mapping = "parameters",
  type = "number",
  optional = true,
  default = 0.2,
  desc = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.",
  validate = function(n) return n >= 0 and n <= 2, "Must be between 0 and 2" end,
}
local max_completion_tokens = {
  order = 3,
  mapping = "parameters",
  type = "integer",
  optional = true,
  default = nil,
  desc = "An upper bound for the number of tokens that can be generated for a completion.",
  validate = function(n) return n > 0, "Must be greater than 0" end,
}
local stop = {
  order = 4,
  mapping = "parameters",
  type = "string",
  optional = true,
  default = nil,
  desc = "Sets the stop sequences to use. When this pattern is encountered the LLM will stop generating text and return. Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.",
  validate = function(s) return s:len() > 0, "Cannot be an empty string" end,
}
local logit_bias = {
  order = 5,
  mapping = "parameters",
  type = "map",
  optional = true,
  default = nil,
  desc = "Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID) to an associated bias value from -100 to 100. Use https://platform.openai.com/tokenizer to find token IDs.",
  subtype_key = {
    type = "integer",
  },
  subtype = {
    type = "integer",
    validate = function(n) return n >= -100 and n <= 100, "Must be between -100 and 100" end,
  },
}

return {
  {
    "codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "j-hui/fidget.nvim",
      "ravitemer/codecompanion-history.nvim",
    },
    opts = {
      adapters = {
        http = {
          opts = {
            show_defaults = false,
            show_presets = false,
            show_model_choices = true,
          },
          bothub = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://bothub.chat/api/v2", -- optional: default value is ollama url http://127.0.0.1:11434
                api_key = require("helpers.secret").get "~/Secrets/bothub_api_key.gpg",
                chat_url = "/openai/v1/chat/completions", -- optional: default value, override if different
                models_endpoint = "/model/list?children=1", -- optional: attaches to the end of the URL to form the endpoint to retrieve models
                -- models_endpoint = "https://bothub.chat/api/v2/model/list?children=1", -- optional: attaches to the end of the URL to form the endpoint to retrieve models
              },
              schema = {
                model = {
                  default = "deepseek-chat-v3-0324:free",
                  -- choices = {
                  --   "claude-sonnet-4",
                  --   "deepseek-chat-v3-0324:free",
                  --   "gemini-2.5-pro",
                  --   "gpt-4.1",
                  --   "gpt-5",
                  --   "gpt-5-mini",
                  --   "grok-4",
                  -- },
                  -- default = "o4-mini-high", -- define llm model to be used
                  -- default = "deepseek-r1-671b", -- define llm model to be used
                },
                temperature = temperature,
                max_completion_tokens = max_completion_tokens,
                stop = stop,
                logit_bias = logit_bias,
              },
            })
          end,
          yandex_gpt = function()
            -- Available yandex models:
            --  https://yandex.cloud/ru/docs/foundation-models/concepts/yandexgpt/models
            -- Prices:
            --  https://yandex.cloud/ru/docs/foundation-models/pricing#text-sync-async
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://llm.api.cloud.yandex.net",
                api_key = require("helpers.secret").get "~/Secrets/ya_api_key.gpg",
              },
              schema = {
                model = {
                  default = "gpt://"
                    .. require("helpers.secret").get "~/Secrets/ya_dir.gpg"
                    .. "/qwen3-235b-a22b-fp8/latest",
                  -- choices = {
                  --   "gpt://" .. require("helpers.secret").get "~/Secrets/ya_dir.gpg" .. "/qwen3-235b-a22b-fp8/latest",
                  --   "gpt://" .. require("helpers.secret").get "~/Secrets/ya_dir.gpg" .. "/yandexgpt/latest",
                  --   "gpt://" .. require("helpers.secret").get "~/Secrets/ya_dir.gpg" .. "/yandexgpt-lite/latest",
                  --   "gpt://" .. require("helpers.secret").get "~/Secrets/ya_dir.gpg" .. "/gpt-oss-120b/latest",
                  --   "gpt://" .. require("helpers.secret").get "~/Secrets/ya_dir.gpg" .. "/gpt-oss-20b/latest",
                  -- },
                },
                temperature = temperature,
                max_completion_tokens = max_completion_tokens,
                stop = stop,
                logit_bias = logit_bias,
              },
            })
          end,
          openrouter = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://openrouter.ai/api",
                api_key = require("helpers.secret").get "~/Secrets/openrouter_key.gpg",
                chat_url = "/v1/chat/completions",
              },
              schema = {
                model = {
                  -- default = "z-ai/glm-4.6",
                  default = "anthropic/claude-sonnet-4.5",
                  -- default = "deepseek/deepseek-v3.2",
                },
                temperature = temperature,
                max_completion_tokens = max_completion_tokens,
                stop = stop,
                logit_bias = logit_bias,
              },
            })
          end,
          z_ai = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://api.z.ai/api/coding/paas",
                api_key = require("helpers.secret").get "~/Secrets/z_ai_key.gpg",
                chat_url = "/v4/chat/completions",
              },
              schema = {
                model = {
                  default = "glm-4.6",
                },
                temperature = temperature,
                max_completion_tokens = max_completion_tokens,
                stop = stop,
                logit_bias = logit_bias,
              },
            })
          end,
          z_ai_light = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://api.z.ai/api/coding/paas",
                api_key = require("helpers.secret").get "~/Secrets/z_ai_key.gpg",
                chat_url = "/v4/chat/completions",
              },
              schema = {
                model = {
                  default = "glm-4.5-air",
                },
                temperature = temperature,
                max_completion_tokens = max_completion_tokens,
                stop = stop,
                logit_bias = logit_bias,
              },
            })
          end,
          polza = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://api.polza.ai/api",
                api_key = require("helpers.secret").get "~/Secrets/polza_key.gpg",
                -- chat_url = "/v1/chat/completions",
              },
              schema = {
                model = {
                  default = "z-ai/glm-4.6",
                },
                temperature = temperature,
                max_completion_tokens = max_completion_tokens,
                stop = stop,
                logit_bias = logit_bias,
              },
            })
          end,
          local_lm_studio = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                -- url = "http://192.168.1.96:1234",
                url = "http://localhost:1234",
              },
              schema = {
                model = {
                  default = "openai/gpt-oss-20b",
                },
                temperature = temperature,
                max_completion_tokens = {
                  order = 3,
                  mapping = "parameters",
                  type = "integer",
                  optional = true,
                  default = 8000,
                  desc = "An upper bound for the number of tokens that can be generated for a completion.",
                  validate = function(n) return n > 0, "Must be greater than 0" end,
                },
                stop = stop,
                logit_bias = logit_bias,
              },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "z_ai",
        },
        inline = {
          adapter = "z_ai",
        },
        cmd = {
          adapter = "z_ai",
        },
        background = {
          adapter = {
            name = "z_ai_light",
            model = "glm-4.5-air",
          },
          -- Callbacks within the plugin that you can attach background actions to
          chat = {
            callbacks = {
              ["on_ready"] = {
                actions = {
                  "interactions.background.builtin.chat_make_title",
                },
                enabled = false,
              },
            },
            opts = {
              enabled = false, -- Enable ALL background chat interactions?
            },
          },
        },
      },
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = "Prompt ", -- Prompt used for interactive LLM calls
          provider = "default", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
          opts = {
            show_preset_actions = true, -- Show the preset actions in the action palette?
            show_preset_prompts = true, -- Show the preset prompts in the action palette?
            title = "CodeCompanion actions", -- The title of the action palette
          },
        },
      },
      extensions = {
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "gh",
            -- Keymap to save the current chat manually (when auto_save is disabled)
            save_chat_keymap = "sc",
            -- Save all chats by default (disable to save only manually using 'sc')
            auto_save = true,
            -- Number of days after which chats are automatically deleted (0 to disable)
            expiration_days = 0,
            -- Picker interface (auto resolved to a valid picker)
            picker = "default", --- ("telescope", "snacks", "fzf-lua", or "default")
            ---Optional filter function to control which chats are shown when browsing
            chat_filter = nil, -- function(chat_data) return boolean end
            -- Customize picker keymaps (optional)
            picker_keymaps = {
              rename = { n = "r", i = "<M-r>" },
              delete = { n = "d", i = "<M-d>" },
              duplicate = { n = "<C-y>", i = "<C-y>" },
            },
            ---Automatically generate titles for new chats
            auto_generate_title = true,
            title_generation_opts = {
              ---Adapter for generating titles (defaults to current chat adapter)
              adapter = "z_ai_light", -- "copilot"
              ---Model for generating titles (defaults to current chat model)
              model = "glm-4.5-air", -- "gpt-4o"
              ---Number of user prompts after which to refresh the title (0 to disable)
              refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
              ---Maximum number of times to refresh the title (default: 3)
              max_refreshes = 3,
              format_title = function(original_title)
                -- this can be a custom function that applies some custom
                -- formatting to the title.
                return original_title
              end,
            },
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = false,
            ---When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = false,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath "data" .. "/codecompanion-history",
            ---Enable detailed logging for history extension
            enable_logging = false,

            -- Summary system
            summary = {
              -- Keymap to generate summary for current chat (default: "gcs")
              create_summary_keymap = "gcs",
              -- Keymap to browse summaries (default: "gbs")
              browse_summaries_keymap = "gbs",

              generation_opts = {
                adapter = nil, -- defaults to current chat adapter
                model = nil, -- defaults to current chat model
                context_size = 90000, -- max tokens that the model supports
                include_references = true, -- include slash command content
                include_tool_outputs = true, -- include tool execution results
                system_prompt = nil, -- custom system prompt (string or function)
                format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
              },
            },
          },
        },
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            -- MCP Tools
            make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
            show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
            add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
            show_result_in_chat = true, -- Show tool results directly in chat buffer
            format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
            -- MCP Resources
            make_vars = true, -- Convert MCP resources to #variables for prompts
            -- MCP Prompts
            make_slash_commands = true, -- Add MCP prompts as /slash commands
          },
        },
      },
      prompt_library = {
        ["Code Edit"] = {
          interaction = "inline",
          description = "Prompt the LLM from Neovim",
          opts = {
            is_slash_cmd = false,
            short_name = "code-edit-inline",
            user_prompt = true,
          },
          prompts = {
            {
              role = "system",
              content = function(context)
                return string.format(
                  [[I want you to act as a senior %s developer. I will ask you specific questions and I want you to return raw code only (no codeblocks and no explanations). If you can't respond with code, respond with nothing]],
                  context.filetype
                )
              end,
              opts = {
                visible = false,
                tag = "system_tag",
              },
            },
          },
        },
        ["Text Fix Spelling Inline"] = {
          interaction = "inline",
          opts = {
            is_slash_cmd = false,
            user_prompt = false,
            placement = "replace",
            short_name = "text-fix-spelling-inline",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = function(context)
                return [[
Fix the grammar and spelling.
Preserve all formatting, line breaks, and special characters.
Do not add or remove any content.
Return only the corrected text.
]]
              end,
              opts = {
                visible = false,
                tag = "system_tag",
              },
            },
          },
          {
            role = "user",
            content = function(context)
              local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

              return string.format(
                [[
Fix spelling for this:

```%s
%s
```
]],
                context.filetype,
                code
              )
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
      ---@diagnostic disable-next-line: unused-local
      system_prompt = function(opts)
        return [[You are an AI programming assistant named "CodeCompanion". You are currently plugged in to the Neovim text editor on a user's machine.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid including line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
- Use actual line breaks instead of '\n' in your response to begin new lines.
- Use '\n' only when you want a literal backslash followed by a character 'n'.
- All non-code text responses must be written in the %s language.

When given a task:
1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
2. Output the code in a single code block, being careful to only return relevant code.
3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
4. You can only give one reply for each conversation turn.]]
      end,
    },
  },
}
