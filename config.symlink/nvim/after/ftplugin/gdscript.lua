local port = 6005
local os_name = vim.loop.os_uname().sysname

-- In Godot 4, the LSP usually communicates over a port.
-- We use a pipe/socket connection.
local cmd = vim.lsp.rpc.connect("127.0.0.1", port)

local config = {
  name = "Godot",
  cmd = cmd,
  root_dir = vim.fs.dirname(vim.fs.find({ 'project.godot', '.git' }, { upward = true })[1]),
  on_attach = function(client, bufnr)
    -- This helps catch errors during attachment
    print("LSP Godot attached!")
  end
}

-- Use pcall (protected call) to prevent Neovim from
-- throwing a massive error UI if the server isn't running.
local status, _ = pcall(function()
    vim.lsp.start(config)
end)

if not status then
    print("Godot LSP failed to start. Is the Godot Editor open?")
end
