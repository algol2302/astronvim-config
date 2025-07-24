return {
  {
    "codecompanion.nvim",
    opts = {
      adapters = {
        bothub = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://bothub.chat/api/v2/openai", -- optional: default value is ollama url http://127.0.0.1:11434
              api_key = "cmd: gpg --batch --quiet --decrypt ~/.config/nvim/bothub_api_key.gpg",
              -- chat_url = "/v1/chat/completions", -- optional: default value, override if different
              -- models_endpoint = "/v1/models", -- optional: attaches to the end of the URL to form the endpoint to retrieve models
              models_endpoint = "https://bothub.chat/api/v2/model/list?children=1", -- optional: attaches to the end of the URL to form the endpoint to retrieve models
            },
            schema = {
              model = {
                default = "o4-mini-high", -- define llm model to be used
                -- default = "deepseek-r1-671b", -- define llm model to be used
              },
              temperature = {
                order = 2,
                mapping = "parameters",
                type = "number",
                optional = true,
                default = 0.8,
                desc = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.",
                validate = function(n) return n >= 0 and n <= 2, "Must be between 0 and 2" end,
              },
              max_completion_tokens = {
                order = 3,
                mapping = "parameters",
                type = "integer",
                optional = true,
                default = nil,
                desc = "An upper bound for the number of tokens that can be generated for a completion.",
                validate = function(n) return n > 0, "Must be greater than 0" end,
              },
              stop = {
                order = 4,
                mapping = "parameters",
                type = "string",
                optional = true,
                default = nil,
                desc = "Sets the stop sequences to use. When this pattern is encountered the LLM will stop generating text and return. Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.",
                validate = function(s) return s:len() > 0, "Cannot be an empty string" end,
              },
              logit_bias = {
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
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "bothub",
        },
        inline = {
          adapter = "bothub",
        },
        cmd = {
          adapter = "bothub",
        },
      },
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = "Prompt ", -- Prompt used for interactive LLM calls
          provider = "default", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
          opts = {
            show_default_actions = true, -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
          },
        },
      },
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
- All non-code responses must be in %s.

When given a task:
1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
2. Output the code in a single code block, being careful to only return relevant code.
3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
4. You can only give one reply for each conversation turn.]]

        --       return [[You are an AI programming assistant named "CodeCompanion". You are currently plugged in to the Neovim text editor on a user's machine.
        --
        -- Your core tasks include:
        -- - Answering general programming questions.
        -- - Explaining how the code in a Neovim buffer works.
        -- - Reviewing the selected code in a Neovim buffer.
        -- - Generating unit tests for the selected code.
        -- - Proposing fixes for problems in the selected code.
        -- - Scaffolding code for a new workspace.
        -- - Finding relevant code to the user's query.
        -- - Proposing fixes for test failures.
        --
        -- You must:
        -- - Follow the user's requirements carefully and to the letter.
        -- - Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
        -- - Minimize other prose.
        -- - Use Markdown formatting in your answers.
        -- - Include the programming language name at the start of the Markdown code blocks.
        -- - Avoid including line numbers in code blocks.
        -- - Avoid wrapping the whole response in triple backticks.
        -- - Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
        -- - Use actual line breaks instead of '\n' in your response to begin new lines.
        -- - Use '\n' only when you want a literal backslash followed by a character 'n'.
        -- - All non-code responses must be in %s.
        --
        -- When given a task:
        -- 1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
        -- 2. Output the code in a single code block, being careful to only return relevant code.
        -- 3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
        -- 4. You can only give one reply for each conversation turn.]]
      end,
    },
  },
}
