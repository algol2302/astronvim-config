local M = {}

--- Loads a secret using the `gpg` command-line tool.
--- @param secret_name string: The name of the secret to load.
--- @return string: The loaded secret.
local function load_secret(secret_name)
  local handle, err = io.popen("gpg --batch --quiet --decrypt " .. secret_name, "r")
  if not handle then error("Failed to start GPG: " .. (err or "unknown error")) end
  local result = handle:read "*a"
  handle:close()
  result = result:gsub("gpg: WARNING: standard error reopened\n?", "")
  result = result:gsub("gpg: .-: .-\n?", "") -- Catch-all for other gpg messages
  local r = result:gsub("%s+$", "")
  if r == "" then error "Decryption failed or no output from GPG" end
  return r
end

--- Gets a secret by name, caching it for future use.
--- @param secret_name string: The name of the secret to get.
--- @return string: The loaded secret.
function M.get(secret_name)
  if not M[secret_name] then M[secret_name] = load_secret(secret_name) end
  return M[secret_name]
end

return M
