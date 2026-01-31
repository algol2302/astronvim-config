local M = {}

local cache = {}

--- Validates that a file exists and is readable.
--- @param path string: The file path to check.
--- @return boolean: True if the file exists and is readable.
local function file_exists(path)
  local stat = vim.uv.fs_stat(path)
  return stat ~= nil and stat.type == "file"
end

--- Loads a secret using the `gpg` command-line tool.
--- @param secret_name string: The path to the encrypted secret file.
--- @return string: The loaded secret.
local function load_secret(secret_name)
  -- Convert to absolute path if relative
  local abs_path = vim.fn.fnamemodify(secret_name, ":p")

  if not file_exists(abs_path) then
    error("Secret file not found: " .. abs_path .. " (original: " .. secret_name .. ")")
  end

  if vim.g.secret_debug then
    vim.notify("Loading secret: " .. secret_name, vim.log.levels.DEBUG)
  end

  local result = vim.system(
    { "gpg", "--batch", "--quiet", "--decrypt", abs_path },
    { text = true, timeout = 5000 }
  ):wait()

  if result.code ~= 0 then
    error("GPG decryption failed for " .. secret_name .. ": " .. (result.stderr or "unknown error"))
  end

  local secret = vim.trim(result.stdout)
  if secret == "" then error("Empty secret: " .. secret_name) end

  return secret
end

--- Gets a secret by name, caching it for future use.
--- @param secret_name string: The path to the encrypted secret file.
--- @return string: The loaded secret.
function M.get(secret_name)
  if type(secret_name) ~= "string" or secret_name == "" then
    error("secret_name must be a non-empty string")
  end

  if cache[secret_name] == nil then cache[secret_name] = load_secret(secret_name) end
  return cache[secret_name]
end

--- Clears all cached secrets from memory.
function M.clear_all()
  cache = {}
end

--- Reloads a specific secret, bypassing the cache.
--- @param secret_name string: The path to the encrypted secret file.
--- @return string: The reloaded secret.
function M.reload(secret_name)
  cache[secret_name] = nil
  return M.get(secret_name)
end

return M
