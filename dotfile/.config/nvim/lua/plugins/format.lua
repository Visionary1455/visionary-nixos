-- C/C++ 格式化：直接使用 clangd 内置的 textDocument/formatting
--
-- clangd 与 clang-format 同源，同一套 .clang-format 配置对两者都生效，
-- 因此不需要额外引入 conform.nvim，也没有格式化器与 LSP 判断不一致的问题。
local M = {}

local CPP_FILETYPES = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' }

function M.setup()
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = CPP_FILETYPES,
    desc = '保存前用 clangd 格式化 C/C++ 源码',
    callback = function(args)
      -- clangd 尚未挂载时不做处理，否则会得到误导性的无操作
      if #vim.lsp.get_clients({ bufnr = args.buf, name = 'clangd' }) == 0 then
        return
      end
      vim.lsp.buf.format({ bufnr = args.buf, async = false, filter = function(fmt)
        return fmt.name == 'clangd'
      end })
    end,
  })

  -- 手动触发整个文件的格式化
  vim.api.nvim_create_user_command('ClangdFormat', function()
    vim.lsp.buf.format({ async = false, filter = function(fmt)
      return fmt.name == 'clangd'
    end })
  end, { desc = '用 clangd 格式化当前文件' })
end

return M
