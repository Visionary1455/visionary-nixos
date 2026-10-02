-- 调试：nvim-dap + nvim-dap-ui，适配器为 LLDB 自带的 lldb-dap
--
-- 选 LLDB 而非 GDB 的原因：LLDB 对 C++ 模板、运算符重载、表达式求值的支持更完整，
-- 且 lldb-dap 是 LLVM 自带的 DAP 服务端（pkgs.lldb 提供），无需额外下载二进制。
--
-- 这里刻意手写适配器而不用 nvim-dap-lldb 插件：后者只支持 codelldb 的「子进程监听
-- --port 再回连」架构，而 lldb-dap 自身就是 DAP 服务端、通过 stdio 直接对话，
-- 两者协议流程不兼容（nixpkgs 也没有 codelldb）。
--
-- 前提：以 Debug 或 RelWithDebInfo 构建，否则二进制里没有调试信息。
--   cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo
local M = {}

local function cpp_config(program)
  return {
    name = '调试当前文件',
    type = 'lldb',
    request = 'launch',
    program = program,
    cwd = '${workspaceFolder}',
    args = {},
    stopOnEntry = false,
    runInTerminal = false,
    -- lldb-dap 以目标程序的参数为准，-- 传入环境变量便于运行时调试
    env = {},
  }
end

function M.setup()
  local dap = require('dap')
  local dapui = require('dapui')

  dap.adapters.lldb = {
    type = 'executable',
    command = 'lldb-dap',
    name = 'lldb',
  }

  dap.configurations.cpp = cpp_config('${file}')
  dap.configurations.c = cpp_config('${file}')
  dap.configurations.cuda = cpp_config('${file}')

  -- 也可以调试工程里已经编译好的可执行文件
  dap.configurations['launch-exe'] = {
    name = '调试指定可执行文件',
    type = 'lldb',
    request = 'launch',
    program = '${input}',
    cwd = '${workspaceFolder}',
    args = {},
    stopOnEntry = false,
    runInTerminal = false,
  }

  dapui.setup()
  dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
  end

  local map = require('config.util').map
  local opts = { silent = true }

  -- <localleader> 前缀下统一放置调试键位
  map('<localleader>d', dapui.toggle, { desc = '调试：打开/关闭 dap-ui' })
  map('<localleader>b', dap.toggle_breakpoint, { desc = '调试：切换断点' })
  map('<localleader>B', function()
    dap.set_breakpoint(vim.api.nvim_buf_get_name(0), vim.fn.line('.'))
  end, { desc = '调试：在当前行设置断点' })
  map('<localleader>c', dap.continue, { desc = '调试：继续' })
  map('<localleader>n', dap.step_over, { desc = '调试：单步跳过' })
  map('<localleader>i', dap.step_into, { desc = '调试：单步进入' })
  map('<localleader>o', dap.step_out, { desc = '调试：单步跳出' })
  map('<localleader>x', dap.terminate, { desc = '调试：结束调试' })
  map('<localleader>r', dap.restart, { desc = '调试：重启' })
  map('<localleader>R', function()
    dapui.run({
      type = 'executable',
      request = 'launch',
      name = '调试指定可执行文件',
      program = '${input}',
      cwd = '${workspaceFolder}',
    })
  end, { desc = '调试：选择要运行的可执行文件' })
end

return M
