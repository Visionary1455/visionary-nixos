-- 语言服务器：C/C++ 使用 clangd
--
-- clangd 的准确性高度依赖 compile_commands.json，它提供真实的宏定义、include
-- 路径与 C++ 标准。找不到该文件时 clangd 会退回「启发式模式」，此时头文件解析、
-- 模板推导与重构几乎全部失效，因此这里主动查找该文件并通过
-- --compile-commands-dir 显式告知 clangd。
local M = {}

-- CMake/Ninja 默认把编译数据库写在 build/ 这类**子目录**里，只向上遍历祖先目录是
-- 找不到的，因此每一级还要顺带看看这些常见构建目录。
local build_dirs = { 'build', 'build-debug', 'out', '.build', 'cmake-build-debug' }

--- 从给定目录逐级向上查找 compile_commands.json，到根目录仍未找到则返回 nil
--- 每一级先看目录本身，再看常见的构建子目录
---@param dir string 起始目录
---@return string|nil 找到时返回其所在目录
local function find_compile_commands(dir)
  if dir == nil or dir == '' or vim.fn.isdirectory(dir) ~= 1 then
    return nil
  end
  if vim.fn.filereadable(dir .. '/compile_commands.json') == 1 then
    return dir
  end
  for _, sub in ipairs(build_dirs) do
    if vim.fn.filereadable(dir .. '/' .. sub .. '/compile_commands.json') == 1 then
      return dir .. '/' .. sub
    end
  end
  local parent = vim.fn.fnamemodify(dir, ':h')
  if parent == dir then
    return nil -- 已到文件系统根目录
  end
  return find_compile_commands(parent)
end

--- 取当前工作区内的 compile_commands.json 目录：优先当前文件，其次当前工作目录
---@return string|nil
function M.compile_commands_dir()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname ~= '' then
    local dir = find_compile_commands(vim.fs.dirname(bufname))
    if dir then
      return dir
    end
  end
  return find_compile_commands(vim.fn.getcwd())
end

--- 生成 clangd 的完整配置
--- 每次从零构建，保证重启后不会丢失 init_options / settings
---@param db_dir string|nil compile_commands.json 所在目录，nil 表示交给 clangd 自行查找
local function build_config(db_dir)
  local cmd = {
    'clangd',
    '--background-index', -- 后台索引未被编译数据库收录的头文件
    '--completion-style=detailed',
    '--query-driver=**', -- 允许 clangd 调用编译数据库里的编译器获取内置宏
  }
  if db_dir then
    table.insert(cmd, '--compile-commands-dir=' .. db_dir)
  end

  return {
    cmd = cmd,
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    init_options = {
      -- 找不到 compile_commands.json 时的兜底编译参数，按项目实际标准调整
      fallbackFlags = '-std=c++20',
      clangdFileStatus = true, -- 在状态栏显示后台索引进度
    },
    settings = {
      clangd = {
        diagnostics = {
          -- 头文件里大量 unused 噪音没有价值，只保留真正影响代码的诊断
          unusedIncludes = 'None',
          missingIncludes = 'None',
        },
      },
    },
  }
end

function M.setup()
  current_db_dir = M.compile_commands_dir()
  vim.lsp.config('clangd', build_config(current_db_dir))
  vim.lsp.enable('clangd')

  local map = require('config.util').map

  -- 跳转与查阅
  map('gd', vim.lsp.buf.definition, { desc = 'LSP：跳转定义' })
  map('gr', vim.lsp.buf.references, { desc = 'LSP：跳转引用' })
  map('gi', vim.lsp.buf.implementation, { desc = 'LSP：跳转实现' })
  map('K', vim.lsp.buf.hover, { desc = 'LSP：悬浮文档' })
  map('<C-]>', vim.lsp.buf.declaration, { desc = 'LSP：跳转声明' })

  -- 改动类操作：重命名与快速修复需要完整输入，故先要求进入普通模式
  map('<leader>rn', function()
    vim.input('重命名为：', function(target)
      if target and target ~= '' then
        vim.lsp.buf.rename(target)
      end
    end)
  end, { desc = 'LSP：重命名符号' })
  map('<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP：快速修复' })

  -- 诊断
  map('<leader>ld', vim.diagnostic.open_float, { desc = 'LSP：行内诊断详情' })

  -- 打开 C/C++ 文件时按该文件重新定位编译数据库：只在 setup 里算一次的话，
  -- 从工程目录之外启动 nvim 会让 clangd 拿不到 --compile-commands-dir。
  -- 目录没变就不重启 clangd，避免每次切文件都重建索引。
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('ClangdCompileDb', { clear = true }),
    pattern = {
      '*.c',
      '*.cc',
      '*.cpp',
      '*.cxx',
      '*.h',
      '*.hh',
      '*.hpp',
      '*.hxx',
      '*.m',
      '*.mm',
      '*.cu',
      '*.cuh',
    },
    callback = function()
      if M.compile_commands_dir() == current_db_dir then
        return
      end
      M.reload_compile_commands({ silent = true })
    end,
  })

  -- 重新生成编译数据库后刷新 clangd
  vim.api.nvim_create_user_command('ClangdSetDb', function()
    M.reload_compile_commands()
  end, {
    desc = '重新探测 compile_commands.json 并重启 clangd',
  })
end

-- 当前生效的编译数据库目录。clangd 的 --compile-commands-dir 只在 setup 时决定，
-- 而 nvim 启动时通常还没打开工程里的源文件（cwd 也未必是工程目录），
-- 因此打开新文件时必须按该缓冲区重新定位。
local current_db_dir = nil

--- 重新探测 compile_commands.json 并重启 clangd
--- 重新执行 cmake / bear 生成编译数据库后使用
---@param opts table|nil silent=true 时不弹通知（打开文件时的自动刷新用）
function M.reload_compile_commands(opts)
  local db_dir = M.compile_commands_dir()
  current_db_dir = db_dir

  if not (opts and opts.silent) then
    if db_dir then
      vim.notify('Clangd：使用 ' .. db_dir .. '/compile_commands.json', vim.log.levels.INFO)
    else
      vim.notify('Clangd：未找到 compile_commands.json，已退回启发式模式', vim.log.levels.WARN)
    end
  end

  vim.lsp.config('clangd', build_config(db_dir))

  -- 配置变更不会作用到已在运行的客户端，需显式停止后再触发 FileType 重新挂载
  local clients = vim.lsp.get_clients({ name = 'clangd' })
  if #clients > 0 then
    vim.lsp.stop_client(clients, true)
    vim.api.nvim_exec_autocmds('FileType', { buffer = 0 })
  end
end

return M
