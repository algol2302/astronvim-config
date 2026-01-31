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

  local result = vim.system(
    { "gpg", "--batch", "--quiet", "--decrypt", abs_path },
    { text = true }
  ):wait()

  if result.code ~= 0 then
    error("GPG decryption failed for " .. secret_name .. ": " .. (result.stderr or "unknown error"))
  end

  local secret = result.stdout:gsub("%s+$", "")
  if secret == "" then
    error("Empty secret: " .. secret_name)
  end

  return secret
end

--- Gets a secret by name, caching it for future use.
--- @param secret_name string: The path to the encrypted secret file.
--- @return string: The loaded secret.
function M.get(secret_name)
  if cache[secret_name] == nil then
    cache[secret_name] = load_secret(secret_name)
  end
  return cache[secret_name]
end

return M
