local function root_dir(buf, markers)
  local path = vim.api.nvim_buf_get_name(buf)
  if path == "" then
    return vim.uv.cwd()
  end
  return vim.fs.root(path, markers) or vim.fs.dirname(path)
end

local function caps()
  local c = vim.lsp.protocol.make_client_capabilities()
  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    c = blink.get_lsp_capabilities(c)
  end
  return c
end

local function start_clangd(buf)
  if vim.fn.executable("clangd") ~= 1 then
    return
  end
  vim.lsp.start({
    name = "clangd",
    cmd = {
      "clangd",
      "--background-index",
      "--header-insertion=never",
      "--completion-style=detailed",
      "--function-arg-placeholders=0",
      "--query-driver=/usr/bin/g++*",
    },
    root_dir = root_dir(buf, {
      "compile_commands.json",
      "compile_flags.txt",
      "CMakeLists.txt",
      "Makefile",
      ".git",
    }),
    capabilities = caps(),
  })
end

local function start_lua_ls(buf)
  if vim.fn.executable("lua-language-server") ~= 1 then
    return
  end
  vim.lsp.start({
    name = "lua_ls",
    cmd = { "lua-language-server" },
    root_dir = root_dir(buf, { ".luarc.json", ".luarc.jsonc", ".git" }),
    capabilities = caps(),
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
        },
        diagnostics = { globals = { "vim" } },
      },
    },
  })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function(ev)
    start_clangd(ev.buf)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function(ev)
    start_lua_ls(ev.buf)
  end,
})
