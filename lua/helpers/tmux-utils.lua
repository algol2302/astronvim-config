local M = {}

-- Check if we're running inside tmux
local function is_tmux()
  return vim.env.TMUX ~= nil
end

-- Execute tmux command and return output
local function exec_tmux(args)
  if not is_tmux() then
    vim.notify("Not running in tmux", vim.log.levels.WARN)
    return nil
  end

  local cmd = "tmux " .. args
  local result = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    return nil
  end

  return result
end

-- Get current pane ID
local function get_current_pane()
  local result = exec_tmux("display-message -p '#{pane_id}'")
  if not result then return nil end
  return vim.trim(result)
end

-- Get list of all panes with their info
local function get_panes()
  local result = exec_tmux("list-panes -F '#{pane_id}|#{pane_index}|#{pane_current_command}'")
  if not result then return {} end

  local panes = {}
  for line in result:gmatch("[^\n]+") do
    local id, index, cmd = line:match("([^|]+)|([^|]+)|([^|]+)")
    if id then
      table.insert(panes, {
        id = id,
        index = tonumber(index),
        command = cmd,
      })
    end
  end
  return panes
end

-- Count the number of panes in the current window
local function count_panes()
  local result = exec_tmux("list-panes | wc -l")
  if not result then return 0 end

  return tonumber(result:match("%d+")) or 0
end

-- Get the "other" pane (works when there are exactly 2 panes)
local function get_other_pane()
  local current = get_current_pane()
  if not current then return nil end

  local panes = get_panes()
  if #panes ~= 2 then
    return nil
  end

  for _, pane in ipairs(panes) do
    if pane.id ~= current then
      return pane.id
    end
  end
  return nil
end

-- Send command to a specific pane
local function send_to_pane(pane_id, command)
  if not pane_id then return false end

  -- Escape single quotes in the command
  local escaped = command:gsub("'", "'\\''")

  -- Enter must be outside quotes to be interpreted as a key, not literal text
  local cmd = string.format("send-keys -t %s '%s' Enter", pane_id, escaped)
  local result = exec_tmux(cmd)

  return result ~= nil
end

-- Open horizontal pane (left/right) if no other panes exist
function M.open_horizontal()
  local pane_count = count_panes()

  if pane_count > 1 then
    vim.notify("Tmux panes already exist", vim.log.levels.INFO)
    return
  end

  local cwd = vim.fn.getcwd()
  exec_tmux(string.format("split-window -h -c '%s'", cwd))
end

-- Open vertical pane (top/bottom) if no other panes exist
function M.open_vertical()
  local pane_count = count_panes()

  if pane_count > 1 then
    vim.notify("Tmux panes already exist", vim.log.levels.INFO)
    return
  end

  local cwd = vim.fn.getcwd()
  exec_tmux(string.format("split-window -v -c '%s'", cwd))
end

-- Get the name of the current test function (Go specific)
local function get_current_test_name()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype

  if filetype ~= "go" then
    return nil
  end

  local filename = vim.fn.expand("%:t")
  if not filename:match("_test%.go$") then
    return nil
  end

  -- Try using treesitter first
  local has_ts, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
  if has_ts then
    local node = ts_utils.get_node_at_cursor()
    while node do
      if node:type() == "function_declaration" then
        local name_node = node:field("name")[1]
        if name_node then
          local name = vim.treesitter.get_node_text(name_node, bufnr)
          if name:match("^Test") then
            return name
          end
        end
      end
      node = node:parent()
    end
  end

  -- Fallback to regex search if treesitter fails
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, cursor_line, false)

  -- Search backwards from cursor for test function
  for i = #lines, 1, -1 do
    local test_name = lines[i]:match("^func%s+(Test%w+)%s*%(")
    if test_name then
      return test_name
    end
  end

  return nil
end

-- Run current Go test in docker-compose
function M.run_go_test()
  if not is_tmux() then
    vim.notify("Not running in tmux", vim.log.levels.WARN)
    return
  end

  local test_name = get_current_test_name()
  if not test_name then
    vim.notify("No test function found. Make sure cursor is inside a test function.", vim.log.levels.WARN)
    return
  end

  -- Get the current file's absolute path
  local file_path = vim.fn.expand("%:p")

  -- Extract relative path starting from /app/
  local relative_path = file_path:match("/app/(.*)")
  if not relative_path then
    vim.notify("Could not determine path relative to /app/", vim.log.levels.WARN)
    return
  end

  -- Get the directory of the file (Go tests are run per package)
  local package_path = "./" .. vim.fn.fnamemodify(relative_path, ":h")

  local cmd = string.format("docker-compose exec app richgo test %s -run %s -v --failfast", package_path, test_name)

  -- Get target pane
  local pane_id = get_other_pane()
  if not pane_id then
    local panes = get_panes()
    if #panes == 1 then
      vim.notify("No other panes available. Create a pane first with <Leader>Th or <Leader>Tv", vim.log.levels.WARN)
      return
    else
      -- Multiple panes available, let user select
      vim.ui.select(panes, {
        prompt = "Select target pane:",
        format_item = function(pane)
          return string.format("Pane %d (%s)", pane.index, pane.command)
        end,
      }, function(choice)
        if choice then
          if send_to_pane(choice.id, cmd) then
            vim.notify(string.format("Running test in pane %d", choice.index), vim.log.levels.INFO)
          end
        end
      end)
      return
    end
  end

  -- Send to the other pane
  if send_to_pane(pane_id, cmd) then
    vim.notify(string.format("Running: %s", test_name), vim.log.levels.INFO)
  else
    vim.notify("Failed to send test command", vim.log.levels.ERROR)
  end
end

return M
