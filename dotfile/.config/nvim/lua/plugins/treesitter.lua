-- 语法解析（treesitter）
--
-- 语法由 nixpkgs 编译成 parser/<lang>.so 并随插件进入 runtimepath，因此不需要
-- nvim 联网自动安装。这里只对 Nix 侧已提供语法的文件类型启用高亮，其余文件类型
-- 保持原样，避免触发 nvim 的自动下载逻辑。
local M = {}

-- 与 module/hm/program/neovim.nix 中声明的 grammar 一一对应
local SUPPORTED_FILETYPES = { 'c', 'cpp', 'objc', 'cmake' }

function M.setup()
  -- 高亮：只在已支持的 C/C++ 文件类型上启动 treesitter
  vim.api.nvim_create_autocmd('FileType', {
    pattern = SUPPORTED_FILETYPES,
    desc = '为 C/C++ 启动 treesitter',
    callback = function(args)
      -- 已有高亮则不重复启动
      if not vim.treesitter.highlighter.active[args.buf] then
        vim.treesitter.start(args.buf)
      end
    end,
  })
end

return M
