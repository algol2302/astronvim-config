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

-- Count the number of panes in the current window
local function count_panes()
  local result = exec_tmux("list-panes | wc -l")
  if not result then return 0 end

  return tonumber(result:match("%d+")) or 0
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

return M
