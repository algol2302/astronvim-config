local M = {}

--- Loads a secret using the `gpg` command-line tool.
--- @param secret_name string: The name of the secret to load.
--- @return string: The loaded secret.
function M.load(secret_name)
  local handle, err = io.popen("gpg --batch --quiet --decrypt " .. secret_name, "r")
  if not handle then error("Failed to start GPG: " .. (err or "unknown error")) end
  local result = handle:read "*a"
  handle:close()
  local r = result:gsub("%s+$", "")
  return r
end

return M
